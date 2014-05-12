
// constructor for Maze objects
//   squareSize:  the width/height in pixels of each square of the maze
function Maze(squareSize)
{

	this.squareSize = squareSize;

//	 this.walls = new Array( 1, 1, 1, 1, 1, 0, 1, 1,
//							 1, 0, 0, 0, 0, 0, 0, 1,
//							 1, 0, 1, 1, 1, 1, 0, 1,
//							 1, 1, 1, 0, 1, 0, 0, 1,
//							 1, 0, 1, 0, 1, 1, 0, 1,
//							 1, 0, 1, 0, 1, 0, 0, 1,
//							 1, 0, 0, 0, 0, 0, 0, 1,
//							 1, 1, 1, 1, 1, 1, 1, 1
//						 );
	
	this.walls = new Array(	1, 1, 1, 1, 1, 0, 1, 1,
							1, 0, 0, 0, 0, 0, 0, 1,
							1, 0, 1, 1, 1, 1, 0, 1,
							1, 0, 1, 0, 1, 0, 0, 1,
							1, 0, 1, 0, 1, 1, 0, 1,
							1, 0, 1, 0, 1, 0, 0, 1,
							1, 0, 0, 0, 0, 0, 0, 1,
							1, 1, 1, 1, 1, 1, 1, 1
	);
	
	this.dist = new Array(	-1, -1, -1, -1, -1, -1, -1, -1,
							-1, -1, -1, -1, -1, -1, -1, -1,
							-1, -1, -1, -1, -1, -1, -1, -1,
							-1, -1, -1, -1, -1, -1, -1, -1,
							-1, -1, -1, -1, -1, -1, -1, -1,
							-1, -1, -1, -1, -1, -1, -1, -1,
							-1, -1, -1, -1, -1, -1, -1, -1,
							-1, -1, -1, -1, -1, -1, -1, -1
	);

	this.width = 8;
	this.height = 8; 
	
	this.adjacency = [  [-1, 0],
	[ 1, 0],
	[ 0,-1],
	[ 0, 1]
	];
	
	// this.start = new Array( 5, 0);
	// this.goal = new Array ( 5, 5);
	
	this.start = new Array( 3, 3);
	this.goal = new Array ( 5, 0);
	
	this.path;
	

// ----- Control methods to access internal structures -------
	
	this.isWall = function(x, y) {
		var wallIndex = y * this.width + x;
		return this.walls[wallIndex];
	}
	
	this.isSquare = function(x,y){
		return ( x >= 0 && x < this.width && y >= 0 && y < this.height );
	}
	
	this.isStart = function(x, y) {
		return ( x == this.start[0]) && ( y == this.start[1]);
	}
	
	this.isGoal = function(x, y) {
		return ( x == this.goal[0]) && ( y == this.goal[1]);
	}
	
	this.resetPath = function (){
		this.path = new Array();
	}
	
	
	
	
	
	
	
// ----- Methods to draw the current representation of the maze -----
	
	this.drawMaze = function(processing) {
		processing.background(230, 230, 230);

		
		for(var x = 0; x < this.width; x++) {
			for(var y = 0; y < this.height; y++) {
				this.drawLocation(processing, x, y);
				
			}	
		}

	}

	this.drawLocation = function(processing, x, y) {
		
		sx = x * this.squareSize;
		sy = y * this.squareSize; 

		if(this.isWall(x, y)) {

			processing.color(0, 100, 0);
			processing.fill(0, 100, 0);
			processing.rect(sx, sy, this.squareSize, this.squareSize);
	
			//processing.textSize(this.squareSize / 2);
			//processing.textAlign(CENTER, CENTER);

			//processing.text(1, (sx + this.squareSize / 2), (sy + this.squareSize / 2)) ;

		} else {
			processing.color(0, 0, 0);
			processing.fill(255, 255, 255);
			processing.rect(sx, sy, this.squareSize, this.squareSize);

		}

	}


}

function sketchMaze(processing) {
	
	console.log("Processing initialized");

	processing.size(300, 300);
	processing.background(10, 200, 10);


	maze = new Maze(300/ 8);

	console.log("Maze created");
	
	processing.draw = function() {
		maze.drawMaze(processing);
		//console.log("draw function called");
	}

	processing.mousePressed = function() {
		processing.textSize(12);
		processing.text( processing.mouseX + " " + processing.mouseY, processing.mouseX, processing.mouseY );
		//console.log("a");
	}


	console.log("draw overridden");

}