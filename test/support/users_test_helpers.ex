defmodule DmBank.UsersTestHelpers do
  import DmBank.Factory

  def valid_user_params(password \\ "123456") do
    :user
    |> params_for(password: password)
    |> Map.put(:password_confirmation, password)
  end
end
