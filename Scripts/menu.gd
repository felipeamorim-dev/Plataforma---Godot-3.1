extends CanvasLayer


func _input(event):
	if event.is_action_pressed("start"):
		get_tree().change_scene("res://Scenes/Fases/fase 1.tscn")

func _on_btn_start_pressed():
	get_tree().change_scene("res://Scenes/Fases/fase 1.tscn")
