extends Timer

var save_time_left
var game_time

func _ready():
	game_time = 30.0
	save_time_left = game_time

func _process(delta):
	find_node("Label").set_text(str(time_left).split(".")[0])

func start_game():
	start(game_time)

func pause_game():
	save_time_left = time_left
	stop()

func continue_game():
	start(save_time_left)
	
func end_game():
	stop()

func set_game_time(new_game_time):
	game_time = new_game_time

func hide():
	$ColorRect.hide()
	$Label.hide()
	
func show():
	$ColorRect.show()
	$Label.show()
