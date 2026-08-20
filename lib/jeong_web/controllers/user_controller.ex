defmodule JeongWeb.UserController do
  use JeongWeb, :controller

  def new(conn, _params) do
    render(conn, :new)
  end
end
