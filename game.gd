extends Node2D

var enemy = preload("res://enemy ship/enemy.tscn")

#Used by Enemyies
var playerPosition

func _ready():
	placeEnemy(0,0)
	placeEnemy(500,500)
	placeEnemy(-500,-500)
	placeEnemy(-500,500)
	placeEnemy(500,-500)

func _physics_process(delta: float):
	#Enemies use this for "pathfinding"
	playerPosition = $player.global_position
	
func placeEnemy(x,y):
	#spawns enemy at given cords
	var loadedEnemy = enemy.instantiate()
	loadedEnemy.global_position = Vector2(x,y)
	#signals
	loadedEnemy.enemyJustDied.connect(_on_shake_screen)
	add_child(loadedEnemy)

func _on_shake_screen() -> void:
	$player/playerCamera.shakeScreen = true
