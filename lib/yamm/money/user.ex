defmodule YAMM.Money.User do
  use Ecto.Schema
  import Ecto.Changeset

  alias YAMM.Money.Wallet

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "users" do
    field :slack_user_id, :string

    has_many :wallets, Wallet

    timestamps()
  end

  @doc false
  def changeset(user, attrs) do
    user
    |> cast(attrs, [:slack_user_id])
    |> validate_required([:slack_user_id])
    |> unique_constraint(:slack_user_id)
  end
end
