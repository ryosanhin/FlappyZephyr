extends Node

@export var _cloud: PackedScene
@export var _lightning_manager: Node
@export var _obj_count: int

@export var _min_interval: float
@export var _max_interval: float

@onready var _timer: Timer = $Timer
@onready var _path_follow2d:PathFollow2D = $Path2D/PathFollow2D

var _pool: NodePool

func _ready() -> void:
	_pool = NodePool.new(
		_cloud,
		_obj_count,
		_on_instantiate_cloud,
		_on_get_cloud,
		Callable()
	)
	add_child(_pool)

func _on_timer_timeout() -> void:
	_set_random_timer()
	_pool.get_instance()

func _set_random_timer() -> void:
	_timer.wait_time = randf_range(_min_interval, _max_interval)
	_timer.start()

func _on_instantiate_cloud(node: Node) -> void:
	var cloud := node as Cloud
	cloud.construct(_lightning_manager)

func _on_get_cloud(node: Node) -> void:
	var cloud := node as Cloud
	cloud.reparent(self)
	_path_follow2d.progress_ratio = randf()
	var init_position := _path_follow2d.position
	cloud.position = init_position
