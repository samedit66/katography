defmodule Katography.Model.FolderPicture do
  @moduledoc false
  use Katography.Model

  alias Katography.Model.{Folder, Picture}

  @required_fields ~w(folder_id picture_id)a

  schema "folder_pictures" do
    belongs_to :folder, Folder, type: :binary_id
    belongs_to :picture, Picture, type: :binary_id

    timestamps()
  end
end
