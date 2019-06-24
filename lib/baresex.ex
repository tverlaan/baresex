defmodule Baresex do
  @moduledoc """
  Main entrypoint to interact with BareSIP.
  First start the `Baresex.Worker` in your own supervision tree.
  """
  alias Baresex.{Command.UA, Command.Call}

  @doc """
  Add a User-Agent to baresip
  """
  def uanew(uri) do
    uanew(Baresex.Worker, uri)
  end

  def uanew(server, uri) do
    Baresex.Worker.process(server, [UA.new(uri)])
  end

  @doc """
  Delete a User-Agent from baresip
  """
  def uadel(uri) do
    uadel(Baresex.Worker, uri)
  end

  def uadel(server, uri) do
    Baresex.Worker.process(server, [UA.delete(uri)])
  end

  @doc """
  Dial a destination by given User-Agent
  """
  def dial(uri, dest) do
    dial(Baresex.Worker, uri, dest)
  end

  def dial(server, uri, dest) do
    Baresex.Worker.process(server, [UA.select(uri), Call.dial(dest)])
  end

  @doc """
  Accept an incoming call
  """
  def accept(uri) do
    accept(Baresex.Worker, uri)
  end

  def accept(server, uri) do
    Baresex.Worker.process(server, [UA.select(uri), Call.accept()])
  end

  @doc """
  Send DTMF to call
  """
  def dtmf(uri, digits) do
    dtmf(Baresex.Worker, uri, digits)
  end

  def dtmf(server, uri, digits) do
    Baresex.Worker.process(server, [UA.select(uri), Call.dtmf(digits)])
  end

  @doc """
  Hangup a call
  """
  def hangup(uri) do
    hangup(Baresex.Worker, uri)
  end

  def hangup(server, uri) do
    Baresex.Worker.process(server, [UA.select(uri), Call.hangup()])
  end

  @doc """
  Transfer a call
  """
  def transfer(uri, dest) do
    transfer(Baresex.Worker, uri, dest)
  end

  def transfer(server, uri, dest) do
    Baresex.Worker.process(server, [UA.select(uri), Call.transfer(dest)])
  end
end
