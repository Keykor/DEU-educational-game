extends Timer

func _ready():
	pass # Replace with function body.


func _process(delta):
	find_node("Label").set_text(str(time_left))
	pass
