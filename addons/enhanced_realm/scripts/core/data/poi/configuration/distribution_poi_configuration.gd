@tool
extends PoiConfiguration
class_name DistributionPoiConfiguration

@export var number: int = 1

func get_pois() -> Array[Poi]:
	var pois: Array[Poi] = []

	for i in range(number):
		pois.append(Poi.new(template))
	
	return pois