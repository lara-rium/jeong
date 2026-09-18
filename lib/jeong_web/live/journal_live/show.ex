defmodule JeongWeb.JournalLive.Show do
  use JeongWeb, :live_view

  alias Jeong.Entries

  def mount(%{"journal_id" => journal_id, "date" => date}, _session, socket) do
    entries = Entries.get_entries(journal_id, date)

    {:ok, assign(socket, entries: entries.requested ++ List.wrap(entries.random))}
  end

  def render(assigns) do
    ~H"""
    <Layouts.app flash={@flash}>
      <main class="flex gap-8 flex-col justify-center items-center min-h-screen">
        <fieldset
          :for={entry <- @entries}
          class="fieldset bg-base-200 w-xl rounded-box border p-6 border-base-300"
        >
          <legend class="fieldset-legend">
            <%= if entry === List.last(@entries) do %>
              {entry.user.name} wrote for {Calendar.strftime(entry.date, "%d.%m.%Y")}
            <% else %>
              {entry.user.name} wrote for yesterday
            <% end %>
          </legend>

          <div class="carousel gap-4 rounded-box *:carousel-item *:box-border *:min-w-36 *:h-48 *:rounded-box">
            <img
              :for={media <- entry.media}
              src={"data:image/jpeg;base64,#{Base.encode64(media)}"}
            />
          </div>

          <div class="my-0 divider"></div>

          <p class="whitespace-pre-wrap">{entry.text}</p>
        </fieldset>
      </main>
    </Layouts.app>
    """
  end
end
