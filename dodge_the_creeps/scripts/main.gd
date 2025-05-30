extends Node

@onready var hud = $HUD
@onready var score_timer = $ScoreTimer
@onready var start_timer = $StartTimer
@onready var player = $Player
@onready var start_position = $StartPosition
@onready var mob = preload("res://scenes/mob.tscn")
@onready var mob_path = $MobPath
@onready var mob_spawn_location = $MobPath/MobSpawnLocation
@onready var mob_timer = $MobTimer
@onready var death_sound = $Death_sound
@onready var background_sound = $Background_sound

var current_score = 0

func _ready():
	if hud:
		hud.game_start_initiated.connect(_on_hud_game_start_initiated)
	if player:
		player.hit.connect(_on_player_hit)
	if background_sound:
		background_sound.finished.connect(_on_background_sound_finished)
	current_score = 0
	hud.update_score_label()
	if player and start_position:
		player.position = start_position.position
		player.hide()
		player.set_physics_process(false)

func _on_hud_game_start_initiated():
	if player and start_position:
		player.position = start_position.position
		player.show()
		get_tree().call_group("mobs", "queue_free") 
	start_timer.start()

func _on_start_timer_timeout():
	background_sound.play()
	score_timer.start()
	mob_timer.start()
	if player:
		player.set_physics_process(true)

func _on_score_timer_timeout():
	current_score += 1
	hud.update_score(1)

func _on_mob_timer_timeout():
	var new_mob = mob.instantiate()

	mob_spawn_location.progress_ratio = randf()

	new_mob.position = mob_spawn_location.position

	new_mob.rotation = mob_spawn_location.rotation

	add_child(new_mob)

func _on_player_hit():
	if player:
		player.set_physics_process(false)
		player.hide()
	
	score_timer.stop()
	mob_timer.stop()
	background_sound.stop()
	death_sound.play()
	hud.show_game_over()
	hud.reset_hud()

func _on_background_sound_finished():
	background_sound.play()
