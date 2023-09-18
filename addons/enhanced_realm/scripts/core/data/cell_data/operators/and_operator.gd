@tool
@icon("res://addons/enhanced_realm/icons/icons8-ampersand-24.png")
extends CellData
class_name AndOperator

@export var operators: Array[CellData] = []

func is_valid(cell: GridCell2D) -> bool:
    return operators.all(func(operator: CellData): return operator.is_valid(cell))

func apply(cell: GridCell2D) -> void:
    for operator in operators:
        operator.apply(cell)