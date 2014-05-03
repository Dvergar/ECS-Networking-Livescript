'use strict'

# LOAD COMPONENTS FROM .PROTO
protoComponents = dcodeIO.ProtoBuf
  .loadProtoFile \components.proto
  .build!

export protoComponents

# ASSOCIATE IDS TO COMPONENTS
components = []
numComponents = 0
for componentName, componentType of protoComponents
    components.push componentType
    componentType.id = numComponents
    componentType::id = numComponents++
    window."#componentName" = componentType

export components


class Entity
    @ids = 0
    code: 0
    components: [undefined] * numComponents  # ugly!

    -> @id = @@ids++
    get: (componentType) -> @components[componentType.id]


class EntityManager
    systems: []

    createEntity: ->
        new Entity

    addComponent: (entity, component) ->
        console.log \addComponent
        entity.components[component.id] = component
        entity.code = entity.code .|. (1 .<<. component.id);

        for system in @systems
            if (system.code .&. entity.code) is system.code
                if system.entities[entity.id] is undefined
                    system.entities[entity.id] = entity
                    system.onEntityAdded entity

        return component

    removeComponent: (entity, component) ->
        for system in @systems
            if (system.code .&. entity.code) is system.code
                system.onEntityRemoved entity

        entity.code = entity.code .&. ~(1 .<<. component.id)
        entity.components[component.id] = undefined

    getComponent: (entity, componentType) ->
        entity.components[componentType.id]

    registerSystem: (system) ->
        @systems.push system

    # FIXED UPDATE: move this stuff
    fps = 60fps
    loops = 0
    skipTicks = 1000ms / fps
    maxFrameSkip = 10
    nextGameTick = new Date!getTime!
    netfps = 20fps
    lastNetTick = new Date!getTime!

    fixedUpdate: (func) ->
        if (new Date!getTime! - lastNetTick) > (1000ms / netfps)
            net.pump!
            lastNetTick := new Date!getTime!

        loops = 0
        while new Date!getTime! > nextGameTick && loops < maxFrameSkip
            func!
            nextGameTick += skipTicks
            loops++


export em = new EntityManager