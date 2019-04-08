defmodule Baresex.Event do
  @moduledoc """
  Event module
  """

  @baresip_reg "register"
  @baresip_call "call"
  @baresip_misc ["VU_REPORT", "mwi", "application", "other"]
  @unknown "unknown"

  defstruct [:class, :data]

  def new(%{"class" => @baresip_reg} = event) do
    Baresex.Event.Register.new(event)
  end

  def new(%{"class" => @baresip_call} = event) do
    Baresex.Event.Call.new(event)
  end

  def new(%{"class" => class} = event)
      when class in @baresip_misc do
    %__MODULE__{class: class, data: event}
  end

  def new(event) do
    %__MODULE__{class: @unknown, data: event}
  end
end
