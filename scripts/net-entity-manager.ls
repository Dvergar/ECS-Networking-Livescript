'use strict'

class NetEntityManager extends Net
    entities = {}
    syncComponents = {}
    templates: {}
    templateIds = numMessages  # To avoid ID collisions
    input: new dcodeIO.ByteBuffer
    output: new dcodeIO.ByteBuffer
    CREATE_ENTITY = 0
    CREATE_TEMPLATE_ENTITY = 1
    ADD_COMPONENT = 2
    EVENT = 3

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
        @_sendAddComponent entity.id, component

    _sendAddComponent: (entityId, component) ->
        @output
            ..writeInt8 ADD_COMPONENT
            ..writeInt16 entityId
            ..writeInt8 component.id
            compenc = component.encode!
            ..writeInt16 compenc.length
            ..append compenc

    create: (entityFunction, triggerEvent) ->
        triggerEvent = false if triggerEvent is undefined
        entity = entityFunction!

        @output
            ..writeInt8 CREATE_TEMPLATE_ENTITY
            ..writeInt8 entityFunction.id  # Entity type
            ..writeInt16 entity.id  # Entity uid
            ..writeInt8 triggerEvent

        # @_sendCreateEntity entity
        for component in entity.components
            if component isnt undefined  # Please U_U
                @_sendAddComponent entity.id, component
                if component.sync then syncComponents[entity.id] = component
        return entity

    # COMMON
    pump: ->
        # SYNC
        for entityId, component of syncComponents
            @_sendAddComponent entityId, component

        # SEND
        @output
            if ..offset > 0
                ..toArrayBuffer! |> @send
                ..reset!

            for component in syncComponents
                _sendAddComponent

        # RECEIVE
        @input
            if ..offset > 0
                ..flip!
                @readMessage! 
                ..reset!

    registerTemplate: (template) ->
        template.id = templateIds++
        @templates[template.id] = template

    sendEvent: (event) ->
        console.log \sendEvent

        @output
            ..writeInt8 EVENT
            ..writeInt8 event.id
            compenc = event.encode!
            ..writeInt16 compenc.length
            ..append compenc

    readMessage:  ->
        @input
            while ..remaining! > 0byte
                msgtype = ..readInt8!

                switch msgtype
                case CREATE_ENTITY
                    netid = ..readInt16!

                    entity = em.createEntity!
                    entities[netid] = entity

                case CREATE_TEMPLATE_ENTITY
                    entityType = ..readInt8!
                    netid = ..readInt16!
                    triggerEvent = ..readInt8!

                    entity = @templates[entityType]!
                    entities[netid] = entity

                    if triggerEvent is 1
                        for _eventType, func of em.events[entityType]
                            func entity: entity

                case ADD_COMPONENT
                    netid = ..readInt16!
                    componentType = ..readInt8!
                    msglength = ..readInt16!
                    mark = ..offset

                    component = messages[componentType].decode ..
                    em.addComponent entities[netid], component
                    ..offset = mark + msglength

                case EVENT
                    eventType = ..readInt8!
                    msglength = ..readInt16!
                    mark = ..offset

                    event = messages[eventType].decode ..
                    for _eventType, func of em.events[eventType]
                        func event
                    
                    ..offset = mark + msglength

            ..reset!

    _onData: (data) ->
        data |> dcodeIO.ByteBuffer.wrap |> @input.append


export net = new NetEntityManager
