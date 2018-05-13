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
alias Ucargo.Driver
alias Ucargo.Pickup
alias Ucargo.Delivery
alias Ucargo.Repo
alias Ucargo.Planning
alias Ucargo.Auction
alias Ucargo.Bid
alias Ucargo.CustomBroker
alias Ucargo.Custom


driver_manuel = %Driver{username: "manuelhz", email: "misaelpc@msn.com", password: "12345678",
                  picture: "", name: "Manuel Hernandez Zamora", phone: "663353733",
                  score: 5}

driver_juan = %Driver{username: "misaelpc", email: "misaelpcgm@gmail.com", password: "12345678",
                  picture: "", name: "Juan Ramirez Perez", phone: "66334433",
                  score: 4}

driver_jorge = %Driver{username: "jorgema", email: "misaelpcyahoo@yahoo.com", password: "12345678",
                  picture: "", name: "Jorge Mendez Alvarez", phone: "223353733",
                  score: 3}

driver_manuel = Repo.insert! driver_manuel
driver_juan = Repo.insert! driver_juan
driver_jorge = Repo.insert! driver_jorge

custom_broker = %CustomBroker{name: "Joel de la Peña",
                          username: "joel65",
                          password: "12345678",
                           company: "Exportadora del Pácifico"}

broker = Repo.insert!(custom_broker)

import_orders_params = %{score: 4, deadline: NaiveDateTime.utc_now(),
                  status: "New", type: 0, distance: "350",
                  merchandise_type: "Plastic", order_number: "47848",
                  transport: "pick-up", weight: "800", comments: "None"}
export_order_params = %{score: 5, deadline: NaiveDateTime.utc_now(),
                  status: "New", type: 1, distance: "450",
                  merchandise_type: "Clothes", order_number: "37598",
                  transport: "rabon", weight: "500", comments: "None"}
order = %Order{}
order_chs = Order.create_changeset(order, import_orders_params)
export_order_chs = Order.create_changeset(order, export_order_params)

pick_up = %Pickup{}
delivery = %Delivery{} #32.5498703,-116.9378327
custom = %Custom{}

custom_import_chgset = Custom.create_changeset(custom,
            %{latitude: 32.5498703, longitude: -116.9378327,
              name: "Aduana de Tijuana", 
              address: "Garita Internacional, Perimetral Nte., 22430 Tijuana, B.C.",
              schedule: "sábado	9–15",
              responsible: "Benjamin Cedillo",
              date: "2018-03-10"})              
deliver_chgset = Delivery.create_changeset(delivery,
            %{latitude: 20.5848521, longitude: -100.3965839,
              name: "Plaza de toros Queretaro", 
              address: "Avenida Constituyentes, s/n, La Granja, 76190 Santiago de Querétaro, Qro.",
              schedule: "Lunes 9–15",
              responsible: "Carlos Sanchez",
              date: "2018-03-18"})

export_pick_chgset = Pickup.create_changeset(pick_up,
            %{latitude: 32.5498703, longitude: -116.9378327,
              name: "Recolección de vacio",
              address: "OCEANO PACIFICO, 423, 66477, Nuevo Leon",
              schedule: "sábado	9–15",
              responsible: "Joel Sanchez",
              date: "2018-03-10"})

export_deliver_chgset = Delivery.create_changeset(delivery,
            %{latitude: 20.5848521, longitude: -100.3965839,
              name: "Plaza de toros Queretaro",
              address: "Avenida Constituyentes, s/n, La Granja, 76190 Santiago de Querétaro, Qro.",
              schedule: "Lunes 9–15",
              responsible: "Mario Sanchez",
              date: "2018-03-18"})

custom_chgset = Custom.create_changeset(custom,
            %{latitude: 32.5498703, longitude: -116.9378327,
              name: "Aduana de Tijuana",
              address: "Garita Internacional, Perimetral Nte., 22430 Tijuana, B.C.",
              schedule: "sábado	9–15",
              responsible: "Hugo Lopez",
              date: "2018-03-10"})

#import order
order_with_pick = Ecto.Changeset.put_assoc(order_chs, :custom, custom_import_chgset)
order_with_delivery = Ecto.Changeset.put_assoc(order_with_pick, :delivery, deliver_chgset)
order_with_drivers = Ecto.Changeset.put_assoc(order_with_delivery, :drivers, [driver_manuel, driver_juan, driver_jorge])
order = Repo.insert! order_with_drivers

############

#export order
order_with_pick = Ecto.Changeset.put_assoc(export_order_chs, :pickup, export_pick_chgset)
order_with_delivery = Ecto.Changeset.put_assoc(order_with_pick, :delivery, export_deliver_chgset)
order_with_custom = Ecto.Changeset.put_assoc(order_with_delivery, :custom, custom_chgset)
order_with_drivers = Ecto.Changeset.put_assoc(order_with_custom, :drivers, [driver_manuel, driver_juan, driver_jorge])

export_order = Repo.insert! order_with_drivers
###########
date_now = NaiveDateTime.utc_now()

### Import Planning
auction_chgs = Auction.create_changeset(%Auction{},
                   %{begin_date: date_now,
                     end_date: NaiveDateTime.add(date_now, 86400, :second),
                     ask_price: 10500.45})

bid_chgs = Bid.create_changeset(%Bid{}, %{price: 324443, winner: true, driver_id: driver_manuel.id})
auction_with_bids = Ecto.Changeset.put_assoc(auction_chgs, :bids, [bid_chgs])

auction = Repo.insert! auction_with_bids

pl_changeset = Planning.create_changeset(%Planning{}, 
                      %{master_reference: "115403",
                        house_reference: "142-3442-2576",
                        custom_broker_id: broker.id})
pl_with_order = Ecto.Changeset.put_assoc(pl_changeset, :order, order)
pl_with_auction = Ecto.Changeset.put_assoc(pl_with_order, :auction, auction)

Repo.insert! pl_with_auction
###

### Export Planning
auction_chgs = Auction.create_changeset(%Auction{},
                   %{begin_date: date_now,
                     end_date: NaiveDateTime.add(date_now, 45999, :second),
                     ask_price: 20500.45})

bid_chgs = Bid.create_changeset(%Bid{}, %{price: 524443, winner: true, driver_id: driver_juan.id})
auction_with_bids = Ecto.Changeset.put_assoc(auction_chgs, :bids, [bid_chgs])

auction = Repo.insert! auction_with_bids

pl_changeset = Planning.create_changeset(%Planning{},
                      %{master_reference: "115403",
                        house_reference: "142-3442-2576",
                        custom_broker_id: broker.id})
pl_with_order = Ecto.Changeset.put_assoc(pl_changeset, :order, export_order)
pl_with_auction = Ecto.Changeset.put_assoc(pl_with_order, :auction, auction)

Repo.insert! pl_with_auction
###
