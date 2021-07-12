extends Area2D

var shape


func _ready():
	pass


func set_texture(tex):
	#Set the sprite texture
	get_node("Sprite").set_texture(tex)
	
	
func get_texture():
	#Return the sprite texture
	return get_node("Sprite").get_texture()
	
	
func set_region_rect(rect):
	#Set the sprite region and default collision shape
	get_node("Sprite").set_region_rect(rect)
	set_collision_shape("square")
	
	
func get_region_rect():
	#Return the sprite region
	return get_node("Sprite").get_region_rect()
	
	
func set_collision_shape(shape):
	#Set the collsion shape type
	var size = get_node("Sprite").get_region_rect().size
	var left = -size.x / 2
	var right = -left
	var top = -size.y / 2
	var bottom = -top
	var shape_obj
	
	if shape == "square":
		shape_obj = RectangleShape2D.new()
		shape_obj.set_extents(Vector2(size.x / 2, size.y / 2))
		
	elif shape == "slope-L":
		shape_obj = ConvexPolygonShape2D.new()
		shape_obj.set_points(PoolVector2Array([
		    Vector2(left, bottom),
		    Vector2(right, bottom),
		    Vector2(right, top)
		]))
		
	elif shape == "slope-R":
		shape_obj = ConvexPolygonShape2D.new()
		shape_obj.set_points(PoolVector2Array([
		    Vector2(left, top),
		    Vector2(left, bottom),
		    Vector2(right, bottom)
		]))
		
	get_node("CollisionShape2D").set_shape(shape_obj)
	self.shape = shape
