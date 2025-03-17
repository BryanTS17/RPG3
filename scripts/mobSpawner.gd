extends Node2D

@export var array: Array[PackedScene]
@export var raridadeMonstro: Array[float]
@export var criadurasPorMinuto: float = 60.0
@export var ondaDuracao: float = 20.0
@export var monstrosPorOnda: float = 30.0
@export var breakIntensidade: float = 0.1
@export var path: PathFollow2D

var player
var cooldown = 0.0
var tempo = 0.0
var dificuldade

func _ready():
	player = GameManager.player
	dificuldade = 1

func _process(delta):
	tempo += delta
	
	if tempo/60 >= 1.5:
		dificuldade = 2
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

	if not resultado.is_empty():		return
		
	var numero = randf_range(0, 1)
	numero = escolherMonstro(array , raridadeMonstro ,numero)
	
	var criatura_scene = array[numero]
	var criatura = criatura_scene.instantiate()
	criatura.global_position = point
	get_parent().add_child(criatura)

func spaw() -> Vector2:
	path.progress_ratio = randf()
	return path.global_position
	
func escolherMonstro(array: Array, raridade: Array, numero: float) -> int:
	var i = 0
	var contador = 0
	
	# telho que colocar mais monstros e raridade neles
	if dificuldade == 2:
		i = 3
		
	for mostro in array:
		if contador == 3:
			return 0
		else:
			if numero < raridade[i]:
				return i
			else: 
				i += 1
				contador += 1
	return 0
	pass

