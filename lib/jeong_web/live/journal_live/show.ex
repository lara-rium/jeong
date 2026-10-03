defmodule JeongWeb.JournalLive.Show do
  use JeongWeb, :live_view

  alias Jeong.Entries

  def mount(%{"journal_id" => journal_id, "date" => date}, _session, socket) do
    entries = Entries.get_entries(journal_id, date)

    {:ok, assign(socket, entries: entries)}
  end

  def render(assigns) do
    ~H"""
    <Layouts.app flash={@flash} connected?={@connected?}>
      <main class="flex gap-8 flex-col justify-center items-center min-h-screen">
        <div>
          <div class="divider w-xl self-auto my-0">
            {if @entry_target.is_today,
              do: gettext("today's entries"),
              else: gettext("yesterday's entries")}
          </div>
          <p :if={!@entry_target.is_today} class="text-xs text-center mt-2 opacity-60">
            {gettext("come after 10pm to see today's entries")}
          </p>
        </div>

        <.entry :for={entry <- @entries.requested} entry={entry} />

        <%= if @entries.random do %>
          <div class="divider w-xl self-auto my-0">
            {gettext("random entry on %{date}",
              date: Calendar.strftime(@entries.random.date, "%d/%m/%Y")
            )}
          </div>

          <.entry entry={@entries.random} />
        <% else %>
          <div class="divider w-xl self-auto my-0">
            {gettext("your random entry will appear below once you have another entry")}
          </div>
        <% end %>

        <div :if={length(@current_user.journal.users) === 1} class="toast toast-center">
          <div role="alert" class="alert alert-soft alert-info">
            <.icon name="hero-user-plus" />
            <span>{gettext("send this link to your partner to add them to your journal")}</span>
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
      <dialog id="image-preview" class="modal">
        <div class="modal-box p-0 max-w-full w-fit">
          <img class="h-[80vh] w-[80w] object-contain" />
        </div>
        <form method="dialog" class="modal-backdrop"><button class="cursor-default"></button></form>
      </dialog>
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

  defp entry(assigns) do
    ~H"""
    <fieldset class="fieldset bg-base-200 w-xl rounded-box border p-6 border-base-300">
      <legend class="fieldset-legend py-0">{@entry.user.name}:</legend>

      <div :if={@entry.media != []}>
        <div class="carousel gap-4 rounded-box">
          <img
            :for={{media, index} <- Enum.with_index(@entry.media)}
            id={"image-thumbnail-#{@entry.id}-#{index}"}
            class="carousel-item box-border min-w-36 h-48 rounded-box cursor-pointer"
            phx-hook=".OpenModal"
            src={"data:image/jpeg;base64,#{Base.encode64(media)}"}
          />
        </div>
        <div class="my-0 divider"></div>
      </div>

      <p class="whitespace-pre-wrap">{@entry.text}</p>
    </fieldset>

    <script :type={Phoenix.LiveView.ColocatedHook} name=".OpenModal">
      export default {
        mounted() {
          this.el.addEventListener("click", () => {
            const dialog = document.getElementById("image-preview")
            dialog.querySelector("img").src = this.el.src
            dialog.showModal()
          })
        }
      }
    </script>
    """
  end
end
