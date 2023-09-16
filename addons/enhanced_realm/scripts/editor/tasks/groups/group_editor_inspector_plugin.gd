extends EditorInspectorPlugin

const GroupEditorInspector = preload("res://addons/enhanced_realm/scripts/editor/tasks/groups/group_editor_inspector.gd")
const GroupEditorInspectorPackedScene = preload("res://addons/enhanced_realm/scenes/editor/tasks/groups/GroupEditorInspector.tscn")

func _can_handle(object: Object) -> bool:
	return object is Realm2D


func _parse_property(object: Object, type: Variant.Type, name: String, hint_type: PropertyHint, hint_string: String, usage_flags: int, wide: bool) -> bool:
	return false