defmodule Katography.Model.UserAction do
  @moduledoc false
  use Katography.Model

  @required_fields ~w(name)a

  schema "user_actions" do
    field :name, :string

    timestamps()
  end
end
