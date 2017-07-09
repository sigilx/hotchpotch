defmodule Hotchpotch.Repo.Migrations.CreateBoard do
  use Ecto.Migration

  def change do
    create table(:boards) do
      add :title, :string
      add :user_id, references(:users, on_delete: :delete_all)

      timestamps()
    end
    create index(:boards, [:user_id])

  end
end
