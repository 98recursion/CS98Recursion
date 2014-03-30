
function Cell(value) {
    this.value = value;
}

function solvePuzzle() {
    
    for (var i=0; i < 9; i++) {
        for (var j=0; i < 9; j++) {
            this.State[i][j]
        }
    }
    
}

function test(row) {
    
    if (row == 9) {
        return;
    }
    
    for (var col=0; col < 9; col++) {
        
        for (var val=1; val <=9; val++) {
            
            if (isLegal(row, col, val)) {
            
            }
        }

    }
    
}