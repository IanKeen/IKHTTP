//
//  IKHTTPDefaultResponseHandler.h
//  HitchPlanet
//
//  Created by Ian Keen on 9/07/2015.
//  Copyright (c) 2015 HitchPlanet. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "IKHTTPResponseHandler.h"

@interface IKHTTPDefaultResponseHandler : NSObject <IKHTTPResponseHandler>
@property (readonly) IKEvent *didSucceed; /* NSURLRequest, NSHTTPURLResponse, NSDictionary */
@property (readonly) IKEvent *didFail; /* NSURLRequest, NSHTTPURLResponse, NSDictionary, NSError */
@end
