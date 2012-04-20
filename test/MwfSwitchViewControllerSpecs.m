#import "SpecHelper.h"
#import "MwfSwitchViewController.h"

SpecBegin(MwfSwitchViewController)

__block MwfSwitchViewController * controller = nil;
__block UIViewController * contentController1 = nil;
__block UIViewController * contentController2 = nil;
__block id mockController = nil;
__block id mockContentController1, mockContentController2 = nil;
__block id mockDelegate = nil;

beforeAll(^{

  controller = (MwfSwitchViewController *) [UIApplication sharedApplication].keyWindow.rootViewController;
  // controller = [[MwfSwitchViewController alloc] initWithNibName:nil bundle:nil];

  mockController = [OCMockObject partialMockForObject:controller];
  mockDelegate = [OCMockObject mockForProtocol:@protocol(MwfSwitchViewControllerDelegate)];
  controller.delegate = mockDelegate;

  
  contentController1 = [[UIViewController alloc] initWithNibName:nil bundle:nil];
  contentController1.view.backgroundColor = [UIColor redColor];
  contentController2 = [[UIViewController alloc] initWithNibName:nil bundle:nil];
  contentController2.view.backgroundColor = [UIColor yellowColor];
  
  mockContentController1 = [OCMockObject partialMockForObject:contentController1];
  mockContentController2 = [OCMockObject partialMockForObject:contentController2];
  
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

SpecEnd