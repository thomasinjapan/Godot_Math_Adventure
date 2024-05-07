extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready():
	$allFields.valueUpdated.connect(_on_allFieldsValue_updated)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _on_allFieldsValue_updated(value:int):
	print("new selection value: " + str(value))
