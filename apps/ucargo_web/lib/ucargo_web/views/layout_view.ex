defmodule UcargoWeb.LayoutView do
  use UcargoWeb, :view
  alias Ucargo.Guardian

  def get_company_name(conn) do
    broker = Guardian.Plug.current_resource(conn)
    broker.company
  end

  def plannings_section(section_name) do
    case section_name do
      "plannings" ->
        "nav-content__item active"
      _ ->
        "nav-content__item"
    end
  end

  def assignments_section(section_name) do
    case section_name do
      "assignments" ->
        "nav-content__item active"
      _ ->
        "nav-content__item"
    end
  end

  def records_section(section_name) do
    case section_name do
      "records" ->
        "nav-content__item active"
      _ ->
        "nav-content__item"
    end
  end

  def favourites_section(section_name) do
    case section_name do
      "favourites" ->
        "nav-content__item active"
      _ ->
        "nav-content__item"
    end
  end
end
