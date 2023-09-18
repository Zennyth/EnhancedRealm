@tool
@icon("res://addons/enhanced_realm/icons/icons8-circle-24.png")
extends InitializationRealmTask
class_name CircleFillInitialization

@export var exclusion_radius: int = 3
@export var transformer: CellData



func execute() -> void:
	var map: GridMap2D = get_data(GridMap2D)
	var radius: int = map.center.x - exclusion_radius
	
	transformer.apply_cells(map.get_round_region_cells(map.center, radius))

	set_data("radius", radius)