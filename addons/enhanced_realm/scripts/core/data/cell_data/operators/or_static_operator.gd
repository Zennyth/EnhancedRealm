@tool
@icon("res://addons/enhanced_realm/icons/icons8-pause-24.png")
extends CellData
class_name OrStaticOperator

@export var operator_1: CellData
@export var operator_2: CellData

func is_valid(cell: GridCell2D) -> bool:
    return operator_1.is_valid(cell) or operator_2.is_valid(cell)