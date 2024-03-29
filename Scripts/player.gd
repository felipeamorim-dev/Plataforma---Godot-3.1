extends KinematicBody2D

const GRAVITY = 20
const SPEED = 150
const JUMP = 400
const FLOOR = Vector2(0, -1)
var velocity = Vector2()
var anim = ""
var new_anim = ""
var runnig = false
var jumping = false
var is_ground = false
var is_alive = true
const OFFSET_POS = Vector2(63, 79)


signal new_game

func _ready():
	add_to_group(game.PLAYER)


func _physics_process(delta):
	if is_alive:
		move_player()
		change_animation() 
		flip_animation()

# Move o personagem
func move_player():
	var d = 0
	var e = 0
	# Evento de verificação de entrada de comando do jogador
	if Input.is_action_pressed("move_dir"): # Verifica se o botão "d" ou " ->" foi pressionado
		 d = 1
	
	if Input.is_action_pressed("move_esq"): #Verifica se o botão "a" ou " <-" foi pressionado
		 e = -1
	
	if is_on_floor():
			# Verifica se foi pressionado o botão de pulo enquanod o player esta no chão
		if Input.is_action_pressed("jump"): 
			$jump_fx.play()
			velocity.y = -JUMP
		
		# Verifica se o personagem está no chao e foi pressionado o botão para descer da plataforma
		if Input.is_action_pressed("desc_plat"):
			if !get_node("raycast").is_colliding(): # Verifica se o chão é umaplataforma do tipo jump-thru, atráves da colisão de camadas com o raycast
				velocity.y = - 30 # Realiza um pequeno salto
				set_collision_mask_bit(1,false) # Desativa a mascara de bits (colisor) da camada 2 permitindo que o player atravesse a plataforma
	else:
		velocity.y += GRAVITY # seta a gravidade ao vetor velocity
	
	
	# Seta ao vetor velocidade a direção do movimento na componente x com a amplitude SPEED
	velocity.x = SPEED * (d + e)
	
	# Realiza o movimento em tela
	velocity = move_and_slide(velocity, FLOOR)

# Função que carrega as animações do player com base em suas ações
func change_animation():
	
	if is_on_floor():
		if Input.is_action_pressed("move_dir") || Input.is_action_pressed("move_esq"):
			runnig = true
			jumping = false
		else:
			runnig = false
			jumping = false
		
		if Input.is_action_pressed("move_dir") && Input.is_action_pressed("move_esq"):
			runnig = false
			jumping = false
		
	if Input.is_action_pressed("jump") || (Input.is_action_pressed("desc_plat") && !get_node("raycast").is_colliding()):
			jumping = true
			runnig = false
			is_ground = false
	
	# Cria o efeito borrachudo a partir da verificação do momento que colide com o chão
	if is_on_floor() && !is_ground:
		is_ground = true
		$anim_fx.play("eraser")
	
	# Vefifica as condições de movimento para setar o tipo de animação 
	if runnig == true && jumping == false:
		new_anim = "run"
	if jumping == true && runnig == false:
		if velocity.y < 0:
			new_anim = "jump"
		else:
			new_anim = "fall"
		
	if runnig == false && jumping == false:
		new_anim = "idle"
	
	# Evita a reexecução da animação caso já esteja rodando
	if new_anim != anim:
		$anim.play(new_anim)
		new_anim = anim

# Função que realiza o espelhamento do sprite de acordo com o sentido do movimento do player
func flip_animation():
	
	if velocity.x > 0:
		$sprite.flip_h = false
	if velocity.x < 0:
		$sprite.flip_h = true

# Método para destroir os inimigos com um pulo na cabeça
func _on_pes_body_entered(body):
	if body.is_in_group(game.ENEMY):
		if body.has_method("_dead"):
			velocity.y = - 200
			body._dead()
		else:
			die()

# Configuração de inicio após perder vida
func pre_game():
	is_alive = true
	position = OFFSET_POS
	$anim.play("idle")
	$shape.set_deferred("disabled", false)
	$"pes/pes-shape".set_deferred("disabled", false)

# Método para terminar o game após o player perder as vidas
func die():
	$shape.disabled = true # Desabilita os colisores do player
	$"pes/pes-shape".set_deferred("disabled", true) # Desabilita os colisores do player
	is_alive = false
	if game.vida > 0:
		game.vida -= 1
		save_data.save_game()
		$anim.play("die")
		yield($anim, "animation_finished")
		pre_game()
	else:
		$anim.play("die")
		yield($anim, "animation_finished")
		emit_signal("new_game")

# Método para terminar o jogo após o player perder as vidas por quedas
func die_fall():
	if game.vida > 0:
		game.vida -= 1
		save_data.save_game()
		pre_game()
	else:
		emit_signal("new_game")

# Método de verificação de saida da tela
func _on_visibility_screen_exited():
	die_fall()

# Método para chamar a tela de game over
func new_game():
	save_data.save_game()
	$timer_die.start()

# Método que chama a tela de game over apos um determinado tempo
func _on_timer_die_timeout():
	get_tree().change_scene("res://Scenes/Fases/game_over.tscn")


func _on_next_fase():
	$timer_die.wait_time = 3
	new_game()
