StringDict pos; // Initilise a string dictonary to store the position of all the pieces 
StringList straightPiece; // A String Array filled with names of pieces that can move up/down and sideways
StringList diagPiece; // A String Array filled with names of pieces that can move diagonally
StringList pawnPiece; // A String Aray filled with names of all the pawns
StringList knightPiece; // A String Array filled with names of all the knight pieces
StringList kingPiece; // A String Array filled with names of the kings
int[] gridPos; // Initilise an int to store the grid number on which the mouse is hovering
float squareSize; // Initilise the squareSize of each square on the grid (This scales with size)
float boardTLP; // Initilise the coordinate of the top left corner not including all the borders

String currentPiece = "None"; // Start of with the current selected piece being nothing
String wKingPos = "60"; 
String bKingPos = "4";
int[] currentPiecePos; // An array to store the position value of the current piece 

boolean whiteTurn; // Boolean to store if it is white turn
boolean pawnFirstMove; // Boolean to see if it's pawns first move. This is not being used anymore
boolean check; // Boolean to see if it is check

// Following just sets the PImages for all the images
PImage BRook;
PImage BKnight;
PImage BBishop;
PImage BQueen;
PImage BKing;
PImage BPawn;

PImage WRook;
PImage WKnight;
PImage WBishop;
PImage WQueen;
PImage WKing;
PImage WPawn;

// Setup what is required for the chess
void setup() {
	size(800, 800); // Set the size to 800 pixels by 800 pixels (This is scalable but only in square)
	pos = new StringDict();
	straightPiece = new StringList("BLRook", "BRRook", "WLRook", "WRRook", "BQueen", "WQueen"); // Insert the names of the pieces in the array
	kingPiece = new StringList("BKing", "WKing"); // Insert king names
	diagPiece = new StringList("BLBishop", "BRBishop", "WLBishop", "WRBishop", "BQueen", "WQueen"); // Set all the queen names
	knightPiece = new StringList("WLKnight", "WRKnight", "BLKnight", "BRKnight");
	pawnPiece = new StringList("WOnePawn", "WTwoPawn", "WThreePawn", "WFourPawn", "WFivePawn", "WSixPawn", "WSevenPawn", "WEightPawn", "BOnePawn", "BTwoPawn", "BThreePawn", "BFourPawn", "BFivePawn", "BSixPawn", "BSevenPawn", "BEightPawn");
	gridPos = new int[3]; // Set the clicked sqaure grid position array
	currentPiecePos = new int[3]; // Set current piece gird positin array

	whiteTurn = true; // Start off with white turn
	pawnFirstMove = true; // At the start it's Pawn's first move
	check = false; // Check is false at the start


	// Set the images to variables
	BRook = loadImage("BRook.png");
	BKnight = loadImage("BKnight.png");
	BBishop = loadImage("BBishop.png");
	BQueen = loadImage("BQueen.png");
	BKing = loadImage("BKing.png");
	BPawn = loadImage("BPawn.png");

	WRook = loadImage("WRook.png");
	WKnight = loadImage("WKnight.png");
	WBishop = loadImage("WBishop.png");
	WQueen = loadImage("WQueen.png");
	WKing = loadImage("WKing.png");
	WPawn = loadImage("WPawn.png");

	initPos(); // Run the initPos function which initilises the starting position of all the chess pieces in the 'pos' string directory
	chessBoard(); // Run the chessBoard function which draws the actual chess board onto the screen
}

// This function is constantly updating so only put code in here which you want constantly updated
void draw() {
	// Put the mouseGridPos function here because the position of the mouse is always chacning so we need the 'gridPos' int constantly updated
	mouseGridPos(mouseX, mouseY); // We pass the x and y coordinates of the mouse into the function
}

