'use strict'

class NetEntityManager extends Net
    entities = {}
    input: new dcodeIO.ByteBuffer
    output: new dcodeIO.ByteBuffer
    CREATE_ENTITY = 0
    ADD_COMPONENT = 1

    ->
        super!
        @onData = @_onData

    # SERVER
    createEntity: ->
        entity = em.createEntity!
        @_sendCreateEntity entity
        return entity

    _sendCreateEntity: (entity) ->
        entities[entity.id] = entity

        @output
            ..writeInt8 CREATE_ENTITY
            ..writeInt16 entity.id

    addComponent: (entity, component) ->
        em.addComponent entity, component
        @_sendAddComponent entity, component

    _sendAddComponent: (entity, component) ->
        @output
            ..writeInt8 ADD_COMPONENT
            ..writeInt16 entity.id
            ..writeInt8 component.id
            compenc = component.encode!
            ..writeInt16 compenc.length
            ..append compenc

    create: (entityFunction) ->
        entity = entityFunction!
        @_sendCreateEntity entity
        for component in entity.components
            if component isnt undefined  # Please U_U
                @_sendAddComponent entity, component

    # COMMON
    pump: ->
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

        @input
            while ..remaining! > 0
                msgtype = ..readInt8!

                switch msgtype
                case CREATE_ENTITY
                    netid = ..readInt16!

                    entity = em.createEntity!
                    entities[netid] = entity

                case ADD_COMPONENT
                    netid = ..readInt16!
                    componentType = ..readInt8!
                    msglength = ..readInt16!
                    mark = ..offset

                    component = components[componentType].decode ..
                    em.addComponent entities[netid], component

                    ..offset = mark + msglength
            ..reset!

    _onData: (data) ->
        data |> dcodeIO.ByteBuffer.wrap |> @input.append




export net = new NetEntityManager
