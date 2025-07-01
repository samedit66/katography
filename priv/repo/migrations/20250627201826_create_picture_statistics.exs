defmodule Katography.Repo.Migrations.CreatePictureStatistics do
  use Ecto.Migration

  def change do
    create table(:picture_statistics, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :picture_id, references(:pictures, type: :binary_id), null: false
      add :action_id, references(:user_actions, type: :binary_id), null: false

      timestamps()
    end
  end
end
