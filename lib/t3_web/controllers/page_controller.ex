defmodule T3Web.PageController do
  use T3Web, :controller

  def index(conn, _params) do
    render conn, "index.html"
  end
end
