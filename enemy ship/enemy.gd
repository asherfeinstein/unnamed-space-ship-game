extends CharacterBody2D

signal enemyJustDied

#related to bullet
@onready var bullet = preload("res://bullet/bullet.tscn")
var playerInRange = false

@export var SPEED = 600

@onready var enemyHealth = 10
@onready var notCurrentlyDead = true
	
var goalPoint = Vector2.ZERO

var rng = RandomNumberGenerator.new()

func _ready():
	$EnemySprite.modulate = Color(1.0, 1.0, 1.0)
	$Collision.set_deferred("disabled",false)
	$AreaHit/AreaHitCollision.set_deferred("disabled",false)
	get_goal_point(Vector2.ZERO)
	$UpdateGoalPointTimer.start()
	$AttemptShot.start()
	
func _physics_process(delta: float):
	#The Basic Enemy AI
	var currentDirection = velocity.normalized()
	var goalDirection = global_position.direction_to(goalPoint)
	currentDirection = currentDirection.lerp(goalDirection, delta * 3)
	velocity = currentDirection * SPEED
	if notCurrentlyDead:
		move_and_slide()
		look_at(global_position + currentDirection)
	
	

func get_goal_point(point: Vector2):
	var randomRange = 500
	var goal = Vector2(point.x + rng.randf_range((0-randomRange),randomRange),point.y + rng.randf_range((0-randomRange),randomRange))
	return goal

func _on_area_hit_body_entered(body: Node2D) -> void:
	#regarding Enemy getting damaged
	enemyHealth -= 1
	if enemyHealth <= 0 and notCurrentlyDead:
		#starts explosion animation
		$"engine particles".emitting = false
		$Collision.set_deferred("disabled",true)
		$AreaHit/AreaHitCollision.set_deferred("disabled",true)
		notCurrentlyDead = false
		enemyJustDied.emit()
		$EnemySprite.modulate = Color(1.0, 1.0, 1.0)
		$EnemySprite.visible = false
		$ExplodedShipParticles.emitting = true
		$Explosion.emitting = true
	elif notCurrentlyDead:
		#Makes them breifly read when hit
		$EnemySprite.modulate = Color(0.973, 0.0, 0.039)
		$DamageColorTimer.start()
		
		
func fire_bullet():
	var newBullet = bullet.instantiate()
	newBullet.aimDirection = global_position.direction_to(get_parent().playerPosition)
	newBullet.global_position = global_position
	newBullet.bulletType = "enemy"
	add_sibling(newBullet)
func _on_exploded_ship_particles_finished() -> void:
	queue_free()


func _on_damage_color_timer_timeout() -> void:
	#resets color
	$EnemySprite.modulate = Color(1.0, 1.0, 1.0)


func _on_update_goal_point_timer_timeout() -> void:
	goalPoint = get_goal_point(get_parent().playerPosition)

#following three signals Partain to trying to shot player

func _on_fire_bullet_area_body_entered(body: Node2D) -> void:
	playerInRange = true
	
func _on_fire_bullet_area_body_exited(body: Node2D) -> void:
	playerInRange = false


func _on_attempt_shot_timeout() -> void:
	if playerInRange:
		fire_bullet()
	$AttemptShot.start()
