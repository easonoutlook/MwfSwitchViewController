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
  UIView        * _menuView;
}
@property (nonatomic, readonly) UIToolbar * toolbar;
@property (nonatomic, readonly) UIView    * overlayView;
@property (nonatomic, readonly) UIView    * contentContainerView;
@property (nonatomic)           BOOL        toolbarHidden;
@property (nonatomic, retain)   UIView    * menuView;
- (void) setContentView:(UIView *)view;
- (void) setToolbarHidden:(BOOL)hidden animated:(BOOL)animated;
- (void) setOverlayHidden:(BOOL)hidden animated:(BOOL)animated;
- (void) setMenuHidden:(BOOL)hidden height:(CGFloat)height animated:(BOOL)animated completion:(void(^)(void))compleation;
@end

@implementation MwfSwitchContentView
@synthesize toolbar = _toolbar;
@synthesize toolbarHidden = _toolbarHidden;
@synthesize contentContainerView = _contentContainerView;
@synthesize overlayView = _overlayView;
@synthesize menuView = _menuView;

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
    UITapGestureRecognizer * tapRecon = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissMenuOrOverlayView:)];
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
- (void) dismissMenuOrOverlayView:(UITapGestureRecognizer *)recon;
{
  if (!self.menuView.hidden) {
    [self setMenuHidden:YES height:0 animated:YES completion:NULL];
  } else {
    [self setOverlayHidden:YES animated:YES];
  }
}

// Menu
- (void) setMenuView:(UIView *)menuView;
{
  [_menuView removeFromSuperview];
  _menuView = menuView;
  _menuView.hidden = YES;
  [_contentContainerView addSubview:_menuView];
}
- (void) setMenuHidden:(BOOL)hidden height:(CGFloat)height animated:(BOOL)animated completion:(void(^)(void))completion;
{
  CGRect b = _contentContainerView.bounds;
  CGFloat h = height;
  CGRect endFrame;
  
  if (!hidden) {
    // height max allowed is 320-(20+33)=267
    if (h > 267) h = 267;
    if (h == 0) h = 176; // default to 176
    _menuView.frame = CGRectMake(0, b.size.height, b.size.width, h);
    _menuView.hidden = NO;
    endFrame = CGRectMake(0, b.size.height-h, b.size.width, h);
  } else {
    h = _menuView.bounds.size.height;
    endFrame = CGRectMake(0,b.size.height,b.size.width,h);
  }
  
  __weak MwfSwitchContentView * weakSelf = self;
  if (animated) {
    [UIView animateWithDuration:kAnimationDuration 
                     animations:^{
                       [weakSelf setOverlayHidden:hidden animated:NO];
                       _menuView.frame = endFrame;
                     } 
                     completion:^(BOOL f){
                       _menuView.hidden = hidden;
                       if (f && completion != NULL) {
                         completion();
                       }
                     }];
  } else {
    [weakSelf setOverlayHidden:hidden animated:NO];
    _menuView.frame = endFrame;
    _menuView.hidden = hidden;
    completion();
  }
}
@end

#pragma mark - MwfSwitchViewController
@interface MwfSwitchViewController ()
- (void) switchFrom:(UIViewController *)from to:(UIViewController *)to;
- (void) didSwitchToViewController:(UIViewController *)controller;
- (void) willShowMenuViewController:(UIViewController *)menuViewController;
- (void) didShowMenuViewController:(UIViewController *)menuViewController;
- (CGFloat) heightForMenuViewController:(UIViewController *)menuViewController;
- (void) willHideMenuViewController:(UIViewController *)menuViewController;
- (void) didHideMenuViewController:(UIViewController *)menuViewController;
@end

