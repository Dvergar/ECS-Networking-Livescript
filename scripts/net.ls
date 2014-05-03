'use strict'

class Net
    connections: []
    ->
        @onData = @onDataDefault
        @onOpen = @onOpenDefault

    # SERVER
    listen: (peerName, host, port) ->
        @peer = new Peer peerName, {host: \localhost, port: 9000} # common
        @peer.on \connection (conn) ~> @onConnection(conn) # server

    onConnection: (conn) ->
        console.log \_onConnection
        conn.on \open (id)   ~> @onOpen(id)
        conn.on \data (data) ~> @onData(data)
        @connections.push conn

    # CLIENT
    connect: (peerName) ->
        @peer = new Peer {host: \localhost, port: 9000} # common
        @conn = @peer.connect peerName
        @conn.on \open (id)   ~> @onOpen(id)
        @conn.on \data (data) ~> @onData(data)
        @connections.push @conn

    # COMMON
    send: (data) ->
        console.log \send
        
        for conn in @connections
            console.log \sending + data
            conn.send data

    # DEFAULTS
    onOpenDefault: (id) ->
        console.log \onOpenDefault

    onDataDefault: (data) ->
        console.log \data
        console.log data


# export net = new Net
export Net