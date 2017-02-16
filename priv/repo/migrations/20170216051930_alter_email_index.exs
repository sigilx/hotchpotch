defmodule Hotchpotch.Repo.Migrations.AlterEmailIndex do
  use Ecto.Migration

  def change do
    drop index(:users, [:email])
    create unique_index(:users, ["lower(email)"])
  end
end
