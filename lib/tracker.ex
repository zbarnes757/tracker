defmodule Tracker do
  def worker_pool([]), do: 1
  def worker_pool(list) do
    list
    |> Enum.sort()
    |> next_available_worker(true)
  end

  defp next_available_worker([first | []], _), do: first + 1
  defp next_available_worker([first | _tail], true) when first !== 1, do: 1
  defp next_available_worker([first | [second | _t]], _) when first + 1 !== second, do: first + 1
  defp next_available_worker([_first | tail], _), do: next_available_worker(tail, false)
end
