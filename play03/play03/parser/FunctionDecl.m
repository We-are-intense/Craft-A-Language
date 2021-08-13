//
//  FunctionDecl.m
//  play01
//
//  Created by xiaerfei on 2021/8/9.
//

#import "FunctionDecl.h"
#import "FunctionBody.h"
@interface FunctionDecl ()

@property (nonatomic, strong, readwrite) FunctionBody *body;
@property (nonatomic, copy, readwrite) NSString *name;

@end

@implementation FunctionDecl

- (instancetype)initWithName:(NSString *)name body:(FunctionBody *)body {
    self = [super init];
    if (self) {
        _name = [name copy];
        _body = body;
    }
    return self;
}

- (void)dump:(NSString *)prefix {
    NSLog(@"%@FunctionDecl%@",prefix, self.name);
    [self.body dump:[NSString stringWithFormat:@"%@\t", prefix]];
}

@end
