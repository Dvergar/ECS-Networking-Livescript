var _root = dcodeIO.ProtoBuf.newBuilder().import({
    "package": null,
    "messages": [
        {
            "name": "CInput",
            "fields": [
                {
                    "rule": "required",
                    "type": "bool",
                    "name": "key_up",
                    "id": 1,
                    "options": {}
                },
                {
                    "rule": "required",
                    "type": "bool",
                    "name": "key_down",
                    "id": 2,
                    "options": {}
                },
                {
                    "rule": "required",
                    "type": "bool",
                    "name": "key_left",
                    "id": 3,
                    "options": {}
                },
                {
                    "rule": "required",
                    "type": "bool",
                    "name": "key_right",
                    "id": 4,
                    "options": {}
                }
            ],
            "enums": [],
            "messages": [],
            "options": {}
        },
        {
            "name": "CPosition",
            "fields": [
                {
                    "rule": "required",
                    "type": "sint32",
                    "name": "x",
                    "id": 1,
                    "options": {}
                },
                {
                    "rule": "required",
                    "type": "sint32",
                    "name": "y",
                    "id": 2,
                    "options": {}
                },
                {
                    "rule": "required",
                    "type": "sint32",
                    "name": "z",
                    "id": 3,
                    "options": {}
                }
            ],
            "enums": [],
            "messages": [],
            "options": {}
        },
        {
            "name": "CSpeed",
            "fields": [
                {
                    "rule": "required",
                    "type": "int32",
                    "name": "value",
                    "id": 1,
                    "options": {
                        "default": 5
                    }
                }
            ],
            "enums": [],
            "messages": [],
            "options": {}
        },
        {
            "name": "CDrawable",
            "fields": [
                {
                    "rule": "optional",
                    "type": "string",
                    "name": "image_name",
                    "id": 1,
                    "options": {}
                },
                {
                    "rule": "optional",
                    "type": "int32",
                    "name": "width",
                    "id": 2,
                    "options": {}
                },
                {
                    "rule": "optional",
                    "type": "int32",
                    "name": "height",
                    "id": 3,
                    "options": {}
                },
                {
                    "rule": "optional",
                    "type": "int32",
                    "name": "color",
                    "id": 4,
                    "options": {}
                },
                {
                    "rule": "required",
                    "type": "Type",
                    "name": "type",
                    "id": 5,
                    "options": {}
                }
            ],
            "enums": [
                {
                    "name": "Type",
                    "values": [
                        {
                            "name": "RECTANGLE",
                            "id": 1
                        },
                        {
                            "name": "IMAGE",
                            "id": 2
                        }
                    ],
                    "options": {}
                }
            ],
            "messages": [],
            "options": {}
        }
    ],
    "enums": [],
    "imports": [],
    "options": {},
    "services": []
}).build();
