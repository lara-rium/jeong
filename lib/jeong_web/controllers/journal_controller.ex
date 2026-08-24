defmodule JeongWeb.JournalController do
  use JeongWeb, :controller

  def show(conn, _params) do
    render(conn, :show)
  end
end
