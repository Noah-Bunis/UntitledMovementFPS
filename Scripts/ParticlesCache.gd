extends CanvasLayer

var BulletPreload = preload("res://Assets/materials/Bullet.tres")
var FlashPreload = preload("res://Assets/materials/Flash.tres")
var GlassPreload = preload("res://Assets/materials/Glass.tres")
var ShellPreload = preload("res://Assets/materials/Shell.tres")
var materials = [BulletPreload,FlashPreload,GlassPreload,ShellPreload]

func _ready():
	for material in materials:
		var particles_instance = Particles.new()
		particles_instance.set_process_material(material)
		particles_instance.set_one_shot(true)
		particles_instance.set_emitting(true)
		self.add_child(particles_instance)
