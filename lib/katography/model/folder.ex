defmodule Katography.Model.Folder do
  @moduledoc false
  use Katography.Model

  alias Katography.Model.{Picture, Page, FolderPicture, PageFolder}

  @required_fields ~w(path)a

  @derive {Jason.Encoder, only: [:id, :path, :inserted_at, :updated_at]}
  schema "folders" do
    field :path, :string

    many_to_many :pictures, Picture,
      join_through: FolderPicture,
      join_keys: [folder_id: :id, picture_id: :id]

    many_to_many :pages, Page,
      join_through: PageFolder,
      join_keys: [folder_id: :id, page_id: :id]

    timestamps()
  end
end
