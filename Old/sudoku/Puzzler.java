package org.racineMountain.soduko;

import java.util.ArrayList;
import java.util.Date;

import java.text.SimpleDateFormat;

public class Puzzler {

    private boolean solutionExists   = false;
    private boolean solutionIsUnique = true;
    private int numberOfSolutions;

    private Cell[] cellArray;
    private Cell[] cellArrayBackup;

    public Puzzler() {}

    public void execute() throws Exception {

	cellArray = new Cell[81];
	for(int index = 0; index < cellArray.length; index++) {
	    cellArray[index] = new Cell(index, cellArray);
	}

	solvePuzzle(Cell.firstCell());

	for(int index = 0; index < cellArray.length; index++) {
	    cellArray[index].freezeValue();
	}

	increasePuzzleDifficulty();

	//Util.printLinear(extractPuzzle());

    }

    private void solvePuzzle(Cell cell) throws Exception {

	if(cell.isFrozen()) {

	    if(possibilityWorks(cell)) {
		if(cell.isLastCell()) { 
		    solutionExists = true; 
		} else {
		    solvePuzzle(cell.getNextCell());
		}
	    }

	} else {

	    while(cell.hasPossibilitiesLeft()) {
		
		if(solutionExists) { break; }
		
		cell.setValue(cell.nextPossibility());
		
		if(possibilityWorks(cell)) {
		    
		    if(cell.isLastCell()) { 
			solutionExists = true; 
			break;
		    } else {
			
			solvePuzzle(cell.getNextCell());
		    }
		    
		}
	    }
	    
	    if(!solutionExists) { cell.initialize(); }
	}
    }

    private void testUniqueness(Cell cell) throws Exception {
	//System.out.print(cell.getLinearPosition()+"-");//debug
	if(cell.isFrozen()) {

	    if(possibilityWorks(cell)) {
		if(cell.isLastCell()) { 
		    numberOfSolutions++;
		} else {
		    testUniqueness(cell.getNextCell());
		}
	    }

	} else {

	    while(cell.hasPossibilitiesLeft()) {
		
		if(numberOfSolutions > 1) { break; }
		
		cell.setValue(cell.nextPossibility());
		
		if(possibilityWorks(cell)) {
		    
		    if(cell.isLastCell()) { 
			numberOfSolutions++;		       		    
			break;
		    } else {
			testUniqueness(cell.getNextCell());
		    }
		    
		}
	    }
	    
	    cell.initialize();
	}
    }

    private void testUniquenessOld(Cell cell) throws Exception {

	if(!cell.isFrozen()) {

	    while(cell.hasPossibilitiesLeft()) {

		if(!solutionIsUnique) { break; }
		
		cell.setValue(cell.nextPossibility());

		if(possibilityWorks(cell)) {

		    solutionIsUnique = false;
		    break;
		}
	    }

	}//end if not frozen

	if(!cell.isFirstCell()) { testUniqueness(cell.getPreviousCell()); }
    }


    private void increasePuzzleDifficulty() throws Exception {
	int[] puzzle;

	ArrayList<Integer> possibleBlanks = new ArrayList<Integer>();
	for(int index = 0; index < 81; index++) {
	    possibleBlanks.add(Util.getRandomInt(possibleBlanks.size()), index);
	}

	while(possibleBlanks.size() > 0) {

	    int[] goodPuzzle = extractPuzzle();

	    Integer possibleBlank = possibleBlanks.remove(0);
	    int linearPosition = possibleBlank.intValue();

	    if(cellArray[linearPosition].getValue() == 0) { continue; }

	    boolean positionLocated = false;
	    for(int boxRow = 0; boxRow < 3; boxRow++) {
		if(positionLocated) { break; }
		for(int row = 0; row < 3; row++) {
		    if(positionLocated) { break; }
		    for(int boxColumn = 0; boxColumn < 3; boxColumn++) {
			if(positionLocated) { break; }
			for(int column = 0; column < 3; column++) {
			
			    int position = Util.linearize(boxRow, row, boxColumn, column);
			    if(linearPosition == position) {

				//create blank
				cellArray[position] = new Cell(position, cellArray);

				//apply symmetry
				position = Util.linearize(2 - boxRow,
							  2 - row,
							  2 - boxColumn, 
							  2 - column);

				cellArray[position] = new Cell(position, cellArray);
				
				positionLocated = true;
				break;
			    }
			}
		    }
		}
	    }

	    System.out.print("\r                                   " );
	    System.out.print("\rpossible blanks left to asses: " + possibleBlanks.size());

	    int[] newPuzzle = extractPuzzle();

	    //solutionExists = false;
	    //solvePuzzle(Cell.firstCell());

	    solutionIsUnique = true;
	    numberOfSolutions = 0;
	    testUniqueness(Cell.firstCell());

	    if(numberOfSolutions > 1) { solutionIsUnique = false; } 
	    
	    if(solutionIsUnique) {
		replacePuzzle(newPuzzle);
		
	    } else {
		replacePuzzle(goodPuzzle);
	    } 

	}//end while

    }


