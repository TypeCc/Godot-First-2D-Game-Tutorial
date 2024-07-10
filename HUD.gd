extends CanvasLayer

signal  start_game

func update_score(score):
	$ScoreLabel.text = str(score)

func show_message(text):
	$MessageLabel.text = text
	$MessageLabel.show()
	$MessageTimer.start()

func show_game_over():
	show_message("ÖLDÜN")
	await $MessageTimer.timeout
	$MessageLabel.text = "Hayatta KAL"
	$MessageLabel.show()
	await get_tree().create_timer(1.0).timeout
	$Button.show()

func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_button_pressed():
	$Button.hide()
	emit_signal("start_game")


func _on_message_timer_timeout():
	$MessageLabel.hide()
