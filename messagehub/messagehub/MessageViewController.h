//
//  MessageViewController.h
//  messagehub
//
//  Created by Aaron Wishnick on 11/5/13.
//  Copyright (c) 2013 Aaron Wishnick. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MessageViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>
    @property NSDictionary *message;
    @property NSMutableArray *messages;
    @property NSTimer *timer;
    @property IBOutlet UITableView *tableView;
@end
