extends Node

@export var mob_scene: PackedScene
var score = 0

func new_game() -> void:
	score = 0
	$HUD.update_score(score)
	get_tree().call_group("mobs", "queue_free")  # Mobs grubundaki tüm nesneleri temizler
	$StartTimer.start()
	$Music.play()
	$HUD.show_message("Hazırlan..")
	# StartTimer sinyalini beklemek için await kullanımı
	await $StartTimer.timeout
	$ScoreTimer.start()
	$MobTimer.start()
	

	var start_position = $StartPosition
	if start_position:
		$Player.start(start_position.position)
	else:
		print("Error: StartPosition node not found.")

func game_over():
	$ScoreTimer.stop()
	$MobTimer.stop()
	$HUD.show_game_over()
	$Music.stop()
	$DeathSound.play()

func _on_score_timer_timeout():
	score += 1
	$HUD.update_score(score)

func _on_start_timer_timeout():
	$MobTimer.start()
	$ScoreTimer.start()

func _ready():
	pass

func _process(delta):
	pass

func _on_mob_timer_timeout():
	# Create a new instance of the Mob scene.
	if mob_scene:
		var mob = mob_scene.instantiate()
		var mob_spawn_location = $MobPath/MobSpawnLocation
		if mob_spawn_location:
			mob_spawn_location.progress_ratio = randf()
			var direction = mob_spawn_location.rotation + PI / 2
			mob.position = mob_spawn_location.position
			direction += randf_range(-PI / 4, PI / 4)
			mob.rotation = direction
			var velocity = Vector2(randf_range(150.0, 250.0), 0.0)
			mob.linear_velocity = velocity.rotated(direction)
			add_child(mob)
		else:
			print("Error: MobSpawnLocation node not found.")
	else:
		print("Error: mob_scene is null. Please assign a valid PackedScene to mob_scene.")
