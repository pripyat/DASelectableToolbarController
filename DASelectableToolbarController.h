//
//  DASelectableToolbarController.h
//  Cookie Stumbler
//
//  Created by David Schiefer on 16.07.12.
<<<<<<< HEAD
//  Copyright (c) 2012 David Schiefer. 
//  You may use this class in any project as long as you acknowledge its author.
//
=======

//  Copyright (c) 2012 David Schiefer
//  Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

//  The above copyright notice and this permission notice shall be included in the documentation of any redistributions of the template files themselves (but not in projects built using the templates).

//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
>>>>>>> Added support for animated resizing based on content size.

#import <Foundation/Foundation.h>

enum 
{
    DASelectableToolbarLayoutDefault = 0, /* || ITEM | ITEM || */
    DASelectableToolbarLayoutCentered = 1 /* || SEPERATOR | ITEM | ITEM | SEPERATOR || */
};
typedef NSUInteger DASelectableToolbarLayout;

@interface DASelectableToolbarController : NSTabView <NSToolbarDelegate>
{
    @private
    NSToolbar*_toolBar;
    id _toolbarItems;
    
    id __delegate;
    
    NSUInteger _layout;
    
    NSWindow*_hostWindow;
}

- (void)addToolbarItem:(NSToolbarItem *)item;
- (void)removeToolbarItem:(NSToolbarItem *)item;

- (void)selectItemAtIndex:(NSUInteger)index;

@property (retain) id delegate;

@property (assign) IBOutlet NSWindow*window;
@property (assign) DASelectableToolbarLayout layout; /* Default - DASelectableToolbarLayoutCentered */

@property (readonly) NSToolbar*toolbar;

@end

@protocol DASelectableToolbarControllerDelegate

@optional
- (float)numberForWindowHeightForItemIndex:(NSUInteger)index;

@end
