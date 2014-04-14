  		var editor = CodeMirror.fromTextArea(document.getElementById("codeInputPane"), {
  		theme: "neat",
  		autofocus: true,
    	lineNumbers: true,
    	styleActiveLine: true,
    	matchBrackets: true,
    	gutters: ["CodeMirror-lint-markers"],
    	lint: true
  		});
		
		var myTime;

		////////////// Graphical Output  /////////////////
  		var processingInstance;
		var first_call;
		
		
		// print error messages
		var bound = false;
		var processingInstance;
		var pjs;

		function bindJavascript() {
			if (!pjs) {
				pjs = Processing.getInstanceById('sketch');
			}
			if (pjs != null) {
				pjs.bindJavascript(this);
				bound = true;
			}

			if (!bound) {
				setTimeout(bindJavascript, 250);
			}
		}
		bindJavascript();
		//
		  		function output_error_message(string_1) {
  		// var string_1;
	  	// 	if (!processingInstance) {
	  	// 		processingInstance = Processing.getInstanceById('sketch');
	  	// 	}
	  	// 	string_1 = processingInstance.glob_string;
			console.log(string_1);
		}
		
  		function move_disc(disc_number, from_peg, to_peg) {
  			if (!processingInstance) {
  				processingInstance = Processing.getInstanceById('sketch');
  			}

  			processingInstance.move_disc(disc_number, from_peg, to_peg);
			//document.getElementById('demo').innerHTML += ("Move disk " + disc_number.toString() + " from peg " + from_peg.toString() + " to peg " + to_peg.toString() + ".\n"); 
  		}
		
		function increaseTotalDiscs() {
			if (!processingInstance) {
  				processingInstance = Processing.getInstanceById('sketch');
  			}
  			processingInstance.increaseTotalDiscs();
		}

		function decreaseTotalDiscs() {
			if (!processingInstance) {
  				processingInstance = Processing.getInstanceById('sketch');
  			}
  			processingInstance.decreaseTotalDiscs();
		}
		
		function setTotalDiscs(total) {
			if (!processingInstance) {
  				processingInstance = Processing.getInstanceById('sketch');
  			}
  			processingInstance.setTotalDiscs(total);
		}		
		
		function resetDiscs(){
		if (!processingInstance) {
  				processingInstance = Processing.getInstanceById('sketch');
  			}
			processingInstance.resetTotalDiscs();
		}
	 	
		function reset() {
			if (!processingInstance) {
  				processingInstance = Processing.getInstanceById('sketch');
  			}
			processingInstance.reset_queue();
			clearOutput();
  			increaseTotalDiscs();
			decreaseTotalDiscs();
		}
		
		function debug(){
			if (!processingInstance) {
  				processingInstance = Processing.getInstanceById('sketch');
  			}
			processingInstance.debug();
			run();
		}
		
		function step(){
			if (!processingInstance) {
  				processingInstance = Processing.getInstanceById('sketch');
  			}
			processingInstance.step_forward();
			var messageToPost = processingInstance.getMessage();
			var outputBox = document.getElementById('demo');
			outputBox.innerHTML += messageToPost;
		}
		
		function back(){
			if (!processingInstance) {
  				processingInstance = Processing.getInstanceById('sketch');
  			}
			processingInstance.step_back();
			var messageToPost = processingInstance.getMessage();
			var outputBox = document.getElementById('demo');
			outputBox.innerHTML += messageToPost;
		}
		
		function wrapRun(){
			if (!processingInstance) {
  				processingInstance = Processing.getInstanceById('sketch');
  			}
			processingInstance.runMode();
			run();
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
			if(myTime == null){
				 myTime = setInterval(function(){postMyMessage()},100);
			}
			reset();
			var content = editor.getValue();		
			var result = eval(content);
			printResult();
		}
		
		function testError(){
			if (!processingInstance) {
  				processingInstance = Processing.getInstanceById('sketch');
  			}
		var t = "test";
		t = processingInstance.errorOutput(t);
		document.getElementById('demo').innerHTML += t + " \n";	
		}
		
		function postMyMessage() {
			if (!processingInstance) {
  				processingInstance = Processing.getInstanceById('sketch');
  			}
			var messageToPost = processingInstance.getMessage();
			var outputBox = document.getElementById('demo');
			if(messageToPost.indexOf("Error:") != -1){
				outputBox.style.color = "red";
			}
			outputBox.innerHTML += messageToPost;
		}