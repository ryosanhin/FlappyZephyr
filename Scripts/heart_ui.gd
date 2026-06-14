extends TextureRect
class_name HeartUI

@onready var _heart_body: TextureRect = $HeartBody

func construct(init_position: Vector2) -> HeartUI:
	position = init_position
	return self

func _ready() -> void:
	_heart_body.self_modulate.r = 1

func on_damaged() -> void:
	_heart_body.self_modulate.r = 0
