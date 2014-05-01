'use strict'

class System
    @ids = 0
    code: 0
    entities: {}

    ->
        @id = @@ids++

    need: (componentTypeList) ->
        for componentType in componentTypeList
            @code = @code .|. (1 .<<. (componentType.id))
        em.registerSystem(@)

        console.log "system code " + @code

    onEntityAdded: (entity) ->
        console.log "An entity has been added but nothing has been catched"

    onComponentAdded: (entity, component) ->
        console.log "A component #component added but nothing has been catched"


export System
