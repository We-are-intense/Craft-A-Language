//
//  SymTable.m
//  play03
//
//  Created by 夏二飞 on 2021/8/13.
//

#import "SymTable.h"

@interface SymTable ()
@property (nonatomic, strong, readwrite) NSMutableDictionary <NSString *, Symbol *> *table;

@end

@implementation SymTable
- (instancetype)init
{
    self = [super init];
    if (self) {
        _table = [NSMutableDictionary dictionary];
    }
    return self;
}


- (void)enterWithName:(NSString *)name
                 decl:(Decl *)decl
              symType:(SymKind)symType {
    self.table[name] = [[Symbol alloc] initWithName:name decl:decl kind:symType];
}

- (BOOL)hasSymbolWithName:(NSString *)name {
    return self.table[name] != nil;
}
- (Symbol *)getSymbolWithName:(NSString *)name {
    return self.table[name];
}

@end
