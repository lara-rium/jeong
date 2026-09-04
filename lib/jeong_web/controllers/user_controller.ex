defmodule JeongWeb.UserController do
  use JeongWeb, :controller

  def new(conn, _params) do
    render(conn, :new)
  end

  def new_with_journal(conn, %{"token" => token}) do
    render(conn, :new_with_journal, token: token)
  end
end
