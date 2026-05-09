defmodule JournetteWeb.UserLive.Login do
  use JournetteWeb, :live_view

  alias Journette.Accounts

  @impl true
  def render(assigns) do
    ~H"""
    <Layouts.auth
      flash={@flash}
      left_title="Welcome back to Journette."
      left_subtitle="Continue telling the stories that matter to you and your audience."
    >
      <div class="mb-8">
        <img src={~p"/images/Journette.png"} class="h-10 w-auto" alt="Journette" />
      </div>

      <h1 class="text-3xl font-bold text-base-content mb-1">Sign In</h1>
      <p class="text-base-content/55 mb-8">
        {if @current_scope,
          do: "Re-authenticate to continue.",
          else: "Welcome back · let's pick up where you left off"}
      </p>

      <%!-- Dev mailbox notice --%>
      <div :if={local_mail_adapter?()} class="alert alert-info mb-6 py-3 text-sm">
        <.icon name="hero-information-circle" class="size-4 shrink-0" />
        <span>
          Dev mode: view sent emails at <.link href="/dev/mailbox" class="underline font-medium">the mailbox page</.link>.
        </span>
      </div>

      <%!-- Login method tabs --%>
      <div class="flex  border border-base-300 bg-base-200 p-1 gap-1 mb-6">
        <button
          type="button"
          phx-click="set_login_method"
          phx-value-method="magic"
          class={"flex-1 py-2.5 px-4  text-sm font-medium transition-all duration-200 flex items-center justify-center gap-1.5 " <>
            if(@login_method == "magic",
              do: "bg-base-100 text-base-content shadow-sm",
              else: "text-base-content/45 hover:text-base-content/70"
            )}
        >
          <.icon name="hero-envelope-micro" class="size-3.5" /> Magic Link
        </button>
        <button
          type="button"
          phx-click="set_login_method"
          phx-value-method="password"
          class={"flex-1 py-2.5 px-4  text-sm font-medium transition-all duration-200 flex items-center justify-center gap-1.5 " <>
            if(@login_method == "password",
              do: "bg-base-100 text-base-content shadow-sm",
              else: "text-base-content/45 hover:text-base-content/70"
            )}
        >
          <.icon name="hero-lock-closed-micro" class="size-3.5" /> Password
        </button>
      </div>

      <%!-- Magic link form --%>
      <.form
        :let={f}
        :if={@login_method == "magic"}
        for={@form}
        id="login_form_magic"
        action={~p"/users/log-in"}
        phx-submit="submit_magic"
        class="space-y-4"
      >
        <.input
          readonly={!!@current_scope}
          field={f[:email]}
          type="email"
          label="Your email"
          placeholder="you@example.com"
          autocomplete="username"
          spellcheck="false"
          required
          phx-mounted={JS.focus()}
        />
        <.button class="btn btn-primary w-full text-base">
          Send magic link <span aria-hidden="true">→</span>
        </.button>
        <p class="text-xs text-center text-base-content/40">
          We'll email you a secure, one-click sign-in link.
        </p>
      </.form>

      <%!-- Password form --%>
      <.form
        :let={f}
        :if={@login_method == "password"}
        for={@form}
        id="login_form_password"
        action={~p"/users/log-in"}
        phx-submit="submit_password"
        phx-trigger-action={@trigger_submit}
        class="space-y-4"
      >
        <.input
          readonly={!!@current_scope}
          field={f[:email]}
          type="email"
          label="Your email"
          placeholder="you@example.com"
          autocomplete="username"
          spellcheck="false"
          required
        />
        <.input
          field={@form[:password]}
          type="password"
          label="Password"
          autocomplete="current-password"
          spellcheck="false"
        />
        <.button
          class="btn btn-primary w-full text-base"
          name={@form[:remember_me].name}
          value="true"
        >
          Sign in <span aria-hidden="true">→</span>
        </.button>
      </.form>

      <%!-- Divider --%>
      <div class="relative my-6">
        <div class="absolute inset-0 flex items-center">
          <div class="w-full border-t border-base-300"></div>
        </div>
        <div class="relative flex justify-center text-xs">
          <span class="bg-base-100 px-3 text-base-content/40">or continue with</span>
        </div>
      </div>

      <%!-- OAuth buttons --%>
      <div class="grid grid-cols-2 gap-3">
        <a href={~p"/auth/google"} class="btn btn-outline gap-2 text-sm font-medium">
          <svg class="size-4 shrink-0" viewBox="0 0 24 24" xmlns="http://www.w3.org/2000/svg">
            <path
              d="M22.56 12.25c0-.78-.07-1.53-.2-2.25H12v4.26h5.92c-.26 1.37-1.04 2.53-2.21 3.31v2.77h3.57c2.08-1.92 3.28-4.74 3.28-8.09z"
              fill="#4285F4"
            />
            <path
              d="M12 23c2.97 0 5.46-.98 7.28-2.66l-3.57-2.77c-.98.66-2.23 1.06-3.71 1.06-2.86 0-5.29-1.93-6.16-4.53H2.18v2.84C3.99 20.53 7.7 23 12 23z"
              fill="#34A853"
            />
            <path
              d="M5.84 14.09c-.22-.66-.35-1.36-.35-2.09s.13-1.43.35-2.09V7.07H2.18C1.43 8.55 1 10.22 1 12s.43 3.45 1.18 4.93l2.85-2.22.81-.62z"
              fill="#FBBC05"
            />
            <path
              d="M12 5.38c1.62 0 3.06.56 4.21 1.64l3.15-3.15C17.45 2.09 14.97 1 12 1 7.7 1 3.99 3.47 2.18 7.07l3.66 2.84c.87-2.6 3.3-4.53 6.16-4.53z"
              fill="#EA4335"
            />
          </svg>
          Google
        </a>
        <a href={~p"/auth/github"} class="btn btn-outline gap-2 text-sm font-medium">
          <svg
            class="size-4 shrink-0"
            viewBox="0 0 24 24"
            xmlns="http://www.w3.org/2000/svg"
            fill="currentColor"
          >
            <path d="M12 .297c-6.63 0-12 5.373-12 12 0 5.303 3.438 9.8 8.205 11.385.6.113.82-.258.82-.577 0-.285-.01-1.04-.015-2.04-3.338.724-4.042-1.61-4.042-1.61C4.422 18.07 3.633 17.7 3.633 17.7c-1.087-.744.084-.729.084-.729 1.205.084 1.838 1.236 1.838 1.236 1.07 1.835 2.809 1.305 3.495.998.108-.776.417-1.305.76-1.605-2.665-.3-5.466-1.332-5.466-5.93 0-1.31.465-2.38 1.235-3.22-.135-.303-.54-1.523.105-3.176 0 0 1.005-.322 3.3 1.23.96-.267 1.98-.399 3-.405 1.02.006 2.04.138 3 .405 2.28-1.552 3.285-1.23 3.285-1.23.645 1.653.24 2.873.12 3.176.765.84 1.23 1.91 1.23 3.22 0 4.61-2.805 5.625-5.475 5.92.42.36.81 1.096.81 2.22 0 1.606-.015 2.896-.015 3.286 0 .315.21.69.825.57C20.565 22.092 24 17.592 24 12.297c0-6.627-5.373-12-12-12" />
          </svg>
          GitHub
        </a>
      </div>

      <p class="text-center text-sm text-base-content/55 mt-8">
        Don't have an account?
        <.link navigate={~p"/users/register"} class="font-semibold text-primary hover:underline">
          Create one
        </.link>
      </p>
    </Layouts.auth>
    """
  end

  @impl true
  def mount(_params, _session, socket) do
    email =
      Phoenix.Flash.get(socket.assigns.flash, :email) ||
        get_in(socket.assigns, [:current_scope, Access.key(:user), Access.key(:email)])

    form = to_form(%{"email" => email}, as: "user")
    {:ok, assign(socket, form: form, trigger_submit: false, login_method: "magic")}
  end

  @impl true
  def handle_event("set_login_method", %{"method" => method}, socket)
      when method in ["magic", "password"] do
    {:noreply, assign(socket, :login_method, method)}
  end

  def handle_event("submit_password", _params, socket) do
    {:noreply, assign(socket, :trigger_submit, true)}
  end

  def handle_event("submit_magic", %{"user" => %{"email" => email}}, socket) do
    if user = Accounts.get_user_by_email(email) do
      Accounts.deliver_login_instructions(user, &url(~p"/users/log-in/#{&1}"))
    end

    info = "If your email is in our system, you will receive instructions for logging in shortly."
    {:noreply, socket |> put_flash(:info, info) |> push_navigate(to: ~p"/users/log-in")}
  end

  defp local_mail_adapter? do
    Application.get_env(:journette, Journette.Mailer)[:adapter] == Swoosh.Adapters.Local
  end
end
