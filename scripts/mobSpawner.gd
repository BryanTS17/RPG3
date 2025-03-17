extends Node2D

@export var array: Array[PackedScene]
@export var criadurasPorMinuto: float = 60.0
@export var ondaDuracao: float = 20.0
@export var monstrosPorOnda: float = 30.0
@export var breakIntensidade: float = 0.2
@export var path: PathFollow2D

var cooldown = 0.0
var tempo = 0.0

func _process(delta):
	tempo += delta

	# Calcula a taxa de spawn base
	var spawnRate = criadurasPorMinuto + monstrosPorOnda * ((tempo / 60.0) * 3) 

	# Aplica a variação da onda usando uma função senoidal
	var sin_wave = sin((tempo * TAU) / ondaDuracao)
	var onda_factor = remap(sin_wave, -1.0, 1.0, breakIntensidade, 1.0)

	spawnRate *= onda_factor  # Multiplica ao invés de somar para manter proporção

	# Calcula o tempo entre os spawns (criaturas por segundo)
	var criaturasPorSegundo = spawnRate / 60.0
	print(criaturasPorSegundo)
	if criaturasPorSegundo <= 0:
		return

	cooldown -= delta
	if cooldown > 0:
		return

	cooldown = 1.0 / criaturasPorSegundo  # Define o cooldown correto

	var point = spaw()
	var worldStatus = get_world_2d().direct_space_state
	var parametros = PhysicsPointQueryParameters2D.new()
	parametros.position = point
	var resultado: Array = worldStatus.intersect_point(parametros, 1)

	if not resultado.is_empty():
		return
		
	var numero = randi_range(0, array.size() - 1)
	var criatura_scene = array[numero]
	var criatura = criatura_scene.instantiate()
	criatura.global_position = point
	get_parent().add_child(criatura)

func spaw() -> Vector2:
	path.progress_ratio = randf()
	return path.global_position

