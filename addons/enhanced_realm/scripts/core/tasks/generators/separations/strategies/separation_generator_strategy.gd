@tool
@icon("res://addons/enhanced_realm/icons/icons8-settings-24.png")
extends Resource
class_name SeparationGeneratorStrategy

func is_separating(cell: GridCell2D, map: GridMap2D, boundary: CellData, transformer: CellData) -> bool:
    return false