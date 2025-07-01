defmodule KatographyWeb.Cors do
  @moduledoc false

  defmacro __using__(endpoint: endpoint) do
    quote do
      import Plug.Conn

      @doc """
      Add CORS headers
      """
      @spec cors(Plug.Conn.t(), Keyword.t()) :: Plug.Conn.t()
      def cors(conn, _opts) do
        conn
        |> put_resp_header("access-control-allow-origin", cors_origin(conn))
        |> put_resp_header("access-control-allow-credentials", "true")
        |> put_resp_header("access-control-allow-methods", "GET, POST, PUT, PATCH, DELETE, OPTIONS")
        |> put_resp_header("access-control-allow-headers", "content-type, authorization, cookie")
      end

      defp cors_origin(conn) do
        origin = get_req_header(conn, "origin")
        endpoint_host = get_in(endpoint_config(), [:url, :host])

        cors_hosts =
          endpoint_config()
          |> Keyword.get(:cors_hosts)
          |> String.split(",")
          |> Enum.map(&String.trim/1)

        cors_origin(origin, cors_hosts, endpoint_host)
      end

      defp cors_origin([origin], cors_hosts, endpoint_host) do
        %URI{host: origin_host} = URI.parse(origin)

        if origin_host in cors_hosts,
          do: origin,
          else: "https://#{endpoint_host}"
      end

      defp cors_origin(_, _, endpoint_host), do: "https://#{endpoint_host}"

      defp endpoint_config, do: Application.get_env(:katography, unquote(endpoint))
    end
  end
end
