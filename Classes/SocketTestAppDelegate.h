//
//  SocketTestAppDelegate.h
//  SocketTest
//
//  Created by Travis Wyatt on 9/23/10.
//  Copyright __MyCompanyName__ 2010. All rights reserved.
//

#import <UIKit/UIKit.h>

@class SocketTestViewController;

@interface SocketTestAppDelegate : NSObject <UIApplicationDelegate> {
    UIWindow *window;
    SocketTestViewController *viewController;
}

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) IBOutlet SocketTestViewController *viewController;

@end

