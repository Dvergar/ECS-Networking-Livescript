'use strict'

# Load components from .proto
components = dcodeIO.ProtoBuf
  .loadProtoFile \components.proto
  .build!

# Associate IDs to components
numComponents = 0
for componentName, componentType of components
    componentType.id = numComponents
    componentType::id = numComponents++
    window."#componentName" = componentType


class EntityManager
    componentStore: [undefined] * numComponents
    systems: [undefined] * numComponents
    entityIds: 0

    createEntity: ->
        @entityIds++

    addComponent: (entity, component) ->
        store = @componentStore[component.id]
        if store is undefined then @componentStore[component.id] = {}
        @componentStore[component.id]."#entity" = component
        console.log @componentStore

        if @systems[component.id] isnt undefined
            for system in @systems[component.id]
                system._onComponentAdded(entity, component)

    getComponent: (entity, componentType) ->
        store = @componentStore[componentType.id]
        if store is undefined then throw new Error "No entity with that comp"
        component = store."#entity"
        if component is undefined then throw new Error "Nope component!"
        return component

    registerSystem: (system, componentTypeList) ->
        for componentType in componentTypeList
            if @systems[componentType.id] is undefined
                @systems[componentType.id] = []
            @systems[componentType.id].push system


export em = new EntityManager