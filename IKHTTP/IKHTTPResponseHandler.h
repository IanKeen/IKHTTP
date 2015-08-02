//
//  IKHTTPResponseHandler
//
//  Created by Ian Keen on 5/06/2015.
//  Copyright (c) 2015 IanKeen. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <IKResults/Result.h>
#import <IKEvents/IKEvent.h>

@protocol IKHTTPResponseHandler <NSObject>
-(Result *)handleResponse:(NSURLRequest *)request response:(NSHTTPURLResponse *)response data:(NSDictionary *)data error:(NSError *)error;
@property (readonly) IKEvent *didSucceed; /* NSURLRequest, NSHTTPURLResponse, NSDictionary */
@property (readonly) IKEvent *didFail; /* NSURLRequest, NSHTTPURLResponse, NSDictionary, NSError */
@end