// This function is run when a mouse press is detected so only put code in here which you want to run when the mouse is pressed
void mousePressed() {
	// In this case we are checking if the position where the mouse was pressed down(clicked) is on our chess board grid
	if (currentPiece == "None") {
		if (pos.hasKey(str(gridPos[0]))) {      
			if ((pos.get(str(gridPos[0])).charAt(0) == "W".charAt(0) && whiteTurn == true) || (pos.get(str(gridPos[0])).charAt(0) == "B".charAt(0) && whiteTurn == false)) {
				// If the mouse was over one of the sqare grid the following code would execute
				println("Current piece: " + pos.get(str(gridPos[0]))); // This is for debuging to see what piece is currently selected. 

				currentPiece = pos.get(str(gridPos[0])); // Set the name of the piece clicked on

				// If the piece can move straigth and diagonal run this
				if (straightPiece.hasValue(currentPiece) && diagPiece.hasValue(currentPiece)){
					int[][] direction = {{1, 0}, {0, 1}, {1, 1}, {-1, 1}};
					showMoves(false, direction, true, true, 1);
				} else if (straightPiece.hasValue(currentPiece)) { // If the piece can only move straight run this
					int[][] direction = {{1, 0}, {0, 1}};
					showMoves(false, direction, true, true, 1);
				}	else if (diagPiece.hasValue(currentPiece)) { // If the piece can only move diagonally run this
					int[][] direction = {{1, 1}, {-1, 1}};
					showMoves(false, direction, true, true, 1);
				} else if (kingPiece.hasValue(currentPiece)) { // If the piece is a king run this
					int[][] direction = {{1, 0}, {0, 1}, {1, 1}, {-1, 1}};
					showMoves(true, direction, true, true, 1);
				} else if(knightPiece.hasValue(currentPiece)) { // If the piece is a knight run this
					int[][] direction = {{1, 2}, {1, -2}, {2, 1}, {2, -1}};
					showMoves(true, direction, true, true, 1);
				} else if (pawnPiece.hasValue(currentPiece)) { // If the piece is a pawn run this
					// If it is a white pawn and moving in the right direction run this and there is a piece diagonally it can attack
					if ((pos.hasKey(str(int(gridPos[0]) - 9)) && currentPiece.charAt(0) == "W".charAt(0) && oppositePiece(int(gridPos[0]) - 9)) || (pos.hasKey(str(int(gridPos[0]) + 9)) && currentPiece.charAt(0) == "B".charAt(0) && oppositePiece(int(gridPos[0]) + 9))){
						int[][] direction = {{1, 1}};
						pawnMove(direction);
					} 

					if ((pos.hasKey(str(int(gridPos[0]) - 7)) && currentPiece.charAt(0) == "W".charAt(0) && oppositePiece(int(gridPos[0]) - 7)) || (pos.hasKey(str(int(gridPos[0]) + 7)) && currentPiece.charAt(0) == "B".charAt(0) && oppositePiece(int(gridPos[0]) + 7))){
						int[][] direction = {{1, -1}};
						pawnMove(direction);
					} 

					// Run this regardless of if there is a piece to attack
					int[][] direction = {{1, 0}};
					pawnMove(direction);
				}

				// Store the piece grid value in currentPiecePos
				currentPiecePos[0] = gridPos[0]; // Absolute square number
				currentPiecePos[1] = gridPos[1]; // Column Number
				currentPiecePos[2] = gridPos[2]; // Row Number
			}
		}
	} else {
		// If there is already a piece selected run this code
		if (canMove(currentPiece)) {
			// If the move is valid remove the piece from the old position and replace it with this new position
			pos.remove(str(currentPiecePos[0]));
			pos.set(str(gridPos[0]), currentPiece);

			// if white turn make it black turn
			if (whiteTurn) {
				whiteTurn = false;
			} else {
				whiteTurn = true;
			}
		}

		// Redraw the board with the new movements
		redrawBoard();
		// Set the selected piece to Nothing again
		currentPiece = "None";
	}
}

// This function defines where exactly a pawn can move
void pawnMove(int[][] direction){
	// If pawn is white run this
	if (currentPiece.charAt(0) == "W".charAt(0)){
		// If this is pawns first move runt this
		if (gridPos[2] == 6){							
			showMoves(true, direction, false, true, 2);
		} else { // Else run this
			showMoves(true, direction, false, true, 1);
		}
	} else { // If pawn is black run this code
		if (gridPos[2] == 1){							
			showMoves(true, direction, true, false, 2);
		} else {
			showMoves(true, direction, true, false, 1);
		}
	}
}

