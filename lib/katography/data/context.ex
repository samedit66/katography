defmodule Katography.Context do
  @moduledoc false

  defmacro __using__(opts \\ []) do
    model = Keyword.fetch!(opts, :model)

    quote do
      import Katography.Filter

      alias Katography.Repo

      @model_module Module.concat(Katography.Model, unquote(model))

      @type opts :: keyword()
      @type params :: map()
      @type model :: @model_module.t()

      @spec get(opts :: opts()) :: model() | nil
      def get(opts) do
        @model_module
        |> filter_by(opts)
        |> Repo.one()
      end

      @spec do_get(opts :: opts()) :: {:ok, model()} | {:error, :not_found}
      def do_get(opts) do
        case __MODULE__.get(opts) do
          nil -> {:error, :not_found}
          record -> {:ok, record}
        end
      end

      @spec all(opts :: opts()) :: [model()]
      def all(opts \\ []) do
        @model_module
        |> filter_by(opts)
        |> Repo.all()
      end

      @spec count(opts :: opts()) :: non_neg_integer()
      def count(opts \\ []) do
        @model_module
        |> filter_by(opts)
        |> Repo.aggregate(:count)
      end

      @spec create(params :: params()) :: {:ok, model()} | {:error, Ecto.Changeset.t()}
      def create(params, changeset \\ :changeset) do
        changeset = fn model -> apply(@model_module, changeset, [model, params]) end

        struct(@model_module)
        |> changeset.()
        |> Repo.insert()
      end

      @spec update(model :: model(), params :: params()) ::
              {:ok, model()} | {:error, Ecto.Changeset.t()}
      def update(model, params) do
        model
        |> @model_module.changeset(params)
        |> Repo.update()
      end

      @spec get_or_create(params :: params()) :: {:ok, model()} | {:error, Ecto.Changeset.t()}
      def get_or_create(params) do
        keyword_params = Enum.into(params, [])

        case do_get(keyword_params) do
          {:error, :not_found} -> create(params)
          record -> record
        end
      end

      defoverridable get: 1, all: 1, count: 1, create: 2, update: 2, get_or_create: 1
    end
  end
end
