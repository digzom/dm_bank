defmodule DmBankWeb.UserView do
  use DmBankWeb, :view
  alias DmBankWeb.UserView

  def render("index.json", %{users: users}) do
    %{data: render_many(users, UserView, "user.json")}
  end

  def render("show.json", %{user: user}) do
    %{data: render_one(user, UserView, "user.json")}
  end

  def render("create.json", %{user: user}), do: render_one(user, UserView, "user.json")

  def render("user.json", %{user: user}) do
    %{
      id: user.id,
      name: user.name,
      email: user.email
    }
  end
end
