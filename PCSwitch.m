//
//  PCSwitch.m
//  PCSwitchTests
//
//  Created by Patrick Perini on 5/21/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "PCSwitch.h"
#include <unistd.h>

#pragma mark - Internal Constants
#define switchSize         NSMakeSize(67, 22)
#define switchCornerRadius 9.0
#define switchOffTintColor [NSColor colorWithCalibratedWhite: .96 alpha: 1]
#define switchButtonSize   NSMakeSize(20, 20)
#define switchFontSize     13
#define switchTintIsLight  [[onTintColor colorUsingColorSpace: [NSColorSpace deviceGrayColorSpace]] whiteComponent] >= .75

#define switchGrooveBorderColor  [NSColor colorWithCalibratedWhite: .75 alpha: 1]
#define switchGrooveGlowColor    [NSColor colorWithCalibratedWhite: 1 alpha: .1]
#define switchButtonBorderColor  [NSColor colorWithCalibratedWhite: .61 alpha: 1]

#pragma mark - Internal Functions
#define NSRangeOfString(str)            NSMakeRange(0, [str length])
#define NSBezierPathNormalize(path)     {                                                                       \
                                            NSAffineTransform *transform = [[NSAffineTransform alloc] init];    \
                                            [transform translateXBy: .5 yBy: .5];                               \
                                            [path transformUsingAffineTransform: transform];                    \
                                        }

#pragma mark - External Constants
NSString *const PCSwitchStateDidChangeNotification = @"PCSwitchStateDidChangeNotification";

@interface PCSwitch ()

- (NSAttributedString *)labelForText: (NSString *)text;

@end

@implementation PCSwitch

#pragma mark - Properties
@synthesize on;
@synthesize onText;
@synthesize offText;
@synthesize onTintColor;

#pragma mark - Accessors and Mutators
- (void)setOn:(BOOL)aState
{
    [self setOn: aState
       animated: NO];
}

- (void)setOn:(BOOL)aState animated:(BOOL)animated
{
    if (aState == [self isOn])
        return;
                                            
    NSRect newButtonFrame = buttonFrame;
    if ([self isOn])
        newButtonFrame.origin.x = NSMaxX(self.bounds) - switchButtonSize.width - 1;
    else
        newButtonFrame.origin.x = NSMinX(self.bounds) + 1;
    
    on = aState;
    [[NSNotificationCenter defaultCenter] postNotificationName: PCSwitchStateDidChangeNotification
                                                        object: self];
    
    if (animated)
    {
        while (NSMinX(buttonFrame) != NSMinX(newButtonFrame))
        {
            if (NSMinX(newButtonFrame) > NSMinX(buttonFrame))
            {
                buttonFrame.origin.x += 1;
            }
            else
            {
                buttonFrame.origin.x -= 1;
            }
            
            [self setNeedsDisplay];
            [[NSRunLoop currentRunLoop] runMode: NSDefaultRunLoopMode beforeDate: [NSDate date]];
            usleep(3072);
        }
    }
    else
    {
        buttonFrame.origin = newButtonFrame.origin;
        [self setNeedsDisplay];
    }
}

- (void)setOnText:(NSString *)text
{
    if ([self labelForText: text].size.width > (NSWidth(self.bounds) / 2.0))
    {
        NSLog(@"PCSwitch Error: Given label is too long.");
        return;
    }
    
    onText = text;
    [self setNeedsDisplay];
}

- (void)setOffText:(NSString *)text
{
    if ([self labelForText: text].size.width > (NSWidth(self.bounds) / 2.0))
    {
        NSLog(@"PCSwitch Error: Given label is too long.");
        return;
    }
    
    offText = text;
    [self setNeedsDisplay];
}

- (void)setOnTintColor:(NSColor *)tintColor
{
    onTintColor = tintColor;
    [self setNeedsDisplay];
}

#pragma mark - Initializers and Instantiators
- (id)initWithFrame:(NSRect)frame
{
    frame.size = switchSize;
    self = [super initWithFrame: frame];
    if (!self)
        return nil;
        
    [self awakeFromNib];
    
    return self;
}

- (void)awakeFromNib
{
    NSRect frame = self.frame;
    frame.size = switchSize;
    [self setFrame: frame];
    [self setNeedsDisplay];
    
    buttonFrame = self.bounds;
    buttonFrame.origin.y += 1;
    buttonFrame.origin.x += 1;
    buttonFrame.size = switchButtonSize;
    
    if (!onTintColor)
        onTintColor = [NSColor blueColor];
    
    if (!onText)
        onText = @"ON";
    
    if (!offText)
        offText= @"OFF";
}

