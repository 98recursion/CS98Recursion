package org.racineMountain.soduko;

import java.util.ArrayList;

public class Cell {

    private int linearPosition;
    private static Cell[] cellArray;
    private int frozenValue = 0;
    private int value = 0;
    private ArrayList<Integer> possibilities = new ArrayList<Integer>();

    public Cell(int linearPosition, Cell[] cellArray) {

	this.linearPosition = linearPosition;
	this.cellArray = cellArray;
	cellArray[linearPosition] = this;
	initialize();
    }
    //---------------------------------------------------------------
    public Cell(int linearPosition, Cell[] cellArray, int frozenValue) {
	
	this(linearPosition, cellArray);
	this.frozenValue = frozenValue;
    }

    public boolean isLastCell() {

	boolean isLastCell = false;
	if(linearPosition == 80) { isLastCell = true; }

	return isLastCell;
    }
    //-------------------------
    public boolean isFirstCell() {

	boolean isFirstCell = false;
	if(linearPosition == 0) { isFirstCell = true; }

	return isFirstCell;
    }

    public Cell getNextCell() throws Exception {

	if(isLastCell()) { throw(new Exception("no more cells")); }
	return cellArray[linearPosition + 1];
    }
    //-----------------------------------------
    public Cell getPreviousCell() throws Exception {

	if(isFirstCell()) { throw(new Exception("no more cells")); }
	return cellArray[linearPosition - 1];
    }

    public int getValue() { 
	if( isFrozen() ) { 
	    return frozenValue; 
	} else {
	    return value; 
	}
    }
    //----------------------------------------------------
    public void setValue(int value) { this.value = value; }

    public Cell[] getOtherRowCells() {
	int position = linearPosition;

	//move to the first column
	while(true) {
	    if( Util.identifyColumn(position) == 0 ) { break; }
	    position--;
	}

	Cell[] otherRowCells = new Cell[8];
	int index = 0;
	for(int localPosition = position; localPosition < position + 9; localPosition++) {

	    if(localPosition != linearPosition) { 
		otherRowCells[index++] = cellArray[localPosition];
	    }
	}

	return otherRowCells;
    }

    public Cell[] getOtherColumnCells() {
	int position = linearPosition;

	//move to the first row
	while(true) {
	    if(Util.identifyRow(position) == 0) { break; }
	    position = position - 9;
	}

	Cell[] otherColumnCells = new Cell[8];
	int index =0;
	for(int localPosition = position; localPosition < 81; localPosition += 9) {

	    if(localPosition != linearPosition) { 
		otherColumnCells[index++] = cellArray[localPosition];
	    }
	}

	return otherColumnCells;
    }

    public Cell[] getOtherBoxCells() {
	int box = Util.identifyBox(linearPosition);

	int index = 0;
	Cell[] otherBoxCells = new Cell[8];
	for(int position = 0; position < 81; position++) {
	    if( Util.identifyBox(position) == box ) {
		if( position != linearPosition ) {

		    otherBoxCells[index++] = cellArray[position];
		}
	    }
	}

	return otherBoxCells;
    }

    public boolean hasPossibilitiesLeft() {

	boolean hasPossibilitesLeft = true;

	if(isFrozen()) { hasPossibilitesLeft = false; }
	if(possibilities.size() == 0) { hasPossibilitesLeft = false; }

	return hasPossibilitesLeft;
    }

    public int nextPossibility() { 
	int possibility;

	if(isFrozen()) {
	    possibility = frozenValue;
	} else {
	    possibility = possibilities.remove(0).intValue();
	}

	return possibility;
    }

    public boolean isFrozen() {
	boolean isFrozen = true;
	if(frozenValue == 0) { isFrozen = false; }

	return isFrozen;
    }

    public static Cell firstCell() { return cellArray[0]; }
    //---------------------------------------------
    public static Cell lastCell() { return cellArray[80]; }

    public void freezeValue() { frozenValue = value; }

    public int getLinearPosition() { return linearPosition; }

    public void initialize() {

	if(!isFrozen()) {
	    possibilities = new ArrayList<Integer>();
	    for(int possibility = 1; possibility < 10; possibility++) {

		int index = Util.getRandomInt(possibilities.size());
		possibilities.add(index, new Integer(possibility));
	    }

	    setValue(0);
	}
    }
}//end class



