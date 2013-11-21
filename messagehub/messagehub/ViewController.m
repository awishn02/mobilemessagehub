//
//  ViewController.m
//  messagehub
//
//  Created by Aaron Wishnick on 11/5/13.
//  Copyright (c) 2013 Aaron Wishnick. All rights reserved.
//

#import "ViewController.h"
#import "MessageViewController.h"
#import "MessageCell.h"

#define DISPATCH_QUEUE dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)
#define URL [NSURL URLWithString:@"http://shrouded-harbor-3141.herokuapp.com/messages.json"]
#define UNREGISTER_URL [NSURL URLWithString:@"http://shrouded-harbor-3141.herokuapp.com/register/destroy.json"]

@interface ViewController ()

@end

@implementation ViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.count = 0;
    self.navigationController.navigationBar.translucent = NO;
    [self.navigationController.navigationBar.layer setBorderWidth:0.0];
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)viewDidAppear:(BOOL)animated {
    [self updateTable];
	[self performSelectorOnMainThread:@selector(LaunchTimer) withObject:nil waitUntilDone:NO];
}

- (void)viewDidDisappear:(BOOL)animated {
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)LaunchTimer{
	self.timer = [NSTimer scheduledTimerWithTimeInterval:5.0 target:self selector:@selector(updateTable) userInfo:nil repeats:YES];
}

- (void)updateTable{
	dispatch_async(DISPATCH_QUEUE,
				   ^{NSData *data = [NSData dataWithContentsOfURL: URL];
					   [self performSelectorOnMainThread:@selector(fetchedData:) withObject:data waitUntilDone:YES];
				   });
}

- (void)fetchedData:(NSData *)responseData {
	NSError *error;
	self.messages = [NSJSONSerialization JSONObjectWithData:responseData options:kNilOptions error:&error];
	[self.tableView reloadData];
}

- (void)killTimer{
	if(self.timer){
		[self.timer invalidate];
		self.timer = nil;
	}
}

- (void)displaySuccess {
    [NSTimer scheduledTimerWithTimeInterval:3.0 target:self selector:@selector(hideSuccess) userInfo:nil repeats:NO];
    self.successView.hidden = false;
    CGRect frame = self.successView.frame;
    frame.size.height = 100;
    
    [UIView beginAnimations:nil context:nil];
	[UIView setAnimationDuration:.5];
	[UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
	
	self.successView.frame = frame;
	[UIView commitAnimations];
}

- (void)hideSuccess {
    CGRect frame = self.successView.frame;
    frame.size.height = 0;
    
    [UIView beginAnimations:nil context:nil];
	[UIView setAnimationDuration:.25];
	[UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
	
	self.successView.frame = frame;
	[UIView commitAnimations];
    self.successView.hidden = true;
}

#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    [self killTimer];
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
    if(self.count < self.messages.count){
        UIApplicationState state = [[UIApplication sharedApplication] applicationState];
        if (state == UIApplicationStateBackground || state == UIApplicationStateInactive)
        {
            UILocalNotification *localNotification = [[UILocalNotification alloc] init];
            localNotification.alertBody = @"You have new unread messages";
            [[UIApplication sharedApplication] presentLocalNotificationNow:localNotification];
        }
    }
    self.count = self.messages.count;
    return self.messages.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //static NSString *CellIdentifier = @"Cell";
    //UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    MessageCell *cell = [tableView dequeueReusableCellWithIdentifier:@"messageCell"];
    // Configure the cell...
    cell.messageLabel.text = [[self.messages objectAtIndex:indexPath.row] objectForKey:@"content"];
    cell.messageLabel.backgroundColor = [UIColor clearColor];
    cell.userLabel.text = [[self.messages objectAtIndex:indexPath.row] objectForKey:@"username"];
    cell.userLabel.backgroundColor = [UIColor clearColor];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    MessageViewController *viewController = [self.storyboard instantiateViewControllerWithIdentifier:@"messageViewController"];
    [viewController setMessage:[self.messages objectAtIndex:indexPath.row]];
    [self.navigationController pushViewController:viewController animated:YES];
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

@end
