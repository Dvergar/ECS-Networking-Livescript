'use strict'

class System
    @ids = 0
    code: 0

    need: (componentTypeList) ->
        @id = @@ids++
        @entities = {}

        for componentType in componentTypeList
            @code = @code .|. (1 .<<. (componentType.id))

    onEntityAdded: (entity) ->
        console.log "An entity has been added but nothing has been caught"

    onEntityRemoved: (entity, component) ->
        console.log "An entity has been removed but nothing has been caught"

    loop: ->


export System
