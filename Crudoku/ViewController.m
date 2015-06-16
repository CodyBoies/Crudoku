//
//  ViewController.m
//  Crudoku
//
//  Created by MacLab08 on 6/3/15.
//  Copyright (c) 2015 Cody & Jeff Boies. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

NSMutableArray *puzzle;
NSMutableArray *rowSection[9];
NSMutableArray *columnSection[9];
NSMutableArray *groupSection[9];

BOOL solved = false;

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    [self initSudoku];
    [self initKeyboard];
    [self defaultPuzzle];
    [self updateView];
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

#pragma mark - initialize

-(void)initSudoku {   //The following code creates the sudoku board on the main view
    int xOffset;
    int yOffset = 56;
    int offset = 0;
    int size = 34;
    UIView *dummyView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
    puzzle = [[NSMutableArray alloc] init];
    
    for (int i = 0; i < 9; i++) {
        rowSection[i] = [[NSMutableArray alloc] init];
        columnSection[i] = [[NSMutableArray alloc] init];
        groupSection[i] = [[NSMutableArray alloc] init];
        
    }
    
    for (int i = 0; i < 9; i++) {
        xOffset = 6;
        for (int j = 0; j < 9; j++) {
            UITextField *cell = [[UITextField alloc] initWithFrame:CGRectMake(xOffset, yOffset, size, size)];
            ViewController *newCell = [[ViewController alloc] init];
            newCell.cellPossibilities = [[NSMutableArray alloc] init];
            newCell.row = i;
            newCell.column = j;
            newCell.value = 0;
            newCell.cellField = cell;
            newCell.group = [getGroup: newCell];
            [puzzle addObject:newCell];
            [rowSection[i] addObject:newCell];
            [columnSection[j] addObject:newCell];
            
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
            }
            
        }
        yOffset += (offset + size);
        if (i == 2 || i == 5) {
            yOffset = yOffset + 1;
        }
    }
}

-(int) getGroup: (ViewController *)cell {
    ViewController *thisCell = cell;
    if (thisCell.row <= 3 && thisCell.column <= 3){
        thisCell.group = 0;
        return thisCell.group;
    }
    if (thisCell.row <= 3 && (thisCell.column >= 4 && thisCell.column <= 6)){
        thisCell.group = 1;
        return thisCell.group;
    }
    if (thisCell.row <= 3 && (thisCell.column >= 7 && thisCell.column <= 9)){
        thisCell.group = 2;
        return thisCell.group;
    }
    if ((thisCell.row >= 4 && thisCell.row <= 6) && thisCell.column <= 3){
        thisCell.group = 3;
        return thisCell.group;
    }
    if ((thisCell.row >= 4 && thisCell.row <= 6) && (thisCell.column >= 4 && thisCell.column <= 6)){
        thisCell.group = 4;
        return thisCell.group;
    }
    if ((thisCell.row >= 4 && thisCell.row <= 6) && (thisCell.column >= 7 && thisCell.column <= 9)){
        thisCell.group = 5;
        return thisCell.group;
    }
    if ((thisCell.row >= 7 && thisCell.row <= 9) && thisCell.column <= 3){
        thisCell.group = 6;
        return thisCell.group;
    }
    if ((thisCell.row >= 7 && thisCell.row <=9) && (thisCell.column >= 4 && thisCell.column <= 6)){
        thisCell.group = 7;
        return thisCell.group;
    }
    if ((thisCell.row >= 7 && thisCell.row >=9) && (thisCell.column >= 7 && thisCell.column <= 9)){
        thisCell.group = 8;
        return thisCell.group;
    }
}

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
        }
        yOffset += (offset + ysize);
    }
}

#pragma mark - interface

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
}

-(void) clearNumber: (id)sender {
    UITextField *cellTapped = sender;
    for (ViewController *thisCell in puzzle) {
        if (thisCell.cellField == cellTapped) {
            thisCell.value = 0;
            thisCell.cellField.text = @"";
            break;
        }
    }
}

-(IBAction)solveButton:(id)sender   //Sets action for solve button
{
    [self setPossibilities];
    [self refinePossibilities];
    [self updateView];
    [self solve:0];
}

-(IBAction)resetButton:(id)sender{   //Set the action for the reset button
    [self defaultPuzzle];
    [self updateView];
}

