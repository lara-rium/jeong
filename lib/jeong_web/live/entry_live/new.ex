defmodule JeongWeb.EntryLive.New do
  use JeongWeb, :live_view

  alias Jeong.Entries
  alias Jeong.Entry

  def mount(_params, _session, socket) do
    {:ok,
     socket
     |> assign(form: to_form(Entry.changeset()))
     |> allow_upload(:media, accept: ~w(image/*), max_entries: 10)}
  end

  # todo: customize validaiton errors, especially text
  def handle_event("validate", %{"entry" => params}, socket) do
    {:noreply,
     assign(socket,
       form:
         params
         |> Entry.changeset()
         |> to_form(action: :validate)
     )}
  end

  def handle_event("save", %{"entry" => params}, socket) do
    media =
      consume_uploaded_entries(socket, :media, fn %{path: path}, _upload ->
        {:ok, File.read!(path)}
      end)

    yesterday =
      socket.assigns.time_zone
      |> DateTime.now!()
      |> DateTime.shift(day: -1)
      |> DateTime.to_date()

    Entries.create_entry(socket.assigns.current_user, params, media, yesterday)

    {:noreply, redirect(socket, to: ~p"/")}
  end

  def render(assigns) do
    ~H"""
    <Layouts.app flash={@flash}>
      <main class="grid place-items-center min-h-screen">
        <.form id="entry-form" for={@form} phx-change="validate" phx-submit="save">
          <fieldset class="fieldset bg-base-200 w-xl rounded-box border p-4 rounded-ss-2xl border-base-300">
            <legend class="fieldset-legend">add yesterday to your journal to continue</legend>

            <div class="carousel gap-4 *:carousel-item *:box-border *:aspect-4/5 *:h-48 *:rounded-box">
              <.live_img_preview
                :for={entry <- @uploads.media.entries}
                entry={entry}
                class="object-cover"
              />

              <label
                id="compress"
                phx-hook=".Compress"
                class="btn btn-dash noise"
              >
                <span class="text-2xl">+</span>
                <span>add a photo</span>
                <.live_file_input upload={@uploads.media} class="hidden" />
              </label>
            </div>

            <.input
              field={@form[:text]}
              type="textarea"
              class="w-full textarea noise h-48 rounded-3xl bg-base-200"
              placeholder="write about it..."
              required
            />

            <button type="submit" class="btn btn-primary">save</button>
          </fieldset>
        </.form>
      </main>
    </Layouts.app>

    <script :type={Phoenix.LiveView.ColocatedHook} name=".Compress">
      import imageCompression from "@/vendor/browser-image-compression.mjs"

      const options = {
        alwaysKeepResolution: true,
        fileType: "image/jpeg",
        initialQuality: 0.9,
        maxSizeMB: 4,
        maxWidthOrHeight: 2560,
        useWebWorker: false,
      }

      export default {
        mounted() {
          this.el.addEventListener("input", event => {
            if (event.isTrusted) event.stopPropagation()
          })

          this.el.addEventListener("change", async event => {
            if (!event.isTrusted) return
            event.stopPropagation()

            const input = event.target
            const submitButton = input.form.querySelector("[type=submit]")
            submitButton.disabled = true

            const transfer = new DataTransfer()
            for (const file of input.files) {
              const blob = await imageCompression(file, options)
              const name = file.name.replace(/\.[^.]+$/, ".jpeg")
              transfer.items.add(new File([blob], name, {type: blob.type}))
            }
            input.files = transfer.files

            input.dispatchEvent(new Event("change", {bubbles: true}))

            submitButton.disabled = false
          })
        },
      }
    </script>
    """
  end
end
