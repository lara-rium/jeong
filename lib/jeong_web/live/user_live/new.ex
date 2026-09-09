defmodule JeongWeb.UserLive.New do
  use JeongWeb, :live_view

  def handle_params(params, _uri, socket) do
    {:noreply, assign(socket, :invite, params["invite"])}
  end

  def render(assigns) do
    ~H"""
    <Layouts.app flash={@flash}>
      <main class="flex flex-col gap-16 justify-center items-center min-h-screen">
        <div class="text-8xl font-bold text-center">
          <p>your journey of</p>
          <p class="text-accent italic mt-4">shared journaling</p>
          <p>starts here</p>
        </div>
        <.link
          id="google-signup"
          href={if @invite, do: ~p"/auth/google?invite=#{@invite}", else: ~p"/auth/google"}
          class="btn btn-accent btn-xl font-bold w-fit"
        >
          sign up with google
        </.link>
      </main>
    </Layouts.app>
    """
  end
end
