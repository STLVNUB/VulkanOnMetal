// Copyright 2017-2018 Chabloom LC
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//   http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.

#import "GameViewController.h"
#import <QuartzCore/CAMetalLayer.h>
#import "cube.h"

@implementation GameView

- (BOOL)wantsUpdateLayer
{
    return TRUE;
}

- (CALayer *)makeBackingLayer
{
    CALayer *layer = [CAMetalLayer layer];
    CGSize viewScale = [self convertSizeToBacking:CGSizeMake(1.0, 1.0)];
    layer.contentsScale = MIN(viewScale.width, viewScale.height);
    return layer;
}

@end

@implementation GameViewController
{
    CVDisplayLinkRef displayLink;
    
    struct demo demo;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.view.wantsLayer = TRUE;
    
    demo_main(&demo, self.view);
    
    CVDisplayLinkCreateWithActiveCGDisplays(&displayLink);
    CVDisplayLinkSetOutputCallback(displayLink, displayLinkCallback, &demo);
    CVDisplayLinkStart(displayLink);
}

static CVReturn displayLinkCallback(CVDisplayLinkRef displayLink,
                                    const CVTimeStamp* inNow,
                                    const CVTimeStamp* inOutputTime,
                                    CVOptionFlags flagsIn,
                                    CVOptionFlags *flagsOut,
                                    void *displayLinkContext)
{
    demo_update_and_draw(displayLinkContext);
    
    return kCVReturnSuccess;
}

- (void)dealloc {
    demo_cleanup(&demo);
    
    [super dealloc];
}

@end
