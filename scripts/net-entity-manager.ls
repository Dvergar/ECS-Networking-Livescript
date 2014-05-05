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
    REMOVE_COMPONENT = 3
    EVENT = 4

    ->
        super!
        @onData = @_onData
        @input.BE!
        @output.BE!

    # SERVER
    createEntity: ->
        entity = em.createEntity!
        @_sendCreateEntity entity
        console.log @output.toColumns!
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
        console.log \_sendAddComponent
        @output
            ..writeInt8 ADD_COMPONENT
            ..writeInt16 entityId
            ..writeInt8 component.id
            compenc = component.encode!
            ..writeInt16 compenc.length
            console.log \offset_ + ..offset
            ..append compenc
            console.log \offset_ + ..offset
            console.log \length_ + ..length
            console.log ..toColumns!
            # ..writeInt16 42

    removeComponent: (entity, componentType) ->
        console.log \removeComponent
        console.log entity.get(componentType).sync

        # if entity.get(componentType).sync is true
        #     delete syncComponents[entity.id]
        #     console.log syncComponents

        @output
            ..writeInt8 REMOVE_COMPONENT
            ..writeInt16 entity.id
            ..writeInt8 componentType.id
        # em.removeComponent entity, componentType
        console.log \pasquoifaire

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
                # if component.sync then syncComponents[entity.id] = component
                if component.sync
                    syncComponents[entity.id] = component
        return entity

    # COMMON
    pump: ->
        # SEND
        @output
            if ..offset > 0
                ..toArrayBuffer! |> @send
                ..reset!

        # SYNC
        for entityId, component of syncComponents
            console.log \SYNC
            @_sendAddComponent entityId, component

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
            console.log \offset_ + ..offset
            ..writeInt8 EVENT
            ..writeInt8 event.id
            compenc = event.encode!
            ..writeInt16 compenc.length
            console.log \offsetbeforeevent_ + ..offset
            ..append compenc
            console.log \offsetafterevent_ + ..offset
            console.log ..toColumns!

    readMessage:  ->
        console.log \readMessage
        # @input.flip!
        console.log @input.toColumns!
        @input
            while ..remaining! > 0byte
                msgtype = ..readInt8!

                switch msgtype
                case CREATE_ENTITY
                    console.log \CREATE_ENTITY
                    entityId = ..readInt16!

                    entity = em.createEntity!
                    entities[entityId] = entity

                    console.log ..toColumns!

                case CREATE_TEMPLATE_ENTITY
                    console.log \CREATE_TEMPLATE_ENTITY
                    entityType = ..readInt8!
                    entityId = ..readInt16!
                    triggerEvent = ..readInt8!

                    entity = @templates[entityType]!
                    entities[entityId] = entity

                    if triggerEvent is 1
                        for _eventType, func of em.events[entityType]
                            func entity: entity
                    console.log \offset_ + ..offset

                case ADD_COMPONENT
                    console.log \ADD_COMPONENT
                    entityId = ..readInt16!
                    componentType = ..readInt8!
                    msglength = ..readInt16!
                    mark = ..offset
                    console.log \mark_ + mark

                    console.log \entityId_ + entityId
                    console.log \componentType_ + componentType
                    console.log \msglength_ + msglength
                    console.log \afteroffset_ + (mark + msglength)
                    console.log @input.toColumns!


                    component = messages[componentType].decode ..
                    em.addComponent entities[entityId], component
                    ..offset = mark + msglength
                    # console.log ..readInt16!


                case REMOVE_COMPONENT
                    console.log \REMOVE_COMPONENT
                    entityId = ..readInt16!
                    componentType = ..readInt8!

                    em.removeComponent entities[entityId], messages[componentType]

                case EVENT
                    console.log \EVENT
                    eventType = ..readInt8!
                    msglength = ..readInt16!
                    mark = ..offset

                    event = messages[eventType].decode ..
                    for _eventType, func of em.events[eventType]
                        console.log \throevent
                        func event
                    
                    ..offset = mark + msglength
            ..reset!

    _onData: (data) ->
        data |> dcodeIO.ByteBuffer.wrap |> @input.append
#  TODO rename component.id to component.type

export net = new NetEntityManager
