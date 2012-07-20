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

static NSToolbarItem*_selectedItem = nil;
static NSView*_replacedView = nil;

- (void)setWindow:(NSWindow *)window
{
    /* Default Layout */
    _layout = DASelectableToolbarLayoutCentered;
    
    /* Prepare Required Objects */
    _toolbarItems = [[NSMutableArray alloc] init];
    _toolBar = [[NSToolbar alloc] initWithIdentifier:@"Identifier"];
    
    /* Memory Management */
    if (_hostWindow != nil)
    {
        [_hostWindow release];
        _hostWindow = nil;
    }
    
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

- (NSToolbarItem *)selectedItem
{
    return _selectedItem;
}

- (void)selectItemAtIndex:(NSUInteger)index
{
    NSAutoreleasePool*pool = [[NSAutoreleasePool alloc] init];
    
    NSToolbarItem*_relevantItem = [_toolbarItems objectAtIndex:index];
    
    if (_relevantItem != nil)
    {
        if (_replacedView != nil)
        {
            [self replaceSubview:[self.subviews lastObject] with:_replacedView];
            
            [_replacedView release];
            _replacedView  = nil;
        }
        
        if (_selectedItem != nil)
        {
            [_selectedItem release];
            _selectedItem = nil;
        }
        
        _selectedItem = [_relevantItem retain];
        
        [_toolBar setSelectedItemIdentifier:[_relevantItem itemIdentifier]];
        [_hostWindow setTitle:[_relevantItem label]];
        
        float _delegateHeight = 0.0f;
        
        [self selectTabViewItemWithIdentifier:[_relevantItem itemIdentifier]];
        
        if ([self.delegate respondsToSelector:@selector(numberForWindowHeightForItemAtIndex:)])
        {
            NSRect _prevFrame = _hostWindow.frame;
            _delegateHeight = [self.delegate numberForWindowHeightForItemAtIndex:index];
            
            NSView*_activeView = [self.subviews lastObject];
            
            if (_delegateHeight != _prevFrame.size.height)
            {
                NSRect _viewRect = _activeView.frame;
                _viewRect.origin = NSMakePoint(0.0f, 0.0f);
                
                [_activeView setFrame:_viewRect];
                
                [self _resizeWindowForContentSize:NSMakeSize(_activeView.frame.size.width, _delegateHeight)];
            }
        }
        
        if ([self.delegate respondsToSelector:@selector(didSelectToolbarItem:)])
        {
            dispatch_async(dispatch_get_main_queue(), 
            ^{
                [self.delegate didSelectToolbarItem:_relevantItem];
            });
        }
    }
    
    [pool drain]; /* Calling 'drain' in case the host project uses ARC */
}

- (void)insertView:(NSView *)view
{
    _replacedView = [[self.subviews lastObject] retain];
    
    [self replaceSubview:[self.subviews lastObject] with:view];
    [self _resizeWindowForContentSize:view.frame.size];
}

- (NSViewAnimation *)_animator
{
    /* use this animation getter in case you want transition animations */
    NSViewAnimation*_vAnim = [[NSViewAnimation alloc] init];
    
    [_vAnim setDuration:0.2f];
    [_vAnim setAnimationBlockingMode:NSAnimationBlocking];
    [_vAnim setAnimationCurve:NSAnimationEaseInOut];

    return [_vAnim autorelease];
}

- (void)_resizeWindowForContentSize:(NSSize) size 
{
    NSRect _windowFrame = [_hostWindow contentRectForFrameRect:_hostWindow.frame];
    
    NSRect _newWindowFrame = [self.window frameRectForContentRect:
                             NSMakeRect(NSMinX(_windowFrame), NSMaxY(_windowFrame) - size.height, size.width, size.height)];
    
    /* Resize Window Content */
    for (id aView in [_hostWindow.contentView subviews])
    {
        if ([aView respondsToSelector:@selector(setFrame:)])
        {
            NSRect _objectRect = [aView frame];
            _objectRect.origin.y += _windowFrame.origin.y - _newWindowFrame.origin.y;
            [aView setFrame:_objectRect];
        }
    }
    
    [_hostWindow setFrame:_newWindowFrame display:YES animate:_hostWindow.isVisible];
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
    [_hostWindow setDelegate:self];
    
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
    
    [_selectedItem release];
    
    self.delegate = nil;
    
    [super dealloc];
}

@end
