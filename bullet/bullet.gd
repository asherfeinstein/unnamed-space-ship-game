extends CharacterBody2D
@export var mouseDirection: Vector2

var speed = 2000
func _ready() -> void:
	look_at(get_global_mouse_position())
	visible = false
	$VisibleTimer.start()
	$ActiveTimer.start()
	
	
func _physics_process(delta: float) -> void:
	velocity = mouseDirection * speed
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
