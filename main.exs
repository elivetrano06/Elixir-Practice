defmodule MergeSort do

  def generate_data(n) do
    Enum.map(1..n, fn _ -> :rand.uniform(1_000_000) end)
  end

  def split_into_parts(list, k) do
    list
    |> Enum.with_index()
    |> Enum.group_by(fn {_val, idx} -> rem(idx, k) end, fn {val, _idx} -> val end)
    |> Map.values()
  end

  def improved_merge(arrays) do
    arrays
    |> Enum.reject(&Enum.empty?/1)
    |> merge_queue()
  end

  defp merge_queue([single]), do: single
  defp merge_queue([a, b | rest]) do
    merged = merge_two(a, b)
    merge_queue(rest ++ [merged])
  end

  defp merge_two([], b), do: b
  defp merge_two(a, []), do: a
  defp merge_two([ha | ta], [hb | tb]) when ha <= hb do
    [ha | merge_two(ta, [hb | tb])]
  end
  defp merge_two([ha | ta], [hb | tb]) do
    [hb | merge_two([ha | ta], tb)]
  end

  def sorter(data, k) do
    data
    |> split_into_parts(k)
    |> Enum.map(&Enum.sort/1)
    |> improved_merge()
  end

  def time_it(fun) do
    start = System.monotonic_time(:microsecond)
    result = fun.()
    elapsed = System.monotonic_time(:microsecond) - start
    {result, elapsed / 1000.0}
  end

  def run do
    sizes = [100_000, 200_000, 300_000, 400_000, 500_000]
    ks    = [2, 3, 5, 10, 50, 100, 200]

    for n <- sizes do
      IO.puts("n = #{n}")
      base = generate_data(n)

      for k <- ks do
        {_result, time} = time_it(fn -> sorter(base, k) end)
        IO.puts("  k = #{k} -> #{:erlang.float_to_binary(time, decimals: 3)} ms")
      end

      IO.puts("------------------------")
    end
  end
end

MergeSort.run()