    private boolean possibilityWorks(Cell cell) {

	boolean solutionWorks = true;

	Cell[] rowArray = cell.getOtherRowCells();
	for(int index = 0; index < rowArray.length; index++) {
	    if(cell.getValue() == rowArray[index].getValue()) { 
		solutionWorks = false;
		break;
	    }
	}

	if(solutionWorks) {
	    Cell[] columnArray = cell.getOtherColumnCells();
	    for(int index = 0; index < columnArray.length; index++) {
		if(cell.getValue() == columnArray[index].getValue()) { 
		    solutionWorks = false;
		    break;
		}
	    }
	}

	if(solutionWorks) {
	    Cell[] boxArray = cell.getOtherBoxCells();
	    for(int index = 0; index < boxArray.length; index++) {
		if(cell.getValue() == boxArray[index].getValue()) { 
		    solutionWorks = false;
		    break;
		}
	    }
	}
	return solutionWorks;
    }

    //---------------------------
    private void replacePuzzle(int[] puzzle) {

	for(int index = 0; index < puzzle.length; index++) {

	    if(puzzle[index] == 0) {
		cellArray[index] = new Cell(index, cellArray);
	    } else {
		cellArray[index] = new Cell(index, cellArray, puzzle[index]);
	    }
	}
    }

    private int[] extractPuzzle() {

	int[] puzzle = new int[81];
	for(int index = 0; index < puzzle.length; index++) {
	    puzzle[index] = cellArray[index].getValue();
	}

	return puzzle;
    }

    public static void main(String[] args) {
	try {

	    long MAX_TIME        = 86400000;//24 hours
	    long START_UP_TIME   = 3600000;//1 hour
	    int  maxDifficulty   = 0;
	    int  minDifficulty   = 1000;
	    long restartTime     = (new Date()).getTime();

	    SimpleDateFormat sdf = new SimpleDateFormat("yyyyMMdd");

	    ThreadGroup ftpThreadGroup = new ThreadGroup("FTPThreadGroup");

	    while(true) {

		Puzzler puzzler = new Puzzler();

		System.out.println();
		puzzler.execute();
		System.out.println();

		int difficulty = GeneratePuzzle.calculateDifficulty(puzzler.extractPuzzle());

		String fileName = args[0] + //path
		    "Diff-" + difficulty + "-" +
		    sdf.format(new Date()) +
		    ".sod";
		
		Util.writeLinearToFile(puzzler.extractPuzzle(), fileName);

		fileName = fileName.replace(".sod", ".htm");

		String diffDate = fileName.replace(".htm", "");

		Util.writeLinearUsingTemplate(puzzler.extractPuzzle(), fileName, diffDate);


		String remoteFileName;
		boolean goToSleep;

		if(difficulty < minDifficulty) {
 
		    minDifficulty = difficulty;
		    remoteFileName = "easySudoku.html";
		    goToSleep = true;

		} else if(difficulty > maxDifficulty) { 

		    maxDifficulty = difficulty;
		    remoteFileName = "hardSudoku.html";
		    goToSleep = true;

		} else {

		    remoteFileName = "sudoku.html";
		    goToSleep = false;

		}//end if

		// FTP the file to server
		try {

		    //if threads are piling up we'll give them a minute, then bail
		    if(ftpThreadGroup.activeCount() > 9) {
			Thread.sleep(60000); 
			System.out.println("interrupting " 
					   + ftpThreadGroup.activeCount() 
					   + " ftp threads");
			ftpThreadGroup.interrupt(); 
		    } else {
			System.out.println("ftp thread count: " 
					   + ftpThreadGroup.activeCount());
		    }

		    Thread ftpThread = new Thread(ftpThreadGroup, 
						  new FTPThread(fileName, remoteFileName));
		    ftpThread.setDaemon(true);
		    ftpThread.start();

		    System.out.println("sending file: " + remoteFileName);
		    System.out.println("difficulty: " + difficulty);
		    System.out.println("maxDifficulty: " + maxDifficulty);
		    System.out.println("minDifficulty: " + minDifficulty);

		}catch(Exception ftpE) {
		    System.out.println(ftpE);
		}

		long time = (new Date()).getTime();

		//reset 
		if(time - restartTime > MAX_TIME) {
		    restartTime = time;
		    maxDifficulty = 0;
		    minDifficulty = 1000;

		}

		//get re-established
		if(time - restartTime > START_UP_TIME) {
		    System.out.println("time: " + (new Date(time)));
		    System.out.println("restartTime: " + (new Date(restartTime)));

		    if(goToSleep) { 
			System.out.println("going to sleep now");
			Thread.sleep(3600000); 
		    }
		}

	    }//end while

	} catch(Exception e) {
	    e.printStackTrace();
	}
    }
}
    





