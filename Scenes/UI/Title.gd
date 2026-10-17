extends Node

onready var clickSoundPlayer = $ClickSoundPlayer


func _ready():
	get_tree().paused = false
	MusicManager.play_main_music()


func _on_btn_start_pressed():
	$Content / MarginContainer / MainMenu.hide()
	$Content / MarginContainer / DifficultyMenu.show()
	clickSoundPlayer.play()


func _on_btn_options_pressed():
	$Content / MarginContainer / MainMenu.hide()
	$Content / MarginContainer / OptionMenu.show()
	clickSoundPlayer.play()


func _on_btn_manual_pressed():
	clickSoundPlayer.play()
	SceneManager.load_scene(SceneManager.MANUAL)


func _on_btn_credits_pressed():
	clickSoundPlayer.play()
	SceneManager.load_scene(SceneManager.CREDITS)


func _on_btn_option_back_pressed():
	$Content / MarginContainer / MainMenu.show()
	$Content / MarginContainer / OptionMenu.hide()
	clickSoundPlayer.play()


func _on_btn_return_pressed():
	$Content / MarginContainer / MainMenu.show()
	$Content / MarginContainer / DifficultyMenu.hide()
	clickSoundPlayer.play()
