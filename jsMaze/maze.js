
// constructor for Maze objects
//   squareSize:  the width/height in pixels of each square of the maze
function Maze(squareSize)
{
	//Squaresize must be an even number for square edges to work.  Thus, substract the mod 2 from the squaresize total
	this.squareSize = squareSize - ( squareSize % 2);
	console.log( "SQUARE SIZE " + this.squareSize);

	// this.walls = new Array(	1, 1, 1, 1, 1, 0, 1, 1,
	// 						1, 0, 0, 0, 0, 0, 0, 1,
	// 						1, 0, 1, 1, 1, 1, 0, 1,
	// 						1, 1, 1, 0, 1, 0, 0, 1,
	// 						1, 0, 1, 0, 1, 1, 0, 1,
	// 						1, 0, 1, 0, 1, 0, 0, 1,
	// 						1, 0, 0, 0, 0, 0, 0, 1,
	// 						1, 1, 1, 1, 1, 1, 1, 1
	// 					);

	this.walls = new Array(	1, 1, 1, 1, 1, 0, 1, 1,
							1, 0, 0, 0, 0, 0, 0, 1,
							1, 0, 1, 1, 1, 1, 0, 1,
							1, 0, 1, 0, 1, 0, 0, 1,
							1, 0, 1, 0, 1, 1, 0, 1,
							1, 0, 1, 0, 1, 0, 0, 1,
							1, 0, 0, 0, 0, 0, 0, 1,
							1, 1, 1, 1, 1, 1, 1, 1
						);

	this.dist = new Array(  -1, -1, -1, -1, -1, -1, -1, -1,
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
	this.animation;

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

	this.resetDist = function(){
		this.dist = new Array( this.height * this.width );
		for (var i = 0; i < this.dist.length; i++) {
			this.dist[i] = -1;
		};
	}

	this.getDist = function(x, y){
		var wallIndex = y * this.width + x;
		return this.dist[wallIndex];
	}

	this.setDist = function(x, y, d){
		var wallIndex = y * this.width + x;
		return this.dist[wallIndex] = d;
	}


	this.updateDist = function( x, y){
		//Dont update this if the square is a wall
		if( this.isWall( x, y )){
			return;
		}

		//If the goal, the distance is 0
		if( this.isGoal( x, y )){
			var wallIndex = y * this.width + x;
			this.dist[wallIndex] = 0;
			return;
		}
		//If surrounded by unassigned squares, you cannot assign the square, else, the number shold take the lowest possibility
		var newAss = this.isAssignable(x,y);
		if( newAss != -1 ) {
			var wallIndex = y * this.width + x;
			this.dist[wallIndex] = newAss;
		}


	}
	
	//Loop through the adjacent squares, if any of them are assigned return the incremented value of the lowest one
	this.isAssignable = function(x,y) {
		var assgn = -1;
		for (var i = 0; i < this.adjacency.length; i++) {
			var xTemp = x + this.adjacency[i][0];
			var yTemp = y + this.adjacency[i][1];
			//console.log( "why..." + xTemp + " "+ yTemp);
			if( this.isSquare( xTemp, yTemp) ){
				var d = this.getDist( xTemp, yTemp);
				if(  d != -1 && (assgn == -1 || d < assgn ) ){
					assgn = d + 1;
				}
			}
		};
		return assgn;
	}

	this.assignDist = function(){

		//Reset the distances
		this.resetDist();

		//queue holding squares to search
		var queue = new Array();
		
		//Set the distance of the goal as zero and add the goal to the queue
		this.setDist( this.goal[0], this.goal[1], 0 );
		queue.push( this.goal );

		//Continue searching until the queue is empty or the start has been found.
		while( queue.length != 0 ){
			//Pop the first element from the queue
			var arr = queue[0];
			queue.splice( 0, 1);

			var value = this.getDist(arr[0], arr[1]) + 1;



			//Check each of the elements next to the current one and add dist and to the queue if it is valid
			//A valid move happens if it is in the maze, not a wall, and not already labled
			for (var i = 0; i < this.adjacency.length; i++) {
				var adj = this.adjacency[i];
				var temp = [ (arr[0] + adj[0]), (arr[1] + adj[1]) ];
				if( this.isValidMove( temp[0], temp[1] ) ){
					this.setDist(temp[0], temp[1], value);
					queue.push( temp );

					if( this.isStart( temp[0], temp[1]) ){
						return;
					}
				}
			}
		}
	}

	this.isValidMove = function(x, y, newDist){
		//See if in bounds, valid location, or already assigned in the current BFS
		return !( (! this.isSquare(x, y)) || ( this.isWall(x,y) == 1 ) || ( this.getDist(x, y) != -1 ) );
	}

	//Create an array with the path from the start to the goal.
	this.createPath = function(){
		this.path = new Array();
		this.path.push( this.start );
		var tempVal = this.getDist(this.start[0], this.start[1]);

		while( tempVal > 0 ){
			var temp = this.path[this.path.length - 1];
			tempVal = this.getDist( temp[0], temp[1]);
			//console.log( "tempVAl "+ tempVal);

			//Loop through the adjacent locations and look for one with a lower distance, add it to the array and break
			for (var i = 0; i < this.adjacency.length; i++) {
				var xTemp = temp[0] + this.adjacency[i][0];
				var yTemp = temp[1] + this.adjacency[i][1];
				// Only continue if this is a legal square
				if( this.isSquare( xTemp, yTemp) ){
					var td = this.getDist(xTemp, yTemp);
					if( td != -1 && td < tempVal ){
						var t = [ xTemp, yTemp ];
						this.path.push( t );
						tempVal = td;
						break;
					}
				}

			}

		}
	}

	// assumes keys from a processing instance have been moved to the global
	//  namespace
	this.drawMaze = function(processing) {
		processing.background(230, 230, 230);

		
		for(var x = 0; x < this.width; x++) {
			for(var y = 0; y < this.height; y++) {
				this.drawLocation(processing, x, y);
				
			}	
		}

		//If the path has been created, draw it.
		if( this.path != undefined && this.path.length != 0 ){
			this.drawPath( processing );
		}

	}

	this.drawLocation = function(processing, x, y) {
		
		var sx = x * this.squareSize;
		var sy = y * this.squareSize; 

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

		if( this.getDist( x, y) != -1 ){
			this.drawDistance( processing, x, y );
		}
	}

	this.drawPath = function( processing ){
		for (var i = 0; i < this.path.length; i++) {
			var x = this.path[i][0];
			var y = this.path[i][1];
			var sx = x * this.squareSize;
			var sy = y * this.squareSize;
			processing.fill(242, 126, 32);
			processing.rect(sx, sy, this.squareSize, this.squareSize);

			this.drawDistance( processing, x, y);
		};
	}

	this.drawDistance = function( processing, x, y ){
		var sx = x * this.squareSize + Math.trunc( this.squareSize/2 ) ;
		var sy = y * this.squareSize + Math.trunc( this.squareSize/2 ); 
		//Draw distance

		//processing.textSize(15);
		processing.textAlign( 3, 3);
		processing.fill( 0 );
		var num = this.getDist(x, y);
		processing.text( num, sx, sy );
	}


}

function sketchMaze(processing) {

	console.log("Processing initialized");

	processing.size(300, 300);
	processing.background(10, 200, 10);

	var squareSize = Math.trunc(300/8);
	console.log( squareSize );

	maze = new Maze(squareSize);

	console.log("Maze created");
	
	processing.draw = function() {
		maze.drawMaze(processing);
		//console.log("draw function called");
	}

	processing.mousePressed = function() {
		//processing.textSize(12);
		//processing.text( processing.mouseX + " " + processing.mouseY, processing.mouseX, processing.mouseY );
		//console.log( Math.trunc(processing.mouseX / maze.squareSize)+ " " +processing.mouseY / maze.squareSize);

		var x = Math.trunc(processing.mouseX / maze.squareSize);
		var y = Math.trunc(processing.mouseY / maze.squareSize);

		maze.updateDist( x, y);
	}

	processing.keyPressed = function( ){
		var value = processing.key.code;

		//Run BFS only if 'b' is pressed.
		if( value == 98 ){
			maze.assignDist();
			maze.createPath();
		}

		//If 'r' is pressed, restart the search board
		if( value == 114 ){
			maze.resetPath();
			maze.resetDist();
		}
	}

	console.log("draw overridden");


}
