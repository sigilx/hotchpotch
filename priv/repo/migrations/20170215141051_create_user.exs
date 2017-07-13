defmodule Hotchpotch.Repo.Migrations.CreateUser do
  use Ecto.Migration

  def change do
    create table(:users) do
      add :username, :string
      add :nickname, :string, null: false
      add :email, :string, null: false
      add :password, :string, null: false

      timestamps()
    end
    create unique_index(:users, ["lower(username)"])
    create unique_index(:users, [:nickname])
    create unique_index(:users, [:email])

  end
end
