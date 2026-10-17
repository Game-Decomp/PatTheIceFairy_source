extends Node

onready var tween = $Tween

var user_volume


func play_main_music():
	$FeverSong.stop()
	$EndingSong.stop()
	$CreditsSong.stop()
	if not $MainMusicPlayer.playing:
		$MainMusicPlayer.play()


func play_fever_music():
	$MainMusicPlayer.stop()
	$EndingSong.stop()
	$CreditsSong.stop()
	if not $FeverSong.playing:
		$FeverSong.play()


func play_ending_music():
	$MainMusicPlayer.stop()
	$FeverSong.stop()
	$CreditsSong.stop()
	if not $EndingSong.playing:
		$EndingSong.play()


func play_credits_music():
	$MainMusicPlayer.stop()
	$FeverSong.stop()
	$EndingSong.stop()
	if not $CreditsSong.playing:
		$CreditsSong.play()


func supress_music():
	user_volume = AudioManager.music_volume
	
	tween.interpolate_property(
		AudioManager, "music_volume", 
		user_volume, - 60, 
		1, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	tween.start()


func _on_Tween_tween_all_completed():
	$MainMusicPlayer.stop()
	$FeverSong.stop()
	$EndingSong.stop()
	$CreditsSong.stop()
	AudioManager.music_volume = user_volume
