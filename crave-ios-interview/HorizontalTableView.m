//
//  HorizontalScrollView.m
//  testa
//
//  Created by Ishay Weinstock on 12/16/14.
//  Copyright (c) 2014 Ishay Weinstock. All rights reserved.
//

#import "HorizontalTableView.h"

#define SEPARATOR_WIDTH 1
#define DEFAULT_CELL_WIDTH 100

@implementation HorizontalTableView

#pragma mark UIView Over-Rides

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initTable];
    }
    return self;
}


//The Draw rect act as event to start and setting up the scrollview and the integers that will be used, before the user can scroll or somthing is displayed.
- (void)drawRect:(CGRect)rect{
    
    self.scrollView.frame = self.bounds;
    
    //Number of cells totally in the array of the datasource
    self.numOfCells = [self.dataSource horizontalScrollViewNumberOfCells:self] - 1;
    
    //Calculates how many cells needs to be used to fill the screen with cells
    self.numOfVisibleCells = MIN(self.frame.size.width / DEFAULT_CELL_WIDTH + 3, self.numOfCells);
    
    //Defines the scrollview contentsize, scrolling area.
    CGSize contentSize = CGSizeMake((DEFAULT_CELL_WIDTH * (self.numOfCells + 1)) + (SEPARATOR_WIDTH * self.numOfCells), self.bounds.size.height);
    self.scrollView.contentSize = contentSize;
    
    
    //After setting up the views we start the table queueing by calling the first one to show.
    [self displayCellAtIndex:0];
}


#pragma mark Views Setup

-(void)initTable{
    self.scrollView = [[UIScrollView alloc] init];
    self.cellsQeue = [NSMutableDictionary dictionary];
    self.scrollView.delegate = self;
    [self addSubview:self.scrollView];
}


#pragma mark Cell Methods


//Display Cell Method - Invoked on init with index 0 or when scroll view is moving and index changes and changes the displayed view. logically differences between scroll directions. 
-(void)displayCellAtIndex:(NSInteger)cellIndex{
    
    NSInteger theNextOrPrevCellIndex = MIN(cellIndex + self.numOfVisibleCells, self.numOfCells);
    
    for (NSInteger i = cellIndex; i <= theNextOrPrevCellIndex ; i++) {
        
        UILabel *cell = [self reusableCellAtIndex:i];
        if (!cell.superview)
        {
            cell.tag = i;
            cell.frame = CGRectMake((i * DEFAULT_CELL_WIDTH) + (SEPARATOR_WIDTH * i), 0, DEFAULT_CELL_WIDTH, self.frame.size.height);
            [self.scrollView addSubview:cell];
        }
        
        CGFloat cellX = i * DEFAULT_CELL_WIDTH + (SEPARATOR_WIDTH * i);
        CGRect cellFrame = cell.frame;
        cellFrame.origin.x = cellX;
        cell.frame = cellFrame;
    }
    
    if (self.lastCellPosition < cellIndex) {
        UILabel *cell = [self reusableCellAtIndex:cellIndex-1];
        if (cell) {
            [self pushReusableCell:cell];
        }
    }
    else{
        UILabel *cell = [self reusableCellAtIndex:theNextOrPrevCellIndex];
        if (cell) {
            [self pushReusableCell:cell];
        }
    }
}

//Add the reusable cell to the set according to movement and index
-(void)pushReusableCell:(UIView *)cell{
    [[self getCellsList] addObject:cell];
}

//Return a reusable cell at certain index
- (UILabel *)reusableCellAtIndex:(NSUInteger)index{
    UILabel *cell = [self visibleCellAtIndex:index];
    
    if (!cell){
        cell = (UILabel*) [self.dataSource horizontalScrollView:self cellForIndex:index];
    }
    cell.tag = index;
    
    return cell;
}

//Return visible cell instance at certain index
- (UILabel *)visibleCellAtIndex:(NSUInteger)index{
    
    for (UIView *view in self.scrollView.subviews){
        if ([view isKindOfClass:[UILabel class]]){
            UILabel *cell = (UILabel *) view;
            if (cell.tag == index){
                return cell;
            }
        }
    }
    return nil;
}



//Return the cells  list as a mutable set using the identifier
//Makes sure memory isnt stacked.
-(NSMutableSet *)getCellsList{
    NSMutableSet *cellsList = self.cellsQeue[@"cell"];
    if(cellsList == nil){
        cellsList = [NSMutableSet set];
        self.cellsQeue[@"cell"] = cellsList;
    }
    return cellsList;
}

#pragma mark UIScrollViewDelegate


//Methoed that invoked when user perform scroll, this is what actually adding/removing the cells according to the movement
-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    CGFloat x = scrollView.contentOffset.x;
    NSInteger cellToScroll = floor(x / (DEFAULT_CELL_WIDTH + SEPARATOR_WIDTH));
    //Return nothing on the edges start and end.
    if (cellToScroll >  self.numOfCells || cellToScroll < 0) {
        return;
    }
    //Updates the last cell loaded
    if (self.lastCellPosition != cellToScroll) {
        [self displayCellAtIndex:cellToScroll];
        self.lastCellPosition = cellToScroll;
    }
}

#pragma mark Dequeue Method

- (UIView*)dequeueCell{
    UIView *cell;
    if([self getCellsList].count > 0){
        cell = [[self getCellsList] anyObject];
        [[self getCellsList] removeObject:cell];
    }
    return cell;
}

@end
