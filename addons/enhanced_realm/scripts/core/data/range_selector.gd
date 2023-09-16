@tool
@icon("res://addons/enhanced_realm/icons/icons8-slider-control-24.png")
extends Resource
class_name RangeSelector

###
# CORE
###
var realm: Realm2D

@export var instance: RealmInstance:
    set = set_instance

func set_instance(value) -> void:
    instance = value
    initialize(realm)
    

func initialize(_realm: Realm2D) -> void:
    realm = _realm

    if instance == null:
        return

    instance.initialize(realm)

func apply(coordinates: Array[Vector2i]) -> void:
    if instance == null:
        return

    instance.instantiate(coordinates)


@export_range(.0, 1.) var min: float = .0
@export_range(.0, 1.) var max: float = .7

func is_in_range(value: float) -> bool:
    return value >= min and value <= max