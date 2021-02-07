defmodule YAMM.Money.Wallet do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "wallets" do
    field :balance, :decimal, default: 0

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
end
