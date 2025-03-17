extends Node2D

@export var cenario: Node2D
@export var soldado: PackedScene

@export var marker1: Marker2D
@export var marker2: Marker2D
@export var marker3: Marker2D
@export var marker4: Marker2D

var array: Array[Marker2D]

func _ready() -> void:
	array.append(marker1)
	array.append(marker2)
	array.append(marker3)
	array.append(marker4)
	for marca in array:
		#criar uma intancia do soldado
		var intanciaSoldado = soldado.instantiate()
		intanciaSoldado.position = marca.position
		cenario.add_child(intanciaSoldado)
		#colocar cada um em uma marca no cenario
	