/*boolean check(String kingSquare, String kingPiece){
	int count = 0;
	int[] oldPiecePos = {gridPos[0], gridPos[1], gridPos[1]};
	String oldCurrentPiece = currentPiece;

	currentPiece = kingPiece;
	gridPos[0] = int(kingSquare);

	int[] rowColKing = rowColNum(gridPos[0]);
	gridPos[1] = rowColKing[1];
	gridPos[2] = rowColKing[0];

	int[][] dirStraight = {{1, 0}, {0, 1}};
	String[] checkPieces;

	checkPieces = showMoves(false, dirStraight, true, true, 1);
	for (int j = 0; j < checkPieces.length; j++){
		if (straightPiece.hasValue(checkPieces[j])){
			count++;
			check = true;
		}
	}

	int[][] dirDiagonal = {{1, 1}, {-1, 1}};
	checkPieces = showMoves(false, dirDiagonal, true, true, 1);
	for (int j = 0; j < checkPieces.length; j++){
		if (diagPiece.hasValue(checkPieces[j])){
			count++;
			check = true;
		}
	}

	currentPiece = oldCurrentPiece;

	gridPos[0] = oldPiecePos[0];
	gridPos[1] = oldPiecePos[1];
	gridPos[2] = oldPiecePos[2];

	println(check);

	return check;
}*/

// This is the function that draws all the possible move of a piece
String[] showMoves(boolean oneStep, int[][] direction, boolean canPos, boolean canNeg, int repeat){
	// THis is a string array that will store all the pieces
	String[] checkPieces = {};

	// Loop through all the possible directions
	for (int i = 0; i < direction.length; i++){
		int[] currentDirection = direction[i]; // get the current direction of the loop
		boolean canMovePositive = canPos; 
		boolean canMoveNegative = canNeg;

		// Loop throught the 7 rows an cols possible for moves
		for (int j = 1; j <= 7; j++){
			// Check if the piece and only move one step iof so run this only once
			if ((oneStep && j <= repeat) || (oneStep == false)){
				// Figure out the new position fo the possible move by rows and cols
				int[][] newSquare = {{(int(gridPos[2]) + (j * currentDirection[0])), (int(gridPos[1]) + (j * currentDirection[1]))},
														{(int(gridPos[2]) - (j * currentDirection[0])), (int(gridPos[1]) - (j * currentDirection[1]))}};

				// Convert the grids and cols into absolute square values
				if (newSquare[0][0] > 7 || newSquare[0][1] > 7 || newSquare[0][0] < 0 || newSquare[0][1] < 0){
					canMovePositive = false;
				}

				if (newSquare[1][0] < 0 || newSquare[1][1] < 0 || newSquare[1][0] > 7 || newSquare[1][1] > 7){
					canMoveNegative = false;
				}

				int[] newSquareAbs = {squareNum(newSquare[0][0], newSquare[0][1]), squareNum(newSquare[1][0], newSquare[1][1])};
				//println("Pos: " + newSquareAbs[0] + " Neg: " + newSquareAbs[1]);
				//println("Row: " + newSquare[1][0] + " Col: " + newSquare[1][1]);

				// Check if there is anything in the way of the move if there is stop and don't draw on any squares further
				for (int k = 0; k < 2; k++){
					if ((k == 0 && canMovePositive) || (k == 1 && canMoveNegative)){
						if (pos.hasKey(str(newSquareAbs[k]))){
							if (oppositePiece(newSquareAbs[k])){
								checkPieces = append(checkPieces, pos.get(str(newSquareAbs[k])));
								println(newSquareAbs[k]);
								drawSquare(newSquare[k][0], newSquare[k][1], true);
							}

							if (k == 0){
								canMovePositive = false;
							} else {
								canMoveNegative = false;
							}
						} else {
							drawSquare(newSquare[k][0], newSquare[k][1], false);
						}
					}
				}
			}
		}
	}

	return checkPieces;
}

// Converts row and col form of square into absolute square values
int squareNum(int row, int col){
	return (row * 8) + col;
}

// Converts absoulte square value to row and cols values
int[] rowColNum(int squareNum){
	int[] list = new int[2];
	list[0] = int(floor(squareNum / 8.0));
	list[1] = squareNum % 8;

	return list;
}

