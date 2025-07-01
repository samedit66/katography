defmodule Katography.Repo.Migrations.CreateFolders do
  use Ecto.Migration

  def change do
    create table(:folders, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :path, :string, size: 500, null: false

      timestamps()
    end
  end
end
