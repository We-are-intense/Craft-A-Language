//
//  VariableStatement.h
//  play04
//
//  Created by xiaerfei on 2021/8/22.
//

#import "Statement.h"
#import "VariableDecl.h"


NS_ASSUME_NONNULL_BEGIN

@interface VariableStatement : Statement

@property (nonatomic, strong) VariableDecl *variableDecl;

- (instancetype)initWithBeginPos:(Position *)beginPos
                          endPos:(Position *)endPos
                     isErrorNode:(BOOL)isErrorNode
                    variableDecl:(VariableDecl *)variableDecl;
    

@end

NS_ASSUME_NONNULL_END
