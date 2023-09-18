@tool
extends SeparationGeneratorStrategy
class_name DifferentNeighboorSeparationGeneratorStrategy

func is_separating(cell: GridCell2D, map: GridMap2D, boundary: CellData, transformer: CellData) -> bool:
    var boundary_type: bool = boundary.is_valid(cell)
    return map.get_neighbors(cell.coordinates).any(func(n: GridCell2D): return !transformer.is_valid(n) and boundary.is_valid(n) != boundary_type)

