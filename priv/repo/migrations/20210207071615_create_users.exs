defmodule YAMM.Repo.Migrations.CreateUsers do
  use Ecto.Migration

  def change do
    create table(:users, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :slack_user_id, :string

      timestamps()
    end

    create unique_index(:users, [:slack_user_id])
  end
end
