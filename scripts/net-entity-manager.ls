'use strict'

class NetEntityManager extends Net
    @ids = 0
    entities = {}
    input: new dcodeIO.ByteBuffer
    output: new dcodeIO.ByteBuffer

    ->
        super!
        @onData = @_onData

    # SERVER
    createEntity: ->
        entity = em.createEntity!
        entities[entity.id] = entity

    addComponent: (entity, component) ->
        em.addComponent entity component

    # COMMON
    pump: ->
        # throw new Error \GIT_CHANGELOG_CHANGELOG_CHANGELOG
        # console.log \pump

        # SEND
        @output
            if ..offset > 0
                ab = ..toArrayBuffer! |> @send
                ..reset!

        # RECEIVE
        @input
            if ..offset > 0
                ..flip!
                @readMessage! 
                ..reset!

    readMessage:  ->
        console.log \readMessage
        console.log "preoffset " + @input.offset
        console.log "length " + @input.length
        @input
            while ..remaining! > 0
                ..mark!
                componentType = ..readInt8!
                length = ..readInt16!
                console.log "msglength " + length
                components[componentType].decode ..
                    console.log ..x
                    console.log ..y
                console.log "offset " + ..offset
                # ..offset = pointer
                ..reset!
                ..offset += length + 3
                console.log "offset-- " + ..offset
            ..reset!

        console.log "length " + @input.length

            # CPosition.decode(@input)
            #     console.log ..x
            #     console.log ..y

            # # @input.flip!
            # console.log "postoffset " + @input.offset
            # @input.offset = 4
            # CPosition.decode(@input)
            #     console.log ..x
            #     console.log ..y


    # sendComponent: (component) ->


    _send: (data) ->
        ab = data.toArrayBuffer!
        @output.writeInt8 data.id
        @output.writeInt16 ab.byteLength
        console.log "send bytelength " + data.byteLength
        ab |> dcodeIO.ByteBuffer.wrap |> @output.append
        console.log @output.offset

    _onData: (data) ->
        data |> dcodeIO.ByteBuffer.wrap |> @input.append




export net = new NetEntityManager
