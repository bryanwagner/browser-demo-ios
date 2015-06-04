//
//  ViewController.h
//  BrowserDemo
//
//  Created by Bryan Wagner on 6/4/15.
//  Copyright (c) 2015 Bryan Wagner. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"

@interface BrowserViewController : UIViewController <UIWebViewDelegate, UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UIWebView   *webView;
@property (weak, nonatomic) IBOutlet UITextField *urlTextField;
@property (weak, nonatomic) IBOutlet UIButton    *refreshButton;
@property (weak, nonatomic) IBOutlet UIButton    *backButton;
@property (weak, nonatomic) IBOutlet UIButton    *forwardButton;

- (IBAction)onRefreshButton :(id)sender;
- (IBAction)onBackButton    :(id)sender;
- (IBAction)onForwardButton :(id)sender;

@end

