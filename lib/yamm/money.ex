defmodule YAMM.Money do
  @moduledoc """
  The Money context.
  """

  import Ecto.Query, warn: false
  alias YAMM.Repo

  alias YAMM.Money.{User, Wallet, Movement}
  alias Ecto.Multi

  def list_users do
    Repo.all(User)
  end

  def get_user!(id), do: Repo.get!(User, id)

  def get_user_by_slack_id(slack_id), do: Repo.get_by(User, slack_user_id: slack_id)

  def create_user(attrs \\ %{}) do
    Multi.new()
    |> Multi.insert(:user, User.changeset(%User{}, attrs))
    |> Multi.run(
      :wallet,
      fn repo, %{user: user} ->
        create_wallet(user, %{}, repo)
      end
    )
    |> Repo.transaction()
  end

  def get_wallet!(id), do: Repo.get!(Wallet, id)

  def get_balance(user) do
    user
    |> wallet_for_user!(lock: :none)
    |> Wallet.balance()
  end

  def create_wallet(user = %User{}, attrs \\ %{}, repo \\ Repo) do
    %Wallet{}
    |> Wallet.changeset(attrs)
    |> Ecto.Changeset.put_assoc(:user, user)
    |> repo.insert()
  end

  def credit_user(user, amount) do
    wallet_query =
      from w in Wallet,
        where: w.user_id == ^user.id,
        limit: 1,
        lock: "FOR UPDATE"

    wallet = Repo.one(wallet_query)
    create_movement(wallet, %{amount: amount})
  end

  @zero_decimal Decimal.new(0)

  def transfer(from, to, amount) do
    Repo.transaction(fn ->
      # Locks all walllets for duration, clean this up later.
      sender_wallet = wallet_for_user!(from)

      balance = Wallet.balance(sender_wallet)
      new_balance = Decimal.sub(balance, amount)

      case Decimal.lt?(new_balance, @zero_decimal) do
        true ->
          {:error, "Insufficient balance"}

        false ->
          debit = Decimal.negate(amount)
          credit = amount
          receiver_wallet = wallet_for_user!(to)

          # Debit the sender
          create_movement(sender_wallet, %{amount: debit})
          # Credit the receiver
          create_movement(receiver_wallet, %{amount: credit})

          :ok
      end
    end)
  end

  defp wallet_for_user!(user, opts \\ []) do
    query =
      Wallet
      |> where(user_id: ^user.id)
      |> preload([:movements])

    query = if Keyword.get(opts, :lock) == :none, do: query, else: lock(query, "FOR UPDATE")

    Repo.one!(query)
  end

  defp create_movement(wallet = %Wallet{}, attrs \\ %{}, repo \\ Repo) do
    next_hash = generate_hash(wallet.id, repo)
    attrs_with_hash = Map.put(attrs, :hash, next_hash)

    %Movement{}
    |> Movement.changeset(attrs_with_hash)
    |> Ecto.Changeset.put_assoc(:wallet, wallet)
    |> repo.insert()
  end

  defp generate_hash(wallet_id, repo) do
    # Latest movement for wallet
    query =
      from m in Movement,
        where: m.wallet_id == ^wallet_id,
        order_by: [desc: :inserted_at],
        limit: 1

    case repo.one(query) do
      nil ->
        # This would be the genesis hash
        hash(wallet_id)

      movement ->
        hash(movement)
    end
  end

  defp hash(term) do
    phash =
      term
      |> :erlang.phash2()
      |> Integer.to_string()

    :sha256
    |> :crypto.hash(phash)
    |> Base.encode16(case: :lower)
  end
end
