@tool
@icon("res://addons/enhanced_realm/icons/icons8-world-24 (1).png")
extends Resource
class_name RealmSettings

@export var poi_templates: Array[PoiTemplate] = []
@export var multiplayer_support: bool = true
@export var log: bool = false