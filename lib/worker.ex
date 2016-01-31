
defmodule LuserBot.MyWorker do
  require Logger
  use GenServer

  @channels ["#mychannel", "#vnluser"]

  def start_link(name) do
    IO.puts "MyWorker started"
    initial_state = :ok
    GenServer.start_link(__MODULE__, initial_state, name: name)
  end

  def init(state) do
    IO.inspect state
    {:ok, client} = ExIrc.start_client!()
    ExIrc.Client.add_handler client, self()
    ExIrc.Client.connect! client, "chat.freenode.net", 6667

    {:ok, client}
  end

  def handle_info({:connected, server, port}, client) do
    IO.puts "connected"
    ExIrc.Client.logon client, "", "chinbot", "chinbot", "chinbot"
    {:noreply, client}
  end

  def handle_info(:logged_in, client) do
    IO.puts "logged_in"

    Enum.each(@channels, fn channel ->
      ExIrc.Client.join client, channel
    end)
    {:noreply, client}
  end

  def handle_info({:joined, channel}, client) do
    ExIrc.Client.msg client, :privmsg, String.strip(channel), "Hallo!"
    {:noreply, client}
  end

  def handle_info({:received, msg, user, channel}, client) do
    # ExIrc.Client.msg client, :privmsg, channel, "Hello " <> user
    urls = extract_urls(msg)

    IO.inspect urls

    urls |>
      Enum.each(fn url ->
        case get_url_title(url) do
          {:ok, ""} ->
            :ok
            # Do nothing on empty title
          {:ok, title} ->
            ExIrc.Client.msg client, :privmsg, channel, "TITLE > " <> title
          {:error, error_msg} ->
            ExIrc.Client.msg client, :privmsg, channel, error_msg
        end
        :ok
      end)
    {:noreply, client}
  end

  def handle_info(:disconnected, client) do
    # FIXME: Try to reconnect here
    {:noreply, client}
  end

  # Catch-all for messages you don't care about
  def handle_info(msg, state) do
    Logger.debug "Received IrcMessage:"
    IO.inspect msg
    {:noreply, state}
  end

  def code_change(old_version, state, extra) do
    IO.puts "Code change"
    IO.inspect state
    {:ok, state}
  end

  @spec get_url_title(String.t) :: {:ok , String.t} | {:error, String.t}
  defp get_url_title(url) do
    case HTTPoison.get(url) do
      {:ok, %HTTPoison.Response{status_code: 200, body: body}} ->
        {:ok, extract_title(body)}
      {:ok, %HTTPoison.Response{status_code: 404}} ->
        {:error, "Not found :("}
      {:error, %HTTPoison.Error{reason: reason}} ->
        IO.inspect reason
        {:error, "Cannot load page :("}
    end
  end

  @spec extract_title(String.t) :: String.t
  defp extract_title(html) do
    case LuserBot.HTMLTitleParser.parse(html) do
      {:error, msg} ->
        Logger.debug msg
        ""
      title ->
        title
    end
  end

  @spec extract_urls(String.t) :: [String.t]
  def extract_urls(string) do
    List.flatten Regex.scan(~r|https?://[\da-z\.-]+\.[a-z\.]{2,6}[/\w\.-]*/?|, string)
  end
end


defmodule LuserBot.HTMLTitleParser do
  @spec parse(String.t) :: String.t | {:error, String.t}
  def parse(html) do
    case :xmerl_sax_parser.stream(html, event_fun: &on_parser_event/3) do
      {:title_found, _, title, _, _} ->
        to_string title
      _ ->
        {:error, "Title not found"}
    end
  end

  def on_parser_event({:startElement, _, 'title', _, _}, location, state) do
    :in_title
  end

  def on_parser_event({:characters, text}, location, state) do
    if state == :in_title do
      throw {:title_found, text}
    else
      state
    end
  end

  def on_parser_event(event, location, state) do
    #IO.inspect [event, location, state]
    state
  end
end
