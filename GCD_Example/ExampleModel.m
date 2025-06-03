//
//  ExampleModel.m
//  GCD_Example
//
//  Created by Estelle Paus on 5/29/25.
//

#import <Foundation/Foundation.h>
#import "ExampleModel.h"

@interface ExampleModel()
@end

@implementation ExampleModel: NSObject

- (void)demonstrateSerialQueue {
    dispatch_queue_t mySerialQueue = dispatch_queue_create("com.exampleModel.serialQueue", DISPATCH_QUEUE_SERIAL);
    
    dispatch_async(mySerialQueue, ^{
        self.task1SerialOn = YES;
        
        [NSThread sleepForTimeInterval:3];
        
        self.task1SerialOn = NO;
      
    });

    dispatch_async(mySerialQueue, ^{
        self.task2SerialOn = YES;
        
        [NSThread sleepForTimeInterval:3];
        
        self.task2SerialOn = NO;
    });
}

-(void)demonstrateConcurrentQueue {
    dispatch_queue_t concurrentQueue = dispatch_queue_create("com.example.concurrentQueue", DISPATCH_QUEUE_CONCURRENT);
    
    dispatch_async(concurrentQueue, ^{
        self.task1ConcurrentOn = YES;
        
        int randomNumber = arc4random_uniform(5) + 1;
        [NSThread sleepForTimeInterval:randomNumber];
        
        self.task1ConcurrentOn = NO;
    });

    dispatch_async(concurrentQueue, ^{
        dispatch_async(concurrentQueue, ^{
            self.task2ConcurrentOn = YES;
           
            int randomNumber = arc4random_uniform(5) + 1;
            [NSThread sleepForTimeInterval:randomNumber];
            
            self.task2ConcurrentOn = NO;
        });
    });

    dispatch_async(concurrentQueue, ^{
        dispatch_async(concurrentQueue, ^{
            self.task3ConcurrentOn = YES;
            
            int randomNumber = arc4random_uniform(5) + 1;
            [NSThread sleepForTimeInterval:randomNumber];
            
            self.task3ConcurrentOn = NO;
        });
    });
}

-(void)demonstrateBarrier {
    dispatch_queue_t queue = dispatch_queue_create("com.example.queue.barrier", DISPATCH_QUEUE_CONCURRENT);

    dispatch_async(queue, ^{
        self.task1BarrierOn = YES;
        
        int randomNumber = arc4random_uniform(5) + 1;
        [NSThread sleepForTimeInterval:randomNumber];
        
        self.task1BarrierOn = NO;
    });

    dispatch_async(queue, ^{
        self.task2BarrierOn = YES;
        
        int randomNumber = arc4random_uniform(5) + 1;
        [NSThread sleepForTimeInterval:randomNumber];
        
        self.task2BarrierOn = NO;
    });

    // Barrier task
    dispatch_barrier_async(queue, ^{
       
        self.barrierTaskOn = YES;
        
       
        int randomNumber = arc4random_uniform(5) + 1;
        [NSThread sleepForTimeInterval:randomNumber];
        
        self.barrierTaskOn = NO;
    });

    // Following tasks will not execute until the barrier task is done
    dispatch_async(queue, ^{
        self.task3BarrierOn = YES;
        
        int randomNumber = arc4random_uniform(5) + 1;
        [NSThread sleepForTimeInterval:randomNumber];
        
        self.task3BarrierOn = NO;
    });
}

// TODO - demonstrateBarrierWithResource


// Create a concurrent queue
/*
 #import <Foundation/Foundation.h>

 @interface BarrierExample : NSObject
 @property (nonatomic, strong) NSMutableArray *sharedArray;
 @end

 @implementation BarrierExample

 - (instancetype)init {
     self = [super init];
     if (self) {
         _sharedArray = [NSMutableArray array];
     }
     return self;
 }

 - (void)addElements {
     for (NSInteger i = 1; i <= 5; i++) {
         [self.sharedArray addObject:@(i)];
         NSLog(@"Added %@", @(i));
         [NSThread sleepForTimeInterval:1]; // Simulate a time-consuming task
     }
 }

 - (void)readElements {
     for (NSNumber *element in self.sharedArray) {
         NSLog(@"Read %@", element);
     }
 }

 - (void)execute {
     dispatch_queue_t concurrentQueue = dispatch_queue_create("com.example.myConcurrentQueue", DISPATCH_QUEUE_CONCURRENT);
     
     // Add elements to the shared resource
     for (NSInteger i = 0; i < 3; i++) {
         dispatch_async(concurrentQueue, ^{
             [self addElements];
         });
     }
     
     // Barrier block to ensure the read occurs after all writes
     dispatch_async(concurrentQueue, ^{
         NSLog(@"Executing barrier. We will read the elements now.");
         [self readElements];
     });
     
    
 }

 @end

 int main(int argc, const char * argv[]) {
     @autoreleasepool {
         BarrierExample *example = [[BarrierExample alloc] init];
         [example execute];
     }
     return 0;
 }
 */
-(void)demonstrateQoS {
    // Not sure how to visualize QoS
    dispatch_queue_t customQueue = dispatch_queue_create("com.yourapp.customQueue", DISPATCH_QUEUE_CONCURRENT);
    
    dispatch_set_target_queue(customQueue, dispatch_get_global_queue(QOS_CLASS_USER_INITIATED, 0));
    
    
    dispatch_async(customQueue, ^{
       
        NSLog(@"Executing User Initiated Task");
    });
    
    dispatch_async(customQueue, ^{
        NSLog(@"Executing Another Task");
    });
    
   
    dispatch_barrier_async(customQueue, ^{
        NSLog(@"All tasks completed");
    });
    
}

