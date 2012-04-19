# MwfSwitchViewController

A simple container view controller that is capable to host multiple view controllers and switching between them by setting the `selectedIndex`.

## How To Use

* Creating the view controller

  ```objective-c
  NSArray * viewControllers = ...; // you initialize the array with the child view controllers
  MwfSwitchViewController * switchController = [[MwfSwitchViewController alloc] initWithNibName:nil bundle:nil];
  switchController.viewControllers = viewControllers; // automatically default view controller to index 0
  ```
  
* Switching view controller

  ```objective-c
  switchController.selectedIndex = theIndex;
  ```
  