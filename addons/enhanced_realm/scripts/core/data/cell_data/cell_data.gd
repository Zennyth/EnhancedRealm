@tool
@icon("res://addons/enhanced_realm/icons/icons8-syringe-24.png")
extends Resource
class_name CellData

func get_exported_properties() -> Array[Dictionary]:
    return []



func is_valid(_cell: GridCell2D) -> bool:
    return false

func apply(_cell: GridCell2D) -> void:
    pass

func create_data() -> Dictionary:
    return {}