-(void)demonstrateConcurrentWorkGroup {
   
    // Create a dispatch group
    dispatch_group_t group = dispatch_group_create();
    
    dispatch_block_t workItem1 = dispatch_block_create(0, ^{
        NSLog(@"This is a dispatch workItem1 running asynchronously.");
        self.workItem1Running = YES;

        int randomNumber = arc4random_uniform(5) + 1;
        [NSThread sleepForTimeInterval:randomNumber];

        self.workItem1Running = NO;
    });

    
    dispatch_block_t workItem2 = dispatch_block_create(0, ^{
        NSLog(@"This is a dispatch workItem2 running asynchronously.");
        self.workItem2Running = YES;

        int randomNumber = arc4random_uniform(5) + 1;
        [NSThread sleepForTimeInterval:randomNumber];

        self.workItem2Running = NO;
    });
    
    dispatch_block_t workItem3 = dispatch_block_create(0, ^{
        NSLog(@"This is a dispatch workItem3 running asynchronously.");
        self.workItem3Running = YES;

        int randomNumber = arc4random_uniform(5) + 1;
        [NSThread sleepForTimeInterval:randomNumber];

        self.workItem3Running = NO;
    });

   
    dispatch_group_enter(group);
    dispatch_group_async(group, dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        workItem1();
        dispatch_group_leave(group);
    });

    dispatch_group_enter(group);
    dispatch_group_async(group, dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        workItem2();
        dispatch_group_leave(group);
    });

    
    dispatch_group_enter(group);
    dispatch_group_async(group, dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        workItem3();
        dispatch_group_leave(group); // Leave the group after the first work item completes
    });
    
   
    dispatch_group_notify(group, dispatch_get_main_queue(), ^{
        self.workGroupComplete = YES;
    });
}

-(void)demonstrateSerialWorkGroup {
    [self resetItemObservers];
    NSLog(@"in demonstrateSerialWorkGroup");
    // Create a dispatch group
    dispatch_group_t group = dispatch_group_create();
    
    // Create a serial dispatch queue
    dispatch_queue_t mySerialQueue = dispatch_queue_create("com.exampleModel.serialQueue", DISPATCH_QUEUE_SERIAL);
    
    dispatch_block_t workItem1 = dispatch_block_create(0, ^{
        NSLog(@"This is a dispatch workItem1 running asynchronously.");
        self.workItem1SerialRunning = YES;

        // Simulate work with sleep
        int randomNumber = arc4random_uniform(5) + 1;
        [NSThread sleepForTimeInterval:randomNumber];

        self.workItem1SerialRunning = NO;
    });

    
    dispatch_block_t workItem2 = dispatch_block_create(0, ^{
        NSLog(@"This is a dispatch workItem2 running asynchronously.");
        self.workItem2SerialRunning = YES;

        // Simulate work with sleep
        int randomNumber = arc4random_uniform(5) + 1;
        [NSThread sleepForTimeInterval:randomNumber];

        self.workItem2SerialRunning = NO;
    });
    
    dispatch_block_t workItem3 = dispatch_block_create(0, ^{
        NSLog(@"This is a dispatch workItem3 running asynchronously.");
        self.workItem3SerialRunning = YES;

        // Simulate work with sleep
        int randomNumber = arc4random_uniform(5) + 1;
        [NSThread sleepForTimeInterval:randomNumber];

        self.workItem3SerialRunning = NO;
    });

   
    // Enter the group before executing the work items
    // Add the work item to a global queue
    // Enter the group before executing the work items
    dispatch_group_enter(group);
    dispatch_group_async(group, mySerialQueue, ^{
        workItem1();
        dispatch_group_leave(group); // Leave the group after the first work item completes
    });

    dispatch_group_enter(group);
    dispatch_group_async(group, mySerialQueue, ^{
        workItem2();
        dispatch_group_leave(group); // Leave the group after the second work item completes
    });
    
    dispatch_group_enter(group);
    dispatch_group_async(group, mySerialQueue, ^{
        workItem3();
        dispatch_group_leave(group); // Leave the group after the third work item completes
    });
    
    
    // Notify when all tasks are completed
    dispatch_group_notify(group, dispatch_get_main_queue(), ^{
        self.workGroupSerialComplete = YES;
    });
}
-(void)resetItemObservers {
    _workItem1SerialRunning = NO;
    _workItem2SerialRunning = NO;
    _workItem3SerialRunning = NO;
}
-(void)testFunc {
    // Create a dispatch group
    dispatch_group_t group = dispatch_group_create();

    // Create the first work item
    dispatch_block_t workItem1 = dispatch_block_create(0, ^{
        NSLog(@"This is dispatch workItem1 running asynchronously.");
        self.workItem1SerialRunning = YES;

        // Simulate work with sleep
        int randomNumber1 = arc4random_uniform(5) + 1;
        [NSThread sleepForTimeInterval:randomNumber1];

        self.workItem1SerialRunning = NO;
    });

    // Create the second work item
    dispatch_block_t workItem2 = dispatch_block_create(0, ^{
        NSLog(@"This is dispatch workItem2 running asynchronously.");
        self.workItem2SerialRunning = YES;

        // Simulate work with sleep
        int randomNumber2 = arc4random_uniform(5) + 1;
        [NSThread sleepForTimeInterval:randomNumber2];

        self.workItem2SerialRunning = NO;
    });

    // Enter the group before executing the work items
    dispatch_group_enter(group);
    dispatch_group_async(group, dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), workItem1);

    dispatch_group_enter(group);
    dispatch_group_async(group, dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), workItem2);

    // Optionally, notify when the group finishes
    dispatch_group_notify(group, dispatch_get_main_queue(), ^{
        NSLog(@"Both work items have completed.");
    });
}

@end
