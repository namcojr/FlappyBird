extends RigidBody2D

var state
const STATE_FLYING		= 0
const STATE_FLAPPING	= 1
const STATE_HIT			= 2
const STATE_GROUNDED	= 3
var speed				= 62
signal state_changed
var prev_state = STATE_FLAPPING
var speed_increase		= 0
var momentum			= 25

func _ready():
	utils.get_random_bird()
	utils.set_random_background()

	state = FlyingState.new(self)
	add_to_group(game.GROUP_BIRDS)
	connect("body_entered", self, "_on_body_entered")
	pass

func _physics_process(delta):
	state.update(delta)

func _input(event):
	state.input(event)
	pass

func _on_body_entered(other_body):
	if state.has_method("on_body_entered"):
		state.on_body_entered(other_body)
	pass

func set_state(new_state):
	prev_state = get_state()
	state.exit()
	if new_state == STATE_FLYING:
		state = FlyingState.new(self)
	elif new_state == STATE_FLAPPING:
		state = FlappingState.new(self)
	elif new_state == STATE_HIT:
		state = HitState.new(self)
	elif new_state == STATE_GROUNDED:
		state = GroundedState.new(self)
	emit_signal("state_changed", self)
	pass

func get_state():
	if state is FlyingState:
		return  STATE_FLYING
	elif state is FlappingState:
		return  STATE_FLAPPING
	elif state is HitState:
		return  STATE_HIT
	elif state is GroundedState:
		return  STATE_GROUNDED

# state management classes
class FlyingState:
	var bird
	var prev_gravity_scale

	func _init(bird):
		self.bird = bird
		bird.get_node(utils.get_anim()).play("flying")
		prev_gravity_scale = bird.get_gravity_scale()
		bird.set_linear_velocity(Vector2(bird.speed, bird.get_linear_velocity().y))
		bird.set_gravity_scale(0)
		pass

	func update(delta):
		pass

	func input(event):
		pass

	func exit():
		bird.set_gravity_scale(prev_gravity_scale)
		bird.get_node(utils.get_anim()).stop();
		bird.get_node(utils.get_sprite()).position = Vector2(0,0)
		pass
		
class FlappingState:
	var bird

	func _init(bird):
		self.bird = bird
		bird.set_linear_velocity(Vector2(bird.speed, bird.get_linear_velocity().y))
		flap()

	func update(delta):
		if bird.rotation < deg2rad(-20):
			bird.rotation = deg2rad(-20)
			bird.set_angular_velocity(0)
		if bird.get_linear_velocity().y > 0 && bird.momentum <= 0:
			bird.speed_increase += 0.5
			if bird.speed_increase > 5:
				bird.speed_increase = 5
			bird.set_angular_velocity(bird.speed_increase)
			if bird.rotation > 1.33:
				bird.set_angular_velocity(0)
				
		bird.momentum -= 1

	func input(event):
		if event.is_action_pressed("flap") or (event is InputEventScreenTouch and event.pressed):
			flap()

	func exit():
		pass
		
	func on_body_entered(other_body):
		if other_body.is_in_group(game.GROUP_PIPES):
			bird.set_state(bird.STATE_HIT)
		elif other_body.is_in_group(game.GROUP_GROUNDS):
			bird.set_state(bird.STATE_GROUNDED)
		pass

	func flap():
		if bird.get_position().y < 12:
			return

		game.flaps += 1
		bird.speed_increase = 0
		bird.momentum = 25
		bird.set_linear_velocity(Vector2(bird.get_linear_velocity().x, -150))
		bird.set_angular_velocity(-12)
		bird.get_node(utils.get_anim()).play("flying")
		bird.get_node("sfx_wing").play()

class HitState:
	var bird
	func _init(bird):
		self.bird = bird
		bird.set_linear_velocity(Vector2(0,0))
		bird.set_angular_velocity(2)
		var other_body = bird.get_colliding_bodies()[0]
		bird.add_collision_exception_with(other_body)
		bird.get_node(utils.get_anim()).play("idle")
		bird.get_node("sfx_hit").play()
		bird.get_node("sfx_die").play()
		pass

	func update(_delta):
		pass

	func input(_event):
		pass

	func on_body_entered(other_body):
		if other_body.is_in_group(game.GROUP_GROUNDS):
			bird.set_state(bird.STATE_GROUNDED)
		pass

	func exit():
		pass

class GroundedState:
	var bird

	func _init(bird):
		self.bird = bird
		bird.get_node(utils.get_anim()).play("idle")
		bird.set_linear_velocity(Vector2(0,0))
		bird.set_angular_velocity(0)
		if bird.prev_state != bird.STATE_HIT:
			bird.get_node("sfx_hit").play()
		pass

	func update(_delta):
		pass

	func input(_event):
		pass

	func exit():
		pass
