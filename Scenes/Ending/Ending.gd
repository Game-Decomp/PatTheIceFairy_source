extends Node

func _ready():
	MusicManager.play_ending_music()


func _on_AnimationPlayer_animation_finished(_anim_name):
	SceneManager.load_scene(SceneManager.AFTERWORD)
