@tool
extends EditorPlugin

const GroupEditorInspectorPlugin = preload("res://addons/enhanced_realm/scripts/editor/tasks/groups/group_editor_inspector_plugin.gd")
var group_editor_inspector_plugin: GroupEditorInspectorPlugin
const TileMapEditorInspectorPlugin = preload("res://addons/enhanced_realm/scripts/editor/tile_map_editor_inspector_plugin.gd")
var tile_map_editor_inspector_plugin: TileMapEditorInspectorPlugin
const PoiConfigurationEditorInspectorPlugin = preload("res://addons/enhanced_realm/scripts/editor/data/poi/configuration/poi_configuration_editor_inspector_plugin.gd")
var poi_configuration_editor_inspector_plugin: PoiConfigurationEditorInspectorPlugin

var selection: EditorSelection


func _enter_tree():
	group_editor_inspector_plugin = GroupEditorInspectorPlugin.new()
	add_inspector_plugin(group_editor_inspector_plugin)
	tile_map_editor_inspector_plugin = TileMapEditorInspectorPlugin.new()
	add_inspector_plugin(tile_map_editor_inspector_plugin)
	poi_configuration_editor_inspector_plugin = PoiConfigurationEditorInspectorPlugin.new()
	add_inspector_plugin(poi_configuration_editor_inspector_plugin)

	selection = get_editor_interface().get_selection()
	selection.selection_changed.connect(_on_selection_changed)

func _exit_tree():
	remove_inspector_plugin(group_editor_inspector_plugin)
	remove_inspector_plugin(tile_map_editor_inspector_plugin)
	remove_inspector_plugin(poi_configuration_editor_inspector_plugin)





###
# Editor
###
func _on_selection_changed() -> void:
	if selection.get_selected_nodes().is_empty():
		return

	var selected_node = selection.get_selected_nodes()[0]

	if not selected_node is Realm2D:
		return
	
	selected_node.initialize_tasks()
	poi_configuration_editor_inspector_plugin.current_realm = selected_node
	await get_tree().create_timer(.25).timeout

	var inspector: EditorInspector = get_editor_interface().get_inspector()
	var properties_container = inspector.get_node("@VBoxContainer@5444")
	var realm = properties_container.get_children()[1]
	
	# Tasks
	var tasks_properties = realm.get_children()[4]
	initialize_custom_properties(tasks_properties, selected_node, "tasks")

	# PoiTemplates
	var settings_properties = realm.get_children()[3]
	var settings_properties_button: Button = settings_properties.get_child(0).get_child(0)
	SignalUtils.connect_if_not_connected(settings_properties_button.pressed, initialize_poi_templates.bind(settings_properties, selected_node))

func initialize_custom_properties(container: Control, object_owner: Object, property: String) -> void:
	var object_button: Button = container.get_child(0)
	SignalUtils.connect_if_not_connected(object_button.pressed, generate_object_properties.bind(container, object_owner, property))
	SignalUtils.connect_if_not_connected(object_owner.property_list_changed, _on_selection_changed)
	generate_object_properties(container, object_owner, property)

func generate_object_properties(objects_properties: Control, object_owner: Object, property: String) -> void:
	if objects_properties.get_child_count() < 3:
		return

	var array_properties = objects_properties.get_children()[2].get_children()[0].get_children()[1]
	var editor_property_resources = []

	for editor_property_resource in array_properties.get_children():
		editor_property_resources.append(editor_property_resource.get_child(1))
	

	var objects: Array = object_owner.get(property)

	for i in len(editor_property_resources):
		if len(objects) <= i:
			break
		
		var editor_resource_picker = editor_property_resources[i].get_child(0)
		var object = objects[i]

		if object == null:
			continue
		
		var button: Button = editor_resource_picker.get_child(0)

		if "name" in object and object.name != null and object.name != "":
			button.text = object.name
		
		if "icon" in object and object.icon != null:
			button.icon = object.icon
		
		SignalUtils.connect_if_not_connected(button.pressed, generate_object_properties.bind(objects_properties, object_owner, property))

		if object is GroupRealmTask:
			if editor_property_resources[i].get_child_count() > 1:
				var new_container: Control = editor_property_resources[i].get_child(1).get_child(0).get_child(0).get_child(0).get_child(0)
				initialize_custom_properties(new_container, object, property)


func initialize_poi_templates(settings_properties: Control, object_owner: Object) -> void:
	if settings_properties.get_child_count() <= 1 or object_owner.settings == null:
		return
	
	var new_container: Control = settings_properties.get_child(1).get_child(0).get_child(0).get_child(0).get_child(0)
	initialize_custom_properties(new_container, object_owner.settings, "poi_templates")