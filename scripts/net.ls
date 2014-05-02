class Net
	connections: []
	->
		@onConnection = @onConnectionDefault
		@onData = @onDataDefault
		@onOpen = @onOpenDefault

	# SERVER
	listen: (peerName, host, port) ->
		@peer = new Peer peerName, {host: \localhost, port: 9000} # common
		@peer .on \connection (conn) ~> @_onConnection(conn) # server

	_onConnection: (conn) ->
		console.log \_onConnection
		conn .on \data (data) ~> @onData(data)
		conn .on \open (id)   ~> @onOpen(id)
		@connections .push conn
		@onConnection conn

	# CLIENT
	connect: (peerName) ->
		@peer = new Peer {host: \localhost, port: 9000} # common
		@conn = @peer.connect peerName
		@conn .on \open (id)   ~> @onOpen(id)
		@conn .on \data (data) ~> @onData(data)

		@connections.push @conn

	# COMMON
	send: (data) ->
		for conn in @connections
			console.log \sending + data
			conn.send data

	# DEFAULTS
	onOpenDefault: (id) ->
		console.log \onOpenDefault

	onConnectionDefault: (conn) ->
		console.log \onConnectionDefault

	onDataDefault: (data) ->
		console.log data


export net = new Net