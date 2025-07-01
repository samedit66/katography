defmodule KatographyWeb.Router do
  use KatographyWeb, :router

  use KatographyWeb.Cors, endpoint: KatographyWeb.Endpoint

  pipeline :api do
    plug :cors
    plug :accepts, ["json"]
  end

  pipe_through :cors

  options "/*path", KatographyWeb.APIController, :options

  scope "/api", KatographyWeb do
    pipe_through :api

    get "/pages", PageController, :pages
    get "/pages/:id", PageController, :page

    get "/page/:page_id/folders", FolderController, :folders
    get "/folder/:id", FolderController, :folder

    get "/folder/:folder_id/pictures", PictureController, :pictures
    get "/picture/:id", PictureController, :picture
  end

  # Enable LiveDashboard and Swoosh mailbox preview in development
  if Application.compile_env(:katography, :dev_routes) do
    # If you want to use the LiveDashboard in production, you should put
    # it behind authentication and allow only admins to access it.
    # If your application does not have an admins-only section yet,
    # you can use Plug.BasicAuth to set up some basic authentication
    # as long as you are also using SSL (which you should anyway).
    import Phoenix.LiveDashboard.Router

    scope "/dev" do
      pipe_through [:fetch_session, :protect_from_forgery]

      live_dashboard "/dashboard", metrics: KatographyWeb.Telemetry
      forward "/mailbox", Plug.Swoosh.MailboxPreview
    end
  end
end
