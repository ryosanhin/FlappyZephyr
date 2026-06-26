extends Polygon2D

@export var _normal_face: Texture
@export var _damaged_face: Texture
@export var _damage_interval: float = 1

@onready var _timer := $Timer

func _on_zephyr_damaged() -> void:
	texture = _damaged_face
	_timer.wait_time = _damage_interval
	_timer.start()


func _on_timer_timeout() -> void:
	texture = _normal_face
