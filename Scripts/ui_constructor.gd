extends CanvasLayer

@export var _player : Zephyr
@export var _heart_ui: PackedScene

var _heart_ui_list: Array[HeartUI] = []

func _ready() -> void:
	construct(3)

func construct(heart_count: int) -> void:
	for i in range(heart_count):
		var position := Vector2(60.0, 60.0)
		var interval := Vector2(150.0, 0.0)
		var heart_ui = (_heart_ui.instantiate() as HeartUI)\
			.construct(position + interval * i)
		add_child(heart_ui)
		_heart_ui_list.append(heart_ui)
	
	_player.damaged.connect(_on_damaged)

func _on_damaged() -> void:
	if _heart_ui_list.is_empty():
		return
	else:
		var heart_ui := _heart_ui_list.pop_back() as HeartUI
		heart_ui.on_damaged()
