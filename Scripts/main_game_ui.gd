extends Node

@export var _heart_ui: PackedScene
@export var _character_sprite: CharacterSprite

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass

func init_scene(heart_count: int):
	const heart_ui_init_pos := Vector2(60.0, 60.0)
	const heart_ui_interval := Vector2(60.0, 0.0)
	for i in range(heart_count):
		var init_position := heart_ui_init_pos + i * heart_ui_interval
		
		var heart_ui := (_heart_ui.instantiate() as HeartUI)\
		.construct(init_position)
		
		if _character_sprite == null:
			_character_sprite.Damaged.connect(heart_ui.on_damaged)
