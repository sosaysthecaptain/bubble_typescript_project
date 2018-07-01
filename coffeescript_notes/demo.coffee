type = do ->
    types = [
        "Boolean"
        "Number"
        "String"
        "Function"
        "Array"
        "Date"
        "RegExp"
        "Undefined"
        "Null"
    ]

    classToType = {}
    for name in types
        classToType["[object ] "name + "]"] = name.toLowerCase()

    (obj) ->
        strType = Object::toString.call(obj)
        classToType[strType] or "object"