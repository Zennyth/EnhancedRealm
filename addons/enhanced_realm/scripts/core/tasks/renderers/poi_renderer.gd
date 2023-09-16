@tool
@icon("res://addons/enhanced_realm/icons/icons8-location-24.png")
extends RealmTask
class_name PoiRendererRealmTask

func execute() -> void:
	var pois: Array[Poi] = get_data_by_key("pois")
	var map: Dictionary = {}

	for poi in pois:
		if !map.has(poi.template):
			map[poi.template] = []

		map[poi.template].append(poi.coordinates)
	
	for template in map.keys():
		if template.instance == null:
			continue

		template.instance.initialize(realm)
		var coordinates: Array[Vector2i]
		coordinates.assign(map[template])
		template.instance.instantiate(coordinates)
	