defmodule LuserBot do
	use Application

	def start(_type, _args) do
		LuserBot.Supervisor.start_link
	end
end
