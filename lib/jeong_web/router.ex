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

  pipeline :canonical_path do
    plug :redirect_to_index
  end

  scope "/", JeongWeb do
    pipe_through :browser

    get "/", IndexController, :index

    scope "/" do
      pipe_through :canonical_path

      resources "/users", UserController, only: [:new]
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

  defp redirect_to_index(conn, _opts) do
    if conn.request_path == JeongWeb.IndexController.destination(conn) do
      conn
    else
      conn
      |> redirect(to: "/")
      |> halt()
    end
  end
end
