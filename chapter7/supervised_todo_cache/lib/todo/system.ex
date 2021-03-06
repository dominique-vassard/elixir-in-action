defmodule Todo.System do
  use Supervisor

  def start_link do
    Supervisor.start_link(__MODULE__, nil)
  end

  @impl true
  def init(_) do
    Supervisor.init([Todo.Cache], strategy: :one_for_one)
  end
end

# TESTING
# {:ok, cache} = Todo.Cache.start()
# bob = Todo.Cache.server_process(cache, "bob's one")
# Todo.Server.all_entries(bob)
# nl = Todo.Cache.server_process(cache, "new list")
# Todo.Server.all_entries(nl)
