@tool
@icon("res://addons/enhanced_realm/icons/icons8-folder-24.png")
extends RealmTask
class_name GroupRealmTask

@export var tasks: Array[RealmTask] = []:
	set = set_tasks


func _initialize() -> void:
	realm.initialize_tasks(tasks, group_level + 1)

func execute() -> void:
	var debug := ""
	var group_time := Time.get_ticks_msec()

	for task in tasks:
		if task.skip:
			return
	
		task.initialize(realm, task.group_level + 1)
		
		var time := Time.get_ticks_msec()
		task.execute()
		
		if realm.settings.log:
			debug += task.log_task(time) + "\n"
	
	if realm.settings.log:
		print_debug(log_task(group_time) + "\n" + debug.erase(debug.length() - 1, 1))




func set_tasks(_tasks: Array[RealmTask]) -> void:	
	tasks = _tasks
	notify_property_list_changed()