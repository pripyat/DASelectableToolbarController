//
//  DASelectableToolbarController.m
//  Cookie Stumbler
//
//  Created by David Schiefer on 16.07.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "DASelectableToolbarController.h"

@implementation DASelectableToolbarController

@synthesize layout = _layout;
@synthesize delegate = __delegate;

- (void)setWindow:(NSWindow *)window
{
    /* Default Layout */
    _layout = DASelectableToolbarLayoutCentered;
    
    /* Prepare Required Objects */
    _toolbarItems = [[NSMutableArray alloc] init];
    _toolBar = [[NSToolbar alloc] initWithIdentifier:@"Identifier"];
    
    _hostWindow = [window retain];
    
    /* Configure NSTabView */
    [self setTabViewType:NSNoTabsNoBorder];
    
    /* Internal Setup */
    [self _setupToolbar:_toolBar];
    
    [_toolBar setDelegate:self];
    [window setToolbar:_toolBar];
    
    /* Select 1st Item */
    [self selectItemAtIndex:1];
}

- (NSWindow *)window
{
    return _hostWindow;
}

- (void)selectItemAtIndex:(NSUInteger)index
{
    NSToolbarItem*_relevantItem = [_toolbarItems objectAtIndex:index];
    
    if (_relevantItem != nil)
    {
        [_toolBar setSelectedItemIdentifier:[_relevantItem itemIdentifier]];
        [_hostWindow setTitle:[_relevantItem label]];
        
        if ([self.delegate respondsToSelector:@selector(numberForWindowHeightForItemIndex:)])
        {
            NSRect _prevFrame = _hostWindow.frame;
            float _delegateHeight = [self.delegate numberForWindowHeightForItemIndex:index];
            
            if (_delegateHeight != _prevFrame.size.height)
            {
                /* we want the content to resize, but the window's y origin shouldn't change */
                _prevFrame.origin.y += _prevFrame.size.height - _delegateHeight;

                _prevFrame.size.height = _delegateHeight;
                
                [_hostWindow setFrame:_prevFrame display:YES animate:YES];
            }
        }

        [self selectTabViewItemWithIdentifier:[_relevantItem itemIdentifier]];
    }
}

- (void)addToolbarItem:(NSToolbarItem *)item
{
    if ([item class] == [NSToolbarItem class])
    {
        [_toolbarItems addObject:item];
    }
}

- (void)removeToolbarItem:(NSToolbarItem *)item
{
    [_toolbarItems removeObject:item];
}

- (void)setLayout:(DASelectableToolbarLayout)layout
{
    [_toolbarItems removeAllObjects];
    [self _setupToolbar:_toolBar];
}

- (DASelectableToolbarLayout)layout
{
    return _layout;
}

- (NSToolbar *)toolbar
{
    return _toolBar;
}

#pragma mark Internal Functionality

- (void)_setupToolbar:(NSToolbar *)toolbar
{
    if (self.layout == DASelectableToolbarLayoutCentered)
    {
        [self addToolbarItem:[self _flexibleSpaceItem]];
    }
    
    for (NSTabViewItem*_item in self.tabViewItems)
    {
        NSToolbarItem*_toolbarItem = [[NSToolbarItem alloc] initWithItemIdentifier:_item.identifier];
        [_toolbarItem setLabel:_item.label];
        [_toolbarItem setPaletteLabel:_item.label];
        [_toolbarItem setImage:[NSImage imageNamed:_item.identifier]];
        
        [_toolbarItem setTarget:self];
        [_toolbarItem setAction:@selector(_switchView:)];
        
        [self addToolbarItem:_toolbarItem];
        [_toolbarItem release];
    }
    
    if (self.layout == DASelectableToolbarLayoutCentered)
    {
        [self addToolbarItem:[self _flexibleSpaceItem]];
    }
}

- (NSToolbarItem *)_flexibleSpaceItem
{
    return [[[NSToolbarItem alloc] initWithItemIdentifier:NSToolbarFlexibleSpaceItemIdentifier] autorelease];
}

- (void)_switchView:(id)sender
{    
    [self selectItemAtIndex:[_toolbarItems indexOfObject:sender]];
}

#pragma mark NSToolbarDelegates

- (NSArray *)toolbarSelectableItemIdentifiers: (NSToolbar *)toolbar
{
    NSMutableArray*_identifiers = [[NSMutableArray alloc] init];
    
    for (NSToolbarItem*_item in _toolbarItems)
    {
        [_identifiers addObject:_item.itemIdentifier];
    }
    
    return [_identifiers autorelease];
}

- (NSArray *)toolbarDefaultItemIdentifiers:(NSToolbar *)toolbar 
{
    NSMutableArray*_identifiers = [[NSMutableArray alloc] init];
    
    for (NSToolbarItem*_item in _toolbarItems)
    {
        [_identifiers addObject:_item.itemIdentifier];
    }
    
    return [_identifiers autorelease];
}

- (NSArray *)toolbarAllowedItemIdentifiers:(NSToolbar*)toolbar
{
    NSMutableArray*_identifiers = [[NSMutableArray alloc] init];
    
    for (NSToolbarItem*_item in _toolbarItems)
    {
        [_identifiers addObject:_item.itemIdentifier];
    }

    return [_identifiers autorelease];
}

- (NSToolbarItem *)toolbar:(NSToolbar *)toolbar itemForItemIdentifier:(NSString *)itemIdentifier willBeInsertedIntoToolbar:(BOOL)flag
{
    for (NSToolbarItem*_item in _toolbarItems)
    {
        if ([_item.itemIdentifier isEqualToString:itemIdentifier])
        {
            return _item;
        }
    }
    
    return nil;
}

- (void)dealloc
{
    [_toolBar setDelegate:nil];
    [_toolBar release];
    
    [_hostWindow setToolbar:nil];
    [_hostWindow release];

    [_toolbarItems release];
    
    self.delegate = nil;
    
    [super dealloc];
}

@end
