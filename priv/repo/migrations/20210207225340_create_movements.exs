defmodule YAMM.Repo.Migrations.CreateMovements do
  use Ecto.Migration

  def change do
    create table(:movements, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :amount, :decimal
      add :hash, :string
      add :wallet_id, references(:wallets, on_delete: :nothing, type: :binary_id)

      timestamps()
    end

    create index(:movements, [:wallet_id])
  end
end
