//
//  UIViewController+ObservationHandler.h
//  GCD_Example
//
//  Created by Estelle Paus on 6/3/25.
//

#import <UIKit/UIKit.h>

@interface UIViewController (ObservationHandler)

- (void)handleObservationsForChange: (NSDictionary<NSKeyValueChangeKey,id> *)change
                               view: (UIView*) view;

@end
