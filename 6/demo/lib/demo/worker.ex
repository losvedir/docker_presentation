defmodule Demo.Worker do
	use GenServer
	require Logger

	def start_link(arg) do
		GenServer.start_link(__MODULE__, arg)
	end

	def init(_) do
		send self(), :print
		{:ok, []}
	end

	def handle_info(:print, state) do
		Logger.info("why hello there...")
		Process.send_after(self(), :print, 2_000)
		{:noreply, state}
	end
	def handle_info(_, state), do: {:noreply, state}
end
