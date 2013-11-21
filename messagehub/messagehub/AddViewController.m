//
//  AddViewController.m
//  messagehub
//
//  Created by Aaron Wishnick on 11/5/13.
//  Copyright (c) 2013 Aaron Wishnick. All rights reserved.
//

#import "AddViewController.h"
#import "ViewController.h"

#define DISPATCH_QUEUE dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)
#define URL [NSURL URLWithString:@"http://shrouded-harbor-3141.herokuapp.com/messages.json"]

@interface AddViewController ()

@end

@implementation AddViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.content.layer.cornerRadius = 5.0f;
    self.content.layer.borderWidth = .25f;
    self.content.layer.borderColor = [[UIColor lightGrayColor] CGColor];
    self.isError = false;
}
    
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    NSLog(@"%@", text);
    if ([text hasSuffix:@"\n"]) {
        NSLog(@"Return pressed");
    } else {
        NSLog(@"Other pressed");
    }
    return YES;
}

- (IBAction)submitMessage:(id)sender{
    NSString *username = self.username.text;
    NSString *content = self.content.text;
    NSString *token = [[NSUserDefaults standardUserDefaults] objectForKey:@"device_token"];
    if(!token){
        token = @"no_token";
    }
    NSDictionary *json = [NSDictionary dictionaryWithObject:[NSDictionary dictionaryWithObjectsAndKeys:
                                                             username, @"username",
                                                             content, @"content",
                                                             @"0", @"app_id",
                                                             token, @"device_token",
                                                             nil] forKey:@"message"];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:URL];
	[request setHTTPMethod:@"POST"];
	[request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
	[request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
	NSError *error;
	NSData *postData = [NSJSONSerialization dataWithJSONObject:json options:0 error:&error];
	[request setHTTPBody:postData];
	NSURLConnection *connection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
	(void)connection;
}

- (void)displayAlert{
	self.errorView.hidden = false;
	CGRect frame = self.errorView.frame;
	frame.origin.y = 0;
	
	[UIView beginAnimations:nil context:nil];
	[UIView setAnimationDuration:.5];
	[UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
	
	self.errorView.frame = frame;
	[UIView commitAnimations];
}

- (void)dismissAlert{
	CGRect frame = self.errorView.frame;
	frame.origin.y = -100;
	
	[UIView beginAnimations:nil context:nil];
	[UIView setAnimationDuration:.5];
	[UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
	
	self.errorView.frame = frame;
	[UIView commitAnimations];
	[NSTimer scheduledTimerWithTimeInterval:.5 target:self selector:@selector(hideAlert) userInfo:nil repeats:NO];
}

- (void)hideAlert{
	self.errorView.hidden = true;
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
	[self.view endEditing:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark - NSURLConnection Delegate Methods
- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
    NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)response;
    if ([httpResponse statusCode] == 200){
        ViewController *viewController = self.navigationController.viewControllers[0];
        [viewController displaySuccess];
        self.isError = false;
        [self.navigationController popToRootViewControllerAnimated:YES];
    }else{
        self.isError = true;
    }
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data{
    if(self.isError){
        NSError *error;
        NSDictionary *json = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
        BOOL isSecond = true;
        BOOL isUnknown = true;
        NSMutableString *errorString = [[NSMutableString alloc] initWithCapacity:160];
        if ([json objectForKey:@"username"]){
            [errorString appendString:@"Username must be alphanumeric and be between 3 and 60 characters."];
            isSecond = false;
            isUnknown = false;
        }
        if ([json objectForKey:@"content"]){
            if(isSecond){
                [errorString appendString:@"\nMessage must be between 1 and 160 characters."];
            }else{
                [errorString appendString:@"Message must be between 1 and 160 characters."];
            }
            isUnknown = false;
        }
        
        if (isUnknown){
            [errorString appendString:@"An unknown error has occured."];
            NSLog(@"%@", json);
        }
    
        self.errorLabel.text = errorString;
        [self displayAlert];
        [NSTimer scheduledTimerWithTimeInterval:3.0 target:self selector:@selector(dismissAlert) userInfo:nil repeats:NO];
    }
}

@end
