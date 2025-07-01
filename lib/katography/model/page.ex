defmodule Katography.Model.Page do
  @moduledoc false
  use Katography.Model

  alias Katography.Model.{Folder, PageFolder}

  @required_fields ~w(name)a

  @derive {Jason.Encoder, only: [:id, :name, :inserted_at, :updated_at]}
  schema "pages" do
    field :name, :string

    many_to_many :folders, Folder,
      join_through: PageFolder,
      join_keys: [page_id: :id, folder_id: :id]

    timestamps()
  end
end
