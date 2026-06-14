extends Area2D

class_name Cloud

@export var _speed: float = 200.0
@export var _lightning_prefab: PackedScene
@onready var _spawn_marker: Marker2D = $Marker2D
@onready var _timer: Timer = $Timer
var _lightning_manager: Node

func construct(lightning_manager: Node) -> Cloud:
	_lightning_manager = lightning_manager
	return self

func _ready() -> void:
	_set_random_timer()

func _process(delta):
	position.x -= _speed * delta
	if global_position.x < -960:
		queue_free()

func _on_timer_timeout() -> void:
	_set_random_timer()
	
	if _lightning_manager == null:
		pass
	
	var lightning := _lightning_prefab.instantiate() as Lightning
	lightning.construct(_speed)
	lightning.global_position = _spawn_marker.global_position
	_lightning_manager.add_child(lightning)

func _set_random_timer() -> void:
	const min_time := 6.0
	const max_time := 15.0
	_timer.wait_time = randf_range(min_time, max_time)
	_timer.start()
