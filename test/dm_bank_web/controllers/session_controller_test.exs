defmodule DmBankweb.SessionControllerTest do
  use DmBankWeb.ConnCase, async: true
  alias DmBank.Users

  defp register_user(password) do
    {:ok, user} =
      :user
      |> params_for()
      |> Map.merge(%{password: password, password_confirmation: password})
      |> Users.register_user()

    user
  end

  describe "create session" do
    test "with valid credentials", %{conn: conn} do
      expect = register_user("pass123456")

      credentials = %{
        email: expect.email,
        password: "pass123456"
      }

      conn = post(conn, Routes.session_path(conn, :create), credentials: credentials)
      assert %{"data" => %{"user" => user, "token" => token}} = json_response(conn, 201)
      assert String.length(token) > 0

      assert user == %{
               "id" => expect.id,
               "name" => expect.name,
               "email" => expect.email
             }
    end

    test "with invalid password", %{conn: conn} do
      expect = register_user("pass123456")

      credentials = %{
        email: expect.email,
        password: "invalid_password"
      }

      conn = post(conn, Routes.session_path(conn, :create), credentials: credentials)
      assert %{"error" => %{"message" => "Invalid credentials."}} = json_response(conn, 401)
    end

    test "with invalid email", %{conn: conn} do
      register_user("pass123456")

      credentials = %{
        email: "invalid_email",
        password: "pass123456"
      }

      conn = post(conn, Routes.session_path(conn, :create), credentials: credentials)
      assert %{"error" => %{"message" => "Invalid credentials."}} = json_response(conn, 401)
    end
  end

  describe "delete session" do
    alias DmBankWeb.UserAuth

    test "with already authenticated user", %{conn: conn} do
      user = register_user("pass123")

      {:ok, token} = UserAuth.encode_and_sign(user)

      conn =
        conn
        # it has to be lowercase but why?
        |> put_req_header("authorization", "Bearer #{token}")
        |> delete(Routes.session_path(conn, :delete))

      assert response(conn, 204) == ""

      assert {:error, _error} = UserAuth.decode_and_verify(token)
    end
  end
end
