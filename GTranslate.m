#import <UIKit/UIKit2.h>
#import <WebKit/WebKit.h>
#import <WebCore/WebCore.h>
#import <Preferences/Preferences.h>
#import "ActionMenu.h"

// Additional Private APIs

@interface UIWebBrowserView (WebPrivate)
- (WebFrame *)_focusedOrMainFrame;
@end

@interface WebFrame (WebPrivate)
- (NSString *)stringByEvaluatingJavaScriptFromString:(NSString *)string forceUserGesture:(BOOL)forceUserGesture;
@end

@implementation UIWebBrowserView (GTranslateAction)

- (BOOL)canDoGTranslateAction:(id)sender
{
	WebThreadLock();
	WebFrame *webFrame = [self _focusedOrMainFrame];
	// Check to see if web view contains a URL we can Read Later
	NSString *URL = [webFrame stringByEvaluatingJavaScriptFromString:@"location.href" forceUserGesture:NO];
	WebThreadUnlock();
	return [URL hasPrefix:@"http://"] || [URL hasPrefix:@"https://"];
}

- (void)performGTranslateAction:(id)sender
{
  // Add the item with specified URL
  WebThreadLock();
  WebFrame *webFrame = [self _focusedOrMainFrame];
  NSString *websiteURL = [webFrame stringByEvaluatingJavaScriptFromString:@"location.href" forceUserGesture:NO];
  NSString *translateURL = [NSString stringWithFormat:@"http://translate.google.com/translate?u=%@", websiteURL];
  [[UIApplication sharedApplication] openURL:[NSURL URLWithString:translateURL]];
  WebThreadUnlock();
}

+ (void)load
{
	id<AMMenuItem> menuItem = [[UIMenuController sharedMenuController] registerAction:@selector(performGTranslateAction:) title:@"Trans" canPerform:@selector(canDoGTranslateAction:) forPlugin:@"GTranslate"];
	menuItem.priority = 1000;
	menuItem.image = [UIImage imageWithContentsOfFile:([UIScreen mainScreen].scale == 2.0f) ? @"/Library/ActionMenu/Plugins/GTranslate@2x.png" : @"/Library/ActionMenu/Plugins/GTranslate.png"];
}

@end

