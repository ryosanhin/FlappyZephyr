extends Node

class_name NodePool

var _pool: Array[Node] = []
var _prefab: PackedScene

var _on_instantiate: Callable
var _on_get: Callable
var _on_release: Callable

func _init(
	prefab: PackedScene,
	initial_size: int,
	on_instantiate: Callable,
	on_get: Callable,
	on_release: Callable
	) -> void:
	_prefab = prefab
	_on_instantiate = on_instantiate
	_on_get = on_get
	_on_release = on_release
	
	for i in range(initial_size):
		var instance := _instantiate()
		_pool.append(instance)

func get_instance() -> Node:
	var instance: Node
	
	if _pool.is_empty():
		instance = _instantiate()
	else:
		instance = _pool.pop_back()
	_enable_node(instance)
	if _on_get.is_valid():
		_on_get.call(instance)
	return instance

func release_instance(node: Node) -> void:
	if node in _pool:
		return
	
	if node.get_parent() != self:
		node.reparent(self)
	
	_disable_node(node)
	if _on_release.is_valid():
		_on_release.call(node)
	_pool.append(node)

func _instantiate() -> Node:
	var instance := _prefab.instantiate()
	add_child(instance)
	_disable_node(instance)
	
	if instance.has_signal("release_requested"):
		instance.release_requested.connect(release_instance.bind(instance))
	if _on_instantiate.is_valid():
		_on_instantiate.call(instance)
	
	return instance

func _enable_node(node: Node) -> void:
	node.process_mode = Node.PROCESS_MODE_INHERIT
	if node is CanvasItem or node is Node3D:
		node.visible = true

func _disable_node(node: Node) -> void:
	node.process_mode = Node.PROCESS_MODE_DISABLED
	if node is CanvasItem or node is Node3D:
		node.visible = false
