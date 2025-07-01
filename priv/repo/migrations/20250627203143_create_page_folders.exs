defmodule Katography.Repo.Migrations.CreatePageFolders do
  use Ecto.Migration

  def change do
    create table(:page_folders, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :page_id, references(:pages, type: :binary_id), null: false
      add :folder_id, references(:folders, type: :binary_id), null: false

      timestamps()
    end
  end
end
