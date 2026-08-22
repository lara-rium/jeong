defmodule JeongWeb.IndexController do
  use JeongWeb, :controller

  def index(conn, _params) do
    if get_session(conn, :user_id) do
      render(conn, :index, entries: [])
    else
      redirect(conn, to: ~p"/users/new")
    end
  end
end
