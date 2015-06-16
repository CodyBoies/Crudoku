//
//  Cell.h
//  Crudoku
//
//  Created by MacLab08 on 6/11/15.
//  Copyright (c) 2015 Cody & Jeff Boies. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Cell : NSObject

@property (nonatomic) int row;
@property (nonatomic) int column;
@property (nonatomic) int group;
@property (nonatomic) int value;

@property (strong, nonatomic) UITextField *cellField;
@property (strong, nonatomic) NSMutableArray *cellPossibilities;

@end
