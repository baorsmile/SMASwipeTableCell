//
//  SMASwipeCell.m
//  SMASwipeTableCell
//
//  Created by Dabao on 13-12-3.
//  Copyright (c) 2013年 Dabao. All rights reserved.
//

#import "SMASwipeTableCell.h"

#define BUTTON_WITH 65

@interface SMASwipeTableCell ()<UIScrollViewDelegate, UIGestureRecognizerDelegate>
{
    SMASwipeTableCellState _cellState; // The state of the cell within the scroll view, can be left, right or middle
    CGFloat _height;
    BOOL isCellSelected;

}

@property (nonatomic, strong) UIScrollView *cellScrollView;
@property (nonatomic, weak)   UIView       *scrollViewContentView;

@property (nonatomic, strong) UIView *scrollViewButtonViewLeft;
@property (nonatomic, strong) UIView *scrollViewButtonViewRight;


@property (nonatomic, weak) UILongPressGestureRecognizer *longPressGestureRecognizer;


@end

static NSString * const kTableViewCellContentView = @"UITableViewCellContentView";

@implementation SMASwipeTableCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier leftButtons:(NSArray *)leftButtons rightButtons:(NSArray *)rightButtons
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        _leftButtons = leftButtons;
        _rightButtons = rightButtons;
        [self initializer];
    
    }
    return self;
}

- (void)awakeFromNib
{
    [self initializer];
}

- (void)detele
{
    NSLog(@"detele ");
}

#pragma mark - Utility buttons handling

- (void)rightUtilityButtonHandler:(UIButton *)sender {
    NSUInteger utilityButtonIndex = sender.tag;
    if ([_delegate respondsToSelector:@selector(swipeableTableViewCell:didTriggerRightUtilityButtonWithIndex:)]) {
        [_delegate swipeableTableViewCell:self didTriggerRightUtilityButtonWithIndex:utilityButtonIndex];
        [self hideUtilityButtonsAnimated:YES];
    }
}

- (void)leftUtilityButtonHandler:(UIButton *)sender {
    NSUInteger utilityButtonIndex = sender.tag;
    if ([_delegate respondsToSelector:@selector(swipeableTableViewCell:didTriggerLeftUtilityButtonWithIndex:)]) {
        [_delegate swipeableTableViewCell:self didTriggerLeftUtilityButtonWithIndex:utilityButtonIndex];
        [self hideUtilityButtonsAnimated:YES];
    }
}

- (void)setLeftButtons:(NSArray *)leftButtons
{
    _leftButtons = [leftButtons copy];
    
    UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, leftButtons.count * BUTTON_WITH, CGRectGetHeight(self.bounds))];
    imageView.image = [UIImage imageNamed:@"bg_opreat"];
    [self.scrollViewButtonViewLeft addSubview:imageView];
  
    if (leftButtons.count > 0) {
        [leftButtons enumerateObjectsUsingBlock:^(NSString *obj, NSUInteger idx, BOOL *stop) {
            UIButton *leftButton = [UIButton buttonWithType:UIButtonTypeCustom];
            [leftButton setBackgroundImage:[UIImage imageNamed: obj] forState:UIControlStateNormal];
            [leftButton setFrame:CGRectMake(idx * (BUTTON_WITH - 1), 2, BUTTON_WITH - 1, CGRectGetHeight(self.bounds) - 4)];
            [leftButton setTitle: obj  forState:UIControlStateNormal];
            leftButton.tag = idx + 100;
            leftButton.titleEdgeInsets = UIEdgeInsetsMake(61 - 30, 0, 0, 0);
            leftButton.titleLabel.font = [UIFont systemFontOfSize:12];
            [leftButton setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
            [leftButton addTarget:self action:@selector(leftUtilityButtonHandler:) forControlEvents:UIControlEventTouchUpInside];
            [self.scrollViewButtonViewLeft addSubview:leftButton];
        }];
    }


    [self layoutSubviews];

}

