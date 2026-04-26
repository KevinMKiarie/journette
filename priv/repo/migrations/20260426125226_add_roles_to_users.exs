defmodule Journette.Repo.Migrations.AddRolesToUsers do
  use Ecto.Migration

  def change do

    alter table(:users)do
      add :role, :string, bull: false, default: "editor"
    end


    create index(:users, [:role])
  end
end
