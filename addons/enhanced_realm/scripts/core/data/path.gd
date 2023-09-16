extends RefCounted
class_name Path

var cells: Array[GridCell2D]
var pois: Array[Poi]

func _init(_pois: Array[Poi]  = [], _cells: Array[GridCell2D] = []) -> void:
	cells = _cells
	pois = _pois

	for poi in pois:
		poi.add_path(self)