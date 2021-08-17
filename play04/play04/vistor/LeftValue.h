//
//  LeftValue.h
//  play03
//
//  Created by 夏二飞 on 2021/8/13.
//

#import <Foundation/Foundation.h>
#import "Variable.h"

NS_ASSUME_NONNULL_BEGIN

@interface LeftValue : NSObject

@property (nonatomic, strong, readonly) Variable *variable;

- (instancetype)initWithVariable:(Variable *)variable;

@end

NS_ASSUME_NONNULL_END
