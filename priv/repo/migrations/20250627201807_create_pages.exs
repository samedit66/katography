defmodule Katography.Repo.Migrations.CreatePages do
  use Ecto.Migration

  def change do
    create table(:pages, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :name, :string, null: true

      timestamps()
    end
  end
end
