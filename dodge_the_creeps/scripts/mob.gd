extends RigidBody2D

@export var MIN_SPEED: int
@export var MAX_SPEED: int

var mob_types = ["fly", "swim", "walk"]

func _ready():
	$AnimatedSprite2D.animation = mob_types[randi() % mob_types.size()]


func _on_visible_on_screen_notifier_2d_screen_entered() -> void:
	queue_free()
