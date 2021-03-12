extends Node

export(int) var max_health = 1
onready var health = max_health setget set_health
#big value -> long knockback and vice versa
export(int) var knockback_distance = 1
onready var knockbackValue = knockback_distance

# onready var DAMAGE = jotaki


signal no_health

func set_health(value):
	health = value
	if health <= 0:
		emit_signal("no_health")