- (void)setRightButtons:(NSArray *)rightButtons
{
    _rightButtons = rightButtons;
  
    if (rightButtons.count > 0) {
        [rightButtons enumerateObjectsUsingBlock:^(NSString *obj, NSUInteger idx, BOOL *stop) {
            UIButton *button1 = [UIButton buttonWithType:UIButtonTypeCustom];
            button1.backgroundColor = [UIColor redColor];
            [button1 setTitle:obj forState:UIControlStateNormal];
            button1.frame = CGRectMake(0, 0, BUTTON_WITH, BUTTON_WITH);
            [button1 addTarget:self action:@selector(rightUtilityButtonHandler:) forControlEvents:UIControlEventTouchUpInside];
            [self.scrollViewButtonViewRight addSubview:button1];
        }];
    }

    [self layoutSubviews];
}

#pragma mark - Overriden methods

- (void)layoutSubviews {
    [super layoutSubviews];
    
    self.cellScrollView.frame = CGRectMake(0, 0, CGRectGetWidth(self.bounds), _height);
    self.cellScrollView.contentSize = CGSizeMake(CGRectGetWidth(self.bounds) + [self utilityButtonsPadding], _height);
    self.cellScrollView.contentOffset = CGPointMake([self leftUtilityButtonsWidth], 0);
    self.scrollViewButtonViewLeft.frame = CGRectMake([self leftUtilityButtonsWidth], 0, [self leftUtilityButtonsWidth], _height);
    self.scrollViewButtonViewRight.frame = CGRectMake(CGRectGetWidth(self.bounds), 0, [self rightUtilityButtonsWidth], _height);
    self.scrollViewContentView.frame = CGRectMake([self leftUtilityButtonsWidth], 0, CGRectGetWidth(self.bounds), _height);
    self.cellScrollView.scrollEnabled = YES;
}

- (void)initializer
{
    _height = CGRectGetHeight(self.bounds);

    /**
     *  UIScrollView
     */
    UIScrollView *cellScrollView = [[UIScrollView alloc] initWithFrame:self.bounds];
    cellScrollView.delegate = self;
    cellScrollView.contentOffset = [self scrollViewContentOffset];
    cellScrollView.showsHorizontalScrollIndicator = NO;
    cellScrollView.contentSize = CGSizeMake(CGRectGetWidth(self.bounds) + [self utilityButtonsPadding], _height);
    self.cellScrollView = cellScrollView;
    
    /**
     *  ButtonsLeftView
     */
    UIView *scrollViewButtonViewLeft = [[UIView alloc] initWithFrame:CGRectMake([self leftUtilityButtonsWidth], 0, [self leftUtilityButtonsWidth], BUTTON_WITH)];
    self.scrollViewButtonViewLeft = scrollViewButtonViewLeft;
    scrollViewButtonViewLeft.hidden = YES;
    [self.cellScrollView addSubview:scrollViewButtonViewLeft];

    /**
     *  ButtonsRightView
     */
    UIView *scrollViewButtonViewRight = [[UIView alloc] initWithFrame:CGRectMake(CGRectGetWidth(self.bounds), 0, BUTTON_WITH, BUTTON_WITH)];
    self.scrollViewButtonViewRight = scrollViewButtonViewRight;
    self. scrollViewButtonViewRight.hidden = YES;
    [self.cellScrollView addSubview:scrollViewButtonViewRight];

    /**
     *  Create the content view that will live in our scroll view
     */
    UIView *scrollViewContentView = [[UIView alloc] initWithFrame:CGRectMake([self leftUtilityButtonsWidth], 0, CGRectGetWidth(self.bounds), CGRectGetHeight(self.bounds))];
    scrollViewContentView.backgroundColor = [UIColor whiteColor];
    [self.cellScrollView addSubview:scrollViewContentView];
    self.scrollViewContentView = scrollViewContentView;
    
    UILongPressGestureRecognizer *longPressGestureRecognizer = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(selectCellWithTimedHighlight:)];
    longPressGestureRecognizer.minimumPressDuration = 0.08;
    [scrollViewContentView addGestureRecognizer:longPressGestureRecognizer];
    self.longPressGestureRecognizer = longPressGestureRecognizer;

    
    // Add the cell scroll view to the cell
    UIView *contentViewParent = self;
    if (![NSStringFromClass([[self.subviews objectAtIndex:0] class]) isEqualToString:kTableViewCellContentView]) {
        // iOS 7
        contentViewParent = [self.subviews objectAtIndex:0];
    }
    NSArray *cellSubviews = [contentViewParent subviews];
    [self insertSubview:cellScrollView atIndex:0];
    for (UIView *subview in cellSubviews) {
        [self.scrollViewContentView addSubview:subview];
    }
}

