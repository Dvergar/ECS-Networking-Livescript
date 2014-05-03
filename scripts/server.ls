'use strict'

# setInterval run, 1000 / fps
# setInterval em.fixedUpdate ->
#     console.log \update
# , 20

# setInterval em.fixedUpdate !->
#     console.log \update
# , 1

# setInterval em.fixedUpdate ->
#   console.log \update
# , 3000

# function lel
#     console.log \lel

# (lel `setInterval` 50_000ms) !->
#     console.log \update

# (lel `setInterval` 50_000ms)

# (`setInterval` 1000) <| -> console.log \test



position = new CPosition
    ..x = 42
    ..y = 42

position2 = new CPosition
    ..x = 12
    ..y = 12

console.log position

output = new dcodeIO.ByteBuffer!

# console.log bb.length

position.encode! |> output.append
console.log "offset " + output.offset
# position2.encode! |> output.append
# console.log "offset " + output.offset
# console.log position.data.printDebug!

output.writeInt16 100

# output.offset = 0
output.flip!
console.log "postflip offset " + output.offset
console.log "postflip length " + output.length
# output.offset = 0


console.log "buffer " + output.toColumns!

# msg = new CPosition
# console.log msg
# msg.decode output, 4
#     console.log ..x
#     console.log ..y

# output.offset = 4
console.log "buffer " + output.toColumns!
# output.BE!
console.log "buffer " + output.toColumns!
console.log "postflip offset " + output.offset
console.log "postflip length " + output.length
console.log output.readInt16!

net.listen \god \localhost 9000
net.onOpen = onOpen
# net.onData = onData


function onOpen conn
    console.log \onOpen
    net._send position
    # console.log "offset " + net.output.offset
    net._send position2
    # console.log "offset2 " + net.output.offset

function dummy
    console.log

setInterval  ->
    em.fixedUpdate dummy
, 1000 / 60fps



# peer = new Peer \god {host: \localhost, port: 9000}

# peer.on \connection (conn) !->
#     conn.send \wot
#     conn.on \open (id) !->
#         console.log \onopen
#         conn.send \wff

#     conn.on \data (data) !->
#         console.log data
#         conn.send \lel