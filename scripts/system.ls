'use strict'

class System
    entities: {}

    need: (componentTypeList) ->
        for componentType in componentTypeList
            em.registerSystem(@, componentTypeList)

    onEntityAdded: (entity) ->
        console.log "An entity has been added but nothing has been catched"

    onComponentAdded: (entity, component) ->
        console.log "A component #component added but nothing has been catched"

    _onComponentAdded: (entity, component) ->
        @onComponentAdded(entity, component)

        if @entities."#entity" is undefined
            @entities."#entity" = []
            @onEntityAdded entity

        @entities[entity].push component

export System
