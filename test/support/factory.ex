defmodule DmBank.Factory do
  use ExMachina.Ecto, repo: DmBank.Repo

  alias DmBank.Users.User
  alias DmBank.Banking.Account

  def user_factory do
    %User{
      name: Faker.Person.name(),
      email: sequence(:email, &"email-#{&1}@example.com"),
      password_hash: ""
    }
  end

  def account_factory do
    user = insert(:user)

    %Account{
      user_id: user.id
    }
  end
end
