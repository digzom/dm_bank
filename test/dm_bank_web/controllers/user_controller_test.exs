defmodule DmBankWeb.UserControllerTest do
  use DmBankWeb.ConnCase
  alias DmBank.{Banking, Users}
  alias DmBank.Banking.Account

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  describe "create user" do
    test "renders user when data is valid", %{conn: conn} do
      user_params = valid_user_params()

      conn = post(conn, Routes.user_path(conn, :create), user: user_params)
      assert %{"id" => _id, "email" => email, "name" => name} = json_response(conn, 201)["data"]

      # first the actual and then the created one
      assert email == user_params.email
      assert name == user_params.name
    end

    test "do not renders the password", %{conn: conn} do
      user_params = valid_user_params()

      conn = post(conn, Routes.user_path(conn, :create), user: user_params)
      data = json_response(conn, 201)["data"]

      assert Map.has_key?(data, "password") == false
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn =
        post(conn, Routes.user_path(conn, :create),
          user: %{email: nil, name: nil, password: nil, password_confirmation: nil}
        )

      assert json_response(conn, 422)["errors"] != %{}
    end

    test "create one banking account when the user is created", %{conn: conn} do
      user_params = valid_user_params()
      conn = post(conn, Routes.user_path(conn, :create), user: user_params)

      assert %{"id" => id} = json_response(conn, 201)["data"]
      assert %Account{user_id: ^id} = id |> Users.get_user!() |> Banking.account_from_user()
    end
  end
end
