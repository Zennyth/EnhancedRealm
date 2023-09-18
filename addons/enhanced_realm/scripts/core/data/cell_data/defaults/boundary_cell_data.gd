@tool
@icon("res://addons/enhanced_realm/icons/icons8-hexagon-24.png")
extends CellData
class_name BoundaryCellData

enum Boundary {
    OUT,
    IN
}

@export var boundary: Boundary




func is_valid(cell: GridCell2D) -> bool:
    return cell.get_data("boundary") == boundary

func apply(cell: GridCell2D) -> void:
    cell.set_data("boundary", boundary)

func create_data() -> Dictionary:
    return {
        "boundary": boundary
    }
