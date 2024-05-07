extends Node

@export var mob_scene: PackedScene
var score


func game_over() -> void:
	$ScoreTimer.stop()
	$MobTimer.stop()
	$HUD.show_game_over()
	$Music.stop()
	$DeathSound.play()


func new_game():
	# Update game state.
	score = 0
	$Player.start($StartPosition.position)
	$StartTimer.start()

	# Update HUD.
	$HUD.update_score(score)
	$HUD.show_message("Get Ready")

	# The call_group() function calls the named function on every
	# node in a group - in this case we are telling every mob to delete itself.
	get_tree().call_group("mobs", "queue_free")
	
	$Music.play() 


func _on_start_timer_timeout() -> void:
	$MobTimer.start()
	$ScoreTimer.start()


func _on_score_timer_timeout() -> void:
	score += 1
	$HUD.update_score(score)


func _on_mob_timer_timeout() -> void:
	# Create a new instance of the Mob scene.
	var mob = mob_scene.instantiate()

	# Set the mob's position to a random location on the path.
	var mob_spawn_location = $MobPath/MobSpawnLocation
	mob_spawn_location.progress_ratio = randf()
	mob.position = mob_spawn_location.position

	# Calculate mob rotation almost perpendicular to the path.
	var direction = mob_spawn_location.rotation + PI / 2
	direction += randf_range(-PI / 4, PI / 4)
	mob.rotation = direction

	# Choose the velocity for the mob.
	var velocity = Vector2(randf_range(150.0, 250.0), 0.0)
	mob.linear_velocity = velocity.rotated(direction)

	# Spawn the mob by adding it to the Main scene.
	add_child(mob)
