//
//  DFRPrivateHeader.m
//  firstTouch
//
//  Created by Crayer/VladimirSpigiel on 04/08/2017.
//  Copyright © 2017 Crayer. All rights reserved.
//


#import <Foundation/Foundation.h>
#import "DFRPrivateHeader.h"

@implementation NSTouchBarItem (DFRAccess)

- (void)addToControlStrip {
    [NSTouchBarItem addSystemTrayItem:self];
    
    [self toggleControlStripPresence:true];
}

- (void)toggleControlStripPresence:(BOOL)present {
    DFRElementSetControlStripPresenceForIdentifier(self.identifier,
                                                   present);
}

@end

@implementation NSTouchBar (DFRAccess)

- (void)presentAsSystemModalForItem:(NSTouchBarItem *)item {
    [NSTouchBar presentSystemModalFunctionBar:self
                     systemTrayItemIdentifier:item.identifier];
}

- (void)dismissSystemModal {
    [NSTouchBar dismissSystemModalFunctionBar:self];
}

- (void)minimizeSystemModal {
    [NSTouchBar minimizeSystemModalFunctionBar:self];
}

@end

@implementation NSControlStripTouchBarItem

- (void)setIsPresentInControlStrip:(BOOL)present {
    _isPresentInControlStrip = present;
    
    if (present) {
        [super addToControlStrip];
    } else {
        [super toggleControlStripPresence:false];
    }
}

@end
