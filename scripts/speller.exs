defmodule Speller do
  @behaviour Problem
  alias Types.Chromosome

#  @target "supercalifragilisticexpialidocious"
#  @target "supercalifragil"
  @target "supercali"

  def genotype do
    size = String.length(@target)
    genes = 
      Stream.repeatedly(fn -> Enum.random(?a..?z) end)
      |> Enum.take(size)
    %Chromosome{genes: genes, size: size}
  end


  def fitness_function(chromosome) do
    guess = List.to_string(chromosome.genes)
    String.jaro_distance(@target, guess)
  end


  def terminate?([best | _], generation), do: best.fitness == 1 or generation == 2

end

soln = Genetic.run(Speller, population_size: 100, selection_type: &Toolbox.Selection.roulette/2, selection_rate: 0.5, mutation_type: &Toolbox.Mutation.scramble(&1), mutation_rate: 0.1, reinsertion_strategy: &Toolbox.Reinsertion.uniform/4)

IO.write("\n")
IO.inspect(soln)
