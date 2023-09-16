@tool
extends OptionButton


var object: Object
var property: String
var items: Array[Dictionary]

func initialize(_object: Object, _property: String, _items: Array[Dictionary]) -> void:
	object = _object
	property = _property
	items = _items



func _ready() -> void:
	item_selected.connect(_on_item_selected)

	for i in len(items):
		var item := items[i]
		add_item(item.name)

		if object.get(property) == item.value:
			select(i)
			_on_item_selected(i)
		
	if selected <= 0:
		select(0)
		_on_item_selected(0)




func _on_item_selected(index: int) -> void:
	object.set(property, items[index].value)