extends Area2D

@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@onready var collect_apple: AudioStreamPlayer2D = $collect_apple
@onready var collision_shape_2d: CollisionShape2D = $CollisionShape2D

signal colleted

func _on_body_entered(body: Node2D) -> void:
	if body.name != "Player":
		return

	animated_sprite_2d.animation = "collected"
	collect_apple.play()
	colleted.emit()
	call_deferred("_disable_collision")


func _disable_collision() -> void:
	collision_shape_2d.disabled = true


func _on_animated_sprite_2d_animation_looped() -> void:
	if animated_sprite_2d.animation == "collected":
		queue_free()
