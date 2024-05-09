extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready():
	$allFields.valueUpdated.connect(_on_allFieldsValue_updated)

func _on_allFieldsValue_updated(value:int):
	print("new selection value: " + str(value))
