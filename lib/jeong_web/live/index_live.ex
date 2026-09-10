defmodule JeongWeb.IndexLive do
  use JeongWeb, :live_view

  alias JeongWeb.Navigation

  def mount(_params, _session, socket) do
    if connected?(socket) do
      {:ok, redirect(socket, to: Navigation.destination(socket.assigns))}
    else
      {:ok, socket}
    end
  end

  def render(assigns) do
    ~H"""
    <Layouts.app flash={@flash} />
    """
  end
end
