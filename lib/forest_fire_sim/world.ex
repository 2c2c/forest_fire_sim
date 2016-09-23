defmodule ForestFireSim.World do
  def create(forest, fire_starter) do
    spawn_link(__MODULE__, :init, [forest, fire_starter])
  end

  def init(forest, fire_starter) do
    ForestFireSim.Forest.get_fires(forest)
    |> Enum.each(fire_starter)

    loop(forest, fire_starter)
  end

  def loop(forest, fire_starter) do
    receive do
      {:advance_fire, xy} ->
        {new_forest, new_fires} = ForestFireSim.Forest.spread_fire(forest, xy)
        Enum.each(new_fires, fire_starter)
        new_forest = ForestFireSim.Forest.reduce_fire(new_forest, xy)

        loop(new_forest, fire_starter)
      {:debug_location, xy, from} ->
        location = ForestFireSim.Forest.get_location(forest, xy)
        send(from, {:debug_location_response, location})

        loop(forest, fire_starter)
      :render ->
        ForestFireSim.Forest.to_string(forest)
        |> IO.puts

        loop(forest, fire_starter)
    end
  end
end
