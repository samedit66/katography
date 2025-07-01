defmodule KatographyWeb.FolderController do
  @moduledoc false
  use KatographyWeb, :controller

  plug :put_view, KatographyWeb.FolderJSON

  alias Katography.Context.Folders

  @doc """
  GET /page/:page_id/folders
  """
  def folders(%{method: "GET"} = conn, %{"page_id" => page_id}) do
    render(conn, "pages_response.json", folders: Folders.all(page_id: page_id))
  end

  @doc """
  GET /folder/:id
  """
  def folder(%{method: "GET"} = conn, %{"id" => id}) do
    with {:ok, folder} <- Folders.do_get(id: id) do
      render(conn, "folder_response.json", folder: folder)
    end
  end
end
