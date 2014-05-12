
// constructor for Maze objects
//   squareSize:  the width/height in pixels of each square of the maze
function Maze(squareSize)
{

	this.squareSize = squareSize;
	console.log( "SQUARE SIZE " + this.squareSize);
	

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
	
	this.getDist = function(x, y){
		var wallIndex = y * this.width + x;
		return this.dist[wallIndex];
	}
	
	
	
	
	
	
// ----- Methods to draw the current representation of the maze -----
	
	this.drawMaze = function(processing) {
		processing.background(230, 230, 230);

		
		for(var x = 0; x < this.width; x++) {
			for(var y = 0; y < this.height; y++) {
				console.log( "square....");
				this.drawLocation(processing, x, y);
				
			}	
		}

	}

	this.drawLocation = function(processing, x, y) {
		
		sx = x * this.squareSize;
		sy = y * this.squareSize; 
		
		if(this.isWall(x, y)) {
			processing.fill(13, 112, 22);
		} else if( this.isStart(x, y)){
			processing.fill(237, 221, 29);
		} else if( this.isGoal( x, y)){
			processing.fill(22, 117, 168);
		} else {
			processing.fill(255, 255, 255);
		}
		processing.rect(sx, sy, this.squareSize, this.squareSize);
		
		//if( this.getDist( x, y) != -1 ){
			this.drawDistance( processing, x, y );
		//}

	}
	
	this.drawDistance = function( processing, x, y ){
		console.log( "distance?");
		var sx = x * this.squareSize + (~~( this.squareSize/2 ));
		console.log( "square?")
		
		var sy = y * this.squareSize + (~~( this.squareSize/2 )); 
		//Draw distance
		
		console.log( "1");
		//processing.textSize(15);
		processing.textAlign( 3, 3);
		console.log( "2");
		processing.fill( 0 );
		console.log( "3");
		
		processing.stroke( 0 );
		console.log( "4");
		
		var num = this.getDist(x, y);
		console.log( "5");
		
		processing.text( num, sx, sy );
		console.log( "6");
		
		console.log( "distance end.");
	}


}

function sketchMaze(processing) {
	
	console.log("Processing initialized");

	processing.size(300, 300);
	processing.background(10, 200, 10);

	//var sqSz = Math.trunc(300/8);
	var sqSz = (~~( 300 / 8));
	console.log( sqSz );
	
	//maze = new Maze(sqSz);

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