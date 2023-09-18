@tool
@icon("res://addons/enhanced_realm/icons/icons8-polyline-24.png")
extends GeneratorRealmTask
class_name WalkerGenerator



class Walker:
	var pos = Vector2.ZERO
	var dir = Vector2.ZERO

@export var settings: WalkerGeneratorSettings
@export var poi_configurations: Array[RngPoiConfiguration] = []
@export var starting_tile := _get_default_starting_tile()

var _walkers : Array[Walker]
var _walked_tiles : Array[Vector2]
var _map: GridMap2D
var _pois: Array[Poi]




func execute() -> void:
	if not settings:
		push_error("%s doesn't have a settings resource")
		return
	
	erase()
	_pois = []
	_map = get_data(GridMap2D)
	_add_walker(starting_tile)
	_generate_floor()
	set_data("pois", _pois)

func erase(clear_tilemap := true) -> void:
	_walked_tiles.clear()
	_walkers.clear()


### Steps ###

func _add_walker(pos) -> void:
	var walker = Walker.new()
	walker.dir = _random_dir()
	walker.pos = pos

	_walkers.append(walker)

func _generate_floor() -> void:
	var iterations = 0

	while iterations < 100000:
		for walker in _walkers:
			_move_walker(walker)

		if settings.fullness_check == settings.FullnessCheck.TILE_AMOUNT:
			if _walked_tiles.size() >= settings.max_tiles:
				break
		elif settings.fullness_check == settings.FullnessCheck.PERCENTAGE:
			if _walked_tiles.size() / (_map.size.x * _map.size.y) >= settings.fullness_percentage:
				break

		iterations += 1
	
	settings.transformer.initialize(realm)
	for tile in _walked_tiles:
		settings.transformer.apply(_map.get_cell(Vector2i(tile.x, tile.y)))

	_walkers.clear()
	_walked_tiles.clear()

func _move_walker(walker: Walker) -> void:
	if rng.randf() <= settings.destroy_walker_chance and _walkers.size() > 1:
		_walkers.erase(walker)
		return

	if not _walked_tiles.has(walker.pos):
		_walked_tiles.append(walker.pos)

	if rng.randf() <= settings.new_dir_chance:
		var random_rotation = _get_random_rotation()
		walker.dir = round(walker.dir.rotated(random_rotation))

	if rng.randf() <= settings.new_walker_chance and _walkers.size() < settings.max_walkers:
		_add_walker(walker.pos)

	for poi_configuration in poi_configurations:
		if rng.randf() <= poi_configuration.chance:
			var poi: Poi = poi_configuration.template.get_poi()
			poi.coordinates = walker.pos
			var room_tiles = poi.get_area_coordinates(_map)
			
			for pos in room_tiles:
				if not _walked_tiles.has(Vector2(pos)):
					_walked_tiles.append(Vector2(pos))
			
			break

	walker.pos += walker.dir
	if settings.constrain_world_size:
		walker.pos = _constrain_to_world_size(walker.pos)


### Utilities ###

func _random_dir() -> Vector2:
	match rng.randi_range(0, 3):
		0: return Vector2.RIGHT
		1: return Vector2.LEFT
		2: return Vector2.UP
		_: return Vector2.DOWN

func _get_random_rotation() -> float:
	match rng.randi_range(0, 2):
		0: return deg_to_rad(90)
		1: return deg_to_rad(-90)
		_: return deg_to_rad(180)

func _constrain_to_world_size(pos: Vector2) -> Vector2:
	pos.x = clamp(pos.x, 1, _map.size.x - 5)
	pos.y = clamp(pos.y, 1, _map.size.y - 5)
	return pos

func _get_default_starting_tile() -> Vector2:
	return _map.get_center() if _map != null else Vector2.ZERO
