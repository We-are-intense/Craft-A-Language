//
//  RefResolver.h
//  play01
//
//  Created by 夏二飞 on 2021/8/10.
//

#import "AstVisitor.h"

NS_ASSUME_NONNULL_BEGIN

@interface RefResolver : AstVisitor

@property (nonatomic, strong, readonly) Prog *prog;

@end

NS_ASSUME_NONNULL_END
