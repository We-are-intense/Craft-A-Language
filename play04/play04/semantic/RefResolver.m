//
//  RefResolver.m
//  play01
//
//  Created by 夏二飞 on 2021/8/10.
//

#import "RefResolver.h"

@interface RefResolver ()

@property (nonatomic, strong, readwrite) SymTable *symTable;

@end

@implementation RefResolver
- (instancetype)initWithSymTable:(SymTable *)symTable {
    self = [super init];
    if (self) {
        _symTable = symTable;
    }
    return self;
}

- (id)visitFunctionCall:(FunctionCall *)functionCall {
    Symbol *symbol = [self.symTable getSymbolWithName:functionCall.name];
    if (symbol && symbol.kind == SymKindFunction) {
        functionCall.decl = (FunctionDecl *)symbol.decl;
    } else if (symbol) {
        if (![functionCall.name isEqualToString:@"println"]) {
            NSLog(@"Error: cannot find declaration of function %@", functionCall.name);
        }
    }
    
    return nil;
}

- (id)visitVariable:(Variable *)exp {
    Symbol *symbol = [self.symTable getSymbolWithName:exp.name];
    if (symbol && symbol.kind == SymKindFunction) {
        exp.decl = (VariableDecl *)exp.decl;
    } else {
        NSLog(@"Error: cannot find declaration of variable %@", exp.name);
    }
    
    return nil;
}


@end
