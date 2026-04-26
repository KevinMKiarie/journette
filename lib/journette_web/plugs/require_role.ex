defmodule JournetteWeb.Plugs.RequireRole do
  import Plug.Conn
  import Phoenix.Controller

  def init(role), do: role

  def call(conn, required_role) do
    user = conn.assigns[:current_scope] && conn.assigns.current_scope.user

    if user && user.role == required_role do
      conn
    else
      conn
      |> put_flash(:error, "You have limited access. Kindly contact support.")
      |> redirect(to: "/")
      |> halt()
    end
  end
end
