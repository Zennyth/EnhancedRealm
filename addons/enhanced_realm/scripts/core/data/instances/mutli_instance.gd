@tool
@icon("res://addons/enhanced_realm/icons/icons8-ungroup-objects-24.png")
extends RealmInstance
class_name MultiRealmInstance

@export var instances: Array[RealmInstance] = []:
	set = set_instances

func set_instances(value) -> void:
	instances = value
	_initialize()


func initialize(_realm: Realm2D) -> void:
	super(_realm)
	_initialize()

func _initialize() -> void:
	for instance in instances:
		if instance == null:
			continue

		instance.initialize(realm)

func instantiate(coordinates: Array[Vector2i]) -> void:
	var chunks := chunck_random(coordinates, len(instances))

	for i in len(chunks):
		var chuncked_coordinates: Array[Vector2i]
		chuncked_coordinates.assign(chunks[i])
		instances[i].instantiate(chuncked_coordinates)