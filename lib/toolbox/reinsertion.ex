defmodule Toolbox.Reinsertion do
  def pure(_parents, offspring, _leftovers, _opts \\ []), do: offspring

  def elitist(parents, offspring, leftover, opts \\ []) do
    survival_rate = Keyword.get(opts, :survival_rate, 0.1)

    old = parents ++ leftover
    n = floor(length(old) * survival_rate)

    survivors =
      old
      |> Enum.sort_by(& &1.fitness, &>=/2)
      |> Enum.take(n)

    offspring ++ survivors
  end

  def uniform(parents, offspring, leftover, opts \\ []) do
    survival_rate = Keyword.get(opts, :survival_rate, 0.1)

    old = parents ++ leftover
    n = floor(length(old) * survival_rate)

    IO.puts("n #{n}, #{length(old)}")

    survivors =
      old
      |> Enum.take_random(n)

    offspring ++ survivors
  end
end
