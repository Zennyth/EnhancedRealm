@tool
@icon("res://addons/enhanced_realm/icons/icons8-cleanup-noise-24.png")
extends RealmTask
class_name SmoothCellular

@export var iteration: int = 5
@export var empty_neighbors_range_min: int = 2
@export var empty_neighbors_range_max: int = 4

@export var restrict_neighboors: CellData
@export var upper_cell_transformer: CellData
@export var lower_cell_transformer: CellData


func execute() -> void:
	var map: GridMap2D = get_data(GridMap2D)
	var radius: int = get_data_by_key("radius")

	var cells := map.get_round_region_cells(map.center, radius)
	var neighboors: Array[Array] = []

	restrict_neighboors.initialize(realm)
	upper_cell_transformer.initialize(realm)
	lower_cell_transformer.initialize(realm)

	for i in iteration:
		for cell in cells:
			var neighbors := map.get_neighbors(cell.coordinates)

			if restrict_neighboors != null:
				neighbors = neighbors.filter(func(neighboor): return restrict_neighboors.is_valid(neighboor))

			if len(neighbors) > rng.randi_range(empty_neighbors_range_min, empty_neighbors_range_max):
				upper_cell_transformer.apply(cell)
			else:
				lower_cell_transformer.apply(cell)
