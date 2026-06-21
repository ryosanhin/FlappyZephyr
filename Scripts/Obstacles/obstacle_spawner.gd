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
	_pool = NodePool.new(_obstacle, _obj_count, Callable(), _on_get_obstacle, Callable())
	add_child(_pool)

func _on_get_obstacle(node: Node) -> void:	
	_path_follow2d.progress_ratio = randf()
	var init_position := _path_follow2d.position
	
	var obstacle := node as Node2D
	obstacle.position = init_position

func _on_timer_timeout() -> void:
	_set_random_timer()
	_pool.get_instance()
	

func _set_random_timer() -> void:
	_timer.wait_time = randf_range(_min_interval, _max_interval)
	_timer.start()
