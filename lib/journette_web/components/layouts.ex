defmodule JournetteWeb.Layouts do
  @moduledoc """
  This module holds layouts and related functionality
  used by your application.
  """
  use JournetteWeb, :html

  # Embed all files in layouts/* within this module.
  # The default root.html.heex file contains the HTML
  # skeleton of your application, namely HTML headers
  # and other static content.
  embed_templates "layouts/*"

  @doc """
  Renders your app layout.

  This function is typically invoked from every template,
  and it often contains your application menu, sidebar,
  or similar.

  ## Examples

      <Layouts.app flash={@flash}>
        <h1>Content</h1>
      </Layouts.app>

  """
  attr :flash, :map, required: true, doc: "the map of flash messages"

  attr :current_scope, :map,
    default: nil,
    doc: "the current [scope](https://hexdocs.pm/phoenix/scopes.html)"

  slot :inner_block, required: true

  def app(assigns) do
    ~H"""
    <header class="navbar border-b border-base-300 px-4 sm:px-6 lg:px-8">
      <div class="flex-1">
        <a href="/">
          <img src={~p"/images/Journette.png"} class="h-8 w-auto" alt="Journette" />
        </a>
      </div>
      <div class="flex-none">
        <ul class="flex items-center gap-1">
          <%= if @current_scope && @current_scope.user do %>
            <li>
              <span class="text-sm text-base-content/50 px-2 hidden sm:block">
                {@current_scope.user.email}
              </span>
            </li>
            <li>
              <.link href={~p"/users/settings"} class="btn btn-ghost btn-sm">Settings</.link>
            </li>
            <li>
              <.link href={~p"/users/log-out"} method="delete" class="btn btn-ghost btn-sm">
                Log out
              </.link>
            </li>
          <% else %>
            <li>
              <.link href={~p"/users/register"} class="btn btn-ghost btn-sm">Register</.link>
            </li>
            <li>
              <.link href={~p"/users/log-in"} class="btn btn-primary btn-sm">Sign in</.link>
            </li>
          <% end %>
          <li><.theme_toggle /></li>
        </ul>
      </div>
    </header>

    <main class="px-4 py-10 sm:px-6 lg:px-8">
      <div class="mx-auto max-w-3xl space-y-4">
        {render_slot(@inner_block)}
      </div>
    </main>

    <.flash_group flash={@flash} />
    """
  end

  @doc """
  Full-screen split layout for auth pages (login, register).
  Left panel: dark brand panel with gradient glow.
  Right panel: the form content.
  """
  attr :flash, :map, required: true
  attr :left_title, :string, default: "Where great journalism lives."

  attr :left_subtitle, :string,
    default: "Join editors and organizations publishing trusted content on Journette."

  slot :inner_block, required: true

  def auth(assigns) do
    ~H"""
    <div class="min-h-screen flex">
      <div
        style="background: url('/images/journette-log.jpg') center/cover no-repeat"
        class="hidden lg:flex lg:w-1/2 relative overflow-hidden flex-col justify-between p-12  "
      >
        <div class="absolute z-2 bg-black/20 h-screen w-full"></div>
        <div class="relative z-10">
          <img
            src={~p"/images/Journette.png"}
            class="h-10 w-auto"
            alt="Journette"
            style="mix-blend-mode: screen;"
          />
        </div>

        <div class="relative z-10">
          <h1 class="text-2xl md:text-7xl font-black text-orange-400 leading-tight tracking-tight">
            {@left_title}
          </h1>
          <p class="mt-5 text-orange-500 text-lg leading-relaxed">
            {@left_subtitle}
          </p>
        </div>

        <div class="relative z-10">
          <p class="text-white/25 text-sm">© 2026 Journette. All rights reserved.</p>
        </div>
      </div>

      <div class="flex-1 flex items-center justify-center bg-base-100 p-8 lg:p-12">
        <div class="w-full max-w-md">
          <div class="lg:hidden mb-10">
            <img src={~p"/images/Journette.png"} class="h-8 w-auto" alt="Journette" />
          </div>

          <.flash_group flash={@flash} />
          {render_slot(@inner_block)}
        </div>
      </div>
    </div>
    """
  end

  @doc """
  Shows the flash group with standard titles and content.

  ## Examples

      <.flash_group flash={@flash} />
  """
  attr :flash, :map, required: true, doc: "the map of flash messages"
  attr :id, :string, default: "flash-group", doc: "the optional id of flash container"

  def flash_group(assigns) do
    ~H"""
    <div id={@id} aria-live="polite">
      <.flash kind={:info} flash={@flash} />
      <.flash kind={:error} flash={@flash} />

      <.flash
        id="client-error"
        kind={:error}
        title={gettext("We can't find the internet")}
        phx-disconnected={show(".phx-client-error #client-error") |> JS.remove_attribute("hidden")}
        phx-connected={hide("#client-error") |> JS.set_attribute({"hidden", ""})}
        hidden
      >
        {gettext("Attempting to reconnect")}
        <.icon name="hero-arrow-path" class="ml-1 size-3 motion-safe:animate-spin" />
      </.flash>

      <.flash
        id="server-error"
        kind={:error}
        title={gettext("Something went wrong!")}
        phx-disconnected={show(".phx-server-error #server-error") |> JS.remove_attribute("hidden")}
        phx-connected={hide("#server-error") |> JS.set_attribute({"hidden", ""})}
        hidden
      >
        {gettext("Attempting to reconnect")}
        <.icon name="hero-arrow-path" class="ml-1 size-3 motion-safe:animate-spin" />
      </.flash>
    </div>
    """
  end

  @doc """
  Provides dark vs light theme toggle based on themes defined in app.css.

  See <head> in root.html.heex which applies the theme before page load.
  """
  def theme_toggle(assigns) do
    ~H"""
    <div class="card relative flex flex-row items-center border-2 border-base-300 bg-base-300 ">
      <div class="absolute w-1/3 h-full  border-1 border-base-200 bg-base-100 brightness-200 left-0 [[data-theme=light]_&]:left-1/3 [[data-theme=dark]_&]:left-2/3 transition-[left]" />

      <button
        class="flex p-2 cursor-pointer w-1/3"
        phx-click={JS.dispatch("phx:set-theme")}
        data-phx-theme="system"
      >
        <.icon name="hero-computer-desktop-micro" class="size-4 opacity-75 hover:opacity-100" />
      </button>

      <button
        class="flex p-2 cursor-pointer w-1/3"
        phx-click={JS.dispatch("phx:set-theme")}
        data-phx-theme="light"
      >
        <.icon name="hero-sun-micro" class="size-4 opacity-75 hover:opacity-100" />
      </button>

      <button
        class="flex p-2 cursor-pointer w-1/3"
        phx-click={JS.dispatch("phx:set-theme")}
        data-phx-theme="dark"
      >
        <.icon name="hero-moon-micro" class="size-4 opacity-75 hover:opacity-100" />
      </button>
    </div>
    """
  end
end
