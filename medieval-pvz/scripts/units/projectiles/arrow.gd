extends Node2D
class_name Arrow

var target: Node = null
var damage: int = 0
var speed: float = 600.0

func _process(delta):
	if not is_instance_valid(target):
		queue_free()
		return
	
	var direction = (target.global_position - global_position).normalized()
	position += direction * speed * delta
	
	if global_position.distance_to(target.global_position) < 10:
		if not target.is_dead:
			target.take_damage(damage)
		queue_free()
