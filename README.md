# Baresex

[![Build Status](https://travis-ci.org/tverlaan/baresex.svg?branch=master)](https://travis-ci.org/tverlaan/baresex)

An Elixir library to control Baresip over a TCP socket

## Basic example

The basic example assumes you have a proxy or a gateway running locally on port 5060. It needs to be able to route basic phone calls.

```elixir
# create UACs
Baresex.uanew("sip:alice@proxy")
Baresex.uanew("sip:bob@proxy")

# subscribe to events from bob
Baresex.Worker.subscribe("sip:bob@proxy")

# call bob from alice
Baresex.dial("sip:alice@proxy", "bob")

# accept the call
receive do
  %Baresex.Event.Call{} ->
    Baresex.accept("sip:bob@proxy")
end

# hangup
Baresex.hangup("sip:bob@proxy")

# delete UACs
Baresex.uadel("sip:alice@proxy")
Baresex.uadel("sip:bob@proxy")
```

## BareSIP configuration

Enable the following lines in your BareSIP configuration file

```
module_app		ctrl_tcp.so
ctrl_tcp_listen		127.0.0.1:4444
```
