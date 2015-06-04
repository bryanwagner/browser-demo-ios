//
//  ViewController.m
//  BrowserDemo
//
//  Created by Bryan Wagner on 6/4/15.
//  Copyright (c) 2015 Bryan Wagner. All rights reserved.
//

#import "BrowserViewController.h"

NSString *const BROWSER_REFRESH_TEXT = @"R";
NSString *const BROWSER_STOP_TEXT    = @"X";

@interface BrowserViewController ()
@property (nonatomic) BOOL loading;
@end

@implementation BrowserViewController

+ (AppDelegate *)appDelegate {
    return (AppDelegate *) [[UIApplication sharedApplication] delegate];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.loading                   = NO;
    self.urlTextField.keyboardType = UIKeyboardTypeWebSearch;
    [self.urlTextField becomeFirstResponder];
}

- (void)viewWillAppear:(BOOL)animated {
    [self updateUI];
}

# pragma mark -
# pragma mark internal methods

- (void)updateUI {
    self.backButton.enabled    = self.webView.canGoBack;
    self.forwardButton.enabled = self.webView.canGoForward;
    [self.refreshButton setTitle:self.loading ? BROWSER_STOP_TEXT : BROWSER_REFRESH_TEXT forState:UIControlStateNormal];
}

- (void)navigateTo:(NSString *)urlString {
    NSArray *words = [urlString componentsSeparatedByCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    urlString      = [words componentsJoinedByString:@""];
    if ([urlString rangeOfString:@"http" options:NSCaseInsensitiveSearch].location != 0) {
        urlString = [NSString stringWithFormat:@"http://%@", urlString];
    }
    NSURL        *url        = [NSURL URLWithString:urlString];
    NSURLRequest *urlRequest = [NSURLRequest requestWithURL:url];
    [self.webView loadRequest:urlRequest];
    self.urlTextField.text   = urlString;
    [self.urlTextField resignFirstResponder];
    [self updateUI];
}

- (void)navigateToUrlTextField {
    [self navigateTo:self.urlTextField.text];
}

- (void)navigateBack {
    [self.webView goBack];
    [self updateUI];
}

- (void)navigateForward {
    [self.webView goForward];
    [self updateUI];
}

- (void)navigateRefresh {
    [self.webView reload];
    [self updateUI];
}

- (void)navigateStop {
    [self.webView stopLoading];
    self.loading = NO;
    [self updateUI];
}

# pragma mark -
# pragma mark UI action methods

- (IBAction)onRefreshButton:(id)sender {
    if (self.loading) {
        [self navigateStop];
    }
    else {
        [self navigateRefresh];
    }
}

- (IBAction)onBackButton:(id)sender {
    [self navigateBack];
}

- (IBAction)onForwardButton:(id)sender {
    [self navigateForward];
}

# pragma mark -
# pragma mark UIWebViewDelegate methods

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
    return YES;
}

- (void)webViewDidStartLoad:(UIWebView *)webView {
    self.loading = YES;
    [self updateUI];
}

- (void)webViewDidFinishLoad:(UIWebView *)webView {
    self.loading = NO;
    if (self.webView.request) {
        NSString *urlString = self.webView.request.URL.absoluteString;
        if (urlString.length > 0) {
            self.urlTextField.text = urlString;
        }
    }
    [self updateUI];
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {
    [self updateUI];
    NSLog(@"webView:didFailLoadWithError: %@", error.description);
}

#pragma mark -
#pragma mark UITextFieldDelegate methods

- (void)textFieldDidEndEditing:(UITextField *)textField {
    [self.urlTextField resignFirstResponder];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [self navigateToUrlTextField];
    return YES;
}

@end
