//
//  Gate.h
//  BreakThrough!
//
//  Created by Ki Hyun Won on 11/11/13.
//
//

#import <Foundation/Foundation.h>

@protocol Gate <NSObject>
+(id) createGate;
-(id) initWithGateImage;
-(void) takeDamage : (float) damage;
@end
