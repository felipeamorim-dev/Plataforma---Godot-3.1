extends KinematicBody2D

const SPEED = 1000
const GRAVITY = 500
const UP = Vector2(0, -1)
var velocity = Vector2()
var dir = -1
	

func change_move(delta):
	
	if !is_on_floor():
		velocity.y += GRAVITY * delta
	
	velocity.x = SPEED * dir * delta
	
	velocity = move_and_slide(velocity, UP)

func test_mov_collider():
	if is_on_wall() || !$raycast.is_colliding():
		dir *= -1
		$raycast.position.x *= -1

func flip_horizontal():
	if velocity.x > 0:
		$sprite.flip_h = true
	else:
		$sprite.flip_h = false