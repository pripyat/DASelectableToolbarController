DASelectableToolbarController provides an easy to use method of creating a "selectable" NSToolbar, as seen in many apps' preference screens, including my application, Cookie Stumbler. 

Usage:

**Interface Builder:**

- Open Interface Builder and open the "File" menu.
- Drag an NSTabView instance into your workspace.
- Set its class to DASelectableToolbarController.
- Link the controller's "window" outlet to the relevant window in your application. This is the window that the toolbar will be attached to.
- Add items to the NSTabView and name them as you want them to appear in the NSToolbar.
- Then set each item's identifier according to the name of the image that they're supposed to use in the toolbar.

**Programmatically:**

Ignore steps 1 & 2 above and initialize an instance of DASelectableToolbarController instead. Then set it up using the options available in DASelectableToolbarController.h.
