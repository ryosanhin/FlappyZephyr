extends Node2D

@export var scroll_speed: float = 150
@export var bg_textures: Array[Texture2D]

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var bg_width = get_viewport().get_visible_rect().size.x
	
	for i:int in range(3):
		var cloud := BgCloud.new(
			bg_textures.pick_random(),
			Vector2(i * bg_width, 0.0),
			bg_width,
			scroll_speed
		)
		
		cloud.reached.connect(
			func():
				cloud.reset_scrolling(
					bg_textures.pick_random(),
					Vector2(bg_width * 2.0, 0.0)
				)
		)
		
		add_child(cloud)
	

class BgCloud extends Sprite2D:
	signal reached
	
	var _bg_width: float
	var _scroll_speed: float
	
	func _init(new_texture: Texture2D, new_position: Vector2, bg_width: float, scroll_speed: float) -> void:
		centered = false
		_bg_width = bg_width
		_scroll_speed = scroll_speed
		reset_scrolling(new_texture, new_position)
		self_modulate = Color(1.0, 1.0, 1.0, 0.5)
	
	func reset_scrolling(new_texture: Texture2D, new_position: Vector2) -> void:
		texture = new_texture
		position = new_position
	
	func _process(delta: float) -> void:
		position.x -= _scroll_speed * delta
		if position.x <= -_bg_width:
			reached.emit()
