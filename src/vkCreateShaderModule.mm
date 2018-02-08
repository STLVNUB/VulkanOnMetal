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

#include "_vulkan.h"
#include "spirv_cross/spirv_msl.hpp"

using namespace spv;
using namespace spirv_cross;

VKAPI_ATTR VkResult VKAPI_CALL vkCreateShaderModule(
    VkDevice                        device,
    const VkShaderModuleCreateInfo* pCreateInfo,
    const VkAllocationCallbacks*    pAllocator,
    VkShaderModule*                 pShaderModule)
{
    VkShaderModule shaderModule = nullptr;
    if (pAllocator)
    {
        shaderModule = static_cast<VkShaderModule>(pAllocator->pfnAllocation(nullptr, sizeof(VkShaderModule_T), 8, VK_SYSTEM_ALLOCATION_SCOPE_DEVICE));
    }
    else
    {
        shaderModule = new VkShaderModule_T();
    }

    bool isSpirv = false;
    if (pCreateInfo->codeSize >= 2)
    {
        switch (pCreateInfo->pCode[1])
        {
        case 0x10000:
        case 0x10100:
        case 0x10200:
            isSpirv = true;
            break;
        default:
            break;
        }
    }

    if (isSpirv)
    {
        CompilerMSL compiler(pCreateInfo->pCode, pCreateInfo->codeSize);

        auto options = compiler.get_options();

        options.set_msl_version(2);

        auto shaderSource = compiler.compile();

        auto nsShaderSource = [NSString stringWithCString:shaderSource.c_str() encoding:[NSString defaultCStringEncoding]];

        NSError* error;
        shaderModule->library = [device->physicalDevice->device newLibraryWithSource:nsShaderSource options:nil error:&error];
    }
    else
    {
        NSError* error;
        shaderModule->library = [device->physicalDevice->device newLibraryWithData:(dispatch_data_t)pCreateInfo->pCode error:&error];
    }

    *pShaderModule = shaderModule;

    return VK_SUCCESS;
}
