# MwfSwitchViewController

A simple container view controller that is capable to host multiple view controllers and switching between them by setting the `selectedIndex`.

## Features
* Dead simple to use
* Toolbar support
* Overlay support

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
  
* Setting toolbar items

  ```objective-c
  switchController.toolbarItems = theArrayWithToolbarItems;
  ```

* Show/Hide Toolbar

  ```objective-c
  [switchController setToolbarHidden:showOrHide animated:withOrWithoutAnimation];
  ```
  
* Show/Hide Overlay  

  ```objective-c
  [switchController setOverlayHidden:showOrHide animated:withOrWithoutAnimation];
  ```
  
## Licensing

MwfSwitchViewController is licensed under MIT License
Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in
all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
THE SOFTWARE.

  