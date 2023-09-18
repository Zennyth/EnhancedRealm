@tool
@icon("res://addons/enhanced_realm/icons/icons8-fence-24.png")
extends GeneratorRealmTask
class_name SeparationGenerator

@export var restrict: CellData
@export var boundary: CellData
@export var transformer: CellData
@export var separation_strategy: SeparationGeneratorStrategy

func execute() -> void:
    var map: GridMap2D = get_data(GridMap2D)
    var cells: Array[GridCell2D] = map.get_cell_list()

    if restrict != null:
        cells = restrict.filter_cells(cells)
    
    transformer.apply_cells(cells.filter(func(c: GridCell2D): return separation_strategy.is_separating(c, map, boundary, transformer)))
