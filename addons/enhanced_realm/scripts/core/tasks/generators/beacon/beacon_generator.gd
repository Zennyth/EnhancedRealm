@tool
@icon("res://addons/enhanced_realm/icons/icons8-preloader-24.png")
extends GeneratorRealmTask
class_name BeaconGenerator

@export var restrict: CellData
@export var transformer: CellData
@export var settings: BeaconGeneratorSettings
@export var poi_configurations: Array[DistributionPoiConfiguration] = []


func execute() -> void:
	var map: GridMap2D = get_data(GridMap2D)
	var radius: int = get_data_by_key("radius")

	var pois: Array[Poi] = _get_all_pois()
	var poi_to_remove: Array[Poi] = []
	var pois_length: int = len(pois)

	var direction: int = rng.randi_range(1, 360)
	var increment: float = 360 / float(pois_length)

	for i in pois_length:
		var poi: Poi = pois[i]
		
		var check: bool = false
		
		var distance: float
		var direction_modifier: int
		var coordinates: Vector2i
		var cells: Array[GridCell2D] = []
		var attempt: int = 0

		while check == false:
			distance = (radius - 4) * pow(rng.randf(), .5)
			direction_modifier = rng.randi_range(-15, 15)

			var computed_direction = deg_to_rad(direction + (i * increment) + direction_modifier)
			var distance_vector := Vector2(distance, distance)
			var direction_vector: Vector2 = distance_vector.rotated(computed_direction)

			coordinates = map.center + Vector2i(round(direction_vector.x), round(direction_vector.y))
			poi.coordinates = coordinates
			cells = poi.get_area_cells(map)
			attempt += 1

			if map.has_cell(coordinates) and cells.all(func(cell: GridCell2D): return restrict.is_valid(cell)):
				check = true
			
			if attempt > settings.max_failed_attempt:
				poi_to_remove.append(poi)
				break
		
		poi.coordinates = coordinates
		poi.cells = cells

		transformer.apply_cells(poi.cells)
	
	for poi in poi_to_remove:
		pois.erase(poi)
	
	set_data("pois", pois)


func _get_all_pois() -> Array[Poi]:
	var pois: Array[Poi] = []

	for configuration in poi_configurations:
		pois += configuration.get_pois()
	
	pois.assign(shuffle(pois))
	return pois