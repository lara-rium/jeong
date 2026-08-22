defmodule JeongWeb.UserController do
  use JeongWeb, :controller

  import Ecto.Query

  alias Jeong.Repo
  alias Jeong.User

  def new(conn, _params) do
    render(conn, :new)
  end

  def callback(%{assigns: %{ueberauth_failure: %Ueberauth.Failure{}}} = conn, _params) do
    conn
    |> put_flash(:error, "couldn't sign you in. please try again.")
    |> redirect(to: ~p"/")
  end

  def callback(%{assigns: %{ueberauth_auth: %Ueberauth.Auth{} = auth}} = conn, _params) do
    {image, image_type} = fetch_image(auth.info.image)

    user =
      Repo.insert!(%User{
        name: auth.info.first_name,
        email: auth.info.email,
        image: image,
        image_type: image_type
      })

    conn
    |> renew_session()
    |> put_session(:user_id, user.id)
    |> redirect(to: ~p"/")
  end

  def image(conn, %{"id" => id}) do
    query = from user in User, where: user.id == ^id, select: {user.image, user.image_type}

    {image, image_type} = Repo.one!(query)

    conn
    |> put_resp_content_type(image_type, nil)
    |> send_resp(200, image)
  end

  defp fetch_image(url) do
    response = Req.get!(url)

    {response.body,
     response
     |> Req.Response.get_header("content-type")
     |> List.first()}
  end

  defp renew_session(conn) do
    Plug.CSRFProtection.delete_csrf_token()

    conn
    |> configure_session(renew: true)
    |> clear_session()
  end
end
