defmodule KatographyWeb.PageJSON do
  @moduledoc false

  def render("pages_response.json", %{pages: pages}) do
    %{status: :ok, pages: render("pages.json", %{pages: pages})}
  end

  def render("page_response.json", %{page: page}) do
    %{status: :ok, page: render("page.json", page)}
  end

  def render("pages.json", %{pages: pages}) do
    Enum.map(pages, &render("page.json", %{page: &1}))
  end

  def render("page.json", %{page: page}) do
    page
  end
end
