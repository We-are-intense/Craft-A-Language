//
//  Decl.h
//  play03
//
//  Created by 夏二飞 on 2021/8/13.
//

#import "AstNode.h"

NS_ASSUME_NONNULL_BEGIN
/**
 * 声明
 * 所有声明都会对应一个符号。
 */
@interface Decl : AstNode

@property (nonatomic, copy, readonly) NSString *name;

- (instancetype)initWithBeginPos:(Position *)beginPos
                          endPos:(Position *)endPos
                     isErrorNode:(BOOL)isErrorNode
                            name:(NSString *)name;

- (instancetype)initWithName:(NSString *)name;

@end

NS_ASSUME_NONNULL_END
