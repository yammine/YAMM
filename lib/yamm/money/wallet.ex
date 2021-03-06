defmodule YAMM.Money.Wallet do
  use Ecto.Schema
  import Ecto.Changeset

  alias YAMM.Money.{Movement, User}

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "wallets" do
    has_many :movements, Movement

    belongs_to :user, User

    timestamps()
  end

  @doc false
  def changeset(wallet, attrs) do
    wallet
    |> cast(attrs, [])
    |> foreign_key_constraint(:user_id)
  end

  def balance(%__MODULE__{movements: movements}) when is_list(movements) do
    Enum.reduce(movements, Decimal.new(0), fn m, acc ->
      Decimal.add(acc, m.amount)
    end)
  end
end
