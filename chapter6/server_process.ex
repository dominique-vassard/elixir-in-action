defmodule ServerProcess do
  def start(callback_module) do
    spawn(fn ->
      # Invokes the callback to initialize the state
      initial_state = callback_module.init()

      loop(callback_module, initial_state)
    end)
  end

  def call(server_pid, request) do
    # Sends the message
    send(server_pid, {:call, request, self()})

    receive do
      # Waits for the response
      {:response, response} ->
        # Returns the response
        response
    end
  end

  def cast(server_pid, request) do
    # Sends the message
    send(server_pid, {:cast, request})
  end

  def loop(callback_module, current_state) do
    receive do
      # Invokes callback to handle message
      {:call, request, caller} ->
        {response, new_state} = callback_module.handle_call(request, current_state)

        # Sends response back
        send(caller, {:response, response})

        # Loops with new state
        loop(callback_module, new_state)

      {:cast, request} ->
        new_state = callback_module.handle_cast(request, current_state)

        loop(callback_module, new_state)
    end
  end
end
