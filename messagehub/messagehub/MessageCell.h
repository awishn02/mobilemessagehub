//
//  MessageCell.h
//  messagehub
//
//  Created by Aaron Wishnick on 11/14/13.
//  Copyright (c) 2013 Aaron Wishnick. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MessageCell : UITableViewCell
    @property IBOutlet UITextView *label;
    @property IBOutlet UILabel *messageLabel;
    @property IBOutlet UILabel *userLabel;

@end
