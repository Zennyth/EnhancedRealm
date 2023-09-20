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
			var icon: Texture2D
			
			if tile_map.tile_set.get_terrains_count(i) == 1:
				terrain_set_name = tile_map.tile_set.get_terrain_name(i, 0)

				for x in tile_map.tile_set.get_source_count():
					var source_id: int = tile_map.tile_set.get_source_id(x)
					var source: TileSetSource = tile_map.tile_set.get_source(source_id)
					
					for y in source.get_tiles_count():
						var source_name: Vector2i = source.get_tile_id(y)
						var data: TileData = source.get_tile_data(source_name, 0)

						if data.terrain_set == i and data.terrain == 0:
							var source_image: Image = source.get_runtime_texture().get_image()
							var recti: Rect2i = source.get_runtime_tile_texture_region(source_name, 0)
							var image: Image = Image.create(recti.size.x, recti.size.y, true, source_image.get_format())
							image.blit_rect(source_image, recti, Vector2i.ZERO)
							image.resize(20, 20)
							icon = ImageTexture.create_from_image(image)
							break

			options.append({ "name": terrain_set_name, "value": i, "icon": icon })
	
	if name == "terrain":
		for i in tile_map.tile_set.get_terrains_count(object.terrain_set):
			var terrain_name: String = tile_map.tile_set.get_terrain_name(object.terrain_set, i)
			if terrain_name == "":
				terrain_name = "Terrain " + str(i)
			
			var icon: Texture2D
			
			for x in tile_map.tile_set.get_source_count():
				var source_id: int = tile_map.tile_set.get_source_id(x)
				var source: TileSetSource = tile_map.tile_set.get_source(source_id)
				
				for y in source.get_tiles_count():
					var source_name: Vector2i = source.get_tile_id(y)
					var data: TileData = source.get_tile_data(source_name, 0)

					if data.terrain == i and data.terrain_set == object.terrain_set:
						var source_image: Image = source.get_runtime_texture().get_image()
						var recti: Rect2i = source.get_runtime_tile_texture_region(source_name, 0)
						var image: Image = Image.create(recti.size.x, recti.size.y, true, source_image.get_format())
						image.blit_rect(source_image, recti, Vector2i.ZERO)
						image.resize(20, 20)
						icon = ImageTexture.create_from_image(image)
						break
				
				if icon != null:
					break
					

			options.append({ "name": terrain_name, "value": i, "icon": icon })
	
	if name == "source":
		for i in tile_map.tile_set.get_source_count():
			var source_id: int = tile_map.tile_set.get_source_id(i)
			var source_name: String = str(source_id)
			var icon: Texture2D

			if tile_map.tile_set.get_source(source_id).texture != null:
				source_name = tile_map.tile_set.get_source(source_id).texture.resource_path.get_file()
				var image: Image = Image.new()
				image.copy_from(tile_map.tile_set.get_source(source_id).get_runtime_texture().get_image())
				image.resize(20, 20)
				icon = ImageTexture.create_from_image(image)
			
			options.append({ "name": source_name, "value": source_id, "icon": icon })
	
	if name == "atlas_coordinates":
		var source: TileSetSource = tile_map.tile_set.get_source(object.source)
		var source_image: Image = source.get_runtime_texture().get_image()

		for i in source.get_tiles_count():
			var source_name: Vector2i = source.get_tile_id(i)
			var recti: Rect2i = source.get_runtime_tile_texture_region(source_name, 0)

			var icon: Image = Image.create(recti.size.x, recti.size.y, true, source_image.get_format())
			icon.blit_rect(source_image, recti, Vector2i.ZERO)
			icon.resize(20, 20)
	
			options.append({ "name": str(source_name), "value": source_name, "icon": ImageTexture.create_from_image(icon) })

	return options