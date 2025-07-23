extends CharacterBody2D

signal enemyJustDied

@onready var enemyHealth = 10
@onready var notCurrentlyDead = true
	

func _on_area_hit_body_entered(body: Node2D) -> void:
	enemyHealth -= 1
	if enemyHealth <= 0 and notCurrentlyDead:
		#starts explosion animation
		notCurrentlyDead = false
		enemyJustDied.emit()
		$EnemySprite.visible = false
		$ExplodedShipParticles.emitting = true
		$Explosion.emitting = true


func _on_exploded_ship_particles_finished() -> void:
	queue_free()
