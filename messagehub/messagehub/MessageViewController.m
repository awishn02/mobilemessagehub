//
//  MessageViewController.m
//  messagehub
//
//  Created by Aaron Wishnick on 11/5/13.
//  Copyright (c) 2013 Aaron Wishnick. All rights reserved.
//

#import "MessageViewController.h"
#import "MessageCell.h"

#define DISPATCH_QUEUE dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)


@interface MessageViewController ()

@end

@implementation MessageViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setTitle:[self.message objectForKey:@"username"]];
    self.navigationController.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName : [UIColor whiteColor]};
    [self updateTable];
    [self LaunchTimer];
    
	// Do any additional setup after loading the view.
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
    NSURL *URL = [NSURL URLWithString:[NSString stringWithFormat:@"http://shrouded-harbor-3141.herokuapp.com/messages/%@/messagesForUser", [self.message objectForKey:@"username"]]];
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
    
#pragma mark - Table view data source
    
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
    {
        // Return the number of sections.
        return 1;
    }
    
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
    {
        // Return the number of rows in the section.
        return self.messages.count;
    }
    
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
    {
        static NSString *CellIdentifier = @"Cell";
        MessageCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
        // Configure the cell...
        cell.label.text = [[self.messages objectAtIndex:indexPath.row] objectForKey:@"content"];
        cell.label.backgroundColor = [UIColor clearColor];
        return cell;
    }


@end
