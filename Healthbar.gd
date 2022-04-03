extends Sprite3D

onready var bar = $Viewport/TextureProgress

func _ready():
	texture = $Viewport.get_texture()

func update(value, full):
	bar.max_value = full
	bar.value = value
