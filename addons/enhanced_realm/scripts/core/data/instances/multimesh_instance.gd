@tool
@icon("res://addons/enhanced_realm/icons/icons8-ungroup-objects-24.png")
extends RealmInstance
class_name MultiMeshRealmInstance

@export var texture: Texture2D

var instance: MultiMeshInstance2D

func instantiate(coordinates: Array[Vector2i]) -> void:
    instance = MultiMeshInstance2D.new()
    instance.multimesh = MultiMesh.new()
    instance.multimesh.mesh = QuadMesh.new()
    (instance.multimesh.mesh as QuadMesh).size = texture.get_size()
    instance.texture = texture
    instance.multimesh.instance_count = len(coordinates)

    for i in len(coordinates):
        instance.multimesh.set_instance_transform_2d(i, Transform2D(PI, get_global_coordinates(coordinates[i])))

    realm.instantiate(instance)