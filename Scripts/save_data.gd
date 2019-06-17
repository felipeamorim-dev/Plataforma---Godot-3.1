extends Node

const SAVE_PATH = "user://save.data"
var moedas = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	load_game()
	pass

func save_game():
	var file = File.new()
	var erro = file.open(SAVE_PATH, File.WRITE)
	var dados = {"moedas" : game.score}
	
	if not erro:
		file.store_var(dados)
	else:
		print("Erro no carregamento")
	
	file.close()

func load_game():
	var file = File.new()
	if file.file_exists(SAVE_PATH):
		file.open(SAVE_PATH, File.READ)
		var saveData = file.get_var()
		moedas = saveData["moedas"]
	else:
		print("Erro no carregamento dos dados.")
	
	file.close()

