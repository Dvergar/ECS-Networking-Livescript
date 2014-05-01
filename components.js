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
                    "id": 2,
                    "options": {}
                },
                {
                    "rule": "required",
                    "type": "bool",
                    "name": "key_right",
                    "id": 2,
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
                    "type": "int32",
                    "name": "x",
                    "id": 1,
                    "options": {}
                },
                {
                    "rule": "required",
                    "type": "int32",
                    "name": "y",
                    "id": 2,
                    "options": {}
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
                    "rule": "required",
                    "type": "Type",
                    "name": "type",
                    "id": 4,
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
