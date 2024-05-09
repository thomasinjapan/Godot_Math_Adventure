class_name SingleField
extends Node2D

#region constants and enumerations
const SELECTION_NONE = 0
const SELECTION_UP = 1
const SELECTION_DOWN = 2
const SELECTION_LEFT = 4
const SELECTION_RIGHT = 8
const SELECTION_ALL = 15

enum enumSelectionDirection {SELECTION_NONE, SELECTION_UP, SELECTION_DOWN, SELECTION_LEFT, SELECTION_RIGHT, SELECTION_ALL}



#endregion

#region properties
@export var value:int = 0: #value of the field
	get:
		return value
	set(newValue):
		value=newValue
		updateLabel()
		valueUpdated.emit(self)

@export var selectionBorder:enumSelectionDirection = SELECTION_ALL: ## current selection border directions
	get:
		return selectionBorder
	set(direction):
		selectionBorder=value

var isSelectionUp:bool :
	get:
		return selectionBorder & SELECTION_UP == SELECTION_UP
		
var isSelectionDown:bool :
	get:
		return selectionBorder & SELECTION_DOWN == SELECTION_DOWN

var isSelectionLeft:bool :
	get:
		return selectionBorder & SELECTION_LEFT == SELECTION_LEFT

var isSelectionRight:bool :
	get:
		return selectionBorder & SELECTION_RIGHT == SELECTION_RIGHT

## defines if field is currently part of a selection
var isSelected:bool = false :
	get:
		return isSelected
	set(value):
		if isSelected && not value:
			selected.emit(self)
		elif not isSelected && value:
			deselected.emit(self)
		else:
			pass
		isSelected=value
#endregion

#region variables
@export_group("location in field")
@export var x:int = 1
@export var y:int = 1
#endregion

#region functions
## adds the selection directions to the selection of the field
## !!! does not trigger a signal if the selection status changes
func addSelectionDirection(directions:enumSelectionDirection):
	# add selection direction to all current directions
	selectionBorder |= directions


## removes the selection directions from the selection of the field
## !!! does not trigger a selection if the selection status changes
func removeSelectionDirection(directions:enumSelectionDirection):
	# remove selection direction to all current directions
	selectionBorder =  selectionBorder | ~directions

## selects the field and marks all relevant borders
func select(borderDirection:enumSelectionDirection):
	# add border
	addSelectionDirection(borderDirection)
	
	updateBorders()
	
	# emit signal if selection is new
	if not isSelected:
		selected.emit(self)
		
## deselects the field and removes all UI markers
func deselect():
	# remove borders
	removeSelectionDirection(SELECTION_ALL)
	
	updateBorders()
	
	# emit signal if selection is new
	if isSelected:
		deselected.emit(self)

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

## updates the label based on the current value 
func updateLabel():
	%label.text = str(value)

## updates the borders of the ui based on the current borderselection and if the field is selected at all
func updateBorders():
	pass
	# TODO: implement

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
