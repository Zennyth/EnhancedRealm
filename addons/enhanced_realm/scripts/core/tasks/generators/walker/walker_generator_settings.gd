@tool
@icon("res://addons/enhanced_realm/icons/icons8-settings-24.png")
extends Resource
class_name WalkerGeneratorSettings

## Settings for [WalkerGenerator]

enum FullnessCheck {
	TILE_AMOUNT, ## Restricts the generation to a predetermined amount of floor tiles.
	PERCENTAGE ## Restricts the generation to a percentage of the [param world size]. Automatically sets Constrain World Size to true if set to this mode.
}

## The type of check to stop the generation.
@export var fullness_check: FullnessCheck:
	set(value):
		fullness_check = value
		if fullness_check == FullnessCheck.PERCENTAGE:
			constrain_world_size = true
		notify_property_list_changed()
## Modifiers can change stuff about your generation. They can be used to
## generate walls, smooth out terrain, etc.
@export_group("Walkers")
## The amount of walkers that can be active at the same time.[br]
## [b]Walkers[/b] move in random directions and place floor tiles where they walk.
## They are the foundation of this type of generation.
@export var max_walkers = 5
## The chance for a walker to change direction. Lower chances mean
## tighter hallways.
@export var new_dir_chance = 0.5
## The chance for a walker to spawn a new walker.
@export var new_walker_chance = 0.05
## The chance for a walker to be destroyed (won't happen
## if there's only one walker in the scene)
@export var destroy_walker_chance = 0.05

@export_group("")

## Maximum amount of floor tiles.
var max_tiles := 150
## Maximum percentage of the [param world_size] to be filled with floors.
var fullness_percentage := 0.2
## Can't be [code]false[/code] if [param Fullness Check] is on [b]Percentage[/b] mode.
var constrain_world_size : bool = false :
	set(value):
		if fullness_check == FullnessCheck.PERCENTAGE and value == false:
			return
		constrain_world_size = value
		notify_property_list_changed()


func _get_property_list() -> Array[Dictionary]:
	var properties : Array[Dictionary]
	match fullness_check:
		FullnessCheck.TILE_AMOUNT:
			properties.append({
				"name": "max_tiles",
				"usage": PROPERTY_USAGE_DEFAULT,
				"type": TYPE_INT,
			})
		FullnessCheck.PERCENTAGE:
			properties.append({
				"name": "fullness_percentage",
				"usage": PROPERTY_USAGE_DEFAULT,
				"type": TYPE_FLOAT,
				"hint": PROPERTY_HINT_RANGE,
				"hint_string": "0.0, 1.0"
			})
	properties.append(
		{
			"name": "constrain_world_size",
			"usage": PROPERTY_USAGE_DEFAULT,
			"type": TYPE_BOOL
		}
	)
	
	return properties