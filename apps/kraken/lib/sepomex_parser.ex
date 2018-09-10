defmodule Kraken.SepomexParser do
  @moduledoc """
  Module for parsing sepomex files
  """
  def parse_file(name) do
    {:ok, container} = Agent.start_link fn -> %{} end
    path = Application.app_dir(:kraken, "priv/sepomex_files/#{name}")
    path
      |> File.stream!
      |> Stream.map(&String.trim/1)
      |> Stream.map(&String.split(&1, ","))
      |> Stream.map(&parse_city(&1, container))
      |> Stream.run
    container
  end

  def parse_city(register, container) do
    [_, city, _, state, _, _, _, _, _, _, _, _, _, _, _] = register
    if city == "" and state == "" do
      []
    else
      value = Agent.get(container, &Map.get(&1, state))
      if value == nil do
        Agent.update(container, &Map.put(&1, state, [city]))
      else
        Agent.update(container, &Map.put(&1, state, [city | value]))
      end
      [city, state]
    end
  end

end