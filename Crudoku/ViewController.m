//
//  ViewController.m
//  Crudoku
//
//  Created by MacLab08 on 6/3/15.
//  Copyright (c) 2015 Cody & Jeff Boies. All rights reserved.
//

#import "ViewController.h"

@implementation ViewController

//------------------------------------
//
//		Fields
//
//------------------------------------

NSMutableArray *puzzle;
NSMutableArray *rowSection[9];
NSMutableArray *columnSection[9];
NSMutableArray *groupSection[9];

//------------------------------------
//
//		System
//
//------------------------------------

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    [self initSudoku];
    [self initKeyboard];
	
}

-(BOOL)canBecomeFirstResponder {
    return YES;
}

-(void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self becomeFirstResponder];
}

-(void)viewWillDisappear:(BOOL)animated{
    [self resignFirstResponder];
    [super viewWillDisappear:animated];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//------------------------------------
//
//		Screen Initialization
//
//------------------------------------

-(void)initSudoku {   //The following code creates the sudoku board on the main view
    int xOffset;
    int yOffset = 56;
    int offset = 0;
    int size = 34;
    UIView *dummyView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
    puzzle = [[NSMutableArray alloc] init];
    
	//Filling the arrays with arrays
    for (int i = 0; i < 9; i++) {
        rowSection[i] = [[NSMutableArray alloc] init];
        columnSection[i] = [[NSMutableArray alloc] init];
        groupSection[i] = [[NSMutableArray alloc] init];
        
    } //end for loop
	
	
    //Setup the cells
    for (int i = 0; i < 9; i++) {
        xOffset = 6;
        for (int j = 0; j < 9; j++) {
            UITextField *cell = [[UITextField alloc] initWithFrame:CGRectMake(xOffset, yOffset, size, size)];
			
			//Setup the cell object
            ViewController *newCell = [[ViewController alloc] init];
            newCell.cellPossibilities = [[NSMutableArray alloc] init];
            newCell.row = i;
            newCell.column = j;
            newCell.value = 0;
            newCell.cellField = cell;
            newCell.group = [ViewController setGroup: newCell];
			
			//Throw the cell in the arrays
            [puzzle addObject:newCell];
            rowSection[i][j] = newCell;
            columnSection[j][i] = newCell;
			NSMutableArray* temp = groupSection[newCell.group];
            [temp insertObject:newCell atIndex:0];
            
			//Setup cell graphical crap
            cell.tag = i * 9 + j + 100;
            cell.backgroundColor = [UIColor whiteColor];
            cell.layer.borderColor = [[UIColor blackColor]CGColor];
            cell.layer.borderWidth = 1.0f;
            cell.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
            cell.textAlignment = NSTextAlignmentCenter;
            cell.inputView = dummyView;
            [cell addTarget:self action:@selector(clearNumber:) forControlEvents:UIControlEventEditingDidBegin];
            
            [self.view addSubview:cell];
            xOffset += (offset + size);  //sets the grid to look like traditional sudoku board with thicker
            if (j == 2 || j == 5) {      //grid lines between groups
                xOffset = xOffset + 1;
            } //End inner for loop
            
        } //end outer for loop
		
        yOffset += (offset + size);
		
        if (i == 2 || i == 5) {
            yOffset = yOffset + 1;
        }
		
    } //End outer for loop
} //End initSudoku

-(void) initKeyboard {   //This method creates the keyboard that allows you to edit the puzzle
    int xOffset;
    int yOffset = 380;
    int offset = 6;
    int xsize = 90;
    int ysize = 25;
    int tag = 1;
    
    for (int i = 0; i < 3; i++){
        xOffset = 20;
        for (int j = 0; j < 3; j++) {
            UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(xOffset, yOffset, xsize, ysize)];
            button.tag = tag;
            [button setTitle: [NSString stringWithFormat:@"%d", tag] forState:UIControlStateNormal];
            [button addTarget:self action:@selector(setNumber:) forControlEvents:UIControlEventTouchDown];
            tag++;
            button.backgroundColor = [UIColor grayColor];
            button.layer.borderColor = [[UIColor blackColor]CGColor];
            button.layer.borderWidth = 1.0f;
            button.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
            [self.view addSubview:button];
            xOffset += (offset + xsize);
        } //End inner for loop
		
        yOffset += (offset + ysize);
		
    } //End for loop
} //end initKeyboard

