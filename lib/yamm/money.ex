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

  def get_balances(user) do
    wallets =
      Wallet
      |> where(user_id: ^user.id)
      |> preload([:movements])
      |> Repo.all()

    Enum.map(wallets, fn wallet ->
      %{id: wallet.id, balance: Wallet.balance(wallet)}
    end)
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
