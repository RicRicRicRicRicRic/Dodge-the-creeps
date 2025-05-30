extends Area2D

@export var SPEED: int
var velocity = Vector2()
var screensize

signal hit

func _ready():
	hide()
	screensize = get_viewport_rect().size

func _process(delta):
	velocity = Vector2()
	if Input.is_action_pressed("right"):
		velocity.x += 1
	if Input.is_action_pressed("left"):
		velocity.x -= 1
	if Input.is_action_pressed("down"):
		velocity.y += 1
	if Input.is_action_pressed("up"):
		velocity.y -= 1

	if velocity.length() > 0:
		velocity = velocity.normalized() * SPEED
		if velocity.x != 0:
			$AnimatedSprite2D.play("right")
			$AnimatedSprite2D.flip_v = false
			$AnimatedSprite2D.flip_h = velocity.x < 0
		elif velocity.y != 0:
			$AnimatedSprite2D.play("up")
			$AnimatedSprite2D.flip_v = velocity.y > 0
			$AnimatedSprite2D.flip_h = false 
	else:
		$AnimatedSprite2D.stop()

	position += velocity * delta
	position.x = clamp(position.x, 0, screensize.x)
	position.y = clamp(position.y, 0, screensize.y)

func _on_Player_body_entered():
	hide()
	emit_signal("hit")
	call_deferred("set_monitoring", false)

func start(pos):
	position = pos
	show()
	monitoring = true
