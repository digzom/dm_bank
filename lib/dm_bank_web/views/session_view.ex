defmodule DmBankWeb.SessionView do
  use DmBankWeb, :view
  alias DmBankWeb.SessionView

  def render("show.json", params) do
    %{data: render_one(params, SessionView, "session.json")}
  end

  def render("session.json", %{session: %{user: user, token: token}}) do
    %{
      user: %{
        id: user.id,
        email: user.email,
        name: user.name
      },
      token: token
    }
  end
end
