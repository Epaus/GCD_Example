//
//  WorkGroupViewController.m
//  GCD_Example
//
//  Created by Estelle Paus on 6/1/25.
//

#import <Foundation/Foundation.h>
#import "WorkGroupViewController.h"

#import <UIKit/UIKit.h>

@interface WorkGroupViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *workItem1Running;
@property (weak, nonatomic) IBOutlet UIImageView *workItem2Running;
@property (weak, nonatomic) IBOutlet UIImageView *workItem3Running;
@property (weak, nonatomic) IBOutlet UILabel *workGroupComplete;

@property (weak, nonatomic) IBOutlet UIButton *startConcurrentButton;


@property (weak, nonatomic) IBOutlet UIImageView *workItem1SerialRunning;
@property (weak, nonatomic) IBOutlet UIImageView *workItem2SerialRunning;
@property (weak, nonatomic) IBOutlet UIImageView *workItem3SerialRunning;
@property (weak, nonatomic) IBOutlet UILabel *workGroupSerialComplete;
@property (weak, nonatomic) IBOutlet UIButton *startSerialButton;

@end

@implementation WorkGroupViewController

-(void)viewDidLoad {
    [self resetViews];
    [self addObservers];
}

- (void)addObservers {
    [self.model addObserver: self
                 forKeyPath: @"workItem1SerialRunning"
                    options: NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld
                    context: nil];
    [self.model addObserver: self
                 forKeyPath: @"workItem2SerialRunning"
                    options: NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld
                    context: nil];
    [self.model addObserver: self
                 forKeyPath: @"workItem3SerialRunning"
                    options: NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld
                    context: nil];
    [self.model addObserver:self
                 forKeyPath:@"workGroupComplete"
                    options: NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld
                    context:nil];
    [self.model addObserver: self
                 forKeyPath: @"workItem1Running"
                    options: NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld
                    context: nil];
    [self.model addObserver: self
                 forKeyPath: @"workItem2Running"
                    options: NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld
                    context: nil];
    [self.model addObserver: self
                 forKeyPath: @"workItem3Running"
                    options: NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld
                    context: nil];
    [self.model addObserver:self
                 forKeyPath:@"workGroupSerialComplete"
                    options: NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld
                    context:nil];
    
}
- (void)resetViews {
    _workItem1Running.tintColor = [UIColor systemRedColor];
    _workItem2Running.tintColor = [UIColor systemRedColor];
    _workItem3Running.tintColor = [UIColor systemRedColor];
    _workGroupComplete.hidden = YES;
    _startConcurrentButton.enabled = YES;
    
    _workItem1SerialRunning.tintColor =  [UIColor systemRedColor];
    _workItem2SerialRunning.tintColor =  [UIColor systemRedColor];
    _workItem3SerialRunning.tintColor =  [UIColor systemRedColor];
    _workGroupSerialComplete.hidden = YES;
    _startSerialButton.enabled = YES;
}

- (void)observeValueForKeyPath:(NSString *)keyPath
                      ofObject:(id)object
                        change:(NSDictionary<NSKeyValueChangeKey,id> *)change
                       context:(void *)context {
    
    if ([keyPath isEqualToString:@"workItem1Running"]) {
        [self handleObservationsForChange:change view:_workItem1Running];
    }
    
    if ([keyPath isEqualToString:@"workItem2Running"]) {
        [self handleObservationsForChange:change view:_workItem2Running];
    }
    
    if ([keyPath isEqualToString:@"workItem3Running"]) {
        [self handleObservationsForChange:change view:_workItem3Running];
    }
    
    if ([keyPath isEqualToString:@"workGroupComplete"]) {
        [self handleCompleteObservation: change button: _startConcurrentButton label: _workGroupComplete];

    }
    
    if ([keyPath isEqualToString:@"workItem1SerialRunning"]) {
        [self handleObservationsForChange:change view:_workItem1SerialRunning];
    }
    
    if ([keyPath isEqualToString:@"workItem2SerialRunning"]) {
        [self handleObservationsForChange:change view:_workItem2SerialRunning];
        
    }
    if ([keyPath isEqualToString:@"workItem3SerialRunning"]) {
        [self handleObservationsForChange:change view:_workItem3SerialRunning];
        
    }
    if ([keyPath isEqualToString:@"workGroupSerialComplete"]) {
        [self handleCompleteObservation: change button: _startSerialButton label: _workGroupSerialComplete];

    }
}


- (void)handleCompleteObservation: (NSDictionary<NSKeyValueChangeKey,id> *)change button: (UIButton *)button label: (UILabel*)label {
    BOOL newStatus = [change[NSKeyValueChangeNewKey] boolValue];
    
    if (newStatus == 1) {
        dispatch_async(dispatch_get_main_queue(), ^{
            label.hidden = NO;
            button.enabled = YES;
        });
    } else {
        dispatch_async(dispatch_get_main_queue(), ^{
            label.hidden = YES;
            
        });
    }
}


- (IBAction)startConcurrentGroup:(id)sender {
    _startConcurrentButton.enabled = NO;
    _workGroupComplete.hidden = YES;
    [_model demonstrateConcurrentWorkGroup];
}

- (IBAction)startSerialGroup:(id)sender {
    NSLog(@"startSerialGroup tapped");
    _startSerialButton.enabled = NO;
    _workGroupSerialComplete.hidden = YES;
    [_model demonstrateSerialWorkGroup];
}

-(void)dealloc {
    [self.model removeObserver:self forKeyPath:@"workItem1SerialRunning"];
    [self.model removeObserver:self forKeyPath:@"workItem2SerialRunning"];
    [self.model removeObserver:self forKeyPath:@"workItem3SerialRunning"];
    [self.model removeObserver:self forKeyPath:@"workGroupSerialComplete"];
    [self.model removeObserver:self forKeyPath:@"workItem1Running"];
    [self.model removeObserver:self forKeyPath:@"workItem2Running"];
    [self.model removeObserver:self forKeyPath:@"workItem3Running"];
    [self.model removeObserver:self forKeyPath:@"workGroupComplete"];
}


@end
