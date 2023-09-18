@tool
@icon("res://addons/enhanced_realm/icons/icons8-syringe-24.png")
extends Resource
class_name CellData

func get_exported_properties() -> Array[Dictionary]:
    return []


###
# INITIALIZATION
###
var realm: Realm2D

func initialize(_realm: Realm2D) -> void:
    realm = _realm
    _initialize()

func _initialize() -> void:
    pass

func get_data(type: Variant) -> Variant:
    for data in realm.data.values():
        if is_instance_of(data, type):
            return data
    
    return null

func get_module(type: Variant) -> Variant:
    for module in realm.settings.module_settings:
        if is_instance_of(module, type):
            return module
    
    return null


###
# RESTRICT
###
func is_valid(_cell: GridCell2D) -> bool:
    return false

func filter_cells(cells: Array[GridCell2D]) -> Array[GridCell2D]:
    return cells.filter(func(cell): return is_valid(cell))


###
# TRANSFORMER
###
func apply(_cell: GridCell2D) -> void:
    pass

func apply_cells(cells: Array[GridCell2D]) -> void:
    for cell in cells:
        apply(cell)


###
# FILL
###
func create_data() -> Dictionary:
    return {}