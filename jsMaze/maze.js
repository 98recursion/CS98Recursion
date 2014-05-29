
// constructor for Maze objects
//   squareSize:  the width/height in pixels of each square of the maze
function Maze(squareSize)
{
	//Squaresize must be an even number for square edges to work.  Thus, substract the mod 2 from the 
	//squaresize total
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

	//Initialize this to -1's but will be updated at the end of the file for bfs and then never changed.
	this.bfs = new Array(	-1, -1, -1, -1, -1, -1, -1, -1,
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

	this.distCounters;

	// ----- Methods controlling access to internal structures -----

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

	this.getBFS = function(x, y){
		var wallIndex = y * this.width + x;
		return this.bfs[wallIndex];
	}

	this.setBFS = function(x, y, d){
		var wallIndex = y * this.width + x;
		return this.bfs[wallIndex] = d;
	}

	this.resetBFS = function(){
		this.bfs = new Array( this.height * this.width );
		for (var i = 0; i < this.dist.length; i++) {
			this.bfs[i] = -1;
		};
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




	// ----- Methods for updating the distance in response to a mouse click -----

	this.updateDist = function( x, y){
		//Dont update this if the square is a wall
		if( this.isWall( x, y )){
			return;
		}

		//Don't reassign if it already has been.
		if( this.getDist( x, y ) !== -1 ) {
			return;
		}

		//If the goal, the distance is 0
		if( this.isGoal( x, y )){
			this.currentDistance( 0 );
			var wallIndex = y * this.width + x;
			this.dist[wallIndex] = 0;
			return;
		}

		var newAss = this.isAssignable(x,y);

		//If the square is assigned, check to see if it is of the layer currently being explored.  If it 
		//is assign it, if not dont.
		if( newAss != -1 ) {
			if( this.currentDistance( newAss ) ){
				this.setDist( x, y, newAss );

				//If the start was the location which was just assigned, create a path.
				if ( this.isStart( x, y ) ){
					this.createPath();
				}
			}

		}


	}
	
	//Loop through the adjacent squares, if any of them are assigned return the incremented value of 
	//the lowest one
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

	//Check to see if the current distance found is part of the layer being explored.  If it is, decrement the 
	//tally and return true, if not return false.
	this.currentDistance = function( value ){
		//Check to see appropriate distance by looking at the sum of the inex one lower than value.
		if( ( value === 0 ) || ((value > 0) && ( this.distCounters[ value - 1 ] === 0 ) )){
			console.log( "true.......wtf");
			this.distCounters[value]--;
			console.log( this.distCounters );
			return true;
		}
		return false;
	}

	//This method is called when the class is being initialized and SHOULD NEVER BE CALLED AGAIN
	this.internalBFSTracking = function(){
		this.resetBFS();

		//Array of counters.  At each index is the number of times the value of the index is found in 
		//the BFS exploration.
		var counters = new Array();
		counters[0] = 0;

		//queue holding squares to search
		var queue = new Array();
		
		//Set the distance of the goal as zero and add the goal to the queue
		this.setBFS( this.goal[0], this.goal[1], 0 );
		queue.push( this.goal );
		this.incrementCounter( counters, 0 );


		//Continue searching until the queue is empty or the start has been found.
		while( queue.length != 0 ){
			//Pop the first element from the queue
			var arr = queue[0];
			queue.splice( 0, 1);

			var value = this.getBFS(arr[0], arr[1]) + 1;



			//Check each of the elements next to the current one and add dist and to the queue if it 
			//is valid. A valid move happens if it is in the maze, not a wall, and not already labled
			for (var i = 0; i < this.adjacency.length; i++) {
				var adj = this.adjacency[i];
				var temp = [ (arr[0] + adj[0]), (arr[1] + adj[1]) ];
				if( this.isValidBFSMove( temp[0], temp[1] ) ){
					this.setBFS(temp[0], temp[1], value);
					queue.push( temp );
					this.incrementCounter( counters, value );
				}
			}
		}
		this.distCounters = counters;
		console.log( this.distCounters );

	}

	this.isValidBFSMove = function(x, y){
		//See if in bounds, valid location, or already assigned in the current BFS
		return !( (! this.isSquare(x, y)) || ( this.isWall(x,y) == 1 ) || ( this.getBFS(x, y) != -1 ) );
	}

	this.incrementCounter = function ( counter, index ){
		//Make sure the array is long enough
		if( counter.length < index + 1 ){
			counter.length = index + 1;
			counter[index] = 0;
		}
		counter[index] = counter[index] + 1; 
	}




	// ----- Methods for updating all the distances in response to a key or button click -----

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

					this.currentDistance( value ); //Decriment the counter.

					if( this.isStart( temp[0], temp[1]) ){
						console.log( this.distCounters );
						return;
					}
				}
			}
		}
	}

	this.isValidMove = function(x, y){
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

			//Loop through the adjacent locations and look for one with a lower distance, add it to the 
			//array and break
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





	// ----- Methods for drawing graphics -----

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
		var sx = x * this.squareSize + (~~( this.squareSize/2 )) ;
		var sy = y * this.squareSize + (~~( this.squareSize/2 )) ; 
		//Draw distance

		//processing.textSize(15);
		processing.textAlign( 3, 3);
		processing.fill( 0 );
		var num = this.getDist(x, y);
		processing.text( num, sx, sy );
	}





	// ----- call during initialization -----
	//This is to control clicking accessibility so it functions like a true BFS.  This function will 
	//never be called again.
	this.internalBFSTracking();


}

function sketchMaze(processing) {

	console.log("Processing initialized");

	processing.size(300, 300);
	processing.background(10, 200, 10);

	var squareSize = (~~(300/8));
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
		//console.log( (~~(processing.mouseX / maze.squareSize))+ " " +processing.mouseY / maze.squareSize);

		var x = (~~(processing.mouseX / maze.squareSize));
		var y = (~~(processing.mouseY / maze.squareSize));

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
			maze.internalBFSTracking();
		}
	}

	console.log("draw overridden");


}
