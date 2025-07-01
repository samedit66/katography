defmodule KatographyWeb.PageController do
  @moduledoc false
  use KatographyWeb, :controller

  plug :put_view, KatographyWeb.PageJSON

  alias Katography.Context.Pages

  @doc """
  GET /pages
  """
  def pages(%{method: "GET"} = conn, _params) do
    render(conn, "pages_response.json", pages: Pages.all())
  end

  @doc """
  GET /page/:id
  """
  def page(%{method: "GET"} = conn, %{"id" => id}) do
    with {:ok, page} <- Pages.do_get(id: id) do
      render(conn, "page_response.json", page: page)
    end
  end
end
