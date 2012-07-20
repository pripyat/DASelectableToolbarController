//
//  DASelectableToolbarController.h
//  Cookie Stumbler
//
//  Created by David Schiefer on 16.07.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

enum 
{
    DASelectableToolbarLayoutDefault = 0, /* || ITEM | ITEM || */
    DASelectableToolbarLayoutCentered = 1 /* || SEPERATOR | ITEM | ITEM | SEPERATOR || */
};
typedef NSUInteger DASelectableToolbarLayout;

@interface DASelectableToolbarController : NSTabView <NSToolbarDelegate,NSWindowDelegate>
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

- (void)insertView:(NSView *)view;

@property (retain) id delegate;

@property (assign) IBOutlet NSWindow*window;
@property (assign) DASelectableToolbarLayout layout; /* Default - DASelectableToolbarLayoutCentered */

@property (readonly) NSToolbarItem*selectedItem;
@property (readonly) NSToolbar*toolbar;

@end

@protocol DASelectableToolbarControllerDelegate

@optional
- (float)numberForWindowHeightForItemAtIndex:(NSUInteger)index;

- (void)didSelectToolbarItem:(NSToolbarItem *)item;

@end