defmodule DmBank.Users.User do
  use Ecto.Schema
  import Ecto.Changeset

  alias Ecto.Changeset

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "users" do
    field :email, :string
    field :name, :string
    # the redact option hide the information in logs
    field :password, :string, virtual: true, redact: true
    field :password_hash, :string, redact: true

    timestamps()
  end

  def update_changeset(user, attrs) do
    user
    |> cast(attrs, [:name])
    |> validate_required([:name])

    # retornarĂ¡ o erro na hora do insert
  end

  @doc false
  def registration_changeset(user, attrs) do
    user
    |> update_changeset(attrs)
    |> cast(attrs, [:email, :password])
    |> validate_required([:email, :password])
    # retornarĂ¡ o erro na hora do insert
    |> unique_constraint([:email])
    # compare with password_confirmation field
    |> validate_confirmation(:password)
    |> put_password_hash()
  end

  defp put_password_hash(%Changeset{valid?: true, changes: %{password: password}} = changeset) do
    hash = Pbkdf2.hash_pwd_salt(password)

    # adicionando a change no changeset
    put_change(changeset, :password_hash, hash)
  end

  defp put_password_hash(changeset), do: changeset
end
