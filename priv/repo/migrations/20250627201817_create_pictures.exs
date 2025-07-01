defmodule Katography.Repo.Migrations.CreatePictures do
  use Ecto.Migration

  def change do
    create table(:pictures, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :name, :string, null: true
      add :filename, :string, null: false

      timestamps()
    end
  end
end
