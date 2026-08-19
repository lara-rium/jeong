defmodule JeongWeb.RegisterController do
  use JeongWeb, :controller

  def index(conn, _params) do
    render(conn, :index)
  end
end
