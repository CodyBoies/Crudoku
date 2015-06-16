//
//  ViewController.h
//  Crudoku
//
//  Created by MacLab08 on 6/3/15.
//  Copyright (c) 2015 Cody & Jeff Boies. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController
<UITextFieldDelegate>

@property (nonatomic) int row;
@property (nonatomic) int column;
@property (nonatomic) int group;
@property (nonatomic) int value;

@property (strong, nonatomic) UITextField *cellField;
@property (strong, nonatomic) NSMutableArray *cellPossibilities;

- (IBAction)resetButton:(id)sender;
- (IBAction)solveButton:(id)sender;


@end
