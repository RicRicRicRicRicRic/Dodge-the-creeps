extends Area2D

signal hit

@export var speed = 400

var screen_size
@onready var animated_sprite = $AnimatedSprite2D
@onready var trail = $Trail

func _ready():
	screen_size = get_viewport_rect().size
	body_entered.connect(_on_body_entered)

func _physics_process(delta):
	var velocity = Vector2.ZERO

	if Input.is_action_pressed("right"):
		velocity.x += 1
	if Input.is_action_pressed("left"):
		velocity.x -= 1
	if Input.is_action_pressed("down"):
		velocity.y += 1
	if Input.is_action_pressed("up"):
		velocity.y -= 1

	if velocity.length() > 0:
		velocity = velocity.normalized() * speed
		trail.emitting = true

	position += velocity * delta

	position.x = clamp(position.x, 0, screen_size.x)
	position.y = clamp(position.y, 0, screen_size.y)

	if animated_sprite:
		animated_sprite.flip_h = false
		animated_sprite.flip_v = false

		if velocity.x > 0:
			animated_sprite.play("right")
		elif velocity.x < 0:
			animated_sprite.play("right")
			animated_sprite.flip_h = true
		elif velocity.y < 0:
			animated_sprite.play("up")
		elif velocity.y > 0:
			animated_sprite.play("up")
			animated_sprite.flip_v = true
		else:
			animated_sprite.stop()
			trail.emitting = false

func _on_body_entered(body):
	if body.has_method("on_screen_exited"):
		hit.emit()
		body.queue_free()
		animated_sprite.stop()
		trail.emitting = false