//------------------------------------
//
//		Cell Initialization
//
//------------------------------------
+(int ) setGroup: (ViewController *) cell {
    
    ViewController *thisCell = cell;
    
    if (thisCell.row <= 2 && thisCell.column <= 2){
        thisCell.group = 0;
        return thisCell.group;
    }
    if (thisCell.row <= 2 && (thisCell.column >= 3 && thisCell.column <= 5)){
        thisCell.group = 1;
        return thisCell.group;
    }
    if (thisCell.row <= 2 && thisCell.column >= 6){
        thisCell.group = 2;
        return thisCell.group;
    }
    if ((thisCell.row >= 3 && thisCell.row <= 5) && thisCell.column <= 2){
        thisCell.group = 3;
        return thisCell.group;
    }
    if ((thisCell.row >= 3 && thisCell.row <= 5) && (thisCell.column >= 3 && thisCell.column <= 5)){
        thisCell.group = 4;
        return thisCell.group;
    }
    if ((thisCell.row >= 3 && thisCell.row <= 5) && thisCell.column >= 6){
        thisCell.group = 5;
        return thisCell.group;
    }
    if (thisCell.row >= 6 && thisCell.column <= 2){
        thisCell.group = 6;
        return thisCell.group;
    }
    if (thisCell.row >= 6 && (thisCell.column >= 3 && thisCell.column <= 5)){
        thisCell.group = 7;
        return thisCell.group;
    }
    if (thisCell.row >= 6 && thisCell.column >= 6){
        thisCell.group = 8;
        return thisCell.group;
    }
    return thisCell.group;
} //End setGroup

//------------------------------------
//
//		Action Handlers
//
//------------------------------------

-(void) setNumber: (id)sender {
    UIButton *buttonPressed = sender;
    NSString *tagAsText = [NSString stringWithFormat:@"%d", buttonPressed.tag];
    for (ViewController *thisCell in puzzle) {
        if (thisCell.cellField.isFirstResponder) {
            thisCell.value = buttonPressed.tag;
            thisCell.cellField.text = tagAsText;
            break;
        }
    }
} //End setNumber

-(void) clearNumber: (id)sender {
    UITextField *cellTapped = sender;
    for (ViewController *thisCell in puzzle) {
        if (thisCell.cellField == cellTapped) {
            thisCell.value = 0;
            thisCell.cellField.text = @"";
            break;
        }
    }
} //End clearNumber

//Clear all the cells
-(IBAction)resetButton:(id)sender{   //Set the action for the reset button
	for (ViewController *thisCell in puzzle) {
		thisCell.value = 0;
		thisCell.cellField.Text = @"";
		
	}
	
} //End resetButton

-(IBAction)solveButton:(id)sender   //Sets action for solve button
{
	//Grab the user entered values
	//For each cell
	for (ViewController *thisCell in puzzle) {
		if(![thisCell.cellField.text isEqualToString:@""]) {
			//Set the cell's value to the entered value
			thisCell.value = [thisCell.cellField.text intValue];
		}
		
	} //End for loop
	
	//Solve the array
    [self solve];
	
} //End solve button

//------------------------------------
//
//		Uniqueness Tests
//
//------------------------------------

//These next three methods check to make sure the current number is unique to that cell
-(BOOL) numIsUniqueForCellInRow :(ViewController *)cell :(int)testnum  //Checks row for unique number
{
    for (ViewController *thisCell in rowSection[cell.row]) {
        if (thisCell.value == testnum) {
            return false;
        }
    } return true;
}
         
