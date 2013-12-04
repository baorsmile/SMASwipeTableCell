//
//  SwipeViewController.m
//  SMASwipeTableCell
//
//  Created by Dabao on 13-12-3.
//  Copyright (c) 2013年 Dabao. All rights reserved.
//

#import "SwipeViewController.h"
#import "SMASwipeTableCell.h"

@interface SwipeViewController ()<SMASwipeTableCellDelegate>

@property (nonatomic, strong) NSIndexPath *selectIndexPath;

@end

@implementation SwipeViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}
- (IBAction)edit:(UIBarButtonItem *)sender
{
    if (self.tableView.isEditing) {
        [self.tableView setEditing:NO animated:YES];
    } else {
        [self.tableView setEditing:YES animated:YES];
    }
    [self.tableView performSelector:@selector(reloadData) withObject:nil afterDelay:0.25];

}

- (void)viewDidLoad
{
    [super viewDidLoad];

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    self.tableView.rowHeight = 65;

    self.selectIndexPath = nil;
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"SwipeCell";
    SMASwipeTableCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    cell.leftButtons = @[@"icon_download", @"icon_move.png", @"icon_copy.png", @"icon_rename.png"];
    cell.rightButtons = @[@"Detele"];
    cell.delegate = self;
    
    if (self.tableView.isEditing) {
        cell.userInteractionEnabled = NO;
    } else {
        cell.userInteractionEnabled = YES;
    }

    // Configure the cell...
    cell.textLabel.text = CellIdentifier;
    cell.textLabel.backgroundColor = [UIColor clearColor];
    cell.detailTextLabel.text = CellIdentifier;
    
    return cell;
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return UITableViewCellEditingStyleDelete | UITableViewCellEditingStyleInsert;
}


- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView.isEditing) {
        //
    } else {
       // [tableView deselectRowAtIndexPath:indexPath animated:YES];
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView.isEditing) {
        //
    } else {
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
    }
}

#pragma mark - SwipeTableCellDelegate

- (void)swipeableTableViewCell:(SMASwipeTableCell *)cell didTriggerLeftUtilityButtonWithIndex:(NSInteger)index
{
    NSLog(@"leftButtonIndex %d",index);
}

- (void)swipeableTableViewCell:(SMASwipeTableCell *)cell didTriggerRightUtilityButtonWithIndex:(NSInteger)index
{
    NSLog(@"rightButtonIndex %d",index);

}

- (void)swipeableTableViewCell:(SMASwipeTableCell *)cell scrollingToState:(SMASwipeTableCellState)state
{
    NSIndexPath *cellIndexPath = [self.tableView indexPathForCell:cell];

    NSLog(@"cellIndexPath %d selectIndexPath %d",cellIndexPath.row, self.selectIndexPath.row);
    
    
    if (self.selectIndexPath) {
        NSLog(@"here");
        if (cellIndexPath.row != self.selectIndexPath.row) {
            [self hideCell];
        }
    }
    
    self.selectIndexPath = cellIndexPath;

}

- (void)hideCell
{
    SMASwipeTableCell *selectedCell = (SMASwipeTableCell *)[self.tableView cellForRowAtIndexPath:self.selectIndexPath];
    [selectedCell hideUtilityButtonsAnimated:YES];

}

#pragma mark - UIScrollView
- (void)scrollViewWillBeginDecelerating:(UIScrollView *)scrollView
{
    [self hideCell];
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a story board-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}

 */

@end
