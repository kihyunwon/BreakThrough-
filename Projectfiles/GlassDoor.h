//
//  PoliceEntrance.h
//  BreakThrough!
//
//  Created by Ki Hyun Won on 11/11/13.
//
//

#import "CCSprite.h"
#import "Gate.h"

@interface GlassDoor : CCSprite <Gate>
@property float health;
@property BOOL reborn;
@property BOOL deadOnce;
+(id) createGate;
-(id) initWithGateImage;
-(void) takeDamage : (float) damage;
@end
