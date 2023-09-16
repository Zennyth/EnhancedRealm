@tool
@icon("res://addons/enhanced_realm/icons/icons8-dice-24.png")
extends InitializationRealmTask
class_name RNGInitialization

@export var use_random_seed: bool = false
@export var seed: String = Guid.v4()

func execute() -> void:
	var new_rng = RandomNumberGenerator.new()
	new_rng.seed = hash(Guid.v4() if use_random_seed else seed) 
	set_data("rng", new_rng)
