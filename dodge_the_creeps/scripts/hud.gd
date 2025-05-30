extends CanvasLayer

signal game_start_initiated

@onready var start_button = $StartMarginContainer/StartButton
@onready var message_label = $MessageMarginContainer/MessageLabel
@onready var score_label = $ScoreMarginContainer/ScoreLabel
@onready var message_timer = $MessageTimer

var score = 0
var _showing_game_over = false

func _ready():
	update_score_label()
	start_button.show()

func _on_start_button_pressed():
	score = 0 
	update_score_label() 
	start_button.hide()
	message_label.text = "GET READY!!!"
	message_label.show()
	_showing_game_over = false
	message_timer.start()
	game_start_initiated.emit()

func _on_message_timer_timeout():
	message_label.hide()
	if _showing_game_over:
		_showing_game_over = false
		reset_hud()

func update_score(amount: int):
	score += amount
	update_score_label()

func update_score_label():
	score_label.text = "Score: " + str(score)

func show_message(text: String):
	message_label.text = text
	message_label.show()
	_showing_game_over = false
	message_timer.start()

func show_game_over():
	message_label.text = "GAME OVER!!!"
	message_label.show()
	start_button.text = "Restart"
	_showing_game_over = true
	message_timer.start()

func reset_hud():

	update_score_label()
	message_label.hide()
	start_button.show()
	_showing_game_over = false
