extends CharacterBody2D

var mouseDirection = Vector2.ZERO
var speed = 100
var canFire = true

#used for sprite animation
var neededChangeInDirection = 0

@onready var bullet = preload("res://bullet/bullet.tscn")

func _physics_process(delta: float) -> void:
	var currentDirection = velocity.normalized()
	#movement code
	#direction to mouse
	mouseDirection = global_position.direction_to(get_global_mouse_position())
	neededChangeInDirection = rad_to_deg(mouseDirection.angle()) - rad_to_deg(currentDirection.angle())
	#distance to mouse
	speed = (get_global_mouse_position() - global_position).length() * 1.5
	currentDirection = currentDirection.lerp(mouseDirection, delta * 10)
	if speed > 1200:
		speed = 1200
	velocity = currentDirection * speed
	move_and_slide()
	if Input.is_action_pressed("fire") and canFire:
		canFire = false
		$bulletTimer.start()
		var newBullet = bullet.instantiate()
		newBullet.aimDirection = mouseDirection
		newBullet.global_position = global_position
		newBullet.bulletType = "player"
		add_sibling(newBullet)
	#looks at current direction 
	look_at(global_position + currentDirection)
"res://"
func _on_bullet_timer_timeout() -> void:
	canFire = true
