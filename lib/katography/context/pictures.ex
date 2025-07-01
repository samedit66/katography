defmodule Katography.Context.Pictures do
  @moduledoc false
  use Katography.Context, model: Picture

  import Ecto.Query

  alias Katography.Model.{Picture, FolderPicture}

  def all(opts) do
    opts
    |> with_folder()
    |> Repo.all()
  end

  def get(opts) do
    opts
    |> with_folder()
    |> Repo.one()
  end

  defp with_folder(opts) do
    {folder_id, opts} = Keyword.pop(opts, :folder_id)

    Picture
    |> join_folder(folder_id)
    |> filter_by(opts)
  end

  defp join_folder(query, nil), do: query

  defp join_folder(query, folder_id) do
    query
    |> join(:inner, [p], fp in FolderPicture, on: fp.picture_id == p.id and fp.folder_id == ^folder_id)
  end
end