@implementation MwfSwitchViewController
@synthesize selectedIndex = _selectedIndex;
@synthesize selectedViewController = _selectedViewController;
@synthesize viewControllers = _viewControllers;
@synthesize delegate = _delegate;
@synthesize contentView = _contentView;
@synthesize menuViewController = _menuViewController;

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
- (void) willShowMenuViewController:(UIViewController *)menuViewController;
{
  if (_delegate && [(id)_delegate respondsToSelector:@selector(switchViewController:willShowMenuViewController:)]) {
    [_delegate switchViewController:self willShowMenuViewController:menuViewController];
  }
}
- (void) didShowMenuViewController:(UIViewController *)menuViewController;
{
  if (_delegate && [(id)_delegate respondsToSelector:@selector(switchViewController:didShowMenuViewController:)]) {
    [_delegate switchViewController:self didShowMenuViewController:menuViewController];
  }
}
- (CGFloat) heightForMenuViewController:(UIViewController *)menuViewController;
{
  CGFloat h = 0;
  if (_delegate && [(id)_delegate respondsToSelector:@selector(switchViewController:heightForMenuViewController:)]) {
    h = [_delegate switchViewController:self heightForMenuViewController:menuViewController];
  }
  return h;
}
- (void) willHideMenuViewController:(UIViewController *)menuViewController;
{
  if (_delegate && [(id)_delegate respondsToSelector:@selector(switchViewController:willHideMenuViewController:)]) {
    [_delegate switchViewController:self willHideMenuViewController:menuViewController];
  }
}
- (void) didHideMenuViewController:(UIViewController *)menuViewController;
{
  if (_delegate && [(id)_delegate respondsToSelector:@selector(switchViewController:didHideMenuViewController:)]) {
    [_delegate switchViewController:self didHideMenuViewController:menuViewController];
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
#pragma mark - Show/Hide Menu
- (void) setMenuViewController:(UIViewController *)menuViewController;
{
  if ([self menuHidden]) {
    if (_menuViewController) {
      [_menuViewController willMoveToParentViewController:nil];
      _contentView.menuView = nil;
      [_menuViewController removeFromParentViewController];
    }
    _menuViewController = menuViewController;
    if (_menuViewController) {
      [self addChildViewController:_menuViewController];
      // _contentView.menuView = _menuViewController.view;
      // [_menuViewController didMoveToParentViewController:self];
    }
  } else {
    [NSException raise:@"Invalid State" format:@"Menu is showing, setting value is disallowed."];
  }
}
- (BOOL) menuHidden;
{
  return !_menuViewController || !_contentView.menuView || _contentView.menuView.hidden;
}
- (void) setMenuHidden:(BOOL)hidden animated:(BOOL)animated;
{
  if (_menuViewController && hidden != [self menuHidden]) {
    
    CGFloat h = 0;
    __weak UIViewController * mctl = _menuViewController;
    __weak MwfSwitchViewController * weakSelf = self;
    if (!hidden) {
      BOOL deferred = NO;
      
      // deferred setting of menu view
      if (!_contentView.menuView) {
        deferred = YES;
        _contentView.menuView = mctl.view;
        [mctl didMoveToParentViewController:self];
      }
      
      [self willShowMenuViewController:mctl];
      h =[self heightForMenuViewController:mctl];

      if (!deferred) {
        [mctl viewWillAppear:animated];
      }

    } else {

      [self willHideMenuViewController:mctl];
    
      [mctl viewWillDisappear:animated];
    }
    [_contentView setMenuHidden:hidden 
                         height:h 
                       animated:animated 
                     completion:^{
                       if (!hidden) {
                         [mctl viewDidAppear:animated];
                         [weakSelf didShowMenuViewController:mctl];
                       } else {
                         [mctl viewDidDisappear:animated];
                         [weakSelf didHideMenuViewController:mctl];
                       }
                     }];
    
  }
}
@end

#pragma mark - UIViewController (MwfSwitchViewController)
@implementation UIViewController (MwfSwitchViewController)
- (MwfSwitchViewController *) switchViewController;
{
  return (MwfSwitchViewController *) self.parentViewController;
}
@end


