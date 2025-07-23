extends Node2D

var enemy = preload("res://enemy ship/enemy.tscn")

func _ready():
	placeEnemy(0,0)
	
func placeEnemy(x,y):
	#spawns enemy at given cords
	var loadedEnemy = enemy.instantiate()
	loadedEnemy.global_position = Vector2(x,y)
	#signals
	loadedEnemy.enemyJustDied.connect(_on_shake_screen)
	add_child(loadedEnemy)

func _on_shake_screen() -> void:
	$player/playerCamera.shakeScreen = true
