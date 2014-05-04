'use strict'

class Net
    connections: []
    ->
        @onData = @onDataDefault
        @onOpen = @onOpenDefault

    # SERVER
    listen: (peerName, host, port) ->
        @peer = new Peer peerName, {host: host, port: port, debug: 0} # common
        @peer.on \connection (conn) ~> @onConnection(conn) # server

    onConnection: (conn) ->
        console.log \_onConnection
        conn.on \open (id)   ~> @onOpen(id)
        conn.on \data (data) ~> @onData(data)
        @connections.push conn

    # CLIENT
    connect: (peerName, host, port) ->
        @peer = new Peer {host: host, port: port, debug: 0} # common
        @conn = @peer.connect peerName
        @conn.on \open (id)   ~> @onOpen(id)
        @conn.on \data (data) ~> @onData(data)
        @connections.push @conn

    # COMMON
    send: (data) ->
        for conn in @connections then conn.send data

    # DEFAULTS
    onOpenDefault: (id) ->
        console.log \onOpenDefault

    onDataDefault: (data) ->
        console.log \onDataDefault


# export net = new Net
export Net