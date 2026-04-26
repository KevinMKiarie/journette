defmodule Journette.Repo.Migrations.CreateUserIdentities do
  use Ecto.Migration

  def change do
    create table(:user_identities) do
      add :user_id, references(:users, on_delete: :delete_all), null: false
      # "google" | "github"
      add :provider, :string, null: false
      # provider's user id
      add :uid, :string, null: false
      # access token (optional)
      add :token, :string

      timestamps(type: :utc_datetime)
    end

    create unique_index(:user_identities, [:provider, :uid])
    create index(:user_identities, [:user_id])
  end
end
