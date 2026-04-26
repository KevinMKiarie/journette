defmodule Journette.Accounts.UserIdentity do
  use Ecto.Schema
  import Ecto.Changeset

  alias Journette.Accounts.User

  schema "user_identities" do
    field :provider, :string
    field :uid, :string
    field :token, :string

    belongs_to :user, User

    timestamps(type: :utc_datetime)
  end

  def changeset(identity, attrs) do
    identity
    |> cast(attrs, [:provider, :uid, :token, :user_id])
    |> validate_required([:provider, :uid, :user_id])
    |> unique_constraint([:provider, :uid])
  end
end
