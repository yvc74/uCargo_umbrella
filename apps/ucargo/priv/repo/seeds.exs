# Script for populating the database. You can run it as:
#
#     mix run priv/repo/seeds.exs
#
# Inside the script, you can read and write to any of your
# repositories directly:
#
#     Ucargo.Repo.insert!(%Ucargo.SomeSchema{})
#
# We recommend using the bang functions (`insert!`, `update!`
# and so on) as they will fail if something goes wrong.
alias Ucargo.Order
alias Ucargo.Pickup
alias Ucargo.Delivery
alias Ucargo.Repo
alias Ucargo.Planning
alias Ucargo.Auction
alias Ucargo.Bid
alias Ucargo.CustomBroker

custom_broker = %CustomBroker{name: "Joel de la Peña",
                          username: "joel65",
                          password: "12345678",
                           company: "Exportadora del Pácifico"}

Repo.insert!(custom_broker)

orders_params = %{score: 4, deadline: NaiveDateTime.utc_now(),
                  status: "New", type: 1, distance: "350",
                  merchandise_type: "Plastic", order_number: "47848",
                  transport: "pick-up", weight: "800", comments: "None"}
order = %Order{}
order_chs = Order.create_changeset(order, orders_params)
pick_up = %Pickup{}
delivery = %Delivery{} #32.5498703,-116.9378327
pick_chgset = Pickup.create_changeset(pick_up,
            %{latitude: 32.5498703, longitude: -116.9378327,
              name: "Aduana de Tijuana", 
              address: "Garita Internacional, Perimetral Nte., 22430 Tijuana, B.C.",
              schedule: "sábado	9–15",
              responsible: "Joel Sanchez",
              date: "2018-03-10"})
deliver_chgset = Delivery.create_changeset(delivery,
            %{latitude: 20.5848521, longitude: -100.3965839,
              name: "Plaza de toros Queretaro", 
              address: "Avenida Constituyentes, s/n, La Granja, 76190 Santiago de Querétaro, Qro.",
              schedule: "Lunes 9–15",
              responsible: "Carlos Sanchez",
              date: "2018-03-18"})
order_with_pick = Ecto.Changeset.put_assoc(order_chs, :pickup, pick_chgset)
order_with_delivery = Ecto.Changeset.put_assoc(order_with_pick, :delivery, deliver_chgset)

order = Repo.insert! order_with_delivery

date_now = NaiveDateTime.utc_now()

auction_chgs = Auction.create_changeset(%Auction{},
                   %{begin_date: date_now,
                     end_date: NaiveDateTime.add(date_now, 86400, :second),
                     ask_price: 10500.45})

bid_chgs = Bid.create_changeset(%Bid{}, %{price: 324443, winner: true})
auction_with_bids = Ecto.Changeset.put_assoc(auction_chgs, :bids, [bid_chgs])

auction = Repo.insert! auction_with_bids

pl_changeset = Planning.create_changeset(%Planning{}, %{})
pl_with_order = Ecto.Changeset.put_assoc(pl_changeset, :order, order)
pl_with_auction = Ecto.Changeset.put_assoc(pl_with_order, :auction, auction)


#Repo.insert! pl_with_order


Repo.insert! pl_with_auction

# bid_params = Bid.create_changeset(%Bid{}, %{price: 324443, winner: true})
# auction_with_bid = Ecto.Changeset.put_assoc(auction_params, :bids, [bid_params])
# Repo.insert! auction_with_bid
