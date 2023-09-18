@tool
@icon("res://examples/_shared/resources/cell_data/layout_cell_data.gd")
extends CellData
class_name LayoutCellData


var map: GridMap2D
var settings: LayoutModuleSettings

func _initialize() -> void:
	map = get_data(GridMap2D)
	settings = get_module(LayoutModuleSettings)


enum Mode {
	TRANSFORM_AUTOMATIC,
	TRANSFORM_MANUAL,
	RESTRIC
}

@export var mode: Mode = Mode.TRANSFORM_AUTOMATIC:
	set = set_mode

func set_mode(value) -> void:
	mode = value
	notify_property_list_changed()

func _get_property_list() -> Array[Dictionary]:
	var properties: Array[Dictionary] = []

	match mode:
		Mode.RESTRIC, Mode.TRANSFORM_MANUAL:
			properties.append({
				"name": "layout",
				"usage": PROPERTY_USAGE_DEFAULT,
				"type": TYPE_INT,
				"hint": TYPE_INT,
				"hint_string": str(Layout).replace("\"", "").replace("{", "").replace("}", "")
			})
			pass
		Mode.TRANSFORM_AUTOMATIC:
			properties.append({
				"name": "compute_walls",
				"usage": PROPERTY_USAGE_DEFAULT,
				"type": TYPE_BOOL,
			})

	return properties

func apply(cell: GridCell2D) -> void:
	apply_automatic(cell) if mode == Mode.TRANSFORM_AUTOMATIC else apply_manual(cell)



###
# TRANSFORM_AUTOMATIC
###
var compute_walls: bool = false

func apply_automatic(cell: GridCell2D) -> void:
	# if compute_walls:
	# 	var current_layout: Layout = cell.get_data("layout")
	# 	var is_walls: bool = map.get_neighbors(cell.coordinates).any(func(n: GridCell2D): return n.get_data("layout") != Layout.WALLS and n.get_data("layout") != current_layout)
	# 	return cell.set_data("layout", Layout.WALLS if is_walls else current_layout)

	cell.set_data("layout", Layout.FLOOR if (settings.path.is_valid(cell) or settings.poi.is_valid(cell)) else Layout.CEILLING)


###
# TRANSFORM_MANUAL, RESTRIC
###
enum Layout {
	FLOOR,
	WALLS,
	CEILLING,
}

var layout: Layout

func is_valid(cell: GridCell2D) -> bool:
	return cell.get_data("layout") == layout

func apply_manual(cell: GridCell2D) -> void:
	cell.set_data("layout", layout)

func create_data() -> Dictionary:
	return {}