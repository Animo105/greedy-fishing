extends RigidBody2D
class_name FishRigidBody

func _init(texture : Texture2D) -> void:
	var on_screen_notifier : VisibleOnScreenNotifier2D = VisibleOnScreenNotifier2D.new()
	on_screen_notifier.screen_exited.connect(_not_on_screen)
	var physics_material : PhysicsMaterial = PhysicsMaterial.new()
	physics_material.bounce = 0.2
	physics_material_override = physics_material
	var collision_shape : CollisionShape2D = CollisionShape2D.new()
	add_child(collision_shape)
	var shape : CircleShape2D = CircleShape2D.new()
	shape.radius = 32
	collision_shape.shape = shape
	var sprite : Sprite2D = Sprite2D.new()
	sprite.scale = Vector2(0.3, 0.3)
	sprite.texture = texture
	add_child(sprite)

func _not_on_screen():
	queue_free()
