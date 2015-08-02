//
//  IKHTTPSession
//
//  Created by Ian Keen on 5/06/2015.
//  Copyright (c) 2015 IanKeen. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "IKHTTP.h"
#import "IKHTTPResponseHandler.h"

typedef NSDictionary *(^httpCommonHeaders)(void);
typedef NSDictionary *(^httpCommonParameters)(void);

@interface IKHTTPSession : NSObject <IKHTTP>
-(instancetype)initWithResponseHandler:(id<IKHTTPResponseHandler>)responseHandler
                         commonHeaders:(httpCommonHeaders)commonHeaders
                      commonParameters:(httpCommonParameters)commonParameters;
@end
