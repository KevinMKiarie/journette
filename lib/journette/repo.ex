defmodule Journette.Repo do
  use Ecto.Repo,
    otp_app: :journette,
    adapter: Ecto.Adapters.Postgres
end
