@tool
@icon("res://addons/enhanced_realm/icons/icons8-path-24.png")
extends GeneratorRealmTask
class_name PathBetweenPoiGenerator

@export var transformer: CellData

func execute() -> void:
	var map: GridMap2D = get_data(GridMap2D)
	var pois: Array[Poi] = get_data_by_key("pois")
	var paths: Array[Path] = []

	pois.assign(shuffle(pois))

	for i in range(1, len(pois)):
		var previous_poi: Poi = pois[i-1]
		var poi: Poi = pois[i]

		var cells := map.get_line_region_cells(
			map.get_cell(previous_poi.coordinates),
			map.get_cell(poi.coordinates),
		)

		var path: Path = Path.new([previous_poi, poi], cells)
		paths.append(path)

		for cell in cells:
			transformer.apply(cell)
	
	set_data("paths", paths)