#pragma mark - TargetForRecongizer
- (void)selectCellWithTimedHighlight:(UILongPressGestureRecognizer *)recognizer
{
    if (_cellState == kCellStateCenter) {
        // Selection
        UITableView *tableView = (UITableView *)self.superview.superview;
        NSIndexPath *cellIndexPath = [tableView indexPathForCell:self];

        if (tableView.isEditing) {
            NSLog(@"recognizer %d",recognizer.state);
            
            if (recognizer.state == UIGestureRecognizerStateBegan) {
                if (self.isSelected) {
                    isCellSelected = YES; //这里说一下， isCellSelected时根据原有tableView状态更改的
                } else {
                    [tableView selectRowAtIndexPath:cellIndexPath animated:NO scrollPosition:UITableViewScrollPositionNone];
                    isCellSelected = NO;
                }
            } else if (recognizer.state == UIGestureRecognizerStateCancelled | recognizer.state == UIGestureRecognizerStateEnded) {
                if (isCellSelected) {
                    [tableView deselectRowAtIndexPath:cellIndexPath animated:NO];
                }
            }
            
            if ([tableView.delegate respondsToSelector:@selector(tableView:didDeselectRowAtIndexPath:)]) {
                [tableView.delegate tableView:tableView didDeselectRowAtIndexPath:cellIndexPath];
            }
            
        } else {
            NSLog(@"recognizer %d",recognizer.state);
            if (recognizer.state == UIGestureRecognizerStateBegan) {
                [tableView selectRowAtIndexPath:cellIndexPath animated:NO scrollPosition:UITableViewScrollPositionNone];
            } else if (recognizer.state == UIGestureRecognizerStateCancelled | recognizer.state == UIGestureRecognizerStateEnded) {
                if ([tableView.delegate respondsToSelector:@selector(tableView:didSelectRowAtIndexPath:)]) {
                    [tableView.delegate tableView:tableView didSelectRowAtIndexPath:cellIndexPath];
                }
            }
        }

    } else {
        // Scroll back to center
        if (recognizer.state == UIGestureRecognizerStateBegan) {
            [self hideUtilityButtonsAnimated:YES];
        }
    }
}

#pragma mark - Setup helpers

- (CGFloat)leftUtilityButtonsWidth {
    return BUTTON_WITH * _leftButtons.count;
}

- (CGFloat)rightUtilityButtonsWidth {
    return BUTTON_WITH * _rightButtons.count;
}

- (CGFloat)utilityButtonsPadding {
    return [self leftUtilityButtonsWidth] + [self rightUtilityButtonsWidth];
}

- (CGPoint)scrollViewContentOffset {
    return CGPointMake([self leftUtilityButtonsWidth], 0);
}

#pragma mark - HiheButtons

- (void)hideUtilityButtonsAnimated:(BOOL)animated
{
    // Scroll back to center
    
    // Force the scroll back to run on the main thread because of weird scroll view bugs
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.cellScrollView setContentOffset:CGPointMake([self leftUtilityButtonsWidth], 0) animated:animated];
    });
    _cellState = kCellStateCenter;

}
#pragma mark UIScrollView helpers

- (void)scrollToRight:(inout CGPoint *)targetContentOffset{
    targetContentOffset->x = [self utilityButtonsPadding];
    _cellState = kCellStateRight;
    
    if ([_delegate respondsToSelector:@selector(swipeableTableViewCell:scrollingToState:)]) {
        [_delegate swipeableTableViewCell:self scrollingToState:kCellStateRight];
    }
}

- (void)scrollToCenter:(inout CGPoint *)targetContentOffset {
    targetContentOffset->x = [self leftUtilityButtonsWidth];
    _cellState = kCellStateCenter;

    if ([_delegate respondsToSelector:@selector(swipeableTableViewCell:scrollingToState:)]) {
        [_delegate swipeableTableViewCell:self scrollingToState:kCellStateCenter];
    }
}

