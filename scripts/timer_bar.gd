extends TextureProgressBar


func _ready():
	get_owner().score_changed.connect(update)
	update()
	

func update():
	value = 8000 - get_owner().score / 10
