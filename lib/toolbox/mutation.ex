defmodule Toolbox.Mutation do
  alias Types.Chromosome
  use Bitwise

  def flip(chromosome) do
    genes =
      chromosome.genes
      |> Enum.map(&Bitwise.bxor(&1, 1))

    %Chromosome{genes: genes, size: chromosome.size}
  end

  def flip(chromosome, p) do
    genes =
      chromosome.genes
      |> Enum.map(fn g ->
        if :rand.uniform() < p do
          Bitwise.bxor(g, 1)
        else
          g
        end
      end)

    %Chromosome{genes: genes, size: chromosome.size}
  end

  def scramble(chromosome) do
    genes =
      chromosome.genes
      |> Enum.shuffle()

    %Chromosome{genes: genes, size: chromosome.size}
  end

  def scramble(chromosome, n) do
    start = :rand.uniform(chromosome.size - n)
    {lo, hi} = {start, start + n}
    head = Enum.slice(chromosome.genes, 0, lo)
    mid = Enum.slice(chromosome.genes, lo, hi)
    tail = Enum.slice(chromosome.genes, hi, chromosome.size)

    %Chromosome{genes: head ++ Enum.shuffle(mid) ++ tail, size: chromosome.size}
  end

  def gaussian(chromosome) do
    genes_size = length(chromosome.genes)
    mu = Enum.sum(chromosome.genes) / genes_size

    sigma =
      chromosome.genes
      |> Enum.map(fn x -> (mu - x) * (mu - x) end)
      |> Enum.sum()
      |> Kernel./(genes_size)

    genes =
      chromosome.genes
      |> Enum.map(fn _ ->
        :rand.normal(mu, sigma)
      end)

    %Chromosome{genes: genes, size: chromosome.size}
  end
end
