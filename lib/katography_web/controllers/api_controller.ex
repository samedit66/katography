defmodule KatographyWeb.APIController do
  @moduledoc false
  use KatographyWeb, :controller

  @doc """
  OPTIONS /*
  """
  def options(%{method: "OPTIONS"} = conn, _params) do
    json(conn, %{status: :ok})
  end
end
