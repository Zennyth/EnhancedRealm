@tool
@icon("res://addons/enhanced_realm/icons/icons8-cube-24.png")
extends Resource
class_name RealmInstance


var realm: Realm2D

func initialize(_realm: Realm2D) -> void:
    realm = _realm

func instantiate(coordinates: Array[Vector2i]) -> void:
    for _coordinates in coordinates:
        _instantiate(_coordinates)

func _instantiate(coordinates: Vector2i) -> void:
    pass



func get_global_coordinates(coordinates: Vector2i) -> Vector2:
    return realm.tile_map.to_global(realm.tile_map.map_to_local(coordinates))