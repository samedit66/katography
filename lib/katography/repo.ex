defmodule Katography.Repo do
  use Ecto.Repo,
    otp_app: :katography,
    adapter: Ecto.Adapters.Postgres
end