// Check if the piece is of the opposite colour to the one selected
Boolean oppositePiece(int square){
	if (currentPiece.charAt(0)=='W' && pos.get(str(square)).charAt(0)=='B') {
		return true;
	} else if (currentPiece.charAt(0)=='B' && pos.get(str(square)).charAt(0)=='W') {
		return true;
	}
	return false;
}

// Draw the squares and what colour depending if there is a peice of the opposte colour or not
void drawSquare(int row, int col, boolean piece){
	if (piece){
		fill(50, 160, 250, 150);
	} else {
		fill(255, 90, 60, 150);
	}

	rect(boardTLP + (col * squareSize), boardTLP + (row * squareSize), squareSize, squareSize);
}

// Check if the piece can attack the current piece
boolean attack () {
	if (pos.hasKey(str(gridPos[0]))) {
		// Run this code if it is a black piece attacking a white piece
		if (pos.get(str(gridPos[0])).charAt(0)=='W' && pos.get(str(currentPiecePos[0])).charAt(0)=='B') {
			return true;
		} else if (pos.get(str(gridPos[0])).charAt(0)=='B' && pos.get(str(currentPiecePos[0])).charAt(0)=='W') { // Run this if white attackign a black
			return true;
		}
	} else { // If the square you want to move to has to piece run this
		return true;
	}
	return false;
}

// Check if there is any piece int he way of the move
boolean inTheWay(int opNum) {
	int startNum;
	int endNum;

	// Loop by a certain number to check if ther is anything in the way
	if (currentPiecePos[0] - gridPos[0] > 0){
		startNum = gridPos[0] + opNum;
		endNum = currentPiecePos[0] - opNum;
	} else {
		startNum = currentPiecePos[0] + opNum;
		endNum = gridPos[0] - opNum;
	}

	for (int i = startNum; i <= endNum; i+=opNum) {
		if (pos.hasKey(str(i))) {
			return false;
		}
	}

	return attack();
}

