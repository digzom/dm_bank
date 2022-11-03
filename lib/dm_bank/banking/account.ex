defmodule DmBank.Banking.Account do
  use Ecto.Schema
  alias DmBank.Users.User

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "account" do
    field :current_balance, :decimal, default: Decimal.new("0.0")

    belongs_to :user, User

    timestamps()
  end
end
