extends Node

const PLAYER = "player"
const ENEMY = "enemy"
var score = 0 setget set_score
var vida = 2 setget set_vida

signal score_change
signal update_vida

func set_score(valor):
	score = valor
	emit_signal("score_change")

func set_vida(new_valor):
	vida = new_valor
	emit_signal("update_vida")
