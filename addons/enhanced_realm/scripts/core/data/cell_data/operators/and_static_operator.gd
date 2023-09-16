@tool
@icon("res://addons/enhanced_realm/icons/icons8-ampersand-24.png")
extends CellData
class_name AndStaticOperator

@export var operator_1: CellData
@export var operator_2: CellData

func is_valid(cell: GridCell2D) -> bool:
    return operator_1.is_valid(cell) and operator_2.is_valid(cell)