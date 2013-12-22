//
//  Weapon.h
//  BreakThrough!
//
//  Created by Ki Hyun Won on 11/11/13.
//
//

#import <Foundation/Foundation.h>

@protocol Weapon <NSObject>
+(id) createWeapon;
-(id) initWithWeaponImage;
-(void) hitAction;
@end
