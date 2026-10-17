extends Node

signal request_scene_load

enum {
	TITLE, 
	INTRO, 
	GAME, 
	SCORE, 
	ENDING, 
	MANUAL, 
	CREDITS, 
	AFTERWORD, 
}

const scenes = {
	TITLE: "res://Scenes/UI/Title.tscn", 
	INTRO: "res://Scenes/Ending/Opening.tscn", 
	GAME: "res://Scenes/Game/PatTest.tscn", 
	SCORE: "res://Scenes/UI/Score.tscn", 
	ENDING: "res://Scenes/Ending/Ending.tscn", 
	MANUAL: "res://Scenes/UI/Manual.tscn", 
	CREDITS: "res://Scenes/UI/Credits.tscn", 
	AFTERWORD: "res://Scenes/UI/Afterword.tscn", 
}

var loading = false


func load_scene(id):
	if not loading:
		emit_signal("request_scene_load", scenes[id])
		loading = true


func load_scene_path(path: String):
	if not loading:
		emit_signal("request_scene_load", path)
		loading = true
