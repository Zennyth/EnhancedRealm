@tool
@icon("res://addons/enhanced_realm/icons/icons8-ungroup-objects-24.png")
extends RealmInstance
class_name MultiMeshGroupRealmInstance

@export var textures: Array[Texture2D] = []
@export var material: Material

var instance: MultiMeshInstance2D

func instantiate(coordinates: Array[Vector2i]) -> void:
	var chunks := chunck_random(coordinates, len(textures))

	for i in len(chunks):
		var chuncked_coordinates: Array[Vector2]
		chuncked_coordinates.assign(chunks[i].map(func(c): return get_global_coordinates(c)))
		
		var instance := MultiMeshUtils.create_multimesh_instance_2d_from_texture(textures[i], chuncked_coordinates, material)
		instance.name = textures[i].resource_path.get_file()
		realm.instantiate(instance)


var icon: Texture2D:
	get: return textures[0] if len(textures) > 0 else null