extends EnhancedEditorInspectorPlugin

const PoiConfigurationEditorInspector = preload("res://addons/enhanced_realm/scripts/editor/data/poi/configuration/poi_configuration_editor_inspector.gd")

func _can_handle(object: Object) -> bool:
	return object is PoiConfiguration


var current_realm: Realm2D

func _parse_property(object: Object, type: Variant.Type, name: String, hint_type: PropertyHint, hint_string: String, usage_flags: int, wide: bool) -> bool:
	if name == "template_name" and current_realm != null:
		var editor: PoiConfigurationEditorInspector = PoiConfigurationEditorInspector.new()
		editor.initialize(object, current_realm.settings.poi_templates)
		add_custom_editor_inspector_container("Template Name", editor)
		return true

	return false