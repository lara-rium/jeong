defmodule JeongWeb.IndexController do
  use JeongWeb, :controller

  def index(conn, _params) do
    redirect(conn, to: ~p"/users/new")
  end
end
