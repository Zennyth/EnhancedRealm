@tool
@icon("res://addons/enhanced_realm/icons/icons8-dust-24.png")
extends RealmTask
class_name NoiseRenderer

@export var noise_texture: NoiseTexture2D
@export var restrict: CellData
@export var range_selectors: Array[RangeSelector] = []:
	set = set_range_selectors

func _initialize() -> void:
	for range_selector in range_selectors:
		if range_selector == null:
			continue

		range_selector.initialize(realm)


func execute() -> void:
	var map: GridMap2D = get_data(GridMap2D)
	var selector_coordinates: Dictionary = {}

	for range_selector in range_selectors:
		selector_coordinates[range_selector] = []
	
	var cells: Array[GridCell2D] = map.get_cell_list()

	if restrict != null:
		cells = cells.filter(func(cell): return restrict.is_valid(cell))

	for cell in cells:
		var value: float = (noise_texture.noise.get_noise_2d(cell.coordinates.x, cell.coordinates.y) + 1) / 2

		for range_selector in range_selectors.filter(func(range_selector): return range_selector.is_in_range(value)):	
			selector_coordinates[range_selector].append(cell.coordinates)
	
	for range_selector in range_selectors:
		var array: Array[Vector2i]
		array.assign(selector_coordinates[range_selector])
		range_selector.apply(array)


###
# EDITOR
###
func set_range_selectors(value) -> void:
	range_selectors = value
	notify_property_list_changed()
	_initialize()
