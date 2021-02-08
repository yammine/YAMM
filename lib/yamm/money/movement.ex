defmodule YAMM.Money.Movement do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "movements" do
    field :amount, :decimal
    field :hash, :string
    belongs_to :wallet, YAMM.Money.Wallet

    timestamps()
  end

  @doc false
  def changeset(movement, attrs) do
    movement
    |> cast(attrs, [:amount, :hash])
    |> validate_required([:amount, :hash])
    |> foreign_key_constraint(:wallet_id)
  end
end
