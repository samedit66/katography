defmodule Katography.Model.PageFolder do
  @moduledoc false
  use Katography.Model

  alias Katography.Model.{Page, Folder}

  @required_fields ~w(page_id folder_id)a

  schema "page_folders" do
    belongs_to :page, Page, type: :binary_id
    belongs_to :folder, Folder, type: :binary_id

    timestamps()
  end
end
