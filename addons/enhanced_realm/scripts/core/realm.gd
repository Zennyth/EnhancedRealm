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

	if settings.generate_on_ready:
		start_generation()


@export var tile_map: TileMap
@export var entities: Node2D


###
# SETTINGS
###
@export var settings: RealmSettings = RealmSettings.new()


###
# TASKS
###
@export var task: GroupRealmTask = GroupRealmTask.new():
	set = set_task

func set_task(_task: GroupRealmTask) -> void:	
	task = _task
	initialize_tasks(_task.tasks)
	notify_property_list_changed()



func initialize_tasks(_tasks: Array[RealmTask] = task.tasks, group_level: int = 0) -> void:
	for task in _tasks.filter(func(task): return task != null):
		task.initialize(self, group_level)



func start_generation() -> void:
	execute_task(task)
	finished.emit()

func execute_task(task: RealmTask) -> void:
	if task.skip:
		return

	task.initialize(self, task.group_level)
	
	var time := Time.get_ticks_msec()
	task.execute()
	
	if settings.log:
		print_debug(task.log_task(time))


###
# DATA
###
var data: Dictionary

func get_data_by_key(key: String) -> Variant:
	return data[key]

func get_data(type: Variant) -> Variant:
	for data in data.values():
		if is_instance_of(data, type):
			return data
	
	return null

func set_data(key: String, _data: Variant) -> void:
	data[key] = _data


###
# INSTANCING
###
func instantiate(node: Node) -> void:	
	entities.add_child(node, settings.multiplayer_support)
	
	if Engine.is_editor_hint():
		node.owner = entities.get_tree().edited_scene_root