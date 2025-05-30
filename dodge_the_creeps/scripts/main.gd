extends Node

@export var Mob: PackedScene
var score

func _ready():
	randomize()

func new_game():
	score = 0
	$Player.start($StartPosition.position)
	$StartTimer.start()

func game_over():
	$ScoreTimer.stop()
	$MobTimer.stop()

func _on_start_timer_timeout() -> void:
	$ScoreTimer.start()
	$MobTimer.start()

func _on_score_timer_timeout() -> void:
	score += 1

func _on_mob_timer_timeout() -> void:
	$MobPath/MobSpawnLocation.set_offset(randi())
	
	var mob = Mob.instantiate()
	add_child(mob)
	
	var direction = $MobPath/MobSpawnLocation.rotation
	
	mob.position = $MobPath/MobSpawnLocation.position
	
	direction += randf_range(-PI / 4, PI / 4)
	
	mob.rotation = direction
	mob.linear_velocity = Vector2(randf_range(mob.MIN_SPEED, mob.MAX_SPEED), 0).rotated(direction)
