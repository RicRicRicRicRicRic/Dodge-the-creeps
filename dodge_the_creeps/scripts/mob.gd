extends RigidBody2D

@export var min_speed = 150
@export var max_speed = 250

@onready var visible_notifier = $VisibleOnScreenNotifier2D
@onready var animated_sprite = $AnimatedSprite2D

var screen_size

func _ready():
	add_to_group("mobs")
	if visible_notifier:
		visible_notifier.screen_exited.connect(on_screen_exited)
	
	screen_size = get_viewport_rect().size

	var random_speed = randf_range(min_speed, max_speed)
	
	var target_x = randf_range(screen_size.x * 0.2, screen_size.x * 0.8)
	var target_y = randf_range(screen_size.y * 0.2, screen_size.y * 0.8)
	var target_point = Vector2(target_x, target_y)

	var direction = (target_point - global_position).normalized()

	linear_velocity = direction * random_speed

	rotation = linear_velocity.angle()

	if animated_sprite:
		var animations = animated_sprite.sprite_frames.get_animation_names()
		if not animations.is_empty():
			var random_animation_name = animations[randi() % animations.size()]
			animated_sprite.play(random_animation_name)

func on_screen_exited():
	queue_free()
