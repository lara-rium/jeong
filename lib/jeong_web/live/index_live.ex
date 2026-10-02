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

  # todo: make sure mobile works
  def render(assigns) do
    ~H"""
    <Layouts.app flash={@flash} connected?={@connected?} />
    """
  end
end
