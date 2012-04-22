#import "SpecHelper.h"
#import "MwfSwitchViewController.h"
#import "MwfMenuViewController.h"

SpecBegin(MwfSwitchViewController)

__block MwfSwitchViewController * controller = nil;
__block UIViewController * contentController1 = nil;
__block UIViewController * contentController2 = nil;
__block UIViewController * menuViewController = nil;
__block id mockController = nil;
__block id mockContentController1, mockContentController2 = nil;
__block id mockDelegate = nil;
__block id mockMenuViewController = nil;

beforeAll(^{

  controller = (MwfSwitchViewController *) [UIApplication sharedApplication].keyWindow.rootViewController;
  contentController1 = [[UIViewController alloc] initWithNibName:nil bundle:nil];
  contentController1.view.backgroundColor = [UIColor redColor];
  contentController2 = [[UIViewController alloc] initWithNibName:nil bundle:nil];
  contentController2.view.backgroundColor = [UIColor yellowColor];
  menuViewController = [[MwfMenuViewController alloc] initWithNibName:nil bundle:nil];
  
});

beforeEach(^{
  mockController = [OCMockObject partialMockForObject:controller];
  mockDelegate = [OCMockObject niceMockForProtocol:@protocol(MwfSwitchViewControllerDelegate)];
  controller.delegate = mockDelegate;
  mockContentController1 = [OCMockObject partialMockForObject:contentController1];
  mockContentController2 = [OCMockObject partialMockForObject:contentController2];
  mockMenuViewController = [OCMockObject partialMockForObject:menuViewController];
});

it(@"tests init and bindings", ^{ 

  expect(controller).toBeKindOf([MwfSwitchViewController class]);
  
  expect(controller.delegate!=nil).toEqual(YES);
  expect(controller.viewControllers).toBeNil();
  expect(controller.selectedIndex).toEqual(NSNotFound);
  expect(controller.view).Not.toBeNil();
  expect(controller.toolbar).Not.toBeNil();
  expect(controller.contentView).Not.toBeNil();
  expect(controller.overlayHidden).toEqual(YES);
  expect(controller.menuHidden).toEqual(YES);
  
});
/*
it(@"tests view reloading", ^{

  expect(controller.view).Not.toBeNil();
  expect(controller.toolbar).Not.toBeNil();
  expect(controller.contentView).Not.toBeNil();
  
  [[mockController expect] viewDidUnload];
  [controller didReceiveMemoryWarning];
  expect(controller.toolbar).toBeNil();
  expect(controller.contentView).toBeNil();
  [mockController verify];
  
  expect(controller.view).Not.toBeNil();
  expect(controller.toolbar).Not.toBeNil();
  expect(controller.contentView).Not.toBeNil();
         
});
*/
context(@"switching view controllers", ^{

  beforeEach(^{
    mockController = [OCMockObject partialMockForObject:controller];
    mockDelegate = [OCMockObject niceMockForProtocol:@protocol(MwfSwitchViewControllerDelegate)];
    controller.delegate = mockDelegate;
    mockContentController1 = [OCMockObject partialMockForObject:contentController1];
    mockContentController2 = [OCMockObject partialMockForObject:contentController2];
    mockMenuViewController = [OCMockObject partialMockForObject:menuViewController];
  });

  it(@"tests assigning controllers", ^{

    [[mockContentController1 expect] viewWillAppear:NO];
    [[mockContentController1 expect] viewDidAppear:NO];
    [[mockContentController1 expect] willMoveToParentViewController:controller];
    [[mockContentController1 expect] didMoveToParentViewController:controller];
    [[mockDelegate expect] switchViewController:controller didSwitchToViewController:contentController1];
    
    NSArray * controllers = [NSArray arrayWithObjects:
                               contentController1
                             , contentController2
                             , nil];
    controller.viewControllers = controllers;
    expect(controller.selectedIndex).toEqual(0);
    expect(contentController1.parentViewController).toEqual(controller);
    expect(contentController1.switchViewController).toEqual(controller);
    
    [mockContentController1 verify];
    [mockDelegate verify];
    
  });
  it(@"tests change selectedIndex", ^{
    [[mockContentController1 expect] viewWillDisappear:NO];
    [[mockContentController1 expect] viewDidDisappear:NO];
    [[mockContentController1 expect] willMoveToParentViewController:nil];
    [[mockContentController1 expect] removeFromParentViewController];
    [[mockContentController2 expect] viewWillAppear:NO];
    [[mockContentController2 expect] viewDidAppear:NO];
    [[mockContentController2 expect] willMoveToParentViewController:controller];
    [[mockContentController2 expect] didMoveToParentViewController:controller];
    [[mockDelegate expect] switchViewController:controller didSwitchToViewController:contentController2];
    
    controller.selectedIndex = 1;
    expect(controller.selectedIndex).toEqual(1);
    expect(contentController2.parentViewController).toEqual(controller);
    expect(contentController2.switchViewController).toEqual(controller);
    
    [mockContentController1 verify];
    [mockContentController2 verify];
    [mockDelegate verify];
  });
  
  it(@"tests assign to invalid index", ^{
    // invalid index
    controller.selectedIndex = 2;
    expect(controller.selectedIndex).toEqual(1);
  });
  
  it(@"tests reassigning controllers", ^{
    
    UIViewController * newController = [[UIViewController alloc] initWithNibName:nil bundle:nil];
    NSArray * controllers = [NSArray arrayWithObjects:newController,nil];
    [[mockContentController2 expect] viewWillDisappear:NO];
    [[mockContentController2 expect] viewDidDisappear:NO];
    [[mockContentController2 expect] willMoveToParentViewController:nil];
    [[mockContentController2 expect] removeFromParentViewController];
    [[mockDelegate expect] switchViewController:controller didSwitchToViewController:newController];
    
    controller.viewControllers = controllers;
    expect(controller.selectedIndex).toEqual(0);

    [mockContentController1 verify];
    [mockContentController2 verify];
    [mockDelegate verify];

  });
  it(@"tests assign viewControllers to nil" , ^{

    // set to no view controllers
    controller.viewControllers = nil;
    expect(controller.selectedIndex).toEqual(NSNotFound);

    [mockDelegate verify];
  });
  it(@"tests overlay feature.", ^{
  
    [controller setOverlayHidden:NO animated:NO];
    expect(controller.overlayHidden).toEqual(NO);
    
  });
});

