defmodule Baresex.Worker do
  @moduledoc """
  Process that communicates with Baresip over TCP socket.
  """
  use GenServer
  alias Baresex.{Protocol, Event}

  @events_with_accounts [Baresex.Event.Call, Baresex.Event.Register]

  defstruct conn: nil,
            conn_str: "",
            messages: "",
            subscribers: %{}

  @doc """

  """
  def start_link(address \\ "127.0.0.1", port \\ "4444") do
    GenServer.start_link(__MODULE__, [address: address, port: port], name: __MODULE__)
  end

  @doc false
  def init(opts) do
    conn_str = "tcp://#{opts[:address]}:#{opts[:port]}"
    {:ok, p} = Socket.connect(conn_str)
    receive_message(p)
    {:ok, %__MODULE__{conn: p, conn_str: conn_str}}
  end

  @doc """
  Subscribe
  """
  def subscribe(username, domain \\ "localhost") do
    GenServer.call(__MODULE__, {:subscribe, {self(), "sip:#{username}@#{domain}"}})
  end

  @doc """
  Send list of commands to Baresip
  """
  def process(commands) do
    GenServer.cast(__MODULE__, {:process, commands})
  end

  @doc false
  def handle_call({:subscribe, {pid, aor}}, _, state) do
    subscribers = update_in(state.subscribers, [aor], &add_subscriber(&1, pid))
    {:reply, :ok, %{state | subscribers: subscribers}}
  end

  @doc false
  def handle_cast({:process, commands}, state) do
    process_commands(commands, state.conn)
    {:noreply, state}
  end

  def handle_cast({:close, _}, state) do
    {:stop, :normal, state}
  end

  def handle_cast(:publish, state) do
    state = publish_event(state)
    {:noreply, state}
  end

  def handle_cast({:receive, msg}, state) do
    receive_message(state.conn)

    state =
      state
      |> process_message(msg)
      |> publish_event()

    {:noreply, state}
  end

  defp process_message(state, msg) do
    %{state | messages: state.messages <> msg}
  end

  defp publish_event(%__MODULE__{messages: ""} = state), do: state

  defp publish_event(%__MODULE__{subscribers: s} = state) when map_size(s) == 0,
    do: %{state | messages: ""}

  defp publish_event(state) do
    {message, tail} =
      state.messages
      |> Protocol.decode()

    event = Event.new(message)

    if subscribable?(event) do
      state.subscribers
      |> Map.get(event.account, [])
      |> send_event(event)
    end

    publish_next()
    put_in(state.messages, tail)
  end

  defp publish_next() do
    GenServer.cast(self(), :publish)
  end

  defp process_commands([], _), do: :ok

  defp process_commands([command | t], conn) do
    msg =
      command
      |> Protocol.encode()

    Socket.Stream.send(conn, msg)
    process_commands(t, conn)
  end

  defp send_event([], _), do: :ok

  defp send_event([subscriber | t], event) do
    send(subscriber, event)
    send_event(t, event)
  end

  defp add_subscriber(nil, subscriber) do
    [subscriber]
  end

  defp add_subscriber(list, subscriber) do
    if Enum.member?(list, subscriber) do
      list
    else
      [subscriber | list]
    end
  end

  defp subscribable?(%{__struct__: struct}) when struct in @events_with_accounts, do: true
  defp subscribable?(_), do: false

  # Spawns an attendant process for (blocking) message receiving.
  defp receive_message(conn) do
    master = self()

    spawn(fn ->
      case Socket.Stream.recv(conn) do
        {:ok, msg} when msg != nil ->
          GenServer.cast(master, {:receive, msg})

        e ->
          GenServer.cast(master, {:close, e})
      end
    end)
  end
end
