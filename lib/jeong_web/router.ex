defmodule JeongWeb.Router do
  use JeongWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_live_flash
    plug :put_root_layout, html: {JeongWeb.Layouts, :root}
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", JeongWeb do
    pipe_through :browser

    live_session :default, on_mount: [JeongWeb.Navigation] do
      live "/", IndexLive
      live "/users/new", UserLive.New
      live "/users/new/:token", UserLive.New, :invite
      live "/journals/:id/days/:date", JournalLive.Show
      live "/entries/new", EntryLive.New
    end
  end

  scope "/auth", JeongWeb do
    pipe_through :browser

    get "/:provider", AuthController, :request
    get "/:provider/callback", AuthController, :callback
  end

  if Application.compile_env(:jeong, :dev_routes) do
    import Phoenix.LiveDashboard.Router

    scope "/dev" do
      pipe_through :browser

      live_dashboard "/dashboard", metrics: JeongWeb.Telemetry
      forward "/mailbox", Plug.Swoosh.MailboxPreview
    end
  end
end
