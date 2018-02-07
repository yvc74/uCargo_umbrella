defmodule Ucargo.Order do
	defstruct(order_number: nil,
		origin: nil,
		destination: nil,
		type: nil,
		deadline: nil,	
		favorite: nil,
		distance: nil,
		transport: nil,
		weight: nil,
		merchandise_type: nil,
		pick_up_address: nil,
		pick_up_schedule: nil,
		score: nil,
		comments: nil,
		status: nil)
end