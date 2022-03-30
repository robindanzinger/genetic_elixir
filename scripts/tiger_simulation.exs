defmodule TigerSimulation do
  @behaviour Problem
  alias Types.Chromosome

  @impl true
  def genotype do 
    genes = for _ <- 1..8, do: Enum.random(0..1)
    %Chromosome{genes: genes, size: 8}
  end

  @impl true
  def fitness_function(chromosome) do 
   # scores = [0.0, 3.0, 2.0, 1.0, 0.5, 1.0, -1.0, 0.0] # tropic
    scores = [1.0, 3.0, -2.0, -1.0, 0.5, 2.0, 1.0, 0.0] # tundra
    traits = chromosome.genes

    traits
    |> Enum.zip(scores)
    |> Enum.map(fn {trait, score} -> trait*score end)
    |> Enum.sum()
  end

  @impl true
  def terminate?(_population, generation), do: generation == 150

  def avg(values) do
    Enum.sum(values) / length(values)
  end
  

  def average_tiger(population) do
    genes = Enum.map(population, & &1.genes)
    fitnesses = Enum.map(population, & &1.fitness)
    ages = Enum.map(population, & &1.age)

    avg_fitness = avg(fitnesses)
    avg_age = avg(ages)
    avg_genes = genes
                |> Enum.zip()
                |> Enum.map(&Tuple.to_list/1)
                |> Enum.map(&avg/1)
                |> Enum.map(&Float.round(&1, 2))

    %Chromosome{genes: avg_genes, age: avg_age, fitness: avg_fitness, size: length(genes)}
  end
end

tiger = Genetic.run(TigerSimulation,
  population_size: 50,
  selection_rate: 0.9,
  mutation_rate: 0.1)
  # statistics: %{average_tiger: &TigerSimulation.average_tiger/1}

stats = :ets.tab2list(:statistics)
        |> Enum.map(fn {gen, stats} -> [gen, stats.mean_fitness] end)

# {_, zero_gen_stats} = Utilities.Statistics.lookup(0)
# {_, fivehundred_gen_stats} = Utilities.Statistics.lookup(200)
# {_, onethousand_gen_stats} = Utilities.Statistics.lookup(100)

# genealogy = Utilities.Genealogy.get_tree()

# IO.inspect(Graph.vertices(genealogy))

IO.write("\n")

#{:ok, dot} = Graph.Serializers.DOT.serialize(genealogy)
#{:ok, dotfile} = File.open("tiger_simulation.dot", [:write])
#:ok = IO.binwrite(dotfile, dot)
#:ok = File.close(dotfile)
#IO.inspect(tiger)
#IO.inspect(zero_gen_stats.mean_fitness)
#IO.inspect(fivehundred_gen_stats.mean_fitness)
#IO.inspect(onethousand_gen_stats.mean_fitness)

{:ok, _cmd} = Gnuplot.plot([
  [:set, :title, "mean fitness versus generation"],
  [:plot, "-", :with, :points]
  ], [stats])
