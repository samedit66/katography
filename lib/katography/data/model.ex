defmodule Katography.Model do
  @moduledoc false

  defmacro __using__(_opts) do
    quote do
      use Ecto.Schema

      import Ecto.Changeset

      @primary_key {:id, :binary_id, autogenerate: true}
      @foreign_key_type :binary_id
      @timestamps_opts [type: :utc_datetime]
      @before_compile Katography.Model

      @optional_fields []
      @required_fields []

      @type t() :: %__MODULE__{}
    end
  end

  defmacro __before_compile__(_env) do
    quote do
      @doc false
      def changeset(model, attrs) do
        model
        |> cast(attrs, @optional_fields ++ @required_fields)
        |> validate_required(@required_fields)
      end
    end
  end
end
