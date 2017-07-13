defmodule Hotchpotch.Repo.Migrations.AlterUserTable do
  use Ecto.Migration

  def change do
    alter table(:users) do
      remove :password
      add :password_hash, :string, null: false
    end
  end
end
