defmodule KatographyWeb.PictureController do
	@moduledoc false
	use KatographyWeb, :controller

	plug :put_view, KatographyWeb.PictureJSON

	alias Katography.Context.Pictures

	@doc """
	GET /folder/:folder_id/pictures
	"""
	def pictures(%{method: "GET"} = conn, %{"folder_id" => folder_id}) do
		render(conn, "pictures_response.json", pictures: Pictures.all(folder_id: folder_id))
	end

	@doc """
	GET /picture/:id
	"""
	def picture(%{method: "GET"} = conn, %{"id" => id}) do
		with {:ok, picture} <- Pictures.do_get(id: id) do
			render(conn, "picture_response.json", picture: picture)
		end
	end

end
