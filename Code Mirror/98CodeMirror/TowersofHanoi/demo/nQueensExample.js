var editor = CodeMirror.fromTextArea(document.getElementById("codeInputPane"), {
  		theme: "neat",
  		autofocus: true,
    	lineNumbers: true,
    	styleActiveLine: true,
    	matchBrackets: true,
    	lint: true,
    	gutters: ['CodeMirror-lint-markers', "CodeMirror-linenumbers"]
  		});

  		// editor.on("gutterClick", function(cm, n) {
  		// 	var info = cm.lineInfo(n);
  		// 	cm.setGutterMarker(n, "breakpoints", info.gutterMarkers ? null : makeMarker());
  		// });

  		// function makeMarker() {
  		// 	var marker = document.createElement("div");
  		// 	marker.style.color = "#822";
  		// 	marker.innerHTML = "●";
  		// 	return marker;
  		// }

		////////////// Graphical Output  /////////////////
  		// var processingInstance;
		// var first_call;

		// -------------------- TEST --------------------

		var bound = false;
		// var processingInstance;
		var processingInstance;

		function bindJavascript() {
			if (!processingInstance) {
				processingInstance = Processing.getInstanceById('sketch');
			}
			if (processingInstance != null) {
				processingInstance.bindJavascript(this);
				bound = true;
			}

			if (!bound) {
				setTimeout(bindJavascript, 250);
			}
		}
		bindJavascript();

		function isMoveValid(row, col) {
			if (!processingInstance) {
				processingInstance = Processing.getInstanceById('sketch');
			}

			return processingInstance.isMoveValid(row, col);

			// var is_move_valid = processingInstance.isMoveValid(row, col);
			// console.log(is_move_valid.toString());
			// return is_move_valid;
		}

		function placeQueen(row, col) {
			if (!processingInstance) {
				processingInstance = Processing.getInstanceById('sketch');
			}

			processingInstance.placeQueen(row, col);
		}

		function removeQueen(row, col) {
			if (!processingInstance) {
				processingInstance = Processing.getInstanceById('sketch');
			}
			processingInstance.removeQueen(row, col);
		}

		function isQueen(row, col) {
			if (!processingInstance) {
				processingInstance = Processing.getInstanceById('sketch');
			}

			return processingInstance.isQueen(row, col);
		}

		function isBoardSolved() {
			if (!processingInstance) {
				processingInstance = Processing.getInstanceById('sketch');
			}

			return processingInstance.isBoardSolved();
		}

		function getNumCols() {
			if (!processingInstance) {
				processingInstance = Processing.getInstanceById('sketch');
			}

			return processingInstance.getNumCols();
		}

		function getNumRows() {
			if (!processingInstance) {
				processingInstance = Processing.getInstanceById('sketch');
			}

			return processingInstance.getNumRows();
		}


		function enterDebugMode() {
			if (!processingInstance) {
  				processingInstance = Processing.getInstanceById('sketch');
  			}

  			processingInstance.enterDebugMode();
		}

		function exitDebugMode() {
			if (!processingInstance) {
  				processingInstance = Processing.getInstanceById('sketch');
  			}

  			processingInstance.exitDebugMode();
		}


		function wrapRun() {
			if (!processingInstance) {
  				processingInstance = Processing.getInstanceById('sketch');
  			}

  			processingInstance.enterRunMode();
  			run();
  			processingInstance.exitRunMode();
		}




		// ----------------------- END TEST -------------
  	// 	function move_disc(disc_number, from_peg, to_peg) {
  	// 		if (!processingInstance) {
  	// 			processingInstance = Processing.getInstanceById('sketch');
  	// 		}

  	// 		processingInstance.move_disc(disc_number, from_peg, to_peg);
			// document.getElementById('demo').innerHTML += ("Move disk " + disc_number.toString() + " from peg " + from_peg.toString() + " to peg " + to_peg.toString() + ".\n"); 
  	// 	}
  		function log_Processing_error(error_message) {
  		// var string_1;
	  	// 	if (!processingInstance) {
	  	// 		processingInstance = Processing.getInstanceById('sketch');
	  	// 	}
	  	// 	string_1 = processingInstance.glob_string;
			console.log(error_message);
			printResult();
		}
	 
	 //////////////////// Text-box Output /////////////////////////
		
		function outputArguments(arguments, type){
			var outputBox = document.getElementById('demo');
			for(i in arguments)
					{
				if(type == 0)
					{
				outputBox.innerHTML +=(arguments[i]+ '\n');
					}
				else if (type == 1)
					{
				outputBox.innerHTML +=(arguments[i] + '\n');	
					}
				else
					{
				outputBox.innerHTML +=(arguments[i] + '\n');
					}
				}
			}
		
		function printResult(){
			var logOfConsole = [];
			var _log = console.log,
			_warn = console.warn,
			_error = console.error;
			
			console.log = function() {
				outputArguments(arguments, 0);
				return true;
			};

			console.warn = function() {
				outputArguments(arguments, 1);
				logOfConsole.push({method: 'warn', arguments: arguments});
				return _warn.apply(console, arguments);
			};

			console.error = function() {
				outputArguments(arguments, 2);
				logOfConsole.push({method: 'error', arguments: arguments});
				return _error.apply(console, arguments);
			};

			window.onerror = function (msg, url, line) {
				console.error("Caught[via window.onerror]: '" + msg + "' from " + url + ":" + line);
				return true; // same as preventDefault
			};
		}
	
		function clearOutput(){
			document.getElementById('demo').innerHTML = "";		
		}
		
		function clearInput(){
			clearOutput();	
			editor.setValue("");
			editor.clearHistory();
			editor.clearGutter("gutterId"); //if you have gutters
			reset();
		}
		
	 	function run(){
			// reset();
			var content = editor.getValue();		
			var result = eval(content);
			printResult();
		}

		///////////// DEBUGGER TEST ////////////////////
