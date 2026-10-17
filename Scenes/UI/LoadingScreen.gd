extends Control

signal load_complete

onready var progressbar = $VBoxContainer / ProgressBar

var loader
var wait_frames
var time_max = 100
var current_scene

func _ready():
	set_process(false)
	hide()
	
	$VBoxContainer / Control / AnimatedSprite.play()


func load_scene(path: String):
	loader = ResourceLoader.load_interactive(path)
	wait_frames = 1
	show()
	set_process(true)


func _process(time):
	if loader == null:
		
		set_process(false)
		return

	
	if wait_frames > 0:
		wait_frames -= 1
		progressbar.value = 0
		return

	var t = OS.get_ticks_msec()
	
	while OS.get_ticks_msec() < t + time_max:
		
		var err = loader.poll()

		if err == ERR_FILE_EOF:
			set_process(false)
			finish_progress()
			break
		elif err == OK:
			update_progress()
		else:
			print("Error")
			loader = null
			break


func update_progress():
	var progress = float(loader.get_stage()) / loader.get_stage_count()
	
	progressbar.value = progress * 100


func finish_progress():
	progressbar.value = 100
	$Timer.start()


func _on_Timer_timeout():
	var resource = loader.get_resource()
	
	loader = null
	
	hide()
	emit_signal("load_complete", resource)
