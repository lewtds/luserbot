defmodule LuserBot.Supervisor do
	use Supervisor

	def start_link do
		IO.puts "Supervisor started"
		Supervisor.start_link(__MODULE__, :ok)
	end

	def init(:ok) do
		children = [
			worker(LuserBot.MyWorker, [LuserBot.MyWorker])
		]

		supervise(children, strategy: :one_for_one)
	end
end
