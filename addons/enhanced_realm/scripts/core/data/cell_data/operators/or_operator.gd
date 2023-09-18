@tool
@icon("res://addons/enhanced_realm/icons/icons8-pause-24.png")
extends CellData
class_name OrOperator

@export var operators: Array[CellData] = []

func is_valid(cell: GridCell2D) -> bool:
    return operators.any(func(operator: CellData): return operator.is_valid(cell))

func apply(cell: GridCell2D) -> void:
    for operator in operators:
        operator.apply(cell)