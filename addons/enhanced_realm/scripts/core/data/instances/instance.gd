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

###
# RNG
###
var rng: RandomNumberGenerator:
	get = get_rng

func get_rng() -> RandomNumberGenerator:
	var _rng: RandomNumberGenerator = realm.get_data(RandomNumberGenerator)
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

func chunck_random(array: Array, chunck_number: int) -> Array:
	var chuncks: Array = []

	for i in chunck_number:
		chuncks.append([])
	
	for x in array:
		pick_random(chuncks).append(x)
	
	return chuncks