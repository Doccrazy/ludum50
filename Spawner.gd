extends Spatial

var zombieScene = preload("res://zombie.tscn")

# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_Timer_timeout():
	if (get_node("/root/Scene/Zombies").get_child_count() < 5):
		var zombie = zombieScene.instance()
		zombie.transform.origin = global_transform.origin + Vector3(0, 0.5, 0)
		get_node("/root/Scene/Zombies").add_child(zombie)
