@tool
@icon("res://addons/enhanced_realm/icons/icons8-location-24.png")
extends CellData
class_name PoiCellData

@export var is_poi: bool

func is_valid(cell: GridCell2D) -> bool:
    return cell.get_boolean_data("is_poi") == is_poi

func apply(cell: GridCell2D) -> void:
    cell.set_data("is_poi", is_poi)

func create_data() -> Dictionary:
    return {
        "is_poi": is_poi
    }
