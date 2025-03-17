extends Node2D

@export var path: PathFollow2D
@export var array: Array[PackedScene]
@export var itensPorSegunto: float = 5
var contador: float = 0

func _process(delta):
	var player_position = GameManager.player_position
	
	position = player_position
	
	contador -= delta
	if contador > 0:
		return
	contador = 60 / itensPorSegunto
	
	var point = spaw()
	var world = get_world_2d().direct_space_state
	var parametros = PhysicsPointQueryParameters2D.new()
	parametros.position = point
	var resultado: Array = world.intersect_point(parametros, 1)
	
	if not resultado.is_empty(): return
	
	var numero = randi_range(0, array.size() - 1) 
	var criatura_scene = array[numero]
	var criatura = criatura_scene.instantiate()
	criatura.global_position = point
	get_parent().add_child(criatura)

func spaw() -> Vector2:
	path.progress_ratio = randf()
	return path.global_position
