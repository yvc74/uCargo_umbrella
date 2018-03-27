defmodule UcargoWeb.AssignmentView  do
  use UcargoWeb, :view

  def render_order_type(order_type) do
    if order_type== 0, do: "IMPORTACIÓN", else: "EXPORTACIÓN"
  end
end