// This is a junction that sorts out what piece and check if the move is valid. It is different logic for each piece
boolean canMove(String name) {
	if (name == "BLRook" || name == "BRRook" || name == "WLRook" || name == "WRRook") {
		if (gridPos[1] == currentPiecePos[1]) {
			return inTheWay(8);
		} else if (gridPos[2] == currentPiecePos[2]) {
			return inTheWay(1);
		}
	} else if (name == "BLKnight" || name == "BRKnight" || name == "WLKnight" || name  == "WRKnight") {
		if ((currentPiecePos[2] != gridPos[2])  && (abs(gridPos[0] - currentPiecePos[0])/6.0 == 1 || abs(gridPos[0] - currentPiecePos[0])/10.0 == 1 || abs(gridPos[0] - currentPiecePos[0])/15.0 == 1 || abs(gridPos[0] - currentPiecePos[0])/17.0 == 1)  && (abs(gridPos[1] - currentPiecePos[1]) <= 3)) {
			return attack();
		}
	} else if (name == "BLBishop" || name == "BRBishop" || (name == "WLBishop" || name == "WRBishop")) {
		if ((gridPos[0] - currentPiecePos[0]) % 7 == 0) {
			return inTheWay(7);
		} else if ((gridPos[0] - currentPiecePos[0]) % 9 == 0) {
			return inTheWay(9);
		}
	} else if (name == "BKing" || name == "WKing"){
		if (gridPos[1] == currentPiecePos[1] && (gridPos[0] - currentPiecePos[0] == -8 || gridPos[0] - currentPiecePos[0] == 8)) {
			return inTheWay(8);
		} else if (gridPos[2] == currentPiecePos[2] && (gridPos[0] - currentPiecePos[0] == -1 || gridPos[0] - currentPiecePos[0] == 1)) {
			return inTheWay(1);
		} else if ((gridPos[0] - currentPiecePos[0]) % 7 == 0 && (gridPos[0] - currentPiecePos[0] > - 10 && gridPos[0] - currentPiecePos[0] < 10)) {
			return inTheWay(7);
		} else if ((gridPos[0] - currentPiecePos[0]) % 9 == 0 && (gridPos[0] - currentPiecePos[0] > - 10 && gridPos[0] - currentPiecePos[0] < 10)) {
			return inTheWay(9);
		}
	} else if (name == "BQueen" || name == "WQueen") {
		if (gridPos[1] == currentPiecePos[1]) {
			return inTheWay(8);
		} else if (gridPos[2] == currentPiecePos[2]) {
			return inTheWay(1);
		} else if ((gridPos[0] - currentPiecePos[0]) % 7 == 0) {
			return inTheWay(7);
		} else if ((gridPos[0] - currentPiecePos[0]) % 9 == 0) {
			return inTheWay(9);
		}
	} else if (name == "BOnePawn" || name == "BTwoPawn" || name == "BThreePawn" || name == "BFourPawn" || name == "BFivePawn" || name == "BSixPawn" || name == "BSevenPawn" || name == "BEightPawn") {
		if ((gridPos[0] - currentPiecePos[0] == 8 || (currentPiecePos[2] == 1 && gridPos[0] - currentPiecePos[0] == 16)) && pos.hasKey(str(gridPos[0]))==false) {
			return inTheWay(8);
		} else if (gridPos[0] - currentPiecePos[0] == 7 && pos.hasKey(str(gridPos[0]))==true) {
			return inTheWay(7);
		} else if (gridPos[0] - currentPiecePos[0] == 9 && pos.hasKey(str(gridPos[0]))==true) {
			return inTheWay(9);
		}
	} else if (name == "WOnePawn" || name == "WTwoPawn" || name == "WThreePawn" || name == "WFourPawn" || name == "WFivePawn" || name == "WSixPawn" || name == "WSevenPawn" || name == "WEightPawn") {
		if ((gridPos[0] - currentPiecePos[0] == -8 || (currentPiecePos[2] == 6 && gridPos[0] - currentPiecePos[0] == -16)) && pos.hasKey(str(gridPos[0]))==false) {
			return inTheWay(8);
		} else if (gridPos[0] - currentPiecePos[0] == -7 && pos.hasKey(str(gridPos[0]))==true) {
			return inTheWay(7);
		} else if (gridPos[0] - currentPiecePos[0] == -9 && pos.hasKey(str(gridPos[0]))==true) {
			return inTheWay(9);
		}
	}

	return false;
}

// This function just draws the pieces depnding ont he row, col and the name of the piece
void drawPiece(String name, int x, int y) { //does as title suggests
	if (name == "BLRook" || name == "BRRook") {
		image(BRook, boardTLP + (x * squareSize), boardTLP + (y * squareSize), BRook.width/(width/200), BRook.height/(height/200));
	} else if (name == "BLKnight" || name == "BRKnight") {
		image(BKnight, boardTLP + (x * squareSize), boardTLP + (y * squareSize), BKnight.width/(width/200), BKnight.height/(height/200));
	} else if (name == "BLBishop" || name == "BRBishop") {
		image(BBishop, boardTLP + (x * squareSize), boardTLP + (y * squareSize), BBishop.width/(width/200), BBishop.height/(height/200));
	} else if (name == "BQueen") {
		image(BQueen, boardTLP + (x * squareSize), boardTLP + (y * squareSize), BQueen.width/(width/200), BQueen.height/(height/200));
	} else if (name == "BKing") {
		image(BKing, boardTLP + (x * squareSize), boardTLP + (y * squareSize), BKing.width/(width/200), BKing.height/(height/200));
	} else if (name == "BOnePawn" || name == "BTwoPawn" || name == "BThreePawn" || name == "BFourPawn" || name == "BFivePawn" || name == "BSixPawn" || name == "BSevenPawn" || name == "BEightPawn") {
		image(BPawn, boardTLP + (x * squareSize), boardTLP + (y * squareSize), BPawn.width/(width/200), BPawn.height/(height/200));
	} else if (name == "WLRook" || name == "WRRook") {
		image(WRook, boardTLP + (x * squareSize), boardTLP + (y * squareSize), WRook.width/(width/200), WRook.height/(height/200));
	} else if (name == "WLKnight" || name  == "WRKnight") {
		image(WKnight, boardTLP + (x * squareSize), boardTLP + (y * squareSize), WKnight.width/(width/200), WKnight.height/(height/200));
	} else if (name == "WLBishop" || name == "WRBishop") {
		image(WBishop, boardTLP + (x * squareSize), boardTLP + (y * squareSize), WBishop.width/(width/200), WBishop.height/(height/200));
	} else if (name == "WQueen") {
		image(WQueen, boardTLP + (x * squareSize), boardTLP + (y * squareSize), WQueen.width/(width/200), WQueen.height/(height/200));
	} else if (name == "WKing") {
		image(WKing, boardTLP + (x * squareSize), boardTLP + (y * squareSize), WKing.width/(width/200), WKing.height/(height/200));
	} else if (name == "WOnePawn" || name == "WTwoPawn" || name == "WThreePawn" || name == "WFourPawn" || name == "WFivePawn" || name == "WSixPawn" || name == "WSevenPawn" || name == "WEightPawn") {
		image(WPawn, boardTLP + (x * squareSize), boardTLP + (y * squareSize), WPawn.width/(width/200), WPawn.height/(height/200));
	}
}

