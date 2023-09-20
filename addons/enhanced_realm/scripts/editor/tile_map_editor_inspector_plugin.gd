extends EnhancedEditorInspectorPlugin

const TileMapEditorInspector = preload("res://addons/enhanced_realm/scripts/editor/tile_map_editor_inspector.gd")
const TileMapEditorInspectorPackedScene = preload("res://addons/enhanced_realm/scenes/editor/TileMapEditorInspector.tscn")

func _can_handle(object: Object) -> bool:
	return object is TileRealmInstance

const HANDLED_PROPERTIES: Array[String] = ["layer", "terrain_set", "terrain", "source", "atlas_coordinates"]

var selection: EditorSelection

func initialize(_selection: EditorSelection) -> void:
	selection = _selection



func _parse_property(object: Object, type: Variant.Type, name: String, hint_type: PropertyHint, hint_string: String, usage_flags: int, wide: bool) -> bool:
	if HANDLED_PROPERTIES.has(name):
		var editor: TileMapEditorInspector = TileMapEditorInspectorPackedScene.instantiate()
		editor.initialize(object, name, get_options(object, name))
		add_custom_editor_inspector_container(name, editor)
		return true

	return false



func get_options(object: Object, name: String) -> Array[Dictionary]:
	var options: Array[Dictionary] = []

	var tile_map: TileMap = object.tile_map

	if tile_map == null:
		var selected_nodes: Array[Node] = selection.get_selected_nodes()
		if selected_nodes.is_empty() or !(selected_nodes[0] is Realm2D):
			return options
		
		selected_nodes[0].initialize_tasks()

	if name == "layer":
		for i in tile_map.get_layers_count():
			var layer_name: String = tile_map.get_layer_name(i)
			options.append({ "name": layer_name if layer_name != "" else "Default", "value": i })
			
	if name == "terrain_set":
		for i in tile_map.tile_set.get_terrain_sets_count():
			var terrain_set_name: String = "Terrain Set " + str(i)

			if tile_map.tile_set.get_terrains_count(i) == 1:
				terrain_set_name = tile_map.tile_set.get_terrain_name(i, 0)

			options.append({ "name": terrain_set_name, "value": i })
	
	if name == "terrain":
		for i in tile_map.tile_set.get_terrains_count(object.terrain_set):
			var terrain_name: String = tile_map.tile_set.get_terrain_name(object.terrain_set, i)
			options.append({ "name": terrain_name if terrain_name != "" else "Terrain " + str(i), "value": i })
	
	if name == "source":
		for i in tile_map.tile_set.get_source_count():
			var source_id: int = tile_map.tile_set.get_source_id(i)
			var source_name: String = str(source_id)

			if tile_map.tile_set.get_source(source_id).texture != null:
				source_name = tile_map.tile_set.get_source(source_id).texture.resource_path.get_file()

			options.append({ "name": source_name, "value": source_id })
	
	if name == "atlas_coordinates":
		var source := tile_map.tile_set.get_source(object.source)

		for i in source.get_tiles_count():
			var source_name: Vector2i = source.get_tile_id(i)
			options.append({ "name": str(source_name), "value": source_name })

	return options