defmodule JournetteWeb.PageController do
  use JournetteWeb, :controller

  def home(conn, _params) do
    render(conn, :home)
  end
end
