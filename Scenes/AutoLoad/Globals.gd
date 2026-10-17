extends Node

enum {
	EASY, 
	NORMAL, 
	HARD, 
}

var difficulty = HARD

var high_score = 0
var score = 0 setget set_score
var ending_unlocked = false

func _ready():
	load_save()


func set_score(val):
	score = val
	
	if high_score < score:
		high_score = score
		save()


func save():
	var save_game = File.new()
	save_game.open("user://Pat_The_Ice_Fairy.save", File.WRITE)
	save_game.store_float(high_score)
	save_game.close()


func load_save():
	var save_game = File.new()
	if not save_game.file_exists("user://Pat_The_Ice_Fairy.save"):
		return
	
	save_game.open("user://Pat_The_Ice_Fairy.save", File.READ)
	high_score = save_game.get_float()
	save_game.close()
