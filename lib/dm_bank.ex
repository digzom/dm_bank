defmodule DmBank do
  @moduledoc """
  DmBank keeps the contexts that define your domain
  and business logic.

  Contexts are also responsible for managing your data, regardless
  if it comes from the database, an external API or others.
  """

  alias DmBank.Users

  @spec register_user_and_account(user_params :: map()) :: tuple()
  defdelegate register_user_and_account(user_params), to: Users
end
