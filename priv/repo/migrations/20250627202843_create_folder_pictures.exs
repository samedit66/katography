defmodule Katography.Repo.Migrations.CreateFolderPictures do
  use Ecto.Migration

  def change do
    create table(:folder_pictures, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :folder_id, references(:folders, type: :binary_id), null: false
      add :picture_id, references(:pictures, type: :binary_id), null: false

      timestamps()
    end
  end
end
