extends Node

export (PackedScene) var Mob
var score

func _ready():
	randomize()
	# new_game()

func game_over():
	$ScoreTimer.stop()
	$MobTimer.stop()
	$HUD.show_game_over()
	get_tree().call_group("mobs", "queue_free")
	
func new_game():
	score = 0
	$Player.start($StartPosition.position)
	$StartTimer.start()
	$HUD.update_score(score)
	$HUD.show_message("Get Ready")

func _on_StartTimer_timeout():
	$MobTimer.start()
	$ScoreTimer.start()

func _on_ScoreTimer_timeout():
	score += 1
	$HUD.update_score(score)

func _on_MobTimer_timeout():
	# Path2Dからランダムに場所を選ぶ
	$MobPath/MobSpawnLocation.offset = randi()
	# Mobインスタンスを作成し、シーンに追加
	var mob = Mob.instance()
	add_child(mob)
	# Mobの方向をパスの方向と垂直に設定する
	var direction = $MobPath/MobSpawnLocation.rotation+ PI / 2
	# Mobの場所をランダムに設定する
	mob.position = $MobPath/MobSpawnLocation.position
	# 方向をランダムに
	direction +=rand_range(-PI / 4, PI / 4)
	mob.rotation = direction
	# 速度を設定（スピード&方向）
	mob.linear_velocity = Vector2(rand_range(mob.min_speed, mob.max_speed), 0)
	mob.linear_velocity = mob.linear_velocity.rotated(direction)
