defmodule Katography.Repo.Migrations.CreateUserActions do
  use Ecto.Migration

  def change do
    create table(:user_actions, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :name, :string, null: false

      timestamps()
    end
  end
end
