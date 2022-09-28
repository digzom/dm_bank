defmodule DmBank.Repo.Migrations.CreateUsers do
  use Ecto.Migration

  def change do
    create table(:users, primary_key: false) do
      add(:id, :binary_id, primary_key: true)
      add(:name, :string, null: false)
      add(:email, :string, null: false)
      add(:password_hash, :string, null: false)

      timestamps()
    end

    # faremos muita pesquisa pelo email do usuário e também não
    # deve existir dois usuários com mesmo email
    create(index("users", [:email], unique: true))
  end
end
