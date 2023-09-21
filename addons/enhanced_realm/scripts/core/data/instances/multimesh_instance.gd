@tool
@icon("res://addons/enhanced_realm/icons/icons8-ungroup-objects-24.png")
extends RealmInstance
class_name MultiMeshRealmInstance

@export var texture: Texture2D
@export var material: Material

var instance: MultiMeshInstance2D

func instantiate(coordinates: Array[Vector2i]) -> void:
	instance = MultiMeshInstance2D.new()
	
	var multimesh: MultiMesh = MultiMesh.new()
	var mesh: QuadMesh = QuadMesh.new()
	mesh.size = texture.get_size()

	if texture is AtlasTexture:
		var image: Image = texture.atlas.get_image()
		var icon: Image = Image.create(texture.region.size.x, texture.region.size.y, false, image.get_format())
		icon.blit_rect(image, texture.region, Vector2i.ZERO)
		instance.texture = ImageTexture.create_from_image(icon)
	else:
		instance.texture = texture
	
	multimesh.instance_count = len(coordinates)
	instance.material = material

	for i in len(coordinates):
		multimesh.set_instance_transform_2d(i, Transform2D(PI, get_global_coordinates(coordinates[i])))
	
	multimesh.mesh = mesh
	instance.multimesh = multimesh
	realm.instantiate(instance)

var icon: Texture2D:
	get: return texture