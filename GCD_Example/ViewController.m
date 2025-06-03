//
//  ViewController.m
//  GCD_Example
//
//  Created by Estelle Paus on 5/29/25.
//

#import "ViewController.h"
#import <UIKit/UIKit.h>
#import "WorkGroupViewController.h"
#import "UIViewController+ObservationHandler.h"

@interface ViewController ()

@property (weak, nonatomic) IBOutlet UIButton *serialButton;
@property (weak, nonatomic) IBOutlet UIImageView *serialTask1View;
@property (weak, nonatomic) IBOutlet UIImageView *serialTask2View;

@property (weak, nonatomic) IBOutlet UIButton *concurrentButton;
@property (weak, nonatomic) IBOutlet UIImageView *concurrentTask1View;
@property (weak, nonatomic) IBOutlet UIImageView *concurrentTask2View;
@property (weak, nonatomic) IBOutlet UIImageView *concurrentTask3View;

@property (weak, nonatomic) IBOutlet UIButton *barrierButton;
@property (weak, nonatomic) IBOutlet UIImageView *barrierTask1;
@property (weak, nonatomic) IBOutlet UIImageView *barrierTask2;
@property (weak, nonatomic) IBOutlet UIImageView *barrierTask3;
@property (weak, nonatomic) IBOutlet UIImageView *barrier;


@end

@implementation ViewController
- (IBAction)serialButtonTapped:(id)sender {
    [self resetSerialViews];
    [_model demonstrateSerialQueue];
    
}
- (IBAction)concurrentButtonTapped:(id)sender {
    [self resetConcurrentViews];
    [_model demonstrateConcurrentQueue];
}

- (IBAction)barrierButtonTapped:(id)sender {
    [self resetBarrierViews];
    [_model demonstrateBarrier];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    self.model = [[ExampleModel alloc] init];
    
    [self addObservers];
 
    [self resetSerialViews];
    
    [self resetConcurrentViews];
  
    [self resetBarrierViews];
 
    
}
- (void)addObservers {
    [self.model addObserver: self
                           forKeyPath: @"task1SerialOn"
                              options: NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld
                              context: nil];
    [self.model addObserver: self
                           forKeyPath: @"task2SerialOn"
                              options: NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld
                              context: nil];
    [self.model addObserver: self
                           forKeyPath: @"task1ConcurrentOn"
                              options: NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld
                              context: nil];
    [self.model addObserver: self
                           forKeyPath: @"task2ConcurrentOn"
                              options: NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld
                              context: nil];
    [self.model addObserver: self
                           forKeyPath: @"task3ConcurrentOn"
                              options: NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld
                              context: nil];
    
    [self.model addObserver: self
                           forKeyPath: @"task1BarrierOn"
                              options: NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld
                              context: nil];
    [self.model addObserver: self
                           forKeyPath: @"task2BarrierOn"
                              options: NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld
                              context: nil];
    [self.model addObserver: self
                           forKeyPath: @"task3BarrierOn"
                              options: NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld
                              context: nil];
    [self.model addObserver: self
                           forKeyPath: @"barrierTaskOn"
                              options: NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld
                              context: nil];
}
- (void)resetSerialViews {
    _serialTask1View.tintColor = [UIColor systemRedColor];
    _serialTask2View.tintColor = [UIColor systemRedColor];
}
- (void)resetConcurrentViews {
    _concurrentTask1View.tintColor = [UIColor systemRedColor];
    _concurrentTask2View.tintColor = [UIColor systemRedColor];
    _concurrentTask3View.tintColor = [UIColor systemRedColor];
}

- (void)resetBarrierViews {
    _barrier.tintColor = [UIColor systemRedColor];
    _barrierTask1.tintColor = [UIColor systemRedColor];
    _barrierTask2.tintColor = [UIColor systemRedColor];
    _barrierTask3.tintColor = [UIColor systemRedColor];
}


// KVO callback method
- (void)observeValueForKeyPath:(NSString *)keyPath
                      ofObject:(id)object
                        change:(NSDictionary<NSKeyValueChangeKey,id> *)change
                       context:(void *)context {
    
    if ([keyPath isEqualToString:@"task1SerialOn"]) {
        [self handleObservationsForChange:change view:_serialTask1View];
    }
    
    if ([keyPath isEqualToString:@"task2SerialOn"]) {
        [self handleObservationsForChange:change view:self->_serialTask2View];
    }
    
    if ([keyPath isEqualToString:@"task1ConcurrentOn"]) {
        [self handleObservationsForChange:change view:_concurrentTask1View];
    }
    
    if ([keyPath isEqualToString:@"task2ConcurrentOn"]) {
        [self handleObservationsForChange:change view:_concurrentTask2View];
    }
    
    if ([keyPath isEqualToString:@"task3ConcurrentOn"]) {
        [self handleObservationsForChange:change view:_concurrentTask3View];
      
    }
    if ([keyPath isEqualToString:@"task1BarrierOn"]) {
        [self handleObservationsForChange:change view:_barrierTask1];
    }
    
    if ([keyPath isEqualToString:@"task2BarrierOn"]) {
        [self handleObservationsForChange:change view:_barrierTask2];
    }
    
    if ([keyPath isEqualToString:@"barrierTaskOn"]) {
        [self handleObservationsForChange:change view:_barrier];
    }
    
    if ([keyPath isEqualToString:@"task3BarrierOn"]) {
        [self handleObservationsForChange:change view:_barrierTask3];
    }
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"segueToWorkGroup"]) {
        WorkGroupViewController *destinationVC = (WorkGroupViewController *)segue.destinationViewController;
        destinationVC.model = self.model; 
    }
}

-(void)dealloc {
    [self.model removeObserver:self forKeyPath:@"task1SerialOn"];
    [self.model removeObserver:self forKeyPath:@"task2SerialOn"];
    [self.model removeObserver:self forKeyPath:@"task1ConcurrentOn"];
    [self.model removeObserver:self forKeyPath:@"task2ConcurrentOn"];
    [self.model removeObserver:self forKeyPath:@"task3ConcurrentOn"];
}
@end


