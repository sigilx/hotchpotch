defmodule Hotchpotch.Repo.Migrations.AlterUserUsernameIndex do
  use Ecto.Migration

  def change do
    drop index(:users, [:username])
    create unique_index(:users, ["lower(username)"])
  end
end
