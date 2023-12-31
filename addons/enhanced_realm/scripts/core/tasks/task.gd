@tool
@icon("res://addons/enhanced_realm/icons/icons8-task-24.png")
extends Resource
class_name RealmTask

@export var skip: bool = false
@export_group("Editor")
@export var name: String = get_default_name()
@export var icon: Texture

###
# CORE
###
var realm: Realm2D
var group_level: int

func initialize(_realm: Realm2D, _group_level: int = 0) -> void:
	realm = _realm
	group_level = _group_level
	_initialize()

func _initialize() -> void:
	pass

func execute() -> void:
	pass


###
# DATA
###
enum CellBoundary {
	IN,
	BORDER,
	OUT,
}

func get_data_by_key(key: String) -> Variant:
	return realm.data[key]

func get_data(type: Variant) -> Variant:
	for data in realm.data.values():
		if is_instance_of(data, type):
			return data
	
	return null

func set_data(key: String, data: Variant) -> void:
	realm.data[key] = data


###
# RNG
###
var rng: RandomNumberGenerator:
	get = get_rng

func get_rng() -> RandomNumberGenerator:
	var _rng: RandomNumberGenerator = get_data(RandomNumberGenerator)
	return _rng if _rng != null else RandomNumberGenerator.new()

func shuffle(array: Array):
	var shuffled = []
	var index := range(array.size())
	for i in range(array.size()):
		var x = pick_random(index)
		shuffled.append(array[x])
		index.erase(x)

	return shuffled

func pick_random(array: Array) -> Variant:
	return array[rng.randi() % array.size()]


###
# TileMap
###
var tile_map: TileMap:
	get = get_tile_map

func get_tile_map() -> TileMap:
	return realm.tile_map

func clear() -> void:
	tile_map.clear()


###
# Editor
###
func get_default_name() -> String:
	if !ClassUtils.has_custom_class(self):
		return ""

	return ClassUtils.get_custom_class(self).class

func log_task(time: int) -> String:
	var indentation: String = ""
	
	for i in group_level:
		indentation += "  "

	return "%s[%s] Time taken: %s ms" % [indentation, name, str(Time.get_ticks_msec() - time)]
