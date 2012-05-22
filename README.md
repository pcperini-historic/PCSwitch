#PCSwitch#


Inherits From:    NSButton

Declared In:      PCSwitch.h


##Overview##

You use the `PCSwitch` class to create and manage On/Off buttons similar to those in iOS' Settings app. These objects are known as switches.

The `PCSwitch` class declares a property and a method to control its on/off state. When the user manipulates the switch control ("flips" it) a `PCSwitchStateDidChangeNotification` notification is posted.

You can customize the appearance of the switch by changing the color used to tint the switch when it is in the on position, and changing the text that appears in the on and off positions.

<img src="http://i.imgur.com/ycJzu.png"/>


##Tasks##

###Initializing the Switch Object###
    - initWithFrame:

###Setting the On/Off State###
    on (property)
    - setOn:animated:

###Customizing the Appearance of the Switch###
    onText (property)
    offText (property)
    onTintColor (property)

##Constants##

    PCSwitchStateDidChangeNotification  @"PCSwitchStateDidChangeNotification"


##Properties##

**on**

>A Boolean value that determines the on/off state of the switch.

        (nonatomic, getter = isOn) BOOL on

**onText**

>The string to display in the on position. 

        (nonatomic) NSString *onText
        
>*Discussion:*

>>If you attempt to set this string to a value whose size is greater than the alloted size, no change will occur, and the console will log the error.
        
**offText**

>The string to display in the off position.

        (nonatomic) NSString *offText
        
>*Discussion:*

>>If you attempt to set this string to a value whose size is greater than the alloted size, no change will occur, and the console will log the error.

**onTintColor**

>The color used to tint the appearance of the switch when it is turned on.

        (nonatomic) NSColor *onTintColor
        
>*Discussion:*

>>The color of `onText` will vary between `[NSColor whiteColor]` and `[NSColor blackColor]` depending on the `- whiteValue` of this color.


##Instance Methods##

**initWithFrame:**

>Returns an initialized switch object.

        - (id)initWithFrame:(CGRect)frame

>*Parameters:*

>`frame`

>>A rectangle defining the frame of the `PCSwitch` object. The size components of this rectangle are ignored.

>*Return Value:*

>>An initialized `PCSwitch` object or `nil` if the object could not be initialized.

**setOn:animated:**

>Set the state of the switch to On or Off, optionally animating the transition.

        - (void)setOn:(BOOL)on animated:(BOOL)animated

>*Parameters:*

>`on`

>>`YES` or `NSOnState` if the switch should be turned to the On position; `NO` or `NSOffState` if it should be turned to the Off position. If the switch is already in the designated position nothing happens.

>`animated`

>>`YES` to animated the "flipping" of the switch; otherwise `NO`.

#License#

License Agreement for Source Code provided by Patrick Perini

This software is supplied to you by Patrick Perini in consideration of your agreement to the following terms, and your use, installation, modification or redistribution of this software constitutes acceptance of these terms. If you do not agree with these terms, please do not use, install, modify or redistribute this software.

In consideration of your agreement to abide by the following terms, and subject to these terms, Patrick Perini grants you a personal, non-exclusive license, to use, reproduce, modify and redistribute the software, with or without modifications, in source and/or binary forms; provided that if you redistribute the software in its entirety and without modifications, you must retain this notice and the following text and disclaimers in all such redistributions of the software, and that in all cases attribution of Patrick Perini as the original author of the source code shall be included in all such resulting software products or distributions. Neither the name, trademarks, service marks or logos of Patrick Perini may be used to endorse or promote products derived from the software without specific prior written permission from Patrick Perini. Except as expressly stated in this notice, no other rights or licenses, express or implied, are granted by Patrick Perini herein, including but not limited to any patent rights that may be infringed by your derivative works or by other works in which the software may be incorporated.

The software is provided by Patrick Perini on an "AS IS" basis. Patrick Perini MAKES NO WARRANTIES, EXPRESS OR IMPLIED, INCLUDING WITHOUT LIMITATION THE IMPLIED WARRANTIES OF NON-INFRINGEMENT, MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE, REGARDING THE SOFTWARE OR PCS USE AND OPERATION ALONE OR IN COMBINATION WITH YOUR PRODUCTS.

IN NO EVENT SHALL Patrick Perini BE LIABLE FOR ANY SPECIAL, INDIRECT, INCIDENTAL OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) ARISING IN ANY WAY OUT OF THE USE, REPRODUCTION, MODIFICATION AND/OR DISTRIBUTION OF THE SOFTWARE, HOWEVER CAUSED AND WHETHER UNDER THEORY OF CONTRACT, TORT (INCLUDING NEGLIGENCE), STRICT LIABILITY OR OTHERWISE, EVEN IF Patrick Perini HAS BEEN ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.