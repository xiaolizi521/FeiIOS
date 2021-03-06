//#import <uikit/uikit.h>
#import <QuartzCore/QuartzCore.h>
#import <SpringBoard/SpringBoard.h>
#import <CaptainHook/CaptainHook.h>

#import "SBIconView.h"
#import "KaiStatusBar.h"

@interface SBIcon (OS40)
- (NSString *)leafIdentifier;
- (void)updateLabel;
@end

@interface UIAlertView (XXX)

- (UITextField *)addTextFieldWithValue:(NSString *)value label:(NSString *)label;

@end

static NSMutableDictionary *iconMappings;

#define kSettingsFilePath "/var/mobile/Library/Preferences/com.njnu.kai.iconrenamer.plist"

__attribute__((visibility("hidden")))
@interface IconRenamer : NSObject <UIAlertViewDelegate, UITextFieldDelegate> {
@private
	SBIcon *_icon;
	SBIconView *_iconView;
	UIAlertView *_av;
	BOOL _hasTouch;
}
- (id)initWithIcon:(SBIcon *)icon iconView:(SBIconView *)iconView;
- (void)receiveTouch;
@end

static NSInteger originalName;

@implementation IconRenamer

static IconRenamer *currentRenamer;


+ (id)renamerWithIcon:(SBIcon *)icon iconView:(SBIconView *)iconView
{
	return [[[self alloc] initWithIcon:icon iconView:iconView] autorelease];
}

- (id)initWithIcon:(SBIcon *)icon iconView:(SBIconView *)iconView
{
	if ((self = [super init]))
	{
		currentRenamer = self;
		_icon = [icon retain];
		_iconView = [iconView retain];
	}
	return self;
}

- (void)receiveTouch
{
	if (!_hasTouch)
	{
		_hasTouch = YES;
		[self performSelector:@selector(show) withObject:nil afterDelay:0.25];
	}
	else
	{
		[NSObject cancelPreviousPerformRequestsWithTarget:self];
	}
}

- (void)show
{
//	static KaiStatusBar* _statusBar = nil;
	
	if (_av == nil)
	{
		_av = [[UIAlertView alloc] init];
		_av.delegate = self;
		originalName++;
		NSString *title = [_icon displayName];
		originalName--;
		_av.title = [@"重命名 " stringByAppendingString:title];
		UITextField *textField = [_av addTextFieldWithValue:[_icon displayName] label:nil];
		textField.delegate = self;
		textField.returnKeyType = UIReturnKeyDone;
		textField.clearButtonMode = UITextFieldViewModeAlways;
		_av.cancelButtonIndex = [_av addButtonWithTitle:@"取消"];
		[_av addButtonWithTitle:@"应用"];
		[_av show];
		[self retain];
		
//		if (_statusBar == nil)
//		{
//			_statusBar = [[KaiStatusBar alloc] initWithFrame:CGRectMake(0, 0, 320, 480)];
//			[_statusBar showWithStatusMessage:@"哈哈，音乐天天 动听无限"];
//		}
//		else
//		{
//			[_statusBar hide];
//			[_statusBar release];
//			_statusBar = nil;
//		}
	}
}

- (void)save
{
	NSString *identifier = [_icon leafIdentifier];
	NSString *newDisplayName = [[_av textFieldAtIndex:0] text];
	if (![[_icon displayName] isEqualToString:newDisplayName])
	{
		[iconMappings setObject:newDisplayName forKey:identifier];
		[iconMappings writeToFile:@kSettingsFilePath atomically:YES];
		if (_iconView)
			[_iconView updateLabel];
		else
			[_icon updateLabel];
	}
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
	textField.delegate = nil;
	[self save];
	_av.delegate = nil;
	[_av dismissWithClickedButtonIndex:0 animated:YES];
	[_av release];
	_av = nil;
	[self release];
	return NO;
}

- (void)alertView:(UIAlertView *)av clickedButtonAtIndex:(NSInteger)buttonIndex
{
//	[_statusBar hide];
//	[_statusBar release];
//	_statusBar = nil;
	
	if (buttonIndex != _av.cancelButtonIndex)
	{
		[self save];
		
	}
	[[_av textFieldAtIndex:0] setDelegate:nil];
	_av.delegate = nil;
	[_av release];
	_av = nil;
	[self release];
}

- (void)dealloc
{
	if (currentRenamer == self)
		currentRenamer = nil;
	[_icon release];
	[_iconView release];
	[super dealloc];
}

@end

CHDeclareClass(SBApplicationIcon);
CHDeclareClass(SBIconController);

CHOptimizedMethod(0, self, NSString *, SBApplicationIcon, displayName)
{
	if (originalName == 0)
	{
		NSString *title = [iconMappings objectForKey:[self leafIdentifier]];
		if (title != nil)
			return title;
	}
	return CHSuper(0, SBApplicationIcon, displayName);
}

static BOOL inTap;
static NSTimeInterval lastTapTime;
static SBApplicationIcon *lastTapIcon;

CHOptimizedMethod(2, super, void, SBApplicationIcon, touchesBegan, NSSet *, touches, withEvent, UIEvent *, event)
{
	inTap = [CHSharedInstance(SBIconController) isEditing];
	CHSuper(2, SBApplicationIcon, touchesBegan, touches, withEvent, event);
}

