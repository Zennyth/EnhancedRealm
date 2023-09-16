@tool
@icon("res://addons/enhanced_realm/icons/icons8-clear-24.png")
extends InitializationRealmTask
class_name ClearInitialization

@export var size: Vector2i = Vector2i(0, 0) 

@export_group("Fill")
@export var default_fill: bool = false
@export var transformer: CellData


func execute() -> void:
	tile_map.clear()
	NodeUtils.delete_children(realm.entities)

	var map: GridMap2D = get_data(GridMap2D)

	if map == null:
		map = GridMap2D.new(size)
		set_data("map", map)
	else:
		map.clear_cells()
		map.size = size
	
	if not default_fill:
		return
	
	var creation_method: Callable = map.get_cell_creation_method(transformer.create_data) if transformer != null else map.get_cell_creation_method()
	
	map.fill(creation_method)
	