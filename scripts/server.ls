'use strict'

# components = dcodeIO.ProtoBuf
#   .loadProtoFile \components.proto
#   .build!
# 
# peer = new Peer \god {host: \localhost, port: 9000}

# peer.on \connection (conn) !->
#     conn.send \wot
#     conn.on \open (id) !->
#         conn.send \wff

#     conn.on \data (data) !->
#         console.log data
#         conn.send \lel

    # console.log components.CPosition.decode(data)

net.listen \god \localhost, 9000
net.onOpen = onOpen

function onOpen conn
    console.log \onOpen
    net.send \coucou