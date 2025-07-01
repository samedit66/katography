defmodule Katography.Context.Folders do
  @moduledoc false
  use Katography.Context, model: Folder

  import Ecto.Query

  alias Katography.Model.Folder

  def all(opts) do
    opts
    |> with_pages()
    |> Repo.all()
  end

  def get(opts) do
    opts
    |> with_pages()
    |> Repo.one()
  end

  defp with_pages(opts) do
    {page_id, opts} = Keyword.pop(opts, :page_id)

    Folder
    |> join_pages(page_id)
    |> filter_by(opts)
  end

  defp join_pages(query, nil), do: query

  defp join_pages(query, page_id) do
    query
    |> join(:inner, [f], p in assoc(f, :pages), as: :page)
    |> where([page: p], p.id == ^page_id)
  end
end
