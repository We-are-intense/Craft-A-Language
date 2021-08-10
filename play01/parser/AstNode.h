//
//  AstNode.h
//  play01
//
//  Created by xiaerfei on 2021/8/9.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN
/**
 * 基类
 */
@interface AstNode : NSObject
// 打印对象信息，prefix是前面填充的字符串，通常用于缩进显示
- (void)dump:(NSString *)prefix;

@end

NS_ASSUME_NONNULL_END
