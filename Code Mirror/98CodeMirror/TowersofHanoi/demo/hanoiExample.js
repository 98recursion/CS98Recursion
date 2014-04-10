  		var editor = CodeMirror.fromTextArea(document.getElementById("codeInputPane"), {
  		theme: "neat",
  		autofocus: true,
    	lineNumbers: true,
    	styleActiveLine: true,
    	matchBrackets: true,
    	gutters: ["CodeMirror-lint-markers"],
    	lint: true
  		});

		////////////// Graphical Output  /////////////////
  		var processingInstance;
		var first_call;
  		function move_disc(disc_number, from_peg, to_peg) {
  			if (!processingInstance) {
  				processingInstance = Processing.getInstanceById('sketch');
  			}

  			processingInstance.move_disc(disc_number, from_peg, to_peg);
			document.getElementById('demo').innerHTML += ("Move disk " + disc_number.toString() + " from peg " + from_peg.toString() + " to peg " + to_peg.toString() + ".\n"); 
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
		}
		
		function back(){
			if (!processingInstance) {
  				processingInstance = Processing.getInstanceById('sketch');
  			}
			processingInstance.step_back();
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