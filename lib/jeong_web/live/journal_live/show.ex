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
            <%!-- todo: put this in a divider line or sth --%>
            <%= if entry === List.last(@entries) do %>
              {entry.user.name} wrote for {Calendar.strftime(entry.date, "%d.%m.%Y")}
            <% else %>
              {entry.user.name} wrote for yesterday
            <% end %>
          </legend>

          <div class="carousel gap-4 rounded-box *:carousel-item *:box-border *:min-w-36 *:h-48 *:rounded-box">
            <%!-- todo: clicking should enlarge image --%>
            <img
              :for={media <- entry.media}
              src={"data:image/jpeg;base64,#{Base.encode64(media)}"}
            />
          </div>

          <%!-- todo: remove this if no images --%>
          <div class="my-0 divider"></div>

          <p class="whitespace-pre-wrap">{entry.text}</p>
        </fieldset>

        <div :if={length(@current_user.journal.users) === 1} class="toast toast-center">
          <div role="alert" class="alert alert-soft alert-info">
            <.icon name="hero-user-plus" />
            <span>send this link to your partner to add them to your journal</span>
            <button
              id="copy-invite"
              type="button"
              class="btn btn-circle btn-sm btn-info"
              phx-hook=".CopyText"
              data-copy={url(~p"/users/new?token=#{@current_user.journal.token}")}
            >
              <.icon name="hero-clipboard-document" />
            </button>
          </div>
        </div>
      </main>
    </Layouts.app>

    <script :type={Phoenix.LiveView.ColocatedHook} name=".CopyText">
      export default {
        mounted() {
          this.el.addEventListener("click", async () => {
            await navigator.clipboard.writeText(this.el.dataset.copy)

            this.el
              .querySelector(".hero-clipboard-document")
              .classList.replace(
                "hero-clipboard-document",
                "hero-clipboard-document-check"
              )
          })
        }
      }
    </script>
    """
  end
end
