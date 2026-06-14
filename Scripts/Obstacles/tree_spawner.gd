extends Node

@export var _obstacle: PackedScene

var _screen_width: float 
const _tree_width: float = 512
const _tree_interval: float = 400

func _ready() -> void:
	_screen_width = get_viewport().get_visible_rect().size.x
	
	for pos_x in range(
		_screen_width + _tree_width,
		-_tree_width,
		-_tree_interval
	):
		var tree := _obstacle.instantiate() as BaseObstacles
		tree.position = Vector2(pos_x, get_random_height())
		tree.release_requested.connect(
			func():
				tree.position = Vector2(_screen_width + _tree_width, get_random_height())
		)
		add_child(tree)

func get_random_height() -> float:
	const min_height: float = 960
	const max_height: float = 1080
	return randf_range(min_height, max_height)