#pragma mark - Drawers
- (void)drawRect:(NSRect)dirtyRect
{
    [NSGraphicsContext saveGraphicsState];
    
    // Groove
    NSRect grooveFrame = NSInsetRect(self.bounds, 1, 1);
    NSBezierPath *groovePath = [NSBezierPath bezierPathWithRoundedRect: grooveFrame
                                                               xRadius: switchCornerRadius
                                                               yRadius: switchCornerRadius]; 
    NSBezierPathNormalize(groovePath);
    [groovePath setClip];
    
    // Left Groove
    NSRect leftGrooveFrame = self.bounds;
    leftGrooveFrame.size.width = (NSWidth(leftGrooveFrame) / 2.0) + NSWidth(buttonFrame) + 1;
    leftGrooveFrame.origin.x -= NSWidth(leftGrooveFrame) - NSMidX(buttonFrame);
    NSBezierPath *leftGroovePath = [NSBezierPath bezierPathWithRect: leftGrooveFrame];
    NSBezierPathNormalize(leftGroovePath);
    
    [onTintColor setFill];
    [leftGroovePath fill];
    
    // On Text
    NSMutableAttributedString *onTextLabel = [[self labelForText: onText] mutableCopy];
    [onTextLabel addAttribute: NSForegroundColorAttributeName
                        value: switchTintIsLight? [NSColor blackColor] : [NSColor whiteColor]
                        range: NSRangeOfString(onText)];
    
    NSShadow *onTextLabelShadow = [[NSShadow alloc] init];
    [onTextLabelShadow setShadowColor: switchTintIsLight? [[NSColor whiteColor] colorWithAlphaComponent: .5] : [[NSColor blackColor] colorWithAlphaComponent: .5]];
    [onTextLabelShadow setShadowOffset: NSMakeSize(0, switchTintIsLight? -1 : 1)];
    [onTextLabelShadow setShadowBlurRadius: 0];
    [onTextLabel addAttribute: NSShadowAttributeName
                        value: onTextLabelShadow
                        range: NSRangeOfString(onText)];
    
    NSPoint onTextLabelOrigin = NSZeroPoint;
    onTextLabelOrigin.x = (((NSMinX(buttonFrame) - NSMinX(leftGrooveFrame)) - onTextLabel.size.width) / 2.0) + NSMinX(leftGrooveFrame) + 2.5;
    onTextLabelOrigin.y = ((NSHeight(grooveFrame) - onTextLabel.size.height) / 2.0) + 1.5;
    [onTextLabel drawAtPoint: onTextLabelOrigin];
    
    // Right Groove
    NSRect rightGrooveFrame = self.bounds;
    rightGrooveFrame.size.width = (NSWidth(self.bounds) / 2.0) + NSWidth(buttonFrame) + 1;
    rightGrooveFrame.origin.x = NSMidX(buttonFrame);
    NSBezierPath *rightGroovePath = [NSBezierPath bezierPathWithRect: rightGrooveFrame];
    NSBezierPathNormalize(rightGroovePath);
    
    [switchOffTintColor setFill];
    [rightGroovePath fill];
    
    // Off Text
    NSMutableAttributedString *offTextLabel = [[self labelForText: offText] mutableCopy];
    [offTextLabel addAttribute: NSForegroundColorAttributeName
                         value: [NSColor darkGrayColor]
                         range: NSRangeOfString(offText)];
    
    NSShadow *offTextLabelShadow = [[NSShadow alloc] init];
    [offTextLabelShadow setShadowColor: [[NSColor whiteColor] colorWithAlphaComponent: .5]];
    [offTextLabelShadow setShadowOffset: NSMakeSize(0, -1)];
    [offTextLabelShadow setShadowBlurRadius: 0];
    [offTextLabel addAttribute: NSShadowAttributeName
                         value: offTextLabelShadow
                         range: NSRangeOfString(offText)];
    
    NSPoint offTextLabelOrigin = NSZeroPoint;
    offTextLabelOrigin.x = (((NSMaxX(rightGrooveFrame) - NSMidX(buttonFrame)) - offTextLabel.size.width) / 2.0) + NSMidX(buttonFrame) + 2.5;
    offTextLabelOrigin.y = ((NSHeight(grooveFrame) - offTextLabel.size.height) / 2.0) + 1.5;
    [offTextLabel drawAtPoint: offTextLabelOrigin];
    
    // Groove Shadow
    NSShadow *grooveShadow = [[NSShadow alloc] init];
    [grooveShadow setShadowColor: [NSColor blackColor]];
    [grooveShadow setShadowBlurRadius: 2];
    [grooveShadow setShadowOffset: NSMakeSize(0, -1)];
    
    [grooveShadow set];
    [switchGrooveBorderColor setStroke];
    [groovePath stroke];
    
    // Groove Glow
    [grooveShadow setShadowColor: [NSColor clearColor]];
    
    NSRect grooveGlowFrame = self.bounds;
    grooveGlowFrame.origin.y = NSMidY(self.bounds) + 1;
    NSBezierPath *grooveGlowPath = [NSBezierPath bezierPathWithRoundedRect: grooveGlowFrame
                                                                   xRadius: switchCornerRadius
                                                                   yRadius: switchCornerRadius];
    NSBezierPathNormalize(grooveGlowPath);
    
    [grooveShadow set];
    [switchGrooveGlowColor setFill];
    [grooveGlowPath fill];

    [NSGraphicsContext restoreGraphicsState];
    [NSGraphicsContext saveGraphicsState];
    
    [[NSBezierPath bezierPathWithRect: self.bounds] setClip];
    
    // Button
    NSBezierPath *buttonPath = [NSBezierPath bezierPathWithOvalInRect: buttonFrame];
    NSBezierPathNormalize(buttonPath);
    
    NSGradient *buttonGradient = [[NSGradient alloc] initWithStartingColor: [NSColor colorWithCalibratedWhite: .83 alpha: 1]
                                                               endingColor: [NSColor colorWithCalibratedWhite: .98 alpha: 1]];
    [buttonGradient drawInBezierPath: buttonPath
                               angle: 90];

    [switchButtonBorderColor setStroke];
    [buttonPath stroke];
    
    [NSGraphicsContext restoreGraphicsState];
}

