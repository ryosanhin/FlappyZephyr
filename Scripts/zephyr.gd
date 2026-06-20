extends CharacterBody2D
class_name Zephyr

@onready var _animation_tree: AnimationTree = $AnimationTree
var _state_machine : AnimationNodeStateMachinePlayback
signal damaged

const _jump_velocity: float = -500
const _gravity: float = 1000

var _vertical_speed := ReactiveVariable.new(0.0)

var _damage_cool_time := false

func _ready() -> void:
	_state_machine = _animation_tree.get("parameters/playback")
	
	_vertical_speed.map(
		func(y: float):
			return "Rising" if y < 0.0 else "Descending"
	) \
	.distinct_until_changed() \
	.subscribe(
	func(state: String) -> void:
		_state_machine.travel(state)
	) \
	.add_to(self)

func _process(delta: float) -> void:
	var current_velocity := velocity
	
	current_velocity.y += _gravity*delta
	
	if Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT):
		current_velocity.y = _jump_velocity
	
	_vertical_speed.value = current_velocity.y
	
	velocity=current_velocity
	
	move_and_slide()

func _hit_animation_async():
	_damage_cool_time = true
	
	var default_color := modulate
	
	const damage_interval := 1.5
	const lap_counts := 15.0
	const lap_times := damage_interval/lap_counts
	
	var tween := create_tween()
	
	tween.tween_property(
		self,
		"modulate:a",
		0.0,
		lap_times * 0.5
	)
	tween.tween_property(
		self,
		"modulate:a",
		1.0,
		lap_times * 0.5
	)
	tween.set_loops(lap_counts as int)
	
	await tween.finished
	
	modulate = default_color
	_damage_cool_time = false

func _on_area_2d_area_entered(area: Area2D) -> void:
	if _damage_cool_time:
		return
	damaged.emit()
	await _hit_animation_async()
