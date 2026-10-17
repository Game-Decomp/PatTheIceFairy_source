extends HBoxContainer

onready var lbl_highscore = $Content / MarginContainer / VBoxContainer / lbl_high_value
onready var lbl_score = $Content / MarginContainer / VBoxContainer / lbl_score
onready var click_sound_player = $ClickSoundPlayer
onready var btn_ending = $Content / MarginContainer / VBoxContainer / HBoxContainer / btn_ending
onready var lbl_ending = $Content / MarginContainer / VBoxContainer / CenterContainer / Label

func _ready():
	get_tree().paused = false
	
	lbl_score.text = num_to_str(Globals.score)
	lbl_highscore.text = num_to_str(Globals.high_score)
	
	$Content / lbl_new_high.visible = Globals.score == Globals.high_score
	btn_ending.disabled = not Globals.ending_unlocked
	lbl_ending.visible = not Globals.ending_unlocked


func num_to_str(value):
	var display_number = str(round(value))
	
	for i in range(display_number.length() - 3, 0, - 3):
		display_number = display_number.insert(i, ",")
	
	return display_number


func _on_btn_retry_pressed():
	click_sound_player.play()
	SceneManager.load_scene(SceneManager.GAME)


func _on_btn_ending_pressed():
	click_sound_player.play()
	MusicManager.supress_music()
	SceneManager.load_scene(SceneManager.ENDING)


func _on_btn_title_pressed():
	click_sound_player.play()
	SceneManager.load_scene(SceneManager.TITLE)
