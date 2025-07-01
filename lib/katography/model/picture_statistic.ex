defmodule Katography.Model.PictureStatistic do
  @moduledoc false
  use Katography.Model

  alias Katography.Model.{Picture, UserAction}

  @required_fields ~w(picture_id action_id)a

  schema "picture_statistics" do
    belongs_to :picture, Picture
    belongs_to :action, UserAction

    timestamps()
  end
end