// This function draws the actual chess board onto the screen
void chessBoard() {
	// At the start we initilise all the variables we will need
	int borderWidth = width/16; // This is the scalable width of the outer boarder
	int innerBorderWidth = width/80; // This is the scalable with of the innner smaller border
	boardTLP = borderWidth + innerBorderWidth; // This is the top left point of the actual chess board not counting the above borders
	float boardSize = width - (2 * (borderWidth + innerBorderWidth)); // The actual size of the chess board not counting the borders
	squareSize = (boardSize/8) + 0.75; // Since there are always 64 squares 8x8 we can just divide by 8 to find the size of one such square

	// Set the border colour to a dark wood brown
	stroke(61, 41, 32);
	strokeWeight(borderWidth); // And the width to a fat one
	rect((borderWidth / 2), (borderWidth / 2), width - borderWidth, height - borderWidth); // Then draw the actual rectangle so the borders will be drawn

	// Change the broder colour to a light creme wood colour
	stroke(206, 185, 152);
	strokeWeight(innerBorderWidth); // Change the border width to a smaller one
	// And draw the square so the borders will be drawn
	rect((borderWidth + (innerBorderWidth / 2)), 
		(borderWidth + (innerBorderWidth / 2)), 
		width - ( 2 * borderWidth + (innerBorderWidth/2)), 
		height - (2 * borderWidth + (innerBorderWidth/2)));

	// Now we need to draw the individual squares of the grid so set the border to 0
	strokeWeight(0);
	int count = 0;

	// Now the logic to figure out what colour of square to draw
	for (int i = 0; i < 8; i++) { // This is a loop that will repeat 8 times this is for each row
		for (int j = 0; j < 8; j++) { // This loop will also repeat 8 times this is for each column
			if ((j % 2) == 0 && (i % 2) != 0) { // If the column is divisable by 2 and the row is not divisible 2 then execute this code
				fill(238, 210, 170);
			} else if ((j % 2) != 0 && (i % 2) == 0) { // If the column is not divisible by 2 and the row is divisible by 2 then execute this code  
				fill(238, 210, 170);
			} else { // Otherwise for every other posiblity execute the following code
				fill(61, 41, 32);
			}

			// Now actually draw each square with a total of 64 once both loop have finished
			rect(boardTLP + (j * squareSize), boardTLP + (i * squareSize), squareSize, squareSize);
			if (pos.hasKey(str(count))) {
				drawPiece(pos.get(str(count)), j, i);
			}

			count++;
		}
	}
}

