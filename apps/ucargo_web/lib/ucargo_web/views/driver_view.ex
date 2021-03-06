defmodule UcargoWeb.DriverView do
  use UcargoWeb, :view
  alias UcargoWeb.DriverView
  require Logger

  def render("orders.json", %{orders: orders}) do
    %{orders: render_many(orders, DriverView, "order.json", as: :order)}
  end

  def render("order.json", %{order: order}) do
  	%{order_number: order.order_number,
    	origin: order.origin,
      destination: order.destination,
      type: order.type,
      deadline: order.deadline,
      favorite: order.favorite,
      distance: order.distance,
      transport: order.transport,
      weight: order.weight,
      merchandise_type: order.merchandise_type,
      pick_up_address: order.pick_up_address,
      pick_up_schedule: order.pick_up_schedule,
      score: order.score,
      comments: order.comments,
      status: order.status
    }
  end

  def render("driver.json", %{user: driver, token: token}) do
    %{
      account: %{
        name: driver.name,
        username: driver.username,
        email: driver.email,
        picture: driver.picture,
        token: token,
        phone: driver.phone,
        score: driver.score,
        driver_id: driver.id
      }
    }
  end

  def render("event.json", %{event: event}) do
    %{
      event: %{
        id: event.id,
        inserted_at: event.inserted_at,
        latitude: event.latitude,
        longitude: event.longitude,
        price: event.price,
        picture: event.picture,
        updated_at: event.updated_at,
        uuid: event.uuid,
        name: event.name
      }
    }
  end

  def render("order_delete.json", %{message: status}) do
      %{
        message: status
      }
  end

  def render("order_quotes.json", %{quotes: price}) do 
    %{
      quotes: price
    }
  end

  def render("order_favorite.json", %{message: status}) do
    %{
      message: status
    }
  end

  def render("order_favorite_delete.json", %{message: status}) do
    %{
      message: status
    }
  end

  def render("order_onroute.json", %{order: order_id}) do
    %{
      order: order_id
    }
  end

  def render("events.json", %{event: event}) do
    %{
      event: event 
    }
  end
end
