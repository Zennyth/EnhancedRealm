@tool
@icon("res://addons/enhanced_realm/icons/icons8-settings-24.png")
extends Resource
class_name BeaconGeneratorSettings

@export var max_failed_attempt: int = 100
@export var restrict: CellData
@export var cell_data: CellData