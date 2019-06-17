extends "res://Scripts/enemy.gd"

var is_alive = true

func _ready():
	add_to_group(game.ENEMY)
	pass

func _physics_process(delta):
	if is_alive:
		change_move(delta)
		test_mov_collider()
		flip_horizontal()
		


func _on_body_body_entered(body):
	if body.is_in_group(game.PLAYER):
		if body.has_method("die"):
			body.die()