CHOptimizedMethod(2, super, void, SBApplicationIcon, touchesMoved, NSSet *, touches, withEvent, UIEvent *, event)
{
	inTap = NO;
	CHSuper(2, SBApplicationIcon, touchesMoved, touches, withEvent, event);
}

CHOptimizedMethod(2, super, void, SBApplicationIcon, touchesEnded, NSSet *, touches, withEvent, UIEvent *, event)
{
	NSLog(@"Kai: IconRenamer SBApplicationIcon touchesEnded");
	if (inTap)
	{
		if ([[iconMappings objectForKey:@"IRRequiresDoubleTap"] boolValue])
		{
			UITouch *touch = [touches anyObject];
			NSTimeInterval currentTapTime = touch.timestamp;
			if ((currentTapTime - lastTapTime < 0.5) && (lastTapIcon == self))
				[[IconRenamer renamerWithIcon:self iconView:nil] show];
			[lastTapIcon autorelease];
			lastTapIcon = [self retain];
			lastTapTime = currentTapTime;
		}
		else
		{
			[currentRenamer ?: [IconRenamer renamerWithIcon:self iconView:nil] receiveTouch];
		}
	}
	CHSuper(2, SBApplicationIcon, touchesEnded, touches, withEvent, event);
}

CHDeclareClass(SBIconView)

static SBIconView *lastTapIconView;

CHOptimizedMethod(2, super, void, SBIconView, touchesBegan, NSSet *, touches, withEvent, UIEvent *, event)
{
	inTap = [CHSharedInstance(SBIconController) isEditing];
	CHSuper(2, SBIconView, touchesBegan, touches, withEvent, event);
}

CHOptimizedMethod(2, super, void, SBIconView, touchesMoved, NSSet *, touches, withEvent, UIEvent *, event)
{
	inTap = NO;
	CHSuper(2, SBIconView, touchesMoved, touches, withEvent, event);
}

CHOptimizedMethod(2, super, void, SBIconView, touchesEnded, NSSet *, touches, withEvent, UIEvent *, event)
{
	NSLog(@"Kai: IconRenamer SBIconView touchesEnded");
	if (inTap)
	{
		SBIcon *icon = self.icon;
		if ([icon isKindOfClass:CHClass(SBApplicationIcon)])
		{
			if ([[iconMappings objectForKey:@"IRRequiresDoubleTap"] boolValue])
			{
				UITouch *touch = [touches anyObject];
				NSTimeInterval currentTapTime = touch.timestamp;
				if ((currentTapTime - lastTapTime < 0.5) && (lastTapIconView == self))
					[[IconRenamer renamerWithIcon:self.icon iconView:self] show];
				[lastTapIconView autorelease];
				lastTapIconView = [self retain];
				lastTapTime = currentTapTime;
			}
			else
			{
				[currentRenamer ?: [IconRenamer renamerWithIcon:self.icon iconView:self] receiveTouch];
			}
		}
	}
	CHSuper(2, SBIconView, touchesEnded, touches, withEvent, event);
}

CHDeclareClass(SpringBoard)

CHOptimizedMethod(1, self, void, SpringBoard, applicationDidFinishLaunching, id, application)
{
	NSLog(@"Kai: SpringBoard applicationDidFinishLaunching: %@ 0x%08X", NSStringFromClass([application class]), (int)application);
	CHSuper(1, SpringBoard, applicationDidFinishLaunching, application);
	
//	UIAlertView* _view = [[UIAlertView alloc] initWithTitle:@"Title" message:@"Message" delegate:nil cancelButtonTitle:@"Cancel" otherButtonTitles:@"OK", nil];
//	[_view show];
	
}

static void LoadSettings()
{
	[iconMappings release];
	iconMappings = [[NSMutableDictionary alloc] initWithContentsOfFile:@kSettingsFilePath] ?: [[NSMutableDictionary alloc] init];
}

CHConstructor {
	CHLoadLateClass(SBApplicationIcon);
	CHHook(0, SBApplicationIcon, displayName);
	CHHook(2, SBApplicationIcon, touchesBegan, withEvent);
	CHHook(2, SBApplicationIcon, touchesMoved, withEvent);
	CHHook(2, SBApplicationIcon, touchesEnded, withEvent);
	CHLoadLateClass(SBIconView);
	CHHook(2, SBIconView, touchesBegan, withEvent);
	CHHook(2, SBIconView, touchesMoved, withEvent);
	CHHook(2, SBIconView, touchesEnded, withEvent);
	CHLoadLateClass(SpringBoard);
	CHHook(1, SpringBoard, applicationDidFinishLaunching);
	CHLoadLateClass(SBIconController);
	CHAutoreleasePoolForScope();
	CFNotificationCenterAddObserver(CFNotificationCenterGetDarwinNotifyCenter(), NULL, (void *)LoadSettings, CFSTR("com.njnu.kai.iconrenamer/settingschanged"), NULL, CFNotificationSuspensionBehaviorCoalesce);
	LoadSettings();
	
}
