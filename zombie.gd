extends RigidBody

# Declare member variables here. Examples:
# var a = 2
# var b = "text"

var time = 0
var lastHit = 0
var health = 100
var maxHealth = 100
var hitStrength = 5
var hitForceScale = 20
var speed = 0.8
var isOnFloor = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	get_node("Head").connect("hit", self, "_on_hit_head")
	get_node("Torso").connect("hit", self, "_on_hit_torso")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	time += delta

func look_follow(state, current_transform: Transform, target_position: Vector3):
	var up_dir = Vector3(0, 1, 0)
	var cur_dir = current_transform.basis.xform(Vector3(0, 0, 1))
	var target_dir = current_transform.origin.direction_to(target_position)
	var rotation_angle = cur_dir.signed_angle_to(target_dir, up_dir)

	#state.set_angular_velocity(up_dir * (rotation_angle / state.get_step()))
	state.set_angular_velocity(Vector3(0, .5 if rotation_angle > 0 else -.5, 0))

func move(state):
	var player = get_node("/root/Scene/Player/ARVRCamera")
	var target_position = player.get_global_transform().origin
	look_follow(state, get_global_transform(), target_position)
	
	if (global_transform.origin.distance_to(target_position) > 1):
		linear_velocity = global_transform.basis.z * speed
	else:
		linear_velocity = Vector3(0, 0, 0)

func _integrate_forces(state):
	if (health > 0 && time - lastHit > 1):
		move(state)

func _on_AnimationPlayer_animation_finished(anim_name):
	if (health > 0):
		get_node("AnimationPlayer").play("Walk")	

func _on_hit_head(velocity: Vector3, hitpoint: Vector3):
	hitMe(velocity, hitpoint, true)

func _on_hit_torso(velocity: Vector3, hitpoint: Vector3):
	hitMe(velocity, hitpoint, false)

func hitMe(velocity: Vector3, hitpoint: Vector3, isHead):
	if (time - lastHit > 0.5):
		print_debug("HIT " + ("head " if isHead else "body "), velocity.length(), " ", to_local(hitpoint).y)
		apply_impulse(Vector3(0, to_local(hitpoint).y, 0), velocity * hitStrength/hitForceScale)
		lastHit = time
		health -= velocity.length() * hitStrength
		$HealthBar.update(health, maxHealth)
		if (health <= 0):
			get_node("AnimationPlayer").stop()
			axis_lock_angular_x = false
			axis_lock_angular_z = false
			$Timer.start(-1)


func _on_Timer_timeout():
	queue_free()


func _on_zombie_body_entered(body: Node):
	if (body.collision_layer & 2):
		isOnFloor += 1

func _on_zombie_body_exited(body: Node):
	if (body.collision_layer & 2):
		isOnFloor -= 1
