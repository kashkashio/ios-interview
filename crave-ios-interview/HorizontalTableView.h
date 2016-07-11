//
//  HorizontalScrollView.h
//  testa
//
//  Created by Ishay Weinstock on 12/16/14.
//  Copyright (c) 2014 Ishay Weinstock. All rights reserved.
//

#import <UIKit/UIKit.h>

@class HorizontalTableView;

@protocol HorizontalTableViewDataSource <NSObject>

- (UIView*)horizontalScrollView:(HorizontalTableView*)view cellForIndex:(NSInteger)index;
- (NSInteger)horizontalScrollViewNumberOfCells:(HorizontalTableView*)scrollView;

@end

@interface HorizontalTableView : UIView <UIScrollViewDelegate>
{
}

@property (weak)   id<HorizontalTableViewDataSource>    dataSource;
@property (assign) CGFloat                              cellWidth;


//Saves the last cell position
@property (assign, nonatomic) NSInteger lastCellPosition;

//Total number of cells in the SET/LIST
@property (assign, nonatomic) NSInteger numOfCells;

//Number of visible cells right now
@property (assign, nonatomic) NSInteger numOfVisibleCells;

//The cells queue that used to push and remove cells from
@property (strong, nonatomic) NSMutableDictionary *cellsQeue;

//The scrollview that scrolls and shows the table and invokes the methodes using its delegate to reuse cells
@property (strong, nonatomic) UIScrollView *scrollView;


- (UIView*)dequeueCell;


@end