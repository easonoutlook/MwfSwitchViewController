//
//  MwfSwitchViewController.m
//  MwfSwitchViewController
//
//  Created by Meiwin Fu on 19/4/12.
//  Copyright (c) 2012 –MwF. All rights reserved.
//

#import "MwfSwitchViewController.h"

#define kAnimationDuration 0.3
#pragma mark - Content View
@interface MwfSwitchContentView : UIView {
  __weak UIView * _contentView;
  UIView        * _contentContainerView;
  UIToolbar     * _toolbar;
  BOOL            _toolbarHidden;
  UIView        * _overlayView;
}
@property (nonatomic, readonly) UIToolbar * toolbar;
@property (nonatomic, readonly) UIView    * overlayView;
@property (nonatomic, readonly) UIView    * contentContainerView;
@property (nonatomic)           BOOL        toolbarHidden;
- (void) setContentView:(UIView *)view;
- (void) setToolbarHidden:(BOOL)hidden animated:(BOOL)animated;
- (void) setOverlayHidden:(BOOL)hidden animated:(BOOL)animated;
@end

@implementation MwfSwitchContentView
@synthesize toolbar = _toolbar;
@synthesize toolbarHidden = _toolbarHidden;
@synthesize contentContainerView = _contentContainerView;
@synthesize overlayView = _overlayView;

- (id) initWithFrame:(CGRect)frame; 
{
  self = [super initWithFrame:frame];
  if (self) {
    // init the containerView
    _contentContainerView = [[UIView alloc] initWithFrame:self.bounds];
    [self addSubview:_contentContainerView];
    
    // init the overlayView
    _overlayView = [[UIView alloc] initWithFrame:_contentContainerView.bounds];
    _overlayView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0];
    _overlayView.hidden = YES;
    _overlayView.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
    UITapGestureRecognizer * tapRecon = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissOverlayView:)];
    [_overlayView addGestureRecognizer:tapRecon];
    [_contentContainerView addSubview:_overlayView];
    
    // init the toolbar
    _toolbar = [[UIToolbar alloc] initWithFrame:CGRectZero];
    [_toolbar sizeToFit];
    _toolbarHidden = YES;
    [self addSubview:_toolbar];
    [self setNeedsLayout];
  }
  return self;
}

- (void) layoutSubviews; 
{
  [super layoutSubviews];
  
  // place the toolbar
  CGFloat tY = self.bounds.size.height;
  if (!_toolbarHidden) {
    tY = tY - (_toolbar.bounds.size.height);
  }
  CGRect sF = self.bounds;
  CGRect tF = _toolbar.frame;
  _toolbar.frame = CGRectMake(tF.origin.x, tY, sF.size.width, tF.size.height);
  
  // place the contentView
  _contentContainerView.frame = CGRectMake(sF.origin.x, sF.origin.y, sF.size.width, tY);
  
}

// Content
- (void) setContentView:(UIView *)view;
{
  UIView * previousContentView = _contentView;
  _contentView = view;
  
  _contentView.frame = _contentContainerView.bounds;
  _contentView.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
  
  [_contentContainerView insertSubview:_contentView atIndex:0];
  [previousContentView removeFromSuperview];
}

// Toolbar Animations
- (void) setToolbarHidden:(BOOL)hidden animated:(BOOL)animated;
{
  if (hidden != _toolbarHidden) {
    if (animated) {
      [UIView animateWithDuration:kAnimationDuration animations:^{
        _toolbarHidden = hidden;
        [self layoutSubviews];
      }];
    } else {
      _toolbarHidden = hidden;
      [self setNeedsLayout];
    }
  }
}
- (void) setToolbarHidden:(BOOL)toolbarHidden;
{
  [self setToolbarHidden:toolbarHidden animated:NO];
}
- (void) setOverlayHidden:(BOOL)hidden animated:(BOOL)animated;
{
  if (hidden != _overlayView.hidden) {

    CGFloat alpha = hidden?0:0.3;
    UIColor * color = [UIColor colorWithRed:0 green:0 blue:0 alpha:alpha];
    
    if (animated) {
      if (!hidden) _overlayView.hidden = NO;
      [UIView animateWithDuration:kAnimationDuration 
                       animations:^{
                         _overlayView.backgroundColor = color;
                       } 
                       completion:^(BOOL f) {
                         if (f) {
                           if (hidden) _overlayView.hidden = YES;
                         }
                       }];
    } else {
      _overlayView.backgroundColor = color;
      _overlayView.hidden = hidden;
    }
  }
}
// Tap Gesture Recon callback
- (void) dismissOverlayView:(UITapGestureRecognizer *)recon;
{
  [self setOverlayHidden:YES animated:YES];
}
@end

#pragma mark - MwfSwitchViewController
@interface MwfSwitchViewController ()
- (void) didSwitchToViewController:(UIViewController *)controller;
- (void) switchFrom:(UIViewController *)from to:(UIViewController *)to;
@end

@implementation MwfSwitchViewController
@synthesize selectedIndex = _selectedIndex;
@synthesize selectedViewController = _selectedViewController;
@synthesize viewControllers = _viewControllers;
@synthesize delegate = _delegate;
@synthesize contentView = _contentView;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
      _selectedIndex = NSNotFound;
      _selectedViewController = nil;
    }
    return self;
}

- (void)loadView {
  [super loadView];
  
  // create content view
  _contentView = [[MwfSwitchContentView alloc] initWithFrame:self.view.bounds];
  _contentView.backgroundColor = [UIColor whiteColor];
  [self.view addSubview:_contentView];
  
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

  _contentView = nil;
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
    
    [_contentView setContentView:to.view];
    [to viewDidAppear:NO];
  }
  
  if (from) {
    [from removeFromParentViewController];
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

#pragma mark - Show/Hide Toolbar
- (UIToolbar *) toolbar;
{
  return _contentView.toolbar;
}
- (void) setToolbarItems:(NSArray *)toolbarItems animated:(BOOL)animated;
{
  [super setToolbarItems:toolbarItems animated:animated];
  [_contentView.toolbar setItems:toolbarItems animated:(animated&&(!_contentView.toolbarHidden))];
}
- (void) setToolbarHidden:(BOOL)hidden animated:(BOOL)animated;
{
  [_contentView setToolbarHidden:hidden animated:animated];
}

#pragma mark - Show/Hide Overlay
- (void) setOverlayHidden:(BOOL)hidden animated:(BOOL)animated;
{
  [_contentView setOverlayHidden:hidden animated:animated];
}
- (void) setOverlayHidden:(BOOL)overlayHidden;
{
  [_contentView setOverlayHidden:overlayHidden animated:NO];
}
- (BOOL) overlayHidden;
{
  return _contentView.overlayView.hidden;
}
@end

#pragma mark - UIViewController (MwfSwitchViewController)
@implementation UIViewController (MwfSwitchViewController)
- (MwfSwitchViewController *) switchViewController;
{
  return (MwfSwitchViewController *) self.parentViewController;
}

@end