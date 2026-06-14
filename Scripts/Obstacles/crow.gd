extends Area2D

@export var _speed: float = 200.0
@onready var _anima_player: AnimationPlayer= $AnimationPlayer
signal release_requested

func _ready() -> void:
	_anima_player.play("flap")

func _process(delta):
	position.x -= _speed * delta
	if global_position.x < -100:
		release_requested.emit()
