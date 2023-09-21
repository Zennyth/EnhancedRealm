@tool
@icon("res://addons/enhanced_realm/icons/icons8-path-24 (1).png")
extends CellData
class_name PathCellData

@export var is_path: bool

func is_valid(cell: GridCell2D) -> bool:
    return cell.get_boolean_data("is_path") == is_path

func apply(cell: GridCell2D) -> void:
    cell.set_data("is_path", is_path)

func create_data() -> Dictionary:
    return {
        "is_path": is_path
    }
