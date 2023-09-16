@tool
extends OptionButton


var object: Object
var items: Array[PoiTemplate]

func initialize(_object: PoiConfiguration, _items: Array[PoiTemplate]) -> void:
	object = _object
	items = _items



func _ready() -> void:
	item_selected.connect(_on_item_selected)

	for i in len(items):
		var item := items[i]
		add_item(item.name)

		if object.template_name == item.name:
			_on_item_selected(i)
		
	if selected <= 0:
		_on_item_selected(0)




func _on_item_selected(index: int) -> void:
	if items.is_empty():
		return

	object.template_name = items[index].name
	object.template = items[index]
	select(index)