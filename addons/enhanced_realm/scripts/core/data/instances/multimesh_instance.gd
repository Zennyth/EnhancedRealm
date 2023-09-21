@tool
@icon("res://addons/enhanced_realm/icons/icons8-ungroup-objects-24.png")
extends RealmInstance
class_name MultiMeshRealmInstance

@export var texture: Texture2D
@export var material: Material

func instantiate(coordinates: Array[Vector2i]) -> void:
	var _coordinates: Array[Vector2]
	_coordinates.assign(coordinates.map(func(c): return get_global_coordinates(c)))
	
	var instance := MultiMeshUtils.create_multimesh_instance_2d_from_texture(texture, _coordinates, material)
	realm.instantiate(instance)

var icon: Texture2D:
	get: return texture