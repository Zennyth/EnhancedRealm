@tool
@icon("res://addons/enhanced_realm/icons/icons8-exclamation-24.png")
extends CellData
class_name NotOperator

@export var operator: CellData

func is_valid(cell: GridCell2D) -> bool:
    return not operator.is_valid(cell)