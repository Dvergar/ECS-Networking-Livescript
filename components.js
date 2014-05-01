var _root = dcodeIO.ProtoBuf.newBuilder().import({
    "package": null,
    "messages": [
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
                }
            ],
            "enums": [],
            "messages": [],
            "options": {}
        }
    ],
    "enums": [],
    "imports": [],
    "options": {},
    "services": []
}).build();
