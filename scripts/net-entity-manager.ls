'use strict'

class NetEntityManager extends Net
    @ids = 0
    entities = {}
    input: new dcodeIO.ByteBuffer
    output: new dcodeIO.ByteBuffer

    ->
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

        # SEND
        if @output.offset > 0 
            @output
                ab = ..toArrayBuffer! |> @send
                ..reset!

        # RECEIVE
        if @input.offset > 0
            @input
                ..flip!
                @readMessage! 
                ..reset!

    readMessage:  ->
        console.log \readMessage
        CPosition.decode(@input)
            console.log ..x
            console.log ..y

        # CPosition.decode(@input)
        #     console.log ..x
        #     console.log ..y

    _send: (data) ->
        data |> dcodeIO.ByteBuffer.wrap |> @output.append
        console.log @output.offset

    _onData: (data) ->
        data |> dcodeIO.ByteBuffer.wrap |> @input.append




export net = new NetEntityManager