#pragma mark - User Interaction Handlers
- (void)mouseDown:(NSEvent *)theEvent
{
    NSPoint clickPoint = [self convertPointFromBase: [theEvent locationInWindow]];    
    isDragging = NSPointInRect(clickPoint, buttonFrame);
}

- (void)mouseDragged:(NSEvent *)theEvent
{
    if (isDragging)
    {
        NSPoint dragPoint = buttonFrame.origin;
        dragPoint.x += [theEvent deltaX];
        
        if (dragPoint.x >= NSMinX(self.bounds) + 1 && dragPoint.x <= NSMaxX(self.bounds) - NSWidth(buttonFrame) - 1)
        {
            buttonFrame.origin = dragPoint;
            [self setNeedsDisplay];
        }
    }
}

- (void)mouseUp:(NSEvent *)theEvent
{
    if (isDragging)
    {   
        if (NSMinX(buttonFrame) == NSMinX(self.bounds) + 1 || NSMinX(buttonFrame) == NSMaxX(self.bounds) - NSWidth(buttonFrame) - 1)
        {
            [self setOn: ![self isOn]
               animated: YES];
            return;
        }
        
        if ([self isOn])
        {
            [self setOn: !(NSMidX(buttonFrame) <= NSMidX(self.bounds))
               animated: YES];
        }
        else
        {
            [self setOn: NSMidX(buttonFrame) >= NSMidX(self.bounds)
               animated: YES];
        }
    }
    
    isDragging = NO;
}

#pragma mark - Overriders
- (void)setTarget:(id)anObject {}
- (void)setAction:(SEL)aSelector {}
- (BOOL)acceptsFirstMouse:(NSEvent *)theEvent
{
    return YES;
}
- (void)setFrame:(NSRect)frameRect
{
    frameRect.size = switchSize;
    [super setFrame: frameRect];
}

#pragma mark - Misc.
- (NSAttributedString *)labelForText:(NSString *)text
{
    NSMutableAttributedString *textLabel = [[NSMutableAttributedString alloc] initWithString: text];
    [textLabel addAttribute: NSFontAttributeName
                      value: [NSFont boldSystemFontOfSize: switchFontSize]
                      range: NSRangeOfString(text)];
    return textLabel;
}

@end
