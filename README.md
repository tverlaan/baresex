# Baresex

[![Build Status](https://travis-ci.org/tverlaan/baresex.svg?branch=master)](https://travis-ci.org/tverlaan/baresex)

An Elixir library to control Baresip over a TCP socket

## Basic example

The basic example assumes you have a proxy or a gateway running locally on port 5060. It needs to be able to route basic phone calls.

```elixir
# create UACs
Baresex.uanew("alice")
Baresex.uanew("bob")

# subscribe to events from bob
Baresex.Worker.subscribe("bob")

# call bob from alice
Baresex.dial("bob", "alice")

# accept the call
receive do
  %Baresex.Event.Call{} ->
    Baresex.accept("bob")
end

# hangup
Baresex.hangup("bob")

# delete UACs
Baresex.uadel("alice")
Baresex.uadel("bob")
```

## BareSIP configuration

Enable the following lines in your BareSIP configuration file

```
module_app		ctrl_tcp.so
ctrl_tcp_listen		127.0.0.1:4444
```
