defmodule Tracker.Server do
  use GenServer

  # Client

  def start_link() do
    GenServer.start_link(__MODULE__, %{})
  end

  def allocate(pid, host) do
    GenServer.call(pid, {:allocate, host})
  end

  def deallocate(pid, worker) do
    GenServer.call(pid, {:deallocate, worker})
  end

  def check_state(pid) do
    GenServer.call(pid, :check_state)
  end

  # Server

  def init(state) do
    {:ok, state}
  end

  def handle_call({:allocate, host}, _from, state) do
    workers = Map.get(state, host, [])
    availableWorker = Tracker.worker_pool(workers)
    {:reply, "#{host}#{availableWorker}", Map.put(state, host, workers ++ [availableWorker])}
  end

  def handle_call({:deallocate, worker}, _from, state) do
    new_state = 
      state
      |> Map.keys()
      |> Enum.filter(fn(key) -> String.contains?(worker, key) end)
      |> List.first()
      |> case do
          nil -> state
          host -> 
            worker_id = 
              worker
              |> String.replace(host, "")
              |> String.to_integer()

            new_worker_list = 
              state
              |> Map.get(host, [])
              |> List.delete(worker_id)
            
            Map.put(state, host, new_worker_list)
        end

    {:reply, nil, new_state}
  end

  def handle_call(:check_state, _from, state), do: {:reply, state, state}
end