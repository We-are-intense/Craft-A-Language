//
//  NullLiteral.h
//  play03
//
//  Created by 夏二飞 on 2021/8/13.
//

#import "Expression.h"
#import "SysTypes.h"
NS_ASSUME_NONNULL_BEGIN

@interface NullLiteral : Expression
@property (nonatomic, strong, readonly) NSString *value;
@property (nonatomic, strong, readonly) SimpleType *theType;
@end

NS_ASSUME_NONNULL_END
