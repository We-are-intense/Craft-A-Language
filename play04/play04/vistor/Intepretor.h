//
//  Intepretor.h
//  play01
//
//  Created by 夏二飞 on 2021/8/10.
//

#import "AstVisitor.h"

NS_ASSUME_NONNULL_BEGIN

@interface Intepretor : AstVisitor

@property (nonatomic, strong, readonly) NSMutableDictionary <NSString *, id> *values; ///< 存储变量值的区域

@end

NS_ASSUME_NONNULL_END