- (void)scrollToLeft:(inout CGPoint *)targetContentOffset{
    targetContentOffset->x = 0;
    _cellState = kCellStateLeft;

    if ([_delegate respondsToSelector:@selector(swipeableTableViewCell:scrollingToState:)]) {
        [_delegate swipeableTableViewCell:self scrollingToState:kCellStateLeft];
    }
}

#pragma mark - ScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (scrollView.contentOffset.x > [self leftUtilityButtonsWidth]) {
       
        if (_rightButtons.count == 0) {
            self.cellScrollView.scrollEnabled = NO;
        } else {
            self.scrollViewButtonViewRight.frame = CGRectMake(scrollView.contentOffset.x + (CGRectGetWidth(self.bounds) - [self rightUtilityButtonsWidth]),
                                                              0.0f,
                                                              [self rightUtilityButtonsWidth],
                                                              BUTTON_WITH);
        }
        if (self.scrollViewButtonViewRight.hidden) {
            self.scrollViewButtonViewRight.hidden = NO;
        }
        
    } else if (scrollView.contentOffset.x < [self leftUtilityButtonsWidth]) {
        self.cellScrollView.scrollEnabled = YES;
        
        if (self.scrollViewButtonViewLeft.hidden) {
            self.scrollViewButtonViewLeft.hidden = NO;
        }
        self.scrollViewButtonViewLeft.frame = CGRectMake(scrollView.contentOffset.x,
                                                         0.0f,
                                                         [self leftUtilityButtonsWidth],
                                                         BUTTON_WITH);
    } else {
        self.cellScrollView.scrollEnabled = YES;

        if (!self.scrollViewButtonViewLeft.hidden) {
            self.scrollViewButtonViewLeft.hidden = YES;
        }
        if (!self.scrollViewButtonViewRight.hidden) {
            self.scrollViewButtonViewRight.hidden = YES;
        }
    }
}

- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset {
    switch (_cellState) {
        case kCellStateCenter:
            if (velocity.x >= 0.5f) {
                [self scrollToRight:targetContentOffset];
            } else if (velocity.x <= -0.5f) {
                [self scrollToLeft:targetContentOffset];
            } else {
                CGFloat rightThreshold = [self utilityButtonsPadding] - ([self rightUtilityButtonsWidth] / 2);
                CGFloat leftThreshold = [self leftUtilityButtonsWidth] / 2;
                if (targetContentOffset->x > rightThreshold)
                    [self scrollToRight:targetContentOffset];
                else if (targetContentOffset->x < leftThreshold)
                    [self scrollToLeft:targetContentOffset];
                else
                    [self scrollToCenter:targetContentOffset];
            }
            break;
        case kCellStateLeft:
            if (velocity.x >= 0.5f) {
                [self scrollToCenter:targetContentOffset];
            } else if (velocity.x <= -0.5f) {
                // No-op
            } else {
                if (targetContentOffset->x >= ([self utilityButtonsPadding] - [self rightUtilityButtonsWidth] / 2))
                    [self scrollToRight:targetContentOffset];
                else if (targetContentOffset->x > [self leftUtilityButtonsWidth] / 2)
                    [self scrollToCenter:targetContentOffset];
                else
                    [self scrollToLeft:targetContentOffset];
            }
            break;
        case kCellStateRight:
            if (velocity.x >= 0.5f) {
                // No-op
            } else if (velocity.x <= -0.5f) {
                [self scrollToCenter:targetContentOffset];
            } else {
                if (targetContentOffset->x <= [self leftUtilityButtonsWidth] / 2)
                    [self scrollToLeft:targetContentOffset];
                else if (targetContentOffset->x < ([self utilityButtonsPadding] - [self rightUtilityButtonsWidth] / 2))
                    [self scrollToCenter:targetContentOffset];
                else
                    [self scrollToRight:targetContentOffset];
            }
            break;
        default:
            break;
    }
}

- (void)setUserInteractionEnabled:(BOOL)userInteractionEnabled
{
    self.cellScrollView.userInteractionEnabled = userInteractionEnabled;
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
