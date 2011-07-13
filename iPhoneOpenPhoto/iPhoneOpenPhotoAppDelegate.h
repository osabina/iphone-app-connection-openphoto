//
//  iPhoneOpenPhotoAppDelegate.h
//  iPhoneOpenPhoto
//
//  Created by Patrick Santana on 12/07/11.
//  Copyright 2011 Moogu bvba. All rights reserved.
//

#import <UIKit/UIKit.h>


@class iPhoneOpenPhotoViewController;

@interface iPhoneOpenPhotoAppDelegate : NSObject <UIApplicationDelegate> {

}

@property (nonatomic, retain) IBOutlet UIWindow *window;

@property (nonatomic, retain) IBOutlet iPhoneOpenPhotoViewController *viewController;

@end
