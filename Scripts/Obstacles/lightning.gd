extends Area2D

class_name Lightning

@export var _vertical_speed: float
var _horizontal_speed: float

func construct(horizontal_speed: float):
	_horizontal_speed = horizontal_speed
	return self

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	position.y += _vertical_speed * delta
	position.x -= _horizontal_speed * delta
	if global_position.y > 1080.0:
		queue_free()
