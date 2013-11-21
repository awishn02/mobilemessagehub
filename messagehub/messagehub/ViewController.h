//
//  ViewController.h
//  messagehub
//
//  Created by Aaron Wishnick on 11/5/13.
//  Copyright (c) 2013 Aaron Wishnick. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UITableViewController
@property NSMutableArray *messages;
@property NSTimer *timer;
@property NSInteger count;

@property IBOutlet UIView *successView;

- (void)updateTable;
- (void)LaunchTimer;
- (void)killTimer;
- (void)displaySuccess;
@end
