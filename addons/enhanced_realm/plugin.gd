@tool
extends EditorPlugin

const TileMapEditorInspectorPlugin = preload("res://addons/enhanced_realm/scripts/editor/tile_map_editor_inspector_plugin.gd")
var tile_map_editor_inspector_plugin: TileMapEditorInspectorPlugin
const PoiConfigurationEditorInspectorPlugin = preload("res://addons/enhanced_realm/scripts/editor/data/poi/configuration/poi_configuration_editor_inspector_plugin.gd")
var poi_configuration_editor_inspector_plugin: PoiConfigurationEditorInspectorPlugin


func _enter_tree():
	tile_map_editor_inspector_plugin = TileMapEditorInspectorPlugin.new()
	add_inspector_plugin(tile_map_editor_inspector_plugin)
	poi_configuration_editor_inspector_plugin = PoiConfigurationEditorInspectorPlugin.new()
	add_inspector_plugin(poi_configuration_editor_inspector_plugin)

func _exit_tree():
	remove_inspector_plugin(tile_map_editor_inspector_plugin)
	remove_inspector_plugin(poi_configuration_editor_inspector_plugin)