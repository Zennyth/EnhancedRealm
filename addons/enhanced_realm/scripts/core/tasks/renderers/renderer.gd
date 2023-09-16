@tool
@icon("res://addons/enhanced_realm/icons/icons8-draw-24.png")
extends RealmTask
class_name RendererRealmTask


@export var restrict: CellData
@export var instance: RealmInstance:	
	set = set_instance

func set_instance(value) -> void:
	instance = value
	_initialize()

func _initialize() -> void:
	if instance == null:
		return
	
	instance.initialize(realm)


func execute() -> void:
	var map: GridMap2D = get_data(GridMap2D)
	var coordinates: Array[Vector2i] = []

	for cell in map.get_cell_list().filter(func(cell): return restrict.is_valid(cell)):
		coordinates.append(cell.coordinates)
	
	instance.instantiate(coordinates)


###
# Utils
###
func distance_from_center(coordinates: Vector2i, center: Vector2i) -> float:
	return Vector2(coordinates).distance_to(Vector2(center)) / center.x
