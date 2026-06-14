extends Area2D
class_name BaseObstacles

@export var _speed: float = 200.0

var speed: float:
	get:
		return _speed

signal release_requested

func _process(delta):
	position.x -= _speed * delta
	if global_position.x < -256:
		release_requested.emit()
