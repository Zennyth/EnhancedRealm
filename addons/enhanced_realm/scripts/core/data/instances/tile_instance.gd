@tool
@icon("res://addons/enhanced_realm/icons/icons8-modern-art-24.png")
extends RealmInstance
class_name TileRealmInstance


enum Type {
	TERRAIN,
	TILE
}

@export var type: Type = Type.TERRAIN:
	set = set_type


@export var layer: int

###
# TERRAIN
###
var terrain_set: int:
	set = set_terrain_set

func set_terrain_set(value) -> void:
	terrain_set = value
	notify_property_list_changed()

var terrain: int

###
# TILE
###
var source: int:
	set = set_source

func set_source(value) -> void:
	source = value
	notify_property_list_changed()

var atlas_coordinates: Vector2i


###
# CORE
###
var  tile_map: TileMap:
	get = get_tile_map

func get_tile_map() -> TileMap:
	return realm.tile_map if realm != null else null

func instantiate(coordinates: Array[Vector2i]) -> void:
	match type:
		Type.TILE:
			for _coordinates in coordinates:
				tile_map.set_cell(layer, _coordinates, source, atlas_coordinates)
		Type.TERRAIN:
			tile_map.set_cells_terrain_connect(layer, coordinates, terrain_set, terrain)




###
# Editor
###
func set_type(value) -> void:
	type = value
	notify_property_list_changed()

func _get_property_list() -> Array[Dictionary]:
	var properties: Array[Dictionary] = []

	match type:
		Type.TERRAIN:
			properties.append({
				"name": "terrain_set",
				"usage": PROPERTY_USAGE_DEFAULT,
				"type": TYPE_INT,
			})
			properties.append({
				"name": "terrain",
				"usage": PROPERTY_USAGE_DEFAULT,
				"type": TYPE_INT,
			})
		Type.TILE:
			properties.append({
				"name": "source",
				"usage": PROPERTY_USAGE_DEFAULT,
				"type": TYPE_INT,
			})
			properties.append({
				"name": "atlas_coordinates",
				"usage": PROPERTY_USAGE_DEFAULT,
				"type": TYPE_VECTOR2I,
			})

	return properties