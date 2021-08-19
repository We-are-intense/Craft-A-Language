//
//  ParameterList.h
//  play04
//
//  Created by 夏二飞 on 2021/8/19.
//

#import "AstNode.h"
#import "VariableDecl.h"

NS_ASSUME_NONNULL_BEGIN

@interface ParameterList : AstNode

@property (nonatomic, copy) NSArray <VariableDecl *> *params;

- (instancetype)initWithBeginPos:(Position *)beginPos
                          endPos:(Position *)endPos
                     isErrorNode:(BOOL)isErrorNode
                          params:(NSArray <VariableDecl *> *)params;

@end

NS_ASSUME_NONNULL_END
