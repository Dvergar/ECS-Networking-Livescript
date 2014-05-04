'use strict'

# LOAD COMPONENTS FROM .PROTO
protoMessages = dcodeIO.ProtoBuf
  .loadProtoFile \components.proto
  .build!

# ASSOCIATE IDS TO MESSAGES
messages = []
numMessages = 0
for messageName, messageType of protoMessages
    messages.push messageType
    messageType.id = numMessages
    messageType::id = numMessages++
    window."#messageName" = messageType

export messages


class Entity
    @ids = 0
    code: 0
    components: [undefined] * numMessages  # ugly!

    -> @id = @@ids++
    get: (componentType) -> @components[componentType.id]


class EntityManager
    systems: []
    events: {}
    (side) ->
        console.log \SIDE_ + side
        if side isnt "client" and side isnt "server"
            throw new Error "Argument should be CLIENT or SERVER"

        if side is "client" then export CLIENT = true
        if side is "server" then export SERVER = true

    createEntity: ->
        new Entity

    addComponent: (entity, component, sync) ->
        entity.components[component.id] = component
        entity.code = entity.code .|. (1 .<<. component.id);

        for system in @systems
            if (system.code .&. entity.code) is system.code
                if system.entities[entity.id] is undefined
                    system.entities[entity.id] = entity
                    system.onEntityAdded entity

        # Should probably be at netem level but fuck that
        if sync is true then component.sync = true

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

    registerEvent: (type, func) ->
        if @events[type.id] is undefined then @events[type.id] = []
        @events[type.id].push func



export EntityManager
export SYNC = true
export CLIENT = false  # Overridden by entity manager
export SERVER = false  # But this is horrible, please fix