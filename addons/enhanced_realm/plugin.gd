@tool
extends EditorPlugin

const TileMapEditorInspectorPlugin = preload("res://addons/enhanced_realm/scripts/editor/tile_map_editor_inspector_plugin.gd")
var tile_map_editor_inspector_plugin: TileMapEditorInspectorPlugin
const PoiConfigurationEditorInspectorPlugin = preload("res://addons/enhanced_realm/scripts/editor/data/poi/configuration/poi_configuration_editor_inspector_plugin.gd")
var poi_configuration_editor_inspector_plugin: PoiConfigurationEditorInspectorPlugin

var selection: EditorSelection
var realm: Realm2D

func _enter_tree():
	tile_map_editor_inspector_plugin = TileMapEditorInspectorPlugin.new()
	add_inspector_plugin(tile_map_editor_inspector_plugin)
	poi_configuration_editor_inspector_plugin = PoiConfigurationEditorInspectorPlugin.new()
	add_inspector_plugin(poi_configuration_editor_inspector_plugin)

	selection = get_editor_interface().get_selection()
	selection.selection_changed.connect(_on_selection_changed)
	_on_selection_changed()
	tile_map_editor_inspector_plugin.initialize(selection)

func _on_selection_changed() -> void:
	for selected_node in selection.get_selected_nodes():
		var new_realm: Realm2D = NodeUtils.find_node(selected_node, Realm2D) if not selected_node is Realm2D else selected_node
		

		if new_realm != null:
			realm = new_realm
			poi_configuration_editor_inspector_plugin.current_realm = realm
	

func _exit_tree():
	selection.selection_changed.disconnect(_on_selection_changed)

	remove_inspector_plugin(tile_map_editor_inspector_plugin)
	remove_inspector_plugin(poi_configuration_editor_inspector_plugin)