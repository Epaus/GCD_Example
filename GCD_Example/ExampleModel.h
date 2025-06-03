//
//  ExampleModel.h
//  GCD_Example
//
//  Created by Estelle Paus on 5/29/25.
//

#ifndef ExampleModel_h
#define ExampleModel_h
#import <Foundation/Foundation.h>

@interface ExampleModel : NSObject
@property (assign, nonatomic) Boolean task1SerialOn;
@property (assign, nonatomic) Boolean task2SerialOn;

@property (assign, nonatomic) Boolean task1ConcurrentOn;
@property (assign, nonatomic) Boolean task2ConcurrentOn;
@property (assign, nonatomic) Boolean task3ConcurrentOn;

@property (assign, nonatomic) Boolean task1BarrierOn;
@property (assign, nonatomic) Boolean task2BarrierOn;
@property (assign, nonatomic) Boolean barrierTaskOn;
@property (assign, nonatomic) Boolean task3BarrierOn;

@property (assign, nonatomic) Boolean workItem1Running;
@property (assign, nonatomic) Boolean workItem2Running;
@property (assign, nonatomic) Boolean workItem3Running;
@property (assign, nonatomic) Boolean workGroupComplete;

@property (assign, nonatomic) Boolean workItem1SerialRunning;
@property (assign, nonatomic) Boolean workItem2SerialRunning;
@property (assign, nonatomic) Boolean workItem3SerialRunning;
@property (assign, nonatomic) Boolean workGroupSerialComplete;

-(void)demonstrateSerialQueue;
-(void)demonstrateConcurrentQueue;
-(void)demonstrateBarrier;
-(void)demonstrateQoS;
-(void)demonstrateSerialWorkGroup;
-(void)demonstrateConcurrentWorkGroup;

@end

#endif /* ExampleModel_h */
