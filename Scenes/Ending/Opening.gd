extends Node

func _ready():
	MusicManager.play_main_music()


func _process(delta):
	if Input.is_action_just_pressed("mouse_left"):
		go_to_title()


func play_intro_music():
	pass


func go_to_title():
	SceneManager.load_scene(SceneManager.TITLE)
