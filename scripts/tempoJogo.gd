extends Label

var tempo = 0

func _process(delta):
	tempo += delta
	var tempoFloori = floori(tempo)
	var tempoSegundos: int = floori(tempoFloori % 60)
	var tempoMinutos: int = floori(tempoFloori / 60) 
	text = "%02d:%02d" % [tempoMinutos, tempoSegundos]
	pass
