//
//  Enter.h
//  play03
//
//  Created by xiaerfei on 2021/8/13.
//

#import "AstVisitor.h"
#import "SymTable.h"

NS_ASSUME_NONNULL_BEGIN

@interface Enter : AstVisitor

@property (nonatomic, strong, readonly) SymTable *symTable;

- (instancetype)initWithSymTable:(SymTable *)symTable;

@end

NS_ASSUME_NONNULL_END
