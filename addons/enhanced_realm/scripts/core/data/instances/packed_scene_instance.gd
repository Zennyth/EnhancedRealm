@tool
@icon("res://addons/enhanced_realm/icons/icons8-documentary-24.png")
extends RealmInstance
class_name PackedSceneRealmInstance

@export var packed_scenes: Array[PackedScene] = []

func _instantiate(coordinates: Vector2i) -> void:
    var instance: Node2D = packed_scenes.pick_random().instantiate()
    instance.global_position = get_global_coordinates(coordinates)
    realm.instantiate(instance)


