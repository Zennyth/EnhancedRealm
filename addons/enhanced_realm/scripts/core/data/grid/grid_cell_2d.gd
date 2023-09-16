extends RefCounted
class_name GridCell2D

var coordinates: Vector2i
var data: Dictionary

func _init(_coordinates: Vector2i, _data: Dictionary = {}) -> void:
    coordinates = _coordinates
    data = _data


###
# DATA
###
func get_data(key: String) -> Variant:
    return data[key] if data.has(key) else null

func set_data(key: String, value: Variant) -> void:
    data[key] = value

func has_data(key: String) -> bool:
    return data.has(key)