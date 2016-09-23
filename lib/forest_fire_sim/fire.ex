defmodule ForestFireSim.Fire do
  def ignite(world, xy, intensity) do
    spawn_link(__MODULE__, :loop, [world, xy, intensity])
  end

  def loop(world, xy, intensity) do
    receive do
      :advance ->
        send(world, {:advance_fire, xy})

        intensity = intensity - 1
        if intensity == 0 do
          :ok
        else
          loop(world, xy, intensity)
        end
    end
  end
end
