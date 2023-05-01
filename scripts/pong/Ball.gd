extends KinematicBody2D

var velocity = Vector2()

func restart():
	position.x = 0
	position.y = 0
	speed = 10.0
	velocity = Vector2(1, rand_range(-1, 1))
	
# Called when the node enters the scene tree for the first time.
func _ready():
	restart()


var speed := 1.0

func _process(delta):
	speed += delta
	$Rat.rotation += speed * delta * 0.2
	var collision = move_and_collide(velocity * speed)
	if collision:
		if collision.collider.is_in_group("Paddle"):
			var l = velocity.length()
			if collision.collider.name == "Player":
				velocity = Vector2(1, rand_range(-1.0, 1.0))
			else:
				velocity = Vector2(-1, rand_range(-1.0, 1.0))
		else :
			var reflect = collision.remainder.bounce(collision.normal)
			velocity = velocity.bounce(collision.normal) * 1.03
			move_and_collide(reflect)
