defmodule KatographyWeb.PictureControllerTest do
  use KatographyWeb.ConnCase, async: true

  alias Katography.Context.{Pictures, Folders}

  describe "GET /api/folder/:folder_id/pictures" do
    test "returns all pictures for a folder", %{conn: conn} do
      {:ok, folder} = Folders.create(%{path: "folder1"})
      {:ok, picture1} = Pictures.create(%{filename: "pic1.jpg", folder_id: folder.id})
      {:ok, picture2} = Pictures.create(%{filename: "pic2.jpg", folder_id: folder.id})
      expected_pictures = [picture1, picture2]

      assert %{"pictures" => actual_pictures} =
        conn
        |> get("/api/folder/#{folder.id}/pictures")
        |> json_response(200)

      expected_picture_ids = Enum.map(expected_pictures, & &1.id)
      actual_picture_ids = Enum.map(actual_pictures, & &1["id"])

      assert length(expected_picture_ids) == length(actual_picture_ids)
      assert expected_picture_ids -- actual_picture_ids == []
    end
  end

  describe "GET /api/picture/:id" do
    test "returns a picture by id", %{conn: conn} do
      {:ok, picture} = Pictures.create(%{filename: "picX.jpg"})
      assert %{"picture" => actual_picture} =
        conn
        |> get("/api/picture/#{picture.id}")
        |> json_response(200)
      assert actual_picture["id"] == picture.id
      assert actual_picture["filename"] == "picX.jpg"
    end

    test "returns 404 for non-existent picture", %{conn: conn} do
      response =
        conn
        |> get("/api/picture/non-existent-id")
        |> json_response(404)
      assert %{"errors" => %{"detail" => "Not Found"}} = response
    end
  end
end 