//
//  Fist.h
//  BreakThrough!
//
//  Created by Ki Hyun Won on 11/18/13.
//
//

#import "CCSprite.h"
#import "Weapon.h"

@interface Fist : CCSprite<Weapon>
@property float hitpoints;
@property BOOL steel;
+(id) createWeapon;
-(id) initWithWeaponImage;
-(void) hitAction;
@end