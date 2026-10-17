extends Node2D

signal pet_active
signal add_score
signal pet_stop
signal escaped

enum {
	SPAWN, 
	IDLE, 
	PAT, 
	PAT_STOP, 
	ESCAPE, 
}
var state setget set_state

var score = 0 setget set_score
var curr_mouse_pos: Vector2
var last_mouse_pos: Vector2

var is_infinite_headpat = false
var is_must_escape = false

onready var mouse_detector = $HandDetector
onready var anim_sprite = $AnimatedSprite
onready var pat_path = $PatPath
onready var pat_particle = $PatParticle
onready var snow_particle = $SnowParticle
onready var anim_player = $AnimationPlayer

func _ready():
	self.state = SPAWN
	last_mouse_pos = get_global_mouse_position()


func _process(delta):
	curr_mouse_pos = get_global_mouse_position()
	
	if state in [IDLE, PAT]:
		headpatable_state()
		if is_must_escape:
			self.state = ESCAPE
	
	pat_path.visible = (state in [IDLE, PAT]) and mouse_detector.is_mouse_entered
	
	if state == PAT and not mouse_detector.is_mouse_entered:
		self.state = PAT_STOP
	
	score -= 120 * delta
	if score < 0:
		score = 0
	
	last_mouse_pos = curr_mouse_pos


func headpatable_state():
	var stroke_dist = 0
	
	if mouse_detector.is_mouse_entered:
		stroke_dist = curr_mouse_pos.distance_to(last_mouse_pos)
		if $PatTimer.is_stopped():
			emit_signal("pet_active", self)
		$PatTimer.start()
	
	if stroke_dist > 50:
		stroke_dist = 50
	
	pat_particle.emitting = stroke_dist > 0
	
	if stroke_dist > 0:
		emit_signal("add_score", stroke_dist)
		if not $PetSound.playing:
			$PetSound.play()
	
	self.score += stroke_dist


func _on_AnimatedSprite_frame_changed():
	if anim_sprite.frame == 0:
		pat_path.rotation_degrees = 0
	if anim_sprite.frame == 1 and state == PAT:
		pat_path.rotation_degrees = - 9
	if anim_sprite.frame == 2 and state == PAT:
		pat_path.rotation_degrees = - 15


func set_score(val):
	if score == val:
		return
	
	score = val
	
	self.state = PAT
	
	if score > 300 and not is_infinite_headpat:
		self.state = ESCAPE


func set_state(val):
	if val == state:
		return
	
	state = val
	
	match (val):
		SPAWN:
			anim_sprite.play("spawn")
			anim_player.play("spawn")
			mouse_detector.monitoring = false
			mouse_detector.monitorable = false
			pat_particle.emitting = false
			snow_particle.emitting = true
		IDLE:
			anim_sprite.play("idle")
			if mouse_detector.is_mouse_entered:
				emit_signal("pet_active", self)
				$PatTimer.start()
		PAT:
			anim_sprite.play("pat")
			$WinkSound.play()
		PAT_STOP:
			anim_sprite.play("pat_reverse")
			$PetSound.playing = false
		ESCAPE:
			anim_sprite.play("spawn", true)
			anim_player.play("despawn")
			pat_particle.emitting = false
			mouse_detector.monitoring = false
			mouse_detector.monitorable = false
			$PetSound.playing = false
			
			if score > 300:
				$PointsParticle.emitting = true


func _on_AnimatedSprite_animation_finished():
	if state == SPAWN:
		mouse_detector.monitoring = true
		mouse_detector.monitorable = true
	
	if state in [SPAWN, PAT_STOP]:
		self.state = IDLE
	
	if state == ESCAPE:
		pat_particle.emitting = false
		$EscapeParticle.emitting = true
		
		emit_signal("pet_stop", self)
		emit_signal("escaped")
		$EscapeTimer.start()


func _on_EscapeTimer_timeout():
	queue_free()


func _on_PatTimer_timeout():
	emit_signal("pet_stop", self)
