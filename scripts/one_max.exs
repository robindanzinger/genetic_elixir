defmodule OneMax do
  @behaviour Problem
  alias Types.Chromosome

  @impl true
  def genotype do
    genes = for _ <- 1..42, do: Enum.random(0..1)
    %Chromosome{genes: genes, size: 42}
  end

  @impl true
  def fitness_function(chromosome), do: Enum.sum(chromosome.genes)

  @impl true
  def terminate?([best | _], _generation), do: best.fitness == 42

#  @impl true
#  def terminate?(_, generation), do: generation == 100 

#  @impl true
#  def terminate?(population), do:
#    Enum.max_by(population, &OneMax.fitness_function/1).fitness == 42
#
#  # Minimum Fitness Threshold
#  @impl true
#  def terminate?(population), do:
#    Enum.min_by(population, &OneMax.fitness_function/1).fitness == 0
  
end


soln = Genetic.run(OneMax)

IO.write("\n")
IO.inspect(soln)
