defmodule KatographyWeb.FolderControllerTest do
  use KatographyWeb.ConnCase, async: true

  alias Katography.Context.{Pages, Folders}

  describe "GET /api/page/:page_id/folders" do
    test "returns all folders for a page", %{conn: conn} do
      {:ok, page} = Pages.create(%{name: "Page 1"})
      {:ok, folder1} = Folders.create(%{path: "folder1", page_id: page.id})
      {:ok, folder2} = Folders.create(%{path: "folder2", page_id: page.id})
      expected_folders = [folder1, folder2]

      assert %{"folders" => actual_folders} =
        conn
        |> get("/api/page/#{page.id}/folders")
        |> json_response(200)

      expected_folder_ids = Enum.map(expected_folders, & &1.id)
      actual_folder_ids = Enum.map(actual_folders, & &1["id"])

      assert length(expected_folder_ids) == length(actual_folder_ids)
      assert expected_folder_ids -- actual_folder_ids == []
    end
  end

  describe "GET /api/folder/:id" do
    test "returns a folder by id", %{conn: conn} do
      {:ok, folder} = Folders.create(%{path: "folderX"})
      assert %{"folder" => actual_folder} =
        conn
        |> get("/api/folder/#{folder.id}")
        |> json_response(200)
      assert actual_folder["id"] == folder.id
      assert actual_folder["path"] == "folderX"
    end

    test "returns 404 for non-existent folder", %{conn: conn} do
      conn = get(conn, "/api/folder/non-existent-id")
      assert json_response(conn, 404)["errors"]["detail"] == "Not Found"
    end
  end
end 