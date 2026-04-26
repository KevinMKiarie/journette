defmodule JournetteWeb.AuthController do
  use JournetteWeb, :controller
  plug Ueberauth

  def request(conn, _params), do: conn
  # ueberauth handles redirect

  def callback(%{assigns: %{ueberauth_failure: _fails}} = conn, _params) do
    conn
    |> put_flash(:error, "Authentication Failed, please try again in 3s")
    |> redirect(to: ~p"/users/log_in")
  end

  def callback(%{assigns: %{ueberauth_auth: auth}} = conn, _params) do
    case Journette.Accounts.find_or_create_from_oauth(auth) do
      {:ok, user} ->
        conn
        |> put_flash(:info, "Signed in with #{auth.provider}.")
        |> JournetteWeb.UserAuth.log_in_user(user)

      {:error, _reason} ->
        conn
        |> put_flash(:error, "Could not sign in")
        |> redirect(to: ~p"/users/log_in")
    end
  end
end
