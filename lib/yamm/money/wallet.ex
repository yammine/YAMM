defmodule YAMM.Money.Wallet do
  use Ecto.Schema
  import Ecto.Changeset

  alias YAMM.Money.{Movement, User}

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "wallets" do
    field :balance, :decimal, default: 0

    has_many :movements, YAMM.Money.Movement

    belongs_to :user, YAMM.Money.User

    timestamps()
  end

  @doc false
  def changeset(wallet, attrs) do
    wallet
    |> cast(attrs, [:balance])
    |> validate_required([:balance])
    |> foreign_key_constraint(:user_id)
  end

  def balance(%__MODULE__{movements: movements}) when is_list(movements) do
    Enum.reduce(movements, Decimal.new(0), fn m, acc ->
      Decimal.add(acc, m.amount)
    end)
  end
end
