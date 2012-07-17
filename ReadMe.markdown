`DASelectableToolbarController` provides an easy to use method of creating a "selectable" NSToolbar, as seen in many apps' preference screens, including my application, Cookie Stumbler. 

Usage:

**Interface Builder:**

- Open Interface Builder and open the "File" menu.
- Drag an NSTabView instance into your workspace.
- Set its class to DASelectableToolbarController.
- Link the controller's "window" outlet to the relevant window in your application. This is the window that the toolbar will be attached to.
- Add items to the NSTabView and name them as you want them to appear in the NSToolbar.
- Then set each item's identifier according to the name of the image that they're supposed to use in the toolbar.

**Programmatically:**

Ignore steps 1 & 2 above and initialize an instance of `DASelectableToolbarController` instead. Then set it up using the options available in `DASelectableToolbarController.h`.


**Extras:**

**Accessing the NSToolbar Instance:**

You can access the NSToolbar instance using the following read-only property:

`@property (readonly) NSToolbar*toolbar;`

Alternatively, you can also access the toolbar using the host window's `-(NSToolbar *)toolbar` selector.

**Layouts:**

`DASelectableToolbarController` supports 2 different layout types, as defined in `DASelectableToolbarController.h`:

`DASelectableToolbarLayoutDefault, /* || ITEM | ITEM || */`

`DASelectableToolbarLayoutCentered /* || SEPERATOR | ITEM | ITEM | SEPERATOR ||` 

The layout can be set using the `layout` property:

`@property (assign) DASelectableToolbarLayout layout`

**Animated Resizing:**

Not every preference pane you've created may have the same amount of content in it, so you will require the Preference window to resize to the correct size. Therefore, this class implements a delegate method that will allow you to do just that:

`- (float)numberForWindowHeightForItemIndex:(NSUInteger)index`

Use this method to return the desired height (as a float) for each tab. Note that this method is **optional**. If you don't implement this method, `DASelectableToolbarController` will simply use its host window's size across all tabs.

### License

Copyright (c) 2012 David Schiefer

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in the documentation of any redistributions of the template files themselves (but not in projects built using the templates).

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
