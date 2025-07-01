defmodule KatographyWeb.FolderJSON do
  @moduledoc false

  def render("pages_response.json", %{folders: folders}) do
    %{status: :ok, folders: render("folders.json", %{folders: folders})}
  end

  def render("folder_response.json", %{folder: folder}) do
    %{status: :ok, folder: render("folder.json", %{folder: folder})}
  end

  def render("folders.json", %{folders: folders}) do
    Enum.map(folders, &render("folder.json", %{folder: &1}))
  end

  def render("folder.json", %{folder: folder}) do
    folder
  end
end
