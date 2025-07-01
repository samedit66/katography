defmodule KatographyWeb.PageControllerTest do
  use KatographyWeb.ConnCase, async: true

  alias Katography.Context.Pages

  describe "GET /api/pages" do
    test "returns all pages", %{conn: conn} do
      {:ok, page1} = Pages.create(%{name: "Page 1"})
      {:ok, page2} = Pages.create(%{name: "Page 2"})
      expected_pages = [page1, page2]

      assert %{"pages" => actual_pages} =
        conn
        |> get("/api/pages")
        |> json_response(200)

      expected_page_ids = Enum.map(expected_pages, & &1.id)
      actual_page_ids = Enum.map(actual_pages, & &1["id"])

      assert length(expected_page_ids) == length(actual_page_ids)
      assert expected_page_ids -- actual_page_ids == []
    end
  end

  describe "GET /api/pages/:id" do
    test "returns a page by id", %{conn: conn} do
      {:ok, page} = Pages.create(%{name: "Test Page"})
      assert %{"page" => actual_page} =
        conn
        |> get("/api/pages/#{page.id}")
        |> json_response(200)
      assert actual_page["id"] == page.id
      assert actual_page["name"] == "Test Page"
    end

    test "returns 404 for non-existent page", %{conn: conn} do
      response =
        conn
        |> get("/api/pages/non-existent-id")
        |> json_response(404)
      assert %{"errors" => %{"detail" => "Not Found"}} = response
    end
  end
end 