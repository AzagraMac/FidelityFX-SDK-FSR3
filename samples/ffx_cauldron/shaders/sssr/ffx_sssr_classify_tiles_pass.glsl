// This file is part of the FidelityFX SDK.
//
// Copyright © 2023 Advanced Micro Devices, Inc.
// 
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files(the “Software”), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and /or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions :
// 
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
// 
// THE SOFTWARE IS PROVIDED “AS IS”, WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.

#version 450

#extension GL_GOOGLE_include_directive : require
#extension GL_EXT_samplerless_texture_functions : require

#define FFX_WAVE 1
#extension GL_KHR_shader_subgroup_basic : require

#define SSSR_BIND_SRV_INPUT_NORMAL                  0
#define SSSR_BIND_SRV_INPUT_MATERIAL_PARAMETERS     1
#define SSSR_BIND_SRV_INPUT_ENVIRONMENT_MAP         2
#define SSSR_BIND_SRV_DEPTH_HIERARCHY               3
#define SSSR_BIND_SRV_VARIANCE                      4

#define SSSR_BIND_UAV_RADIANCE                        2000
#define SSSR_BIND_UAV_RAY_LIST                        2001
#define SSSR_BIND_UAV_DENOISER_TILE_LIST              2002
#define SSSR_BIND_UAV_RAY_COUNTER                     2003
#define SSSR_BIND_UAV_EXTRACTED_ROUGHNESS             2004

#define SSSR_BIND_CB_SSSR   3000

#include "sssr/ffx_sssr_callbacks_glsl.h"
#include "sssr/ffx_sssr_classify_tiles.h"

#ifndef FFX_SSSR_THREAD_GROUP_WIDTH
#define FFX_SSSR_THREAD_GROUP_WIDTH 64
#endif // #ifndef FFX_SSSR_THREAD_GROUP_WIDTH
#ifndef FFX_SSSR_THREAD_GROUP_HEIGHT
#define FFX_SSSR_THREAD_GROUP_HEIGHT 1
#endif // FFX_SSSR_THREAD_GROUP_HEIGHT
#ifndef FFX_SSSR_THREAD_GROUP_DEPTH
#define FFX_SSSR_THREAD_GROUP_DEPTH 1
#endif // #ifndef FFX_SSSR_THREAD_GROUP_DEPTH
#ifndef FFX_SSSR_NUM_THREADS
#define FFX_SSSR_NUM_THREADS layout (local_size_x = FFX_SSSR_THREAD_GROUP_WIDTH, local_size_y = FFX_SSSR_THREAD_GROUP_HEIGHT, local_size_z = FFX_SSSR_THREAD_GROUP_DEPTH) in;
#endif // #ifndef FFX_SSSR_NUM_THREADS

FFX_SSSR_NUM_THREADS
void main()
{
    FfxUInt32x2 group_thread_id = FFX_DNSR_Reflections_RemapLane8x8(gl_LocalInvocationIndex);
    FfxUInt32x2 dispatch_thread_id = gl_WorkGroupID.xy * 8 + group_thread_id;
    FfxFloat32 roughness = LoadRoughnessFromMaterialParametersInput(FfxInt32x3(dispatch_thread_id, 0));

    ClassifyTiles(dispatch_thread_id, group_thread_id, roughness);

    // Extract only the channel containing the roughness to avoid loading all 4 channels in the follow up passes.
    StoreExtractedRoughness(dispatch_thread_id, roughness);
}