-(BOOL) numIsUniqueForCellInColumn :(ViewController *)cell :(int)testnum  //Checks column
{
    for(ViewController *thisCell in columnSection[cell.column]) {
        if (thisCell.value == testnum) {
            return false;
        }
    } return true;
}
         
-(BOOL) numIsUniqueForCellInGroup :(ViewController *)cell :(int)testnum  //Checks 3x3 group
{
    for (ViewController *thisCell in groupSection[cell.group]) {
        if (thisCell.value == testnum) {
            return false;
        }
    } return true;
}

//------------------------------------
//
//		Solving
//
//------------------------------------

//Change the given cell's value to the given number
-(void)updateCellToNum: (ViewController*) cell :(int)num{
	int domain = cell.cellPossibilities.count;
	
	cell.value = num;
    cell.cellField.text = [NSString stringWithFormat:@"%d", num];
	[cell.cellPossibilities removeAllObjects];
	
	NSLog([NSString stringWithFormat:@"Updating:(%d, %d), Domain: %d, Value: %d", cell.row, cell.column, domain, cell.value]);
	
} //End updateCellToNum

//Initialize the cells' domains
-(void) setPossibilities {
	//For each cell
    for (ViewController *thisCell in puzzle) {
		//Clear the cell's domain
        [thisCell.cellPossibilities removeAllObjects];
	
		if(thisCell.value != 0) {
			//From 1-9, if num valid, add it to the cell's domain
			for (int num = 1; num < 10; num++) {
				if ([self numIsUniqueForCellInRow:thisCell :num] &&
					[self numIsUniqueForCellInColumn:thisCell :num] &&
					[self numIsUniqueForCellInGroup:thisCell :num]) {
					[thisCell.cellPossibilities addObject:[NSNumber numberWithInteger:num]];
				}
			} //End inner for loop
		}
    } //End outer for loop
} //End setPossibilities

//Solve the given puzzle
-(void) solve {
	//Initialize the cells' domains
	[self setPossibilities];
	
    BOOL solved = [self allCellsHaveValues];
    
    while (!solved) {
		[self setSolvedCells];
		[self refreshDomains];
		
		solved = [self allCellsHaveValues];
		
    } //End While Loop
} //End solve

//For-each cell, if the cell only has one element in its domain, set the value to that element
-(void) setSolvedCells
{
	//For each cell
	for (ViewController *thisCell in puzzle) {
		//If only one possible value
		if(thisCell.cellPossibilities.count == 1) { //Not hit
			//Set the cell's value as the only possible value
			[self updateCellToNum: thisCell: [thisCell.cellPossibilities[0] intValue]]; //Problem Line//
			
		}
	
	} //End For Loop
} //End setSolvedCells

//Make sure every cell only has "unique"(valid) values in its domain
-(void)refreshDomains
{
	//For each cell
	for (ViewController *thisCell in puzzle) {
		//For each possible value
		for (NSNumber *num in [thisCell.cellPossibilities copy]){
			
			//If the value isn't unique, remove it  //Not hit
			if (!([self numIsUniqueForCellInRow:thisCell :[num integerValue]] &&   //If the number is not unique for row,
                  [self numIsUniqueForCellInColumn:thisCell :[num integerValue]] && //column, or group
                  [self numIsUniqueForCellInGroup:thisCell :[num integerValue]])) {
				
				[thisCell.cellPossibilities removeObject:num];
				
			} //end if
		} //End inner for loop	
	} //End outer for loop
} //End refreshDomains

-(bool) allCellsHaveValues
{	
	//For each cell
	for (ViewController *thisCell in puzzle) {
		//If cell.value == 0
		if(thisCell.value == 0) {
			return false;
		} //End if
	
	} //End for loop
	
	return true;
	
} //End allCellsHaveValues


@end
