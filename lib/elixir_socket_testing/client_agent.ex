defmodule ElixirSocketTesting.ClientAgent do
  
  def start_link do
    Agent.start_link(fn -> [] end, name: __MODULE__)
  end

  def add(client) do
    Agent.update(__MODULE__, fn list -> [client | list]  end)
  end

  def remove(client) do
    Agent.update(__MODULE__, fn list -> List.delete(list, client) end)
  end

  def all do
    Agent.get(__MODULE__, fn list -> list end)
  end
end