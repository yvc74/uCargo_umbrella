defmodule UcargoWeb.WebAuthErrorHandler do
  @moduledoc """
  Guardian erro hander
  """
  use UcargoWeb, :router

  def auth_error(conn, {_type, _reason}, _opts) do
    conn
      |> redirect(to: "/signin")
      |> halt
  end
end
