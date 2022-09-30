defmodule DmBank.Factory do
  use ExMachina.Ecto, repo: DmBank.Repo

  alias DmBank.UserAuth.User

  def user_factory do
    %User{
      name: Faker.Person.name(),
      email: sequence(:email, &"email-#{&1}@example.com"),
      # password: "123456",
      password_hash: ""
    }
  end
end
