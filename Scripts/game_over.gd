extends Node


func _ready():
	game.score = 0
	game.vida = 2


func _on_timer_timeout():
	get_tree().change_scene("res://Scenes/Fases/menu.tscn")
