### Vulkan On Metal

VulkanOnMetal aims to make the Vulkan API available to platforms where only a
Metal driver is available, such as macOS.

**This project is currently a work in progress and as such, some or most things
may not work at all.**

#### Building

VulkanOnMetal uses the CMake build system and requires a shadowed build root.

`mkdir VulkanOnMetal-build`<br/>
`cd VulkanOnMetal-build`<br/>
`cmake -G Xcode ../VulkanOnMetal`

This will generate a .xcodeproj project you can then open with Xcode.
