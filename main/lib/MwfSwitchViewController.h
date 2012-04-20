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
- (void)switchViewController:(MwfSwitchViewController *)controller didSwitchToViewController:(UIViewController *)viewController;
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
- (void) setToolbarHidden:(BOOL)hidden animated:(BOOL)animated;
@end

@interface UIViewController (MwfSwitchViewController)
- (MwfSwitchViewController *) switchViewController;
@end