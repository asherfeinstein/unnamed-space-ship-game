extends CharacterBody2D

signal enemyJustDied

@export var SPEED = 600

@onready var enemyHealth = 10
@onready var notCurrentlyDead = true
	
var goalPoint = Vector2.ZERO

var rng = RandomNumberGenerator.new()

func _ready():
	modulate = Color(1.0, 1.0, 1.0)
	$Collision.set_deferred("disabled",false)
	$AreaHit/AreaHitCollision.set_deferred("disabled",false)
	get_goal_point(Vector2.ZERO)
	$UpdateGoalPointTimer.start()
	
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
		$Collision.set_deferred("disabled",true)
		$AreaHit/AreaHitCollision.set_deferred("disabled",true)
		notCurrentlyDead = false
		enemyJustDied.emit()
		modulate = Color(1.0, 1.0, 1.0)
		$EnemySprite.visible = false
		$ExplodedShipParticles.emitting = true
		$Explosion.emitting = true
	elif notCurrentlyDead:
		#Makes them breifly read when hit
		modulate = Color(0.973, 0.0, 0.039)
		$DamageColorTimer.start()
		
func _on_exploded_ship_particles_finished() -> void:
	queue_free()


func _on_damage_color_timer_timeout() -> void:
	#resets color
	modulate = Color(1.0, 1.0, 1.0)


func _on_update_goal_point_timer_timeout() -> void:
	goalPoint = get_goal_point(get_parent().playerPosition)
