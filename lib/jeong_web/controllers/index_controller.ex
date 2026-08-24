defmodule JeongWeb.IndexController do
  use JeongWeb, :controller

  def index(conn, _params) do
    path = destination(conn)

    if path == ~p"/" do
      render(conn, :index, entries: [])
    else
      redirect(conn, to: path)
    end
  end

  def destination(conn) do
    if conn.assigns.current_user, do: ~p"/", else: ~p"/users/new"
  end
end
