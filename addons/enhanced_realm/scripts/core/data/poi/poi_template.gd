@tool
@icon("res://addons/enhanced_realm/icons/icons8-location-24.png")
extends Resource
class_name PoiTemplate


@export var name: String = "Poi"
@export var instance: RealmInstance


enum Shape {
	CIRCLE,
	RECTANGLE,
}

@export var shape: Shape = Shape.RECTANGLE:
	set = set_shape
## Circle Shape
var radius: int = 15
## Rectangle Shape
var size: Vector2i = Vector2i.ZERO


###
# Core
###
func get_poi() -> Poi:
	return Poi.new(self)

###
# Editor
###
func set_shape(value) -> void:
	shape = value
	notify_property_list_changed()

func _get_property_list() -> Array[Dictionary]:
	var properties : Array[Dictionary]

	match shape:
		Shape.CIRCLE:
			properties.append({
				"name": "radius",
				"usage": PROPERTY_USAGE_DEFAULT,
				"type": TYPE_INT,
			})
		Shape.RECTANGLE:
			properties.append({
				"name": "size",
				"usage": PROPERTY_USAGE_DEFAULT,
				"type": TYPE_VECTOR2I,
			})

	return properties