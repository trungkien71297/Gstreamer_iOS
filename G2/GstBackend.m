//
//  GstBackend.m
//  G2
//
//  Created by MAC013 on 4/28/22.
//

#import "GstBackend.h"
#include <gst/video/video.h>

GST_DEBUG_CATEGORY_STATIC (debug_category);
#define GST_CAT_DEFAULT debug_category

@implementation GstBackend {
    GstElement *pipeline;
    GMainContext *context;
    GstElement *video_sink;
    GMainLoop *loop;
    UIView *previewView;
}
- (void) app_function {
    GError *error = NULL;
    context = g_main_context_new();
    g_main_context_push_thread_default(context);
    pipeline = gst_parse_launch("videotestsrc ! video/x-raw,width=1920,height=1080 ! autovideosink", &error);
    if (error) {
            gchar *message = g_strdup_printf("Unable to build pipeline: %s", error->message);
        GST_DEBUG("%s", message);
            return;
    }
    gst_element_set_state(pipeline, GST_STATE_READY);
    video_sink = gst_bin_get_by_interface(GST_BIN((pipeline)), GST_TYPE_VIDEO_OVERLAY);
    if (!video_sink) {
        GST_ERROR ("Could not retrieve video sink");
        return;
    }
    gst_video_overlay_set_window_handle(GST_VIDEO_OVERLAY(video_sink), (guintptr) (id) previewView);
    GST_DEBUG ("Entering main loop...");
    loop = g_main_loop_new(context, FALSE);
    g_main_loop_run(loop);
    GST_DEBUG ("Exited main loop");
    g_main_loop_unref(loop);
    loop = NULL;
    g_main_context_pop_thread_default(context);
    g_main_context_unref(context);
    gst_element_set_state(pipeline, GST_STATE_NULL);
    gst_object_unref(pipeline);
    return;
}
- (id) initWithPreview: (UIView *)preview {
    GST_DEBUG("INIT");
    gst_ios_init();
    if(self = [super init]) {
    GST_DEBUG_CATEGORY_INIT (debug_category, "G-2", 0, "iOS G-2");
    gst_debug_set_threshold_for_name("G-2", GST_LEVEL_DEBUG);
    self->previewView = preview;
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [self app_function];
    });
        GST_DEBUG("DONE INIT");
    }
    return self;
}

- (void) play {
    GST_DEBUG("PLAY GAME");
    gst_element_set_state(self->pipeline, GST_STATE_PLAYING);
}
@end