context(@"menu", ^{
  
  beforeEach(^{
    mockController = [OCMockObject partialMockForObject:controller];
    mockDelegate = [OCMockObject niceMockForProtocol:@protocol(MwfSwitchViewControllerDelegate)];
    controller.delegate = mockDelegate;
    mockContentController1 = [OCMockObject partialMockForObject:contentController1];
    mockContentController2 = [OCMockObject partialMockForObject:contentController2];
    mockMenuViewController = [OCMockObject partialMockForObject:menuViewController];
  });

  it(@"tests scenario with no menu view controller assigned.", ^{
    
    [[mockDelegate reject] switchViewController:controller willShowMenuViewController:[OCMArg any]];
    [[mockDelegate reject] switchViewController:controller heightForMenuViewController:[OCMArg any]];
    [[mockDelegate reject] switchViewController:controller didShowMenuViewController:[OCMArg any]];
    [controller setMenuHidden:NO animated:NO];
    
    [[mockDelegate reject] switchViewController:controller willHideMenuViewController:[OCMArg any]];
    [[mockDelegate reject] switchViewController:controller didHideMenuViewController:[OCMArg any]];
    [controller setMenuHidden:YES animated:NO];

    [mockDelegate verify];
    
  });
  
  it(@"tests scenario with menu view controller assigned.", ^{
    
    controller.menuViewController = menuViewController;
    expect(controller.menuViewController).Not.toBeNil();
    expect(menuViewController.parentViewController).toEqual(controller);

    [[mockDelegate expect] switchViewController:controller willShowMenuViewController:menuViewController];
    [[mockDelegate expect] switchViewController:controller heightForMenuViewController:menuViewController];
    [[mockDelegate expect] switchViewController:controller didShowMenuViewController:menuViewController];
    [[mockMenuViewController expect] viewWillAppear:NO];
    [[mockMenuViewController expect] viewDidAppear:NO];
    [controller setMenuHidden:NO animated:NO];
    expect(controller.menuHidden).toEqual(NO);
    expect(controller.overlayHidden).toEqual(NO);
    
    // when menuViewController is showing, cannot change the value of menuViewController
    NSException * e = nil;
    @try {
      UIViewController * newMenuViewController = [[UIViewController alloc] initWithNibName:nil bundle:nil];
      controller.menuViewController = newMenuViewController;
    }
    @catch (NSException * excp) {
      e = excp;
    }
    expect(e).Not.toBeNil();
    
    e = nil;
    @try {
      controller.menuViewController = nil;
    }
    @catch (NSException * excp) {
      e = excp;
    }
    expect(e).Not.toBeNil();
    
    
    // already visible, nothing should happen
    [[mockDelegate reject] switchViewController:controller willShowMenuViewController:menuViewController];
    [[mockDelegate reject] switchViewController:controller heightForMenuViewController:menuViewController];
    [[mockDelegate reject] switchViewController:controller didShowMenuViewController:menuViewController];
    [[mockMenuViewController reject] viewWillAppear:NO];
    [[mockMenuViewController reject] viewDidAppear:NO];
    [controller setMenuHidden:NO animated:NO];
    
    [[mockDelegate expect] switchViewController:controller willHideMenuViewController:menuViewController];
    [[mockDelegate expect] switchViewController:controller didHideMenuViewController:menuViewController];
    [[mockMenuViewController expect] viewWillDisappear:NO];
    [[mockMenuViewController expect] viewDidDisappear:NO];
    [controller setMenuHidden:YES animated:NO];
    expect(controller.menuHidden).toEqual(YES);
    expect(controller.overlayHidden).toEqual(YES);
    
    // already hidden, nothing should happen
    [[mockDelegate reject] switchViewController:controller willHideMenuViewController:menuViewController];
    [[mockDelegate reject] switchViewController:controller didHideMenuViewController:menuViewController];
    [[mockMenuViewController reject] viewWillDisappear:NO];
    [[mockMenuViewController reject] viewDidDisappear:NO];
    [controller setMenuHidden:YES animated:NO];

    [mockMenuViewController verify];
    [mockDelegate verify];
    
  });
  
  it(@"Showing menu again on second/subsequent invocation", ^{
  
    // show it again, make sure the same sets of methods are invoked
    [[mockDelegate expect] switchViewController:controller willShowMenuViewController:menuViewController];
    [[mockDelegate expect] switchViewController:controller heightForMenuViewController:menuViewController];
    [[mockDelegate expect] switchViewController:controller didShowMenuViewController:menuViewController];
    [[mockMenuViewController expect] viewWillAppear:NO];
    [[mockMenuViewController expect] viewDidAppear:NO];
    [controller setMenuHidden:NO animated:NO];
    expect(controller.menuHidden).toEqual(NO);
    expect(controller.overlayHidden).toEqual(NO);
    
  });
  
});

SpecEnd