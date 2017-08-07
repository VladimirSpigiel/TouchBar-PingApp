//
//  DFRPrivateHeader.h
//  firstTouch
//
//  Created by Crayer/VladimirSpigiel on 04/08/2017.
//  Copyright © 2017 Crayer. All rights reserved.
//

#ifndef DFRPrivateHeader_h
#define DFRPrivateHeader_h


#import <AppKit/AppKit.h>

extern void DFRElementSetControlStripPresenceForIdentifier(NSString *, BOOL);
extern void DFRSystemModalShowsCloseBoxWhenFrontMost(BOOL);

@interface NSTouchBarItem ()

+ (void)addSystemTrayItem:(NSTouchBarItem *)item;

@end

@interface NSTouchBarItem (DFRAccess)

- (void)addToControlStrip;

- (void)toggleControlStripPresence:(BOOL)present;

@end

@interface NSTouchBar ()

+ (void)presentSystemModalFunctionBar:(NSTouchBar *)touchBar
             systemTrayItemIdentifier:(NSString *)identifier;

+ (void)dismissSystemModalFunctionBar:(NSTouchBar *)touchBar;

+ (void)minimizeSystemModalFunctionBar:(NSTouchBar *)touchBar;

@end

@interface NSTouchBar (DFRAccess)

- (void)presentAsSystemModalForItem:(NSTouchBarItem *)item;

- (void)dismissSystemModal;

- (void)minimizeSystemModal;

@end

@interface NSControlStripTouchBarItem: NSCustomTouchBarItem

@property (nonatomic) BOOL isPresentInControlStrip;

@end


#endif /* DFRPrivateHeader_h */
