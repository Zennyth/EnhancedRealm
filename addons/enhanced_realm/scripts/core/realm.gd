@tool
@icon("res://addons/enhanced_realm/icons/icons8-world-24.png")
extends Node2D
class_name Realm2D

signal finished


@export var generate: bool = false:
	set = set_generate

func set_generate(_value) -> void:
	generate = false
	start_generation()

func _ready() -> void:
	initialize_tasks()


@export var tile_map: TileMap
@export var entities: Node2D


###
# SETTINGS
###
@export var settings: RealmSettings = RealmSettings.new()


###
# TASKS
###
var data: Dictionary

@export var tasks: Array[RealmTask] = []:
	set = set_tasks

func set_tasks(_tasks: Array[RealmTask]) -> void:	
	tasks = _tasks
	initialize_tasks()
	notify_property_list_changed()

func initialize_tasks(_tasks: Array[RealmTask] = tasks, group_level: int = 0) -> void:
	for task in _tasks.filter(func(task): return task != null):
		task.initialize(self, group_level)



func start_generation() -> void:
	for task in tasks:
		execute_task(task)
	
	finished.emit()

func execute_task(task: RealmTask) -> void:
	if task.skip:
		return

	task.initialize(self, task.group_level)
	
	var time := Time.get_ticks_msec()
	task.execute()
	
	if settings.log and not task is GroupRealmTask:
		print_debug(task.log_task(time))


###
# INSTANCING
###
func instantiate(node: Node) -> void:	
	entities.add_child(node, settings.multiplayer_support)
	
	if Engine.is_editor_hint():
		node.owner = entities.get_tree().edited_scene_root