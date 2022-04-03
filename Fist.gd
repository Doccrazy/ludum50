extends Area

export(String) var hand;

# Declare member variables here. Examples:
# var a = 2
# var b = "text"

var lastPosition = Vector3(0,0,0)
var velocityCache = []
var left = 1;

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func _physics_process(delta):
	var velocity = (global_transform.origin - lastPosition) / delta
	velocityCache.push_back(velocity)
	if (velocityCache.size() > 10):
		velocityCache.pop_front()
	lastPosition = global_transform.origin
	left -= delta
	if (left < 0):
		#print_debug(velocity)
		left += 1

func _on_Fist_area_entered(area: Area):
	var totalVelocity = Vector3(0, 0, 0)
	for v in velocityCache:
		totalVelocity += v
	area.emit_signal("hit", totalVelocity / velocityCache.size(), global_transform.origin)
	print_debug("Enter " + hand + " " + area.name)


func _on_RightHandController_button_pressed(button):
	pass
