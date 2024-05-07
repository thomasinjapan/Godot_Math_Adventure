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

#endregion

#region Signals
signal valueUpdated(SingleField)   # emits if the value of a field has changed
signal touched(SingleField)        # emits if field is touched and needs to be checked if it may be selected
signal selected(SingleField)       # emits if a field was selected
signal deselected(SingleField)     # emits if field selection ends
#endregion

#region system functions

# Called when the node enters the scene tree for the first time.
func _ready():
	updateLabel()
#endregion

#region UI functions

#updates the label based on the current value 
func updateLabel():
	%label.text = str(value)

#endregion

#region input

#register if mouse was clicked on field
@warning_ignore("unused_parameter")
func _on_area_2d_input_event(viewport, event, shape_idx):
	#TODO: add swipe into the field
	if (event is InputEventMouseButton):
		if event.pressed:
			print(value)
			touched.emit(self)
#endregion

## selects the field
func select():
	isSelected = true
	selected.emit(self)
