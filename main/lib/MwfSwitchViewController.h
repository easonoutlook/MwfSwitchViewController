//
//  MwfSwitchViewController.h
//  MwfSwitchViewController
//
//  Created by Meiwin Fu on 19/4/12.
//  Copyright (c) 2012 –MwF. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MwfSwitchViewController;
@protocol MwfSwitchViewControllerDelegate
@optional
- (void)switchViewController:(MwfSwitchViewController *)controller didSwitchToViewController:(UIViewController *)viewController;
- (void)switchViewController:(MwfSwitchViewController *)controller willShowMenuViewController:(UIViewController *)menuViewController;
- (void)switchViewController:(MwfSwitchViewController *)controller didShowMenuViewController:(UIViewController *)menuViewController;
- (void)switchViewController:(MwfSwitchViewController *)controller willHideMenuViewController:(UIViewController *)menuViewController;
- (void)switchViewController:(MwfSwitchViewController *)controller didHideMenuViewController:(UIViewController *)menuViewController;
- (CGFloat) switchViewController:(MwfSwitchViewController *)controller heightForMenuViewController:(UIViewController *)menuViewController;
@end

@class MwfSwitchContentView;
@interface MwfSwitchViewController : UIViewController {
  MwfSwitchContentView * _contentView;
}
@property (nonatomic) NSUInteger                                      selectedIndex;
@property (nonatomic, readonly) UIViewController                    * selectedViewController;
@property (nonatomic, copy) NSArray                                 * viewControllers;
@property (nonatomic, assign) id<MwfSwitchViewControllerDelegate>     delegate;
@property (nonatomic, readonly) __strong UIView                     * contentView;
@property (nonatomic, readonly) UIToolbar                           * toolbar;
@property (nonatomic)           BOOL                                  overlayHidden;
@property (nonatomic, readonly) BOOL                                  menuHidden;
@property (nonatomic, strong) UIViewController                      * menuViewController;
- (void) setToolbarHidden:(BOOL)hidden animated:(BOOL)animated;
- (void) setOverlayHidden:(BOOL)hidden animated:(BOOL)animated;
- (void) setMenuHidden:(BOOL)hidden animated:(BOOL)animated;
@end

@interface UIViewController (MwfSwitchViewController)
- (MwfSwitchViewController *) switchViewController;
@end