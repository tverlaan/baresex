defmodule Baresex do
  @moduledoc """
  Main entrypoint to quickly create commands for `Baresex.Worker.process/1`
  """
  alias Baresex.{Command.UA, Command.Call}

  @doc """
  Add a User-Agent to baresip
  """
  def uanew(username, domain \\ "localhost") do
    [UA.new("sip:#{username}@#{domain}")]
  end

  @doc """
  Delete a User-Agent from baresip
  """
  def uadel(username, domain \\ "localhost") do
    [UA.delete("sip:#{username}@#{domain}")]
  end

  @doc """
  Dial a destination by given User-Agent
  """
  def dial(dest, username, domain \\ "localhost") do
    [
      UA.select("sip:#{username}@#{domain}"),
      Call.dial(dest)
    ]
  end

  @doc """
  Accept an incoming call
  """
  def accept(username, domain \\ "localhost") do
    [
      UA.select("sip:#{username}@#{domain}"),
      Call.accept()
    ]
  end

  @doc """
  Hangup a call
  """
  def hangup(username, domain \\ "localhost") do
    [
      UA.select("sip:#{username}@#{domain}"),
      Call.hangup()
    ]
  end
end
