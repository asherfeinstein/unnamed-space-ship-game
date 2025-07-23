extends CharacterBody2D

var mouseDirection = Vector2.ZERO
var speed = 100
var canFire = true

@onready var bullet = preload("res://bullet/bullet.tscn")

func _physics_process(delta: float) -> void:
	var currentDirection = velocity.normalized()
	#movement code
	#direction to mouse
	mouseDirection = global_position.direction_to(get_global_mouse_position())
	#distance to mouse
	speed = (get_global_mouse_position() - global_position).length()
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

func _on_bullet_timer_timeout() -> void:
	canFire = true
