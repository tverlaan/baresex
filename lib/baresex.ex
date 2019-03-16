defmodule Baresex do
  @moduledoc """

  """

  def uanew(username, domain \\ "localhost") do
    [Baresex.Command.UA.new("sip:#{username}@#{domain}")]
  end

  def dial(dest, username, domain \\ "localhost") do
    [
      Baresex.Command.UA.select("sip:#{username}@#{domain}"),
      Baresex.Command.Call.dial(dest)
    ]
  end

  def accept(username, domain \\ "localhost") do
    [
      Baresex.Command.UA.select("sip:#{username}@#{domain}"),
      Baresex.Command.Call.accept()
    ]
  end

  def hangup(username, domain \\ "localhost") do
    [
      Baresex.Command.UA.select("sip:#{username}@#{domain}"),
      Baresex.Command.Call.hangup()
    ]
  end

  def subscribe(username, domain \\ "localhost") do
    Baresex.Worker.subscribe("sip:#{username}@#{domain}")
  end

  def execute(commands, server \\ Baresex.Worker) do
    Baresex.Worker.process(server, commands)
  end

  def start_link(address \\ "127.0.0.1", port \\ "4444", name \\ Baresex.Worker) do
    Baresex.Worker.start_link(address, port, name)
  end
end
