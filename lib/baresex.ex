defmodule Baresex do
  @moduledoc """
  Main entrypoint to interact with BareSIP.
  First start the `Baresex.Worker` in your own supervision tree.
  """
  alias Baresex.{Command.UA, Command.Call}

  @doc """
  Add a User-Agent to baresip
  """
  def uanew(username, domain \\ "localhost") do
    [UA.new("sip:#{username}@#{domain}")]
    |> Baresex.Worker.process()
  end

  @doc """
  Delete a User-Agent from baresip
  """
  def uadel(username, domain \\ "localhost") do
    [UA.delete("sip:#{username}@#{domain}")]
    |> Baresex.Worker.process()
  end

  @doc """
  Dial a destination by given User-Agent
  """
  def dial(dest, username, domain \\ "localhost") do
    [
      UA.select("sip:#{username}@#{domain}"),
      Call.dial(dest)
    ]
    |> Baresex.Worker.process()
  end

  @doc """
  Accept an incoming call
  """
  def accept(username, domain \\ "localhost") do
    [
      UA.select("sip:#{username}@#{domain}"),
      Call.accept()
    ]
    |> Baresex.Worker.process()
  end

  @doc """
  Send DTMF to call
  """
  def dtmf(digits, username, domain \\ "localhost") do
    [
      UA.select("sip:#{username}@#{domain}"),
      Call.dtmf(digits)
    ]
    |> Baresex.Worker.process()
  end

  @doc """
  Hangup a call
  """
  def hangup(username, domain \\ "localhost") do
    [
      UA.select("sip:#{username}@#{domain}"),
      Call.hangup()
    ]
    |> Baresex.Worker.process()
  end
end
