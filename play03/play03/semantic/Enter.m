//
//  Enter.m
//  play03
//
//  Created by xiaerfei on 2021/8/13.
//

#import "Enter.h"

@interface Enter ()

@property (nonatomic, strong, readwrite) SymTable *symTable;

@end

@implementation Enter

- (instancetype)initWithSymTable:(SymTable *)symTable {
    self = [super init];
    if (self) {
        _symTable = symTable;
    }
    return self;
}

- (id)visitFunctionDecl:(FunctionDecl *)functionDecl {
    if ([self.symTable hasSymbolWithName:functionDecl.name]) {
        NSLog(@"Dumplicate symbol: %@", functionDecl.name);
    }
    
    [self.symTable enterWithName:functionDecl.name decl:functionDecl symType:SymKindFunction];
    
    return nil;
}

- (id)visitVariableDecl:(VariableDecl *)variableDecl {
    if ([self.symTable hasSymbolWithName:variableDecl.name]) {
        NSLog(@"Dumplicate symbol: %@", variableDecl.name);
    }
    
    [self.symTable enterWithName:variableDecl.name decl:variableDecl symType:SymKindVariable];

    return nil;
}


@end
