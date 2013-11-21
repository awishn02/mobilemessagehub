//
//  AddViewController.h
//  messagehub
//
//  Created by Aaron Wishnick on 11/5/13.
//  Copyright (c) 2013 Aaron Wishnick. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AddViewController : UIViewController <NSURLConnectionDelegate, NSURLConnectionDataDelegate, UITextViewDelegate>
@property IBOutlet UITextField *username;
@property IBOutlet UITextView *content;
@property IBOutlet UIView *errorView;
@property IBOutlet UILabel *errorLabel;
    @property IBOutlet UIButton *submitBtn;
@property BOOL isError;
- (IBAction)submitMessage:(id)sender;
    - (IBAction)cancel:(id)sender;

@end