void redrawBoard(){
	for (int i = 0; i < 8; i++) { // This is a loop that will repeat 8 times this is for each row
		for (int j = 0; j < 8; j++) { // This loop will also repeat 8 times this is for each column
			if ((j % 2) == 0 && (i % 2) != 0) { // If the column is divisable by 2 and the row is not divisible 2 then execute this code
				fill(238, 210, 170);
			} else if ((j % 2) != 0 && (i % 2) == 0) { // If the column is not divisible by 2 and the row is divisible by 2 then execute this code  
				fill(238, 210, 170);
			} else { // Otherwise for every other posiblity execute the following code
				fill(61, 41, 32);
			}

			// Now actually draw each square with a total of 64 once both loop have finished
			rect(boardTLP + (j * squareSize), boardTLP + (i * squareSize), squareSize, squareSize);
		}
	}

	String[] piecePos = pos.keyArray();

	for (int i = 0; i < piecePos.length; i++){
		int[] rowCol = rowColNum(int(piecePos[i]));

		drawPiece(pos.get(piecePos[i]), rowCol[1], rowCol[0]);
	}
}

// This function is to calculate what square the mouse is hovering over
void mouseGridPos(int x, int y) {
	// Take 60 away from both x and y coordinates so 0,0 would be the top left corner of the board not the actual canavas
	x = x - 60;
	y = y - 60;

	//Check if the mouse is actually on the chess board and not the borders
	if (x > 0 && y > 0 && x < (width - 2 * boardTLP) && y < (height - 2 * boardTLP)) {
		// Divide both x and y coordiantes by the square size to give the actual square number of the grid and set it to the variable gridPos
		gridPos[0] = int((floor(y / squareSize) * 8) + floor(x / squareSize));
		gridPos[1] = int(floor(x / squareSize));
		gridPos[2] = int(floor(y / squareSize));
		//println("X-Cord: " + x + " Y-Cord: " + y + " Square " + gridPos);
	}
}

void initPos() {
	// Top left square is 0 and the bottom right is 63 increasing left to right and down
	// Set the position of the black chess pieces on the 8x8 grid
	pos.set("0", "BLRook"); // Square 0 is black left rook
	pos.set("1", "BLKnight"); // Square 1 is black left knight
	pos.set("2", "BLBishop"); // Square 2 is black left bishop
	pos.set("3", "BQueen"); // Square 3 is black queen
	pos.set("4", "BKing"); // Square 4 is black king
	pos.set("5", "BRBishop"); // Square 5 is black right bishop
	pos.set("6", "BRKnight"); // Square 6 is black right knight
	pos.set("7", "BRRook"); // Square 7 is black right rook
	pos.set("8", "BOnePawn"); // Square 8 is black first pawn from left 
	pos.set("9", "BTwoPawn"); // Square 9 is black second pawn from left
	pos.set("10", "BThreePawn"); // Square 10 is the black third pawn from left
	pos.set("11", "BFourPawn"); // Square 11 is the balck fourth pawn from left
	pos.set("12", "BFivePawn"); // Square 12 is the black fifth pawn from left
	pos.set("13", "BSixPawn"); // Square 13 is the black sixth pawn from left
	pos.set("14", "BSevenPawn"); // Square 14 is the black seventh pawn from left
	pos.set("15", "BEightPawn"); // Square 15 is the black eighth pawn from left

	// Set the position of the white chess pieces on the 8x8 grid
	pos.set("48", "WOnePawn"); // Square 48 is the white first pawn from left
	pos.set("49", "WTwoPawn"); // Square 49 is the white second pawn from left
	pos.set("50", "WThreePawn"); // Square 50 is the white third pawn from left
	pos.set("51", "WFourPawn"); // Square 51 is the white fourth pawn from left
	pos.set("52", "WFivePawn"); // Square 52 is the white fifth pawn from left
	pos.set("53", "WSixPawn"); // Square 53 is the white sixth pawn from left
	pos.set("54", "WSevenPawn"); // Square 54 is the white seventh pawn from left
	pos.set("55", "WEightPawn"); // Square 55 is the white eight pawn from left
	pos.set("56", "WLRook"); // Square 56 is the white left rook
	pos.set("57", "WLKnight"); // Square 57 is the white left knight
	pos.set("58", "WLBishop"); // Square 58 is the white left bishop
	pos.set("59", "WQueen"); // Square 59 is the white queen
	pos.set("60", "WKing"); // Square 60 is the white king
	pos.set("61", "WRBishop"); // Square 61 is the right white bishop
	pos.set("62", "WRKnight"); // Square 62 is the white right knight
	pos.set("63", "WRRook"); // Square 63 is the white right rook
}