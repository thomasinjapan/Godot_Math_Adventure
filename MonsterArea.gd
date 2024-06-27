class_name MonsterArea
extends Node2D

# TODO: check if regions are still okay

#region Properties
var selectedSum:int:    # sum of all values in the selection
	get:
		return selectedSum
	set(newValue):
		selectedSum = newValue
		valueUpdated.emit(selectedSum)
#endregion

#region Variables
var selection:Array = []    # list of all currently selected fields must be of type SingfleField / arrays can't be strongly typed
var fieldList:Array=[]      ## is of all fields in order
#endregion

#region System Functions
# Called when the node enters the scene tree for the first time.
func _ready():
	createFieldArray()
	subscribe_to_signals()
#endregion

#region Signals
signal valueUpdated(int)    #triggers when the value of the selection was updated
#endregion

#region Signal Subscriptions
## subscribe
func subscribe_to_signals() -> void:
	# subscribe to all touch events of all singlefields
		for SingleSingleField in self.get_children():
			if SingleSingleField is SingleField:
				SingleSingleField.touched.connect(_on_singleField_touched)
				SingleSingleField.selected.connect(_on_singleField_selected)

## triggers if a field is touched and checks if it
## - creates a new selection
## - adds to an existing selection
## - starts a new selection
## - removes from a selection <-- not sure if I will implemented
func _on_singleField_touched(singleField:SingleField):
	print("touched:" + singleField.name)
	if selection == []:
		print("no selection so far")
		selection.append(singleField)
		singleField.select(SingleField.SELECTION_NONE)

	elif selection.has(singleField):
		print("field is already part of selection")
		# do nothing

	else: # check if how we handle the neighbors
		var neighborsFromSelection:Array = getNeighborFieldsInSelection(singleField)
		#if there are no fields are in selection that is neighboring the singleField, start a new selection
		if neighborsFromSelection[0]==null && \
				neighborsFromSelection[1]==null && \
				neighborsFromSelection[2]==null && \
				neighborsFromSelection[3]==null:
			for deselectField:SingleField in selection: deselectField.deselect()
			#select new field only and add to selection
			selection=[singleField]
			singleField.select(SingleField.SELECTION_NONE)
		else: 
			#add to slection and update connections between selections
			selection.append(singleField)
			var borders:int = SingleField.SELECTION_NONE

			# handle if the field above is in selection
			if neighborsFromSelection[0] != null:
				var neighbor:SingleField = neighborsFromSelection[0]
				borders |= SingleField.SELECTION_UP
				neighbor.addSelectionDirection(SingleField.SELECTION_DOWN)

			# handle if the field below is in selection
			if neighborsFromSelection[1] != null:
				var neighbor:SingleField = neighborsFromSelection[1]
				borders |= SingleField.SELECTION_DOWN
				neighbor.addSelectionDirection(SingleField.SELECTION_UP)

			# handle if the field left is in selection
			if neighborsFromSelection[2] != null:
				var neighbor:SingleField = neighborsFromSelection[2]
				borders |= SingleField.SELECTION_LEFT
				neighbor.addSelectionDirection(SingleField.SELECTION_RIGHT)

			# handle if the field above is in selection
			if neighborsFromSelection[3] != null:
				var neighbor:SingleField = neighborsFromSelection[3]
				borders |= SingleField.SELECTION_RIGHT
				neighbor.addSelectionDirection(SingleField.SELECTION_LEFT)

			singleField.select(borders)

	prints(selection)

## triggers if a field is selected
func _on_singleField_selected(singleField:SingleField):
	#recalculate sum
	var tmpSum:int = 0
	for field:SingleField in selection:
		tmpSum+=field.value

	selectedSum = tmpSum
	
	# emit info to game that sum was updated
#endregion

#region Internal Functions
## initialize the fieldArray
## since it is 2-dimensional it must be initialized manually
func createFieldArray():
	for x:int in range(0,4):
		for y:int in range(0,4):
			# prepare new line for next x
			fieldList.append(getFieldByCoordinate(x,y))
	prints(fieldList)

## retruns a field from all fields that match x and y coordinate; else null
func getFieldByCoordinate(x:int,y:int) -> SingleField:
	for SingleSingleField in self.get_children():
		if SingleSingleField is SingleField:
			if SingleSingleField.x == x && SingleSingleField.y == y:
				return SingleSingleField
	return null


## returns the field left of the field or null if empty
## slow - could be done with direct link to field in fieldarray-1 and catch overflow to earlier line
func getFieldToLeft(singleField:SingleField) -> SingleField:
	var newX = singleField.x-1
	if newX < 1:
		return null
	else:
		return getFieldByCoordinate(newX,singleField.y)
	
## returns the field right of the field or null if empty
## slow - could be done with direct link to field in fieldarray+1 and catch overflow to next line
func getFieldToRight(singleField:SingleField) -> SingleField:
	var newX = singleField.x+1
	if newX > 4:
		return null
	else:
		return getFieldByCoordinate(newX,singleField.y)
	
## returns the abope the field or null if empty
## slow - could be done with direct link to field in fieldarray-5 and catch overflow to earlier line
func getFieldAbove(singleField:SingleField) -> SingleField:
	var newY = singleField.y-1
	if newY < 0:
		return null
	else:
		return getFieldByCoordinate(singleField.x,newY)

## returns the field below the field or null if empty
## slow - could be done with direct link to field in fieldarray+5 and catch overflow to next line
func getFieldBelow(singleField:SingleField) -> SingleField:
	var newY = singleField.y+1
	if newY > 4:
		return null
	else:
		return getFieldByCoordinate(singleField.x,newY)

## returns a list of all fields that are in the selection and neighboring to this field
## order: above, below, left, right
func getNeighborFieldsInSelection(singleField:SingleField) -> Array:
	var result:Array=[]
	
	#find field in fieldlist
	# look at the neighboring fields and check if in selection
	var leftField:SingleField = getFieldToLeft(singleField)
	var rightField:SingleField = getFieldToRight(singleField)
	var topField:SingleField = getFieldAbove(singleField)
	var bottomField:SingleField = getFieldBelow(singleField)
	
	# if the field above is in selection, add it to result; else add null
	if selection.has(topField):
		result.append(topField)
	else:
		result.append(null)

	# if the field below is in selection, add it to result; else add null
	if selection.has(bottomField):
		result.append(bottomField)
	else:
		result.append(null)

	# if the field left is in selection, add it to result; else add null
	if selection.has(leftField):
		result.append(leftField)
	else:
		result.append(null)

	# if the field right is in selection, add it to result; else add null
	if selection.has(rightField):
		result.append(rightField)
	else:
		result.append(null)

	return result

## moves all monsters in row y one field to the left and returns the damage done
func attackRow(y:int) -> int:
	var result:int = 0  #no damage by default
	# for performance, get all fields
	var field1:SingleField=getFieldByCoordinate(1,y)
	var field2:SingleField=getFieldByCoordinate(2,y)
	var field3:SingleField=getFieldByCoordinate(3,y)
	var field4:SingleField=getFieldByCoordinate(4,y)
	
	# deal damage
	if getFieldByCoordinate(1,y).value>0: result = 1  #if there is a monster on the most left, deal damage
	
	# move all damages from left to right
	field1.value=field2.value
	field2.value=field3.value
	field3.value=field4.value
	
	# add new monster from right if feasible
	# TODO: implement logic to add new monster from right
	field4.value=0
	
	return result
#endregion




