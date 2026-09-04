defmodule JeongWeb.IndexController do
  use JeongWeb, :controller

  alias Jeong.Entries

  def index(conn, _params) do
    path = destination(conn)

    if path == ~p"/" do
      render(conn, :index, entries: [])
    else
      redirect(conn, to: path)
    end
  end

  def destination(conn) do
    user = conn.assigns.current_user

    cond do
      is_nil(user) -> ~p"/users/new"
      # todo: only if yesterday entry missing
      Entries.get_entries(user.journal_id) == [] -> ~p"/entries/new"
      true -> ~p"/entries/new"
    end
  end
end
