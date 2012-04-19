//
//  MwfSwitchViewController.m
//  MwfSwitchViewController
//
//  Created by Meiwin Fu on 19/4/12.
//  Copyright (c) 2012 –MwF. All rights reserved.
//

#import "MwfSwitchViewController.h"

@interface MwfSwitchViewController ()
- (void) didSwitchToViewController:(UIViewController *)controller;
- (void) switchFrom:(UIViewController *)from to:(UIViewController *)to;
@end

@implementation MwfSwitchViewController
@synthesize selectedIndex = _selectedIndex;
@synthesize selectedViewController = _selectedViewController;
@synthesize viewControllers = _viewControllers;
@synthesize delegate = _delegate;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
      _selectedIndex = NSNotFound;
      _selectedViewController = nil;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - Private Methods
- (void) didSwitchToViewController:(UIViewController *)controller
{
  if (_delegate && [(id)_delegate respondsToSelector:@selector(switchViewController:didSwitchToViewController:)]) {
    [_delegate switchViewController:self didSwitchToViewController:controller];
  }
}
- (void) switchFrom:(UIViewController *)from to:(UIViewController *)to
{
  if ([from respondsToSelector:@selector(willMoveToParentViewController:)]) {
    [from willMoveToParentViewController:nil];
  }
  
  if (to) {
    
    to.view.frame = self.view.bounds;
    to.view.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;

    [self addChildViewController:to];
    [to didMoveToParentViewController:self];
    
    [self.view addSubview:to.view];
    [to viewDidAppear:NO];
  }
  
  if (from) {
    [from removeFromParentViewController];
    [from.view removeFromSuperview];
    [from viewDidDisappear:NO];
  }
  
  if (to) {
    [self didSwitchToViewController:to];
  }
}

#pragma mark - Public Methods
- (void) setSelectedIndex:(NSUInteger)selectedIndex
{
  if ([_viewControllers count] > selectedIndex
      && selectedIndex != _selectedIndex) {
    UIViewController * currentViewController = [_viewControllers objectAtIndex:_selectedIndex];
    _selectedIndex = selectedIndex;
    UIViewController * newViewController = [_viewControllers objectAtIndex:_selectedIndex];
    [self switchFrom:currentViewController to:newViewController];
  }
}

- (void) setViewControllers:(NSArray *)viewControllers
{
  UIViewController * currentViewController = nil;
  if (_selectedIndex != NSNotFound) currentViewController = [_viewControllers objectAtIndex:_selectedIndex];
  
  _viewControllers = [viewControllers copy];
  
  UIViewController * newViewController = nil;
  if (_viewControllers) {
    if ([_viewControllers count] >= _selectedIndex
        || _selectedIndex == NSNotFound) {
      _selectedIndex = 0;
    }
    newViewController = [_viewControllers objectAtIndex:_selectedIndex];
  } else {
    _selectedIndex = NSNotFound;
  }
  
  [self switchFrom:currentViewController to:newViewController];
}

@end

#pragma mark - UIViewController (MwfSwitchViewController)
@implementation UIViewController (MwfSwitchViewController)
- (MwfSwitchViewController *) switchViewController;
{
  return (MwfSwitchViewController *) self.parentViewController;
}
@end