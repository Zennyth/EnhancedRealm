@tool
@icon("res://addons/enhanced_realm/icons/icons8-sd-24.png")
extends InitializationRealmTask
class_name CellDataInitialization

@export var restrict: CellData
@export var transformer: CellData

func execute() -> void:
	var map: GridMap2D = get_data(GridMap2D)
	var cells: Array[GridCell2D] = map.get_cell_list()

	if restrict != null:
		restrict.initialize(realm)
		cells = cells.filter(func(cell): return restrict.is_valid(cell))
	
	transformer.initialize(realm)
	transformer.apply_cells(cells)
