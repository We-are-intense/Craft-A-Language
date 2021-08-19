//
//  AstNode.h
//  play01
//
//  Created by xiaerfei on 2021/8/9.
//

#import <Foundation/Foundation.h>
#import "Position.h"

NS_ASSUME_NONNULL_BEGIN

@class AstVisitor;
/**
 * 基类
 */
@interface AstNode : NSObject

@property (nonatomic, strong) Position *beginPos; ///< 在源代码中的第一个Token的位置
@property (nonatomic, strong) Position *endPos; ///< 在源代码中的最后一个Token的位置
@property (nonatomic, assign) BOOL isErrorNode; ///< default is false

- (instancetype)initWithBeginPos:(Position *)beginPos
                          endPos:(Position *)endPos
                     isErrorNode:(BOOL)isErrorNode;

// 打印对象信息，prefix是前面填充的字符串，通常用于缩进显示
- (void)dump:(NSString *)prefix;
- (id)accept:(AstVisitor *)visitor;

- (id)accept:(AstVisitor *)visitor additional:(id)additional;

@end

NS_ASSUME_NONNULL_END
