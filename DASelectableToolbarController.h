//
//  DASelectableToolbarController.h
//  Cookie Stumbler
//
//  Created by David Schiefer on 16.07.12.
//  Copyright (c) 2012 David Schiefer. 
//  You may use this class as long as you acknowledge its source.
//

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
    
    NSUInteger _layout;
    
    NSWindow*_hostWindow;
}

- (void)addToolbarItem:(NSToolbarItem *)item;
- (void)removeToolbarItem:(NSToolbarItem *)item;

- (void)selectItemAtIndex:(NSUInteger)index;

@property (assign) IBOutlet NSWindow*window;
@property (assign) DASelectableToolbarLayout layout; /* Default - DASelectableToolbarLayoutCentered */

@property (readonly) NSToolbar*toolbar;

@end
