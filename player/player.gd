extends CharacterBody2D

var mouseDirection = Vector2.ZERO
var speed = 100
var canFire = true

@onready var bullet = preload("res://bullet/bullet.tscn")

func _physics_process(delta: float) -> void:
	#movement code
	#direction to mouse
	mouseDirection = global_position.direction_to(get_global_mouse_position())
	#distance to mouse
	speed = (get_global_mouse_position() - global_position).length()
	if speed > 1000:
		speed = 1000
	velocity = mouseDirection * speed
	move_and_slide()
	if Input.is_action_pressed("fire") and canFire:
		canFire = false
		$bulletTimer.start()
		var newBullet = bullet.instantiate()
		newBullet.mouseDirection = mouseDirection
		newBullet.global_position = global_position
		add_sibling(newBullet)
	#looks at mouse
	look_at(get_global_mouse_position())

func _on_bullet_timer_timeout() -> void:
	canFire = true
