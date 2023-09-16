@tool
extends RefCounted
class_name GridMap2D

var size: Vector2i

# cells: Dictionary[Vector2i, GridCell2D]
var cells: Dictionary

func _init(_size: Vector2i) -> void:
	size = _size
	cells = {}

func has_cell(coordinates: Vector2i) -> bool:
	return coordinates in cells

func get_cell(coordinates: Vector2i) -> GridCell2D:
	return cells[coordinates] if has_cell(coordinates) else null

func get_cell_list() -> Array[GridCell2D]:
	var list: Array[GridCell2D] = []

	for c in cells.values():
		if c == null:
			continue
		
		list.append(c as GridCell2D)

	return list

func get_neighbors(coordinates: Vector2i) -> Array[GridCell2D]:
	var list: Array[GridCell2D] = []

	for x in range(-1, 2):
		for y in range(-1, 2):
			if not has_cell(coordinates + Vector2i(x, y)) or (x == 0 and y == 0):
				continue
			
			list.append(get_cell(coordinates + Vector2i(x, y)))
	
	return list

func get_side_neighbors(coordinates: Vector2i) -> Array[GridCell2D]:
	var list: Array[GridCell2D] = []

	for side_coordinates in [Vector2i(1, 0), Vector2i(-1, 0), Vector2i(0, 1), Vector2i(0, -1)]:
		if not has_cell(coordinates + side_coordinates):
			continue
		
		list.append(get_cell(coordinates + side_coordinates))
	
	return list
			
func get_corner_neighbors(coordinates: Vector2i) -> Array[GridCell2D]:
	var list: Array[GridCell2D] = []

	for side_coordinates in [Vector2i(1, 1), Vector2i(-1, 1), Vector2i(1, -1), Vector2i(-1, -1)]:
		if not has_cell(coordinates + side_coordinates):
			continue
		
		list.append(get_cell(coordinates + side_coordinates))
	
	return list



func set_cell(cell: GridCell2D) -> void:
	cells[cell.coordinates] = cell

func clear_cells() -> void:
	cells = {}


var center: Vector2i:
	get = get_center

func get_center() -> Vector2i:
	return size / 2

###
# Utils
###

####
## Coordinates
####

func is_inside_circle(center: Vector2i, radius: int, cell_coordinates: Vector2i) -> bool:
	var d: int = (center - cell_coordinates).length_squared()
	return d <= pow(radius, 2)

func get_round_region_coordinates(center: Vector2i, radius: int) -> Array[Vector2i]:
	var coordinates_list: Array[Vector2i] = []

	for x in range(center.x - radius, center.x + radius + 1):
		for y in range(center.y - radius, center.y + radius + 1):
			var coordinates: Vector2i = Vector2i(x, y)

			if !is_inside_circle(center, radius, coordinates):
				continue
			
			coordinates_list.append(coordinates)
	
	return coordinates_list

func get_rectangle_region_coordinates(center: Vector2i, size: Vector2i) -> Array[Vector2i]:
	var coordinates_list: Array[Vector2i] = []

	var offest_x: int = floor(size.x / 2) if size.x % 2 == 0 else floor(size.x / 2) + 1
	var offest_y: int = floor(size.y / 2)

	for x in range(center.x - offest_x, center.x + (offest_x if size.x % 2 == 0 else offest_x + 1)):
		for y in range(center.y - offest_y, center.y + (offest_y if size.y % 2 == 0 else offest_y + 1)):		
			coordinates_list.append(Vector2i(x, y))
	
	return coordinates_list

func get_line_region_coordinates(c0: Vector2i, c1: Vector2i) -> Array[Vector2i]:
	var d: Vector2i = c1 - c0
	var n: Vector2i = abs(d)
	var sign: Vector2i = Vector2i(1 if d.x > 0 else -1, 1 if d.y > 0 else -1)
	
	var c = Vector2i(c0);
	var coordinates_list: Array[Vector2i] = [Vector2i(c)]

	var ix = 0
	var iy = 0

	while ix < n.x or iy < n.y:
		var decision: int = (1 + 2*ix) * n.y - (1 + 2*iy) * n.x

		if decision == 0:
			c.x += sign.x
			c.y += sign.y
			ix+=1
			iy+=1
		elif decision < 0:
			c.x += sign.x
			ix+=1
		else:
			c.y += sign.y
			iy+=1
		
		#TODO: do this better
		for x in range(-2, 3):
			for y in range(-2, 3):
				coordinates_list.append(Vector2i(c) + Vector2i(x, y));

	return coordinates_list


####
## Cells
####

func get_cell_creation_method(get_data: Callable = func(): return {}) -> Callable:
	var create_cell: Callable = func(coordinates: Vector2i) -> GridCell2D:
		return GridCell2D.new(coordinates, get_data.call() if get_data != null else null)
	
	return create_cell

func get_round_region_cells(center: Vector2i, radius: int) -> Array[GridCell2D]:
	var cell_list: Array[GridCell2D] = []

	for coordinates in get_round_region_coordinates(center, radius): 
		if has_cell(coordinates):
			cell_list.append(get_cell(coordinates))
	
	return cell_list

func get_rectangle_region_cells(center: Vector2i, size: Vector2i) -> Array[GridCell2D]:
	var cell_list: Array[GridCell2D] = []

	for coordinates in get_rectangle_region_coordinates(center, size): 
		if has_cell(coordinates):
			cell_list.append(get_cell(coordinates))
	
	return cell_list

func get_line_region_cells(start: GridCell2D, goal: GridCell2D) -> Array[GridCell2D]:
	var cell_list: Array[GridCell2D] = []

	for coordinates in get_line_region_coordinates(start.coordinates, goal.coordinates): 
		if has_cell(coordinates):
			cell_list.append(get_cell(coordinates))
	
	return cell_list

####
## Fill
####

func fill_region(top_left: Vector2i, bottom_right: Vector2i, create: Callable) -> void:
	for x in range(top_left.x, bottom_right.x):
		for y in range(top_left.y, bottom_right.y):
			set_cell(create.call(Vector2i(x, y)))

func fill(create: Callable) -> void:
	fill_region(Vector2i.ZERO, size, create)

func fill_round_region(center: Vector2i, radius: int, create: Callable) -> void:
	for coordinates in get_round_region_coordinates(center, radius):
		set_cell(create.call(coordinates))