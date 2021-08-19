//
//  Scope.m
//  play04
//
//  Created by 夏二飞 on 2021/8/19.
//

#import "Scope.h"

@implementation Scope

- (instancetype)initWithEnclosingScope:(Scope *)enclosingScope {
    self = [super init];
    if (self) {
        self.enclosingScope = enclosingScope;
        self.name2sym = [NSMutableDictionary dictionary];
    }
    return self;
}

- (void)enterWithName:(NSString *)name sym:(Symbol *)sym {
    self.name2sym[name] = sym;
}

- (BOOL)hasSymbolWithName:(NSString *)name {
    return self.name2sym[name] != nil;
}

- (Symbol *)getSymbolWithName:(NSString *)name {
    return self.name2sym[name];
}

- (Symbol *)getSymbolCascade:(NSString *)name {
    Symbol *sym = self.name2sym[name];
    if (sym) {
        return sym;
    } else if (self.enclosingScope) {
        return [self.enclosingScope getSymbolCascade:name];
    } else {
        return nil;
    }
}
@end
