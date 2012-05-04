//
//  AppDelegate.h
//  ninjaToArtillery
//
//  Created by default on 3/29/12.
//  Copyright __MyCompanyName__ 2012. All rights reserved.
//

#import <UIKit/UIKit.h>

@class RootViewController;

@interface AppDelegate : NSObject <UIApplicationDelegate> {
	UIWindow			*window;
	RootViewController	*viewController;
}

@property (nonatomic, retain) UIWindow *window;

@end

/*
 Nice-looking, playable app, and extra kudos for teaching yourself Cocos2d. I'd
 prefer if you gave credit to the Ray Wenderlich tutorial for the code you
 borrowed, but you obviously modified it heavily and understand how it works, so
 I'm not too concerned. Good code structure, comments, etc.
 
 The app crashes strangely on a device, but not in the simulator. It says it
 can't find Target_Jet_Blue_mod.png, though the file is present and loads in the
 simulator. I don't know what to make of this - the iOS developer tools are buggy
 sometimes.
 
 Grade: 100%
 Course grade: 100% (A)
*/