tool
extends MeshInstance
class_name RepeatMesh

export(Vector3) var repeat: Vector3 = Vector3(1,1,1) setget set_repeat
var my_mesh: Mesh = get_mesh()
var sm: SpatialMaterial = my_mesh.surface_get_material(0) 
#export(Texture) var setTexture setget set_texture
var prev_scale

func _ready():
	update_uv1_scale()

func _process(_delta):
	if prev_scale == null:
		prev_scale = scale
	else:
		if prev_scale != scale:
			update_uv1_scale()
			prev_scale = scale

func update_uv1_scale():
	sm.uv1_scale = scale * repeat

func set_repeat(vector: Vector3):
	repeat = vector
	update_uv1_scale()

#func set_texture(tex: Texture):
#	sm.set_texture(SpatialMaterial.TEXTURE_ALBEDO, tex)
