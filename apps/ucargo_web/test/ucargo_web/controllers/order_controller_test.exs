defmodule UcargoWeb.PageControllerTest do
  use UcargoWeb.ConnCase

  alias Ucargo.Driver
  alias Ucargo.Repo
  alias Ucargo.Guardian
  setup do
    driver_chs = Driver.signup_changeset(%Driver{}, %{username: "SAM",
                                        password: "12345678",
                                        email: "john@doe.com",
                                        picture: "picture",
                                        phone: "5534734763",
                                        name: "Sam Bigotes"})
    driver = Repo.insert! driver_chs
    OrderInsertHelper.create_order
    {:ok, driver: driver}
  end

  test "Driver Order", %{driver: driver} do
    {:ok, token, _resource} = Guardian.encode_and_sign(driver)
    conn = build_conn()
      |> put_req_header("x-auth-token", token)
      |> put_req_header("x-api-key", "e70e918f-8035-48fc-a707-4507e1fd85c1")
      |> get("/api/v1/drivers/orders")
    body = json_response(conn, 200)

    assert %{"orders" => [
                %{
                  "deadline" => _,
                  "delivery" => %{
                    "address" => "Avenida Constituyentes, s/n, La Granja, 76190 Santiago de Querétaro, Qro.",
                    "latitude" => "20.584852",
                    "longitude" => "-100.396584",
                    "name" => "Plaza de toros Queretaro",
                    "schedule" => "Lunes 9–15"
                  },
                  "details" => [
                    %{"label" => "distance", "value" => "350"},
                    %{"label" => "merchandise_type", "value" => "Plastic"},
                    %{"label" => "order_number", "value" => 47848},
                    %{"label" => "transport", "value" => "pick-up"},
                    %{"label" => "weight", "value" => "800"}
                  ],
                  "favorite" => false,
                  "pickup" => %{
                    "address" => "Garita Internacional, Perimetral Nte., 22430 Tijuana, B.C.",
                    "latitude" => "32.549870",
                    "longitude" => "-116.937833",
                    "name" => "Aduana de Tijuana",
                    "schedule" => "sábado\t9–15"
                  },
                  "score" => 4,
                  "status" => "New",
                  "type" => 1
                }
              ]
            } = body
  end
end