#pragma mark - solver

//These next three methods check to make sure the current number is unique to that cell

-(BOOL)numIsUniqueForCellInRow :(ViewController *)cell :(int)testnum  //Checks row for unique number
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

//Recursive method of solution

-(void) solve :(int)index {
    solved = (index > 80);   //If the cell index is greater than 80, the puzzle is finished
    if (solved) {
        return;
    }
    
    ViewController *thisCell = [puzzle objectAtIndex:index];
    
    if (thisCell.value !=0) {  //If cell index has a number in it, run solve method for next cell
        [self solve: (index + 1)];
        if (solved) {
            return;
        }
    }
    else
    {
        for (NSNumber *testNum in thisCell.cellPossibilities){  //Otherwise, if the number is unique to the
            int num = [testNum integerValue];                   //cell index
            if ([self numIsUniqueForCellInRow:thisCell :num] &&
                [self numIsUniqueForCellInColumn:thisCell :num] &&
                [self numIsUniqueForCellInGroup:thisCell :num])
            {
                [self updateCellToNum: thisCell :num];  //Set cell to that number
                [self solve:index + 1];   //run solve method on next cell
                if (solved) {
                    return;
                }
            }
        }
        //[self updateCellToNum:thisCell :0];
    }
}
         
-(void) defaultPuzzle {   //This sets up a default puzzle to run on launch
    int t[9][9] =
       {{5,7,0,2,6,0,0,0,0},
        {2,0,8,0,0,0,0,0,0},
        {0,9,1,8,0,0,0,0,0},
        {3,0,7,5,0,0,0,0,0},
        {6,0,0,0,4,0,0,0,8},
        {0,0,0,0,0,7,9,0,3},
        {0,0,0,0,0,8,5,3,0},
        {0,0,0,0,0,0,1,0,4},
        {0,0,0,0,1,4,0,7,2}};
    
    for (int i = 0; i < 9; i++) {
        for (int j = 0; j < 9; j++) {
            ViewController *thisCell = [puzzle objectAtIndex:(9 * i + j)];
            thisCell.value = t[i][j];
        }
    }
    solved = false;
}
         
//This method updates valid possible cell numbers
         
-(void) refinePossibilities {
    BOOL solvedAtLeastOneCell = false;
    BOOL allSolved = true;
    for (ViewController *thisCell in puzzle) {
        for (NSNumber *testNum in [thisCell.cellPossibilities copy]){
            int num = [testNum integerValue];
            if (!([self numIsUniqueForCellInRow:thisCell :num] &&   //If the number is not unique for row,
                  [self numIsUniqueForCellInColumn:thisCell :num] && //column, or group
                  [self numIsUniqueForCellInGroup:thisCell :num])) {
                [thisCell.cellPossibilities removeObject:testNum]; //Remove number from possibilities array
            }
            
        }
        
        if (thisCell.cellPossibilities.count == 1 && thisCell.value == 0) {
            thisCell.value = [[thisCell.cellPossibilities objectAtIndex:0] integerValue];
            //solvedAtLeastOneCell == true;
        }
        if (thisCell.cellPossibilities.count > 1) {
            allSolved = false;
        }
    }
    if (!solvedAtLeastOneCell) {
        //solvedAtLeastOneCell = [self onlyPossibleValueMethod];
    }
    if (solvedAtLeastOneCell && !allSolved) {
        [self refinePossibilities];
    }
}

//Initializes possibilities for cell answers

-(void) setPossibilities {
    for (ViewController *thisCell in puzzle) {
        [thisCell.cellPossibilities removeAllObjects];
        for (int num = 1; num < 10; num++) {
            if ([self numIsUniqueForCellInRow:thisCell :num] &&
                [self numIsUniqueForCellInColumn:thisCell :num] &&
                [self numIsUniqueForCellInGroup:thisCell :num]) {
                [thisCell.cellPossibilities addObject:[NSNumber numberWithInt:num]];
            }
        }
    }
}
    
-(void)updateCellToNum: cell :(int)num{
    ViewController *thisCell = cell;
    for (thisCell in puzzle) {
        thisCell.cellField.text = [NSString stringWithFormat:@"%d", num];
        [self updateView];
    }
}

-(void) updateView {
    
}









@end
