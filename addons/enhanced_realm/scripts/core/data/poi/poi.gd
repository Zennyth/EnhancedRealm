extends RefCounted
class_name Poi


## Center coordinates
var coordinates: Vector2i = Vector2i.ZERO
var cells: Array[GridCell2D] = []
var paths: Array[Path] = []
var template: PoiTemplate


func _init(_template: PoiTemplate) -> void:
	template = _template

func add_path(path: Path) -> void:
	paths.append(path)



func get_area_coordinates(map: GridMap2D) -> Array[Vector2i]:
	if template.shape == PoiTemplate.Shape.CIRCLE:
		return map.get_round_region_coordinates(coordinates, template.radius)
	
	elif template.shape == PoiTemplate.Shape.RECTANGLE:
		return map.get_rectangle_region_coordinates(coordinates, template.size)

	return []

func get_area_cells(map: GridMap2D) -> Array[GridCell2D]:
	if template.shape == PoiTemplate.Shape.CIRCLE:
		return map.get_round_region_cells(coordinates, template.radius)
	
	elif template.shape == PoiTemplate.Shape.RECTANGLE:
		return map.get_rectangle_region_cells(coordinates, template.size)

	return []