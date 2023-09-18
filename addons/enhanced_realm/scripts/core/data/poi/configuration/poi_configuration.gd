@tool
@icon("res://addons/enhanced_realm/icons/icons8-leaving-geo-fence-24.png")
extends Resource
class_name PoiConfiguration

@export var template_name: String
@export var template: PoiTemplate


###
# Editor
###
var name: String:
    get = get_name

func get_name() -> String:
    return template_name