defmodule Katography.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      KatographyWeb.Telemetry,
      Katography.Repo,
      {DNSCluster, query: Application.get_env(:katography, :dns_cluster_query) || :ignore},
      {Phoenix.PubSub, name: Katography.PubSub},
      # Start a worker by calling: Katography.Worker.start_link(arg)
      # {Katography.Worker, arg},
      # Start to serve requests, typically the last entry
      KatographyWeb.Endpoint
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Katography.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    KatographyWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
