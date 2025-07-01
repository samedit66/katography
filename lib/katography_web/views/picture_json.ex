defmodule KatographyWeb.PictureJSON do
	@moduledoc false

	def render("pictures_response.json", %{pictures: pictures}) do
		%{status: :ok, pictures: render("pictures.json", %{pictures: pictures})}
	end

	def render("picture_response.json", %{picture: picture}) do
		%{status: :ok, picture: render("picture.json", %{picture: picture})}
	end

	def render("pictures.json", %{pictures: pictures}) do
		Enum.map(pictures, &render("picture.json", %{picture: &1}))
	end

	def render("picture.json", %{picture: picture}) do
		picture
		|> Map.take([:id, :filename])
		|> Map.put(:url, url_for_picture(picture))
	end

	defp url_for_picture(%{filename: filename}) do
		KatographyWeb.Endpoint.url() <> "/uploads/" <> filename
	end
end
