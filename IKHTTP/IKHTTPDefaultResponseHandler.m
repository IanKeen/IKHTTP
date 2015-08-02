//
//  IKHTTPDefaultResponseHandler.m
//  HitchPlanet
//
//  Created by Ian Keen on 9/07/2015.
//  Copyright (c) 2015 HitchPlanet. All rights reserved.
//

#import "IKHTTPDefaultResponseHandler.h"
#import <IKCore/NSError+Init.h>

@interface IKHTTPDefaultResponseHandler ()
@end

@implementation IKHTTPDefaultResponseHandler
#pragma mark - Lifecycle
-(instancetype)init {
    if (!(self = [super init])) { return nil; }
    _didSucceed = [IKEvent new];
    _didFail = [IKEvent new];
    return self;
}
#pragma mark - Default Handling Behaviour
-(Result *)handleResponse:(NSURLRequest *)request response:(NSHTTPURLResponse *)response data:(NSDictionary *)data error:(NSError *)err {
    NSError *error = nil;
    
    if (err) {
        NSString *message = NSLocalizedString(@"Server returned error", nil);
        error = [NSError errorWithDomain:NSStringFromClass([self class]) description:message underlyingError:err data:data];
    }
    
    if (response == nil) {
        NSString *message = NSLocalizedString(@"No response from server", nil);
        error = [NSError errorWithDomain:NSStringFromClass([self class]) description:message underlyingError:err];
    }
    
    if ([self isFailureCode:response.statusCode]) {
        NSString *message = [NSString stringWithFormat:NSLocalizedString(@"Server returned error code %i", nil), response.statusCode];
        error = [NSError errorWithDomain:NSStringFromClass([self class]) description:message data:data];
    }
    
    if (error) {
        notify(self.didFail, request, response, data, error);
        return [Result failure:error];

    } else {
        NSDictionary *resultData = (data ?: @{@"success": @(YES)});
        notify(self.didSucceed, request, response, resultData);
        return [Result success:resultData];
    }
}

#pragma mark - Private - Helpers
-(BOOL)isSuccessCode:(NSInteger)code {
    return (code >= 200 && code <= 299);
}
-(BOOL)isFailureCode:(NSInteger)code {
    return (code >= 400 && code <= 599);
}
@end
