extends KinematicBody2D

var knockback = Vector2.ZERO
onready var stats = $Stats
func _physics_process(delta):
	knockback = knockback.move_toward(Vector2.ZERO, 200 * delta)
	knockback = move_and_slide(knockback)

# area on miekka
func _on_Hurtbox_area_entered(area):
	$AnimatedSprite.play("TakeDamage")
	stats.health -= area.damage
	knockback = area.knock_direction * stats.knockbackValue
	


func _on_Stats_no_health():
	$AnimatedSprite.play("Death")
	print("BlueDino is dead")
	queue_free()


func _on_AnimatedSprite_animation_finished():
	$AnimatedSprite.play("Idle")

