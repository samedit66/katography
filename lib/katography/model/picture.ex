defmodule Katography.Model.Picture do
  @moduledoc false
  use Katography.Model

  alias Katography.Model.{PictureStatistic, Folder, FolderPicture}

  @required_fields ~w(filename)a
  @optional_fields ~w(name)a

  @derive {Jason.Encoder, only: [:id, :name, :filename, :inserted_at, :updated_at]}
  schema "pictures" do
    field :name, :string
    field :filename, :string

    has_many :statistic, PictureStatistic

    many_to_many :folders, Folder,
      join_through: FolderPicture,
      join_keys: [picture_id: :id, folder_id: :id]

    timestamps()
  end
end
