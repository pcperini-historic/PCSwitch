//
//  PCSwitch.h
//  PCSwitchTests
//
//  Created by Patrick Perini on 5/21/12.
//  Licensing information available in README.md
//

#import <Cocoa/Cocoa.h>

extern NSString *const PCSwitchStateDidChangeNotification;

@interface PCSwitch : NSButton
{
    NSRect buttonFrame;
    BOOL isDragging;
}

@property (nonatomic, getter = isOn) BOOL on;
@property (nonatomic) NSString *onText;
@property (nonatomic) NSString *offText;
@property (nonatomic) NSColor *onTintColor;

#pragma mark - Accessors and Mutators
- (void)setOn:(BOOL)on animated:(BOOL)animated;

@end
