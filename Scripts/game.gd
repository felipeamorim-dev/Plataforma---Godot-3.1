extends Node

const PLAYER = "player"
const ENEMY = "enemy"
var score = 0 setget set_score

signal score_change

func _ready():
	
	pass 

func set_score(valor):
	score = valor
	emit_signal("score_change")
