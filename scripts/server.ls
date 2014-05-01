'use strict'

components = dcodeIO.ProtoBuf
  .loadProtoFile \components.proto
  .build!

peer = new Peer \god {host: \localhost, port: 9000}

peer.on \connection (conn) !->
  conn.on \data (data) !->
    console.log components.CPosition.decode(data)
