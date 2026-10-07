defmodule JeongWeb.UserLive.New do
  use JeongWeb, :live_view

  def handle_params(params, _uri, socket) do
    {:noreply, assign(socket, :token, params["token"])}
  end

  def render(assigns) do
    ~H"""
    <Layouts.app flash={@flash} connected?={@connected?}>
      <main class="flex flex-col lg:gap-16 gap-4 justify-center items-center min-h-dvh">
        <div class="lg:text-8xl text-5xl font-bold text-center">
          <p>{gettext("your journey of")}</p>
          <p class="text-accent italic">{gettext("shared journaling")}</p>
          <p>{gettext("starts here")}</p>
        </div>
        <.link
          id="google-signup"
          href={if @token, do: ~p"/auth/google?token=#{@token}", else: ~p"/auth/google"}
          class="btn btn-accent lg:btn-xl btn-lg font-bold w-fit"
        >
          <%= if @token do %>
            {gettext("sign in with google to join journal")}
          <% else %>
            {gettext("sign in with google")}
          <% end %>
        </.link>
      </main>
    </Layouts.app>
    """
  end
end
