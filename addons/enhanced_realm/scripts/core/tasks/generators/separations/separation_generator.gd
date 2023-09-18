@tool
@icon("res://addons/enhanced_realm/icons/icons8-fence-24.png")
extends GeneratorRealmTask
class_name SeparationGenerator

@export var restrict: CellData
@export var boundary: CellData
@export var transformer: CellData

func execute() -> void:
    transformer.initialize(realm)

    var map: GridMap2D = get_data(GridMap2D)
    var cells: Array[GridCell2D] = map.get_cell_list()

    if restrict != null:
        cells = restrict.filter_cells(cells)
    
    for cell in cells:
        var boundary_type: bool = boundary.is_valid(cell)
        var is_boundary: bool = map.get_neighbors(cell.coordinates).any(func(n: GridCell2D): return !transformer.is_valid(n) and boundary.is_valid(n) != boundary_type)
        
        if is_boundary:
            transformer.apply(cell)
