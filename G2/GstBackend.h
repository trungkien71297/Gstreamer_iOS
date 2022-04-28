//
//  GstBackend.h
//  G2
//
//  Created by MAC013 on 4/28/22.
//

#import <Foundation/Foundation.h>
#include <gst/gst.h>
#include "gst_ios_init.h"
#import <UIKit/UIkit.h>
NS_ASSUME_NONNULL_BEGIN

@interface GstBackend : NSObject
- (void) app_function;
- (void) play;
- (id) initWithPreview: (UIView *) preview;
@end

NS_ASSUME_NONNULL_END
