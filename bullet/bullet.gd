extends CharacterBody2D
@export var aimDirection: Vector2
@export var bulletType: String

var speed = 2000
func _ready() -> void:
	if bulletType == "player":
		#Makes it so the bullet interacts with enemies when shot by player
		look_at(get_global_mouse_position())
		set_collision_layer_value(2, true)
		$HitArea.set_collision_mask_value(3, true)
		#Makes bullet look like player Bullet
		$BulletTypeSpriteStorage.animation = "playerBullet"
		$BulletLight.color = Color(0.0, 0.334, 0.334)
	if bulletType == "enemy":
		#Makes it so the bullet interacts with the player when shot by enemies
		look_at(get_parent().playerPosition)
		set_collision_layer_value(4, true)
		$HitArea.set_collision_mask_value(1, true)
		#Makes bullet look like enemy Bullet
		$BulletTypeSpriteStorage.animation = "enemyBullet"
		$BulletLight.color = Color(1.0, 0.11, 0.11)
	visible = false
	$VisibleTimer.start()
	$ActiveTimer.start()
	
	
func _physics_process(delta: float) -> void:
	velocity = aimDirection * speed
	move_and_slide()



func _on_visible_timer_timeout() -> void:
	visible = true


func _on_active_timer_timeout() -> void:
	#Deletes Bullet after set amount of time
	queue_free()


func _on_hit_area_body_entered(body: Node2D) -> void:
	$DestroyInTimer.start()

func _on_destroy_in_timer_timeout() -> void:
	queue_free()
