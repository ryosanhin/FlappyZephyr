extends Node

@export var _obstacle: PackedScene
@export var _obstacle_root: Node
@export var _obj_count: int

@export var _min_interval: float
@export var _max_interval: float

@onready var _timer: Timer = $Timer
@onready var _path_follow2d:PathFollow2D = $Path2D/PathFollow2D

var _pool: NodePool

func _ready() -> void:
	_pool = NodePool.new(_obstacle, _obj_count)
	add_child(_pool)

func _on_timer_timeout() -> void:
	_set_random_timer()
	
	_path_follow2d.progress_ratio = randf()
	
	var init_position := _path_follow2d.position
	
	var obstacle := _pool.get_instance(_obstacle_root) as Node2D
	
	obstacle.position = init_position

func _set_random_timer() -> void:
	_timer.wait_time = randf_range(_min_interval, _max_interval)
	_timer.start()
