class_name SingleField
extends Node2D

#region properties
@export var value:int = 0: #value of the field
	get:
		return value
	set(newValue):
		value=newValue
		updateLabel()
		valueUpdated.emit(self)
#endregion

#region variables
@export_group("location in field")
@export var x:int = 1
@export var y:int = 1

var isSelected:bool = false #defines if field is currently part of a selection

@export_group("Neighbors") ## List of all neighboring fields
@export var above:SingleField ## field above this field
@export var below:SingleField ## field below this field
@export var left:SingleField ## field left of this field
@export var right:SingleField ## field right of this field

#endregion

#region Signals
signal valueUpdated(Node2D)
#endregion

#region system functions

# Called when the node enters the scene tree for the first time.
func _ready():
	updateLabel()
#endregion

#region UI functions

#updtest the label based on the current value 
func updateLabel():
	%label.text = str(value)

#endregion

#region input

#register of mouse was clicked on field
@warning_ignore("unused_parameter")
func _on_area_2d_input_event(viewport, event, shape_idx):
	#TODO: add swipe into the field
	if (event is InputEventMouseButton):
		if event.pressed:
			print(value)
			print("left:" + str(left.value))
#endregion
