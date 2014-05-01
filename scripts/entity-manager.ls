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


class Entity
    @ids = 0
    code: 0
    components: [undefined] * numComponents
    ->
        @id = @@ids++


class EntityManager
    systems: []

    createEntity: ->
        new Entity

    addComponent: (entity, component) ->
        entity.components[component.id] = component
        entity.code = entity.code .|. (1 .<<. component.id);

        for system in @systems
            if system.code .&. entity.code is system.code
                system.onEntityAdded entity

    removeComponent: (entity, component) ->
        for system in @systems
            if system.code .&. entity.code is system.code
                system.onEntityRemoved entity

        entity.code = entity.code .&. ~(1 .<<. component.id)
        entity.components[component.id] = undefined

    getComponent: (entity, componentType) ->
        entity.components[componentType.id]

    registerSystem: (system) ->
        @systems.push system


export em = new EntityManager