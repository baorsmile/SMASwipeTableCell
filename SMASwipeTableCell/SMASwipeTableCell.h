//
//  SMASwipeCell.h
//  SMASwipeTableCell
//
//  Created by Dabao on 13-12-3.
//  Copyright (c) 2013年 Dabao. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum {
    kCellStateCenter,
    kCellStateLeft,
    kCellStateRight
} SMASwipeTableCellState;

@class SMASwipeTableCell;

@protocol SMASwipeTableCellDelegate <NSObject>

@optional
- (void)swipeableTableViewCell:(SMASwipeTableCell *)cell didTriggerLeftUtilityButtonWithIndex:(NSInteger)index;
- (void)swipeableTableViewCell:(SMASwipeTableCell *)cell didTriggerRightUtilityButtonWithIndex:(NSInteger)index;
- (void)swipeableTableViewCell:(SMASwipeTableCell *)cell scrollingToState:(SMASwipeTableCellState)state;

@end

@interface SMASwipeTableCell : UITableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier leftButtons:(NSArray *)leftButtons rightButtons:(NSArray *)rightButtons;


@property (nonatomic) BOOL userInteractionEnabled;

/**
 *  leftButtons 必须是图片名字，并且也要以图片名字作为图片的 下标名字
 */
@property (nonatomic, strong) NSArray *leftButtons;

/**
 *
 */
@property (nonatomic, strong) NSArray *rightButtons;

@property (nonatomic, weak) id <SMASwipeTableCellDelegate> delegate;

- (void)hideUtilityButtonsAnimated:(BOOL)animated;

@end

