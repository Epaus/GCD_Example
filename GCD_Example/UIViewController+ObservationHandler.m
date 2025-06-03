//
//  UIViewController+ObservationHandler.m
//  GCD_Example
//
//  Created by Estelle Paus on 6/3/25.
//

#import <Foundation/Foundation.h>
#import "UIViewController+ObservationHandler.h"


@implementation UIViewController (ObservationHandler)

- (void)handleObservationsForChange: (NSDictionary<NSKeyValueChangeKey,id> *)change
                                  view: (UIView*) view {
    BOOL newStatus = [change[NSKeyValueChangeNewKey] boolValue];
    
    if (newStatus == 1) {
        dispatch_async(dispatch_get_main_queue(), ^{
            
            view.tintColor = [UIColor systemGreenColor];
        });
    } else {
        dispatch_async(dispatch_get_main_queue(), ^{
            
            view.tintColor = [UIColor systemRedColor];
        });
    }
}

@end
