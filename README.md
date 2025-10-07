# Vulkan-AMD-developed-RadeonRays  
**Developed by Dr. Chamyoung**

## Overview  
**Vulkan-AMD-developed-RadeonRays** is a high-performance rendering and computation framework built upon AMD’s RadeonRays technology.  
It leverages Vulkan APIs for GPU acceleration and supports advanced rendering pipelines, ray tracing, and Radeon Machine Learning (RML) integration.

This repository documents the essential data types, pointer structures, parameters, and backend support used in RadeonRays, Radeon Machine Learning (RML), and HIP RT SDK.

---

## Basic Data Types  

| **RPR Type** | **C Type** |
|---------------|-------------|
| rpr_char | Char |
| rpr_uchar | Unsigned char |
| rpr_int | Int |
| rpr_uint | Unsigned int |
| rpr_long | Long int |
| rpr_ulong | Unsigned long int |
| rpr_short | Short int |
| rpr_ushort | Unsigned short int |
| rpr_float | Float |
| rpr_double | Double |
| rpr_longlong | Long long int |
| rpr_bool | Int |
| rpr_bitfield | Unsigned int |
| rpr_status | Int |

---

## Pointer Data Types  

All pointer data types are of the C type `void *`.  
They reference Radeon ProRender (RPR) data classes and are fundamental for managing scene, geometry, and rendering objects.

| **Pointer Data Type** | **Description** |
|------------------------|-----------------|
| rpr_buffer | Buffer (float list) for procedural texture nodes. |
| rpr_camera | Camera object controlling field of view and camera settings. |
| rpr_composite | Arithmetic operation node for transforming frame buffers. |
| rpr_context | Context for rendering setup, device configuration, and object creation. |
| rpr_context_properties | Struct of properties set on an rpr_context. |
| rpr_curve | Curve type for rendering hair, fur, grass, or strand-like geometry. |
| rpr_framebuffer | Holds rendering results for display, saving, or post-processing. |
| rpr_grid | Layout of voxels referencing lookup arrays. |
| rpr_hetero_volume | Used for rendering clouds or variable-density volumes. |
| rpr_image | Texture image object. |
| rpr_light | Light object (spot, directional, area via emissive shaders). |
| rpr_lut | LUT object for applying color transforms in composites. |
| rpr_material_node | Node for materials, used to build complex BRDF graphs. |
| rpr_material_system | System for creating and attaching materials to objects. |
| rpr_post_effect | Post-processing operation applied on framebuffers. |
| rpr_scene | Scene object holding all geometry, lights, and materials. |
| rpr_shape | Shape or mesh instance used in a scene. |

---

## Shader Parameters  

These parameters define shader inputs and behaviors within the Radeon ProRender (RPR) material system.

### General Shader Inputs  

| **Name** | **Type** | **Explanation** |
|-----------|-----------|----------------|
| RPR_MATERIAL_INPUT_COLOR0 | Shader | Primary shader input (Shader 1). |
| RPR_MATERIAL_INPUT_COLOR1 | Shader | Secondary shader input (Shader 2). |

### Volume Shader Parameters  

Volume shaders handle light scattering and absorption within a medium such as fog, clouds, or translucent materials.

| **Name** | **Type / Range** | **Explanation** |
|-----------|------------------|----------------|
| RPR_MATERIAL_INPUT_SCATTERING | Color | Scattering color. |
| RPR_MATERIAL_INPUT_ABSORBTION | Color | Absorption color. |
| RPR_MATERIAL_INPUT_EMISSION | Color | Emissive color. |
| RPR_MATERIAL_INPUT_G | Float (-1 to 1) | Forward or back scattering factor. |
| RPR_MATERIAL_INPUT_MULTISCATTER | 0 or 1 | Enable/disable multiple scattering. |

**Usage:**  
Volume shaders simulate light transport through a participating medium. They are essential for realistic rendering of fog, smoke, skin subsurface scattering, and clouds.

---

## Radeon Machine Learning (RML)

**Radeon Machine Learning (RML)** is AMD’s SDK for high-performance deep learning inference on GPUs.  
It supports **cross-platform** GPU acceleration with a unified API for **DirectML**, **MIOpen**, and **Metal Performance Shaders (MPS)** backends.

RML achieves optimal performance using native low-level APIs and offers seamless interoperability with **DirectX**, **OpenCL**, and **Metal**.

---

## Backends  

| **Backend** | **Windows** | **Linux** | **macOS** |
|--------------|-------------|------------|------------|
| Microsoft DirectML | Supported | Not supported | Not supported |
| AMD MIOpen | Supported | Supported | Not supported |
| Apple MPS | Not supported | Not supported | Supported |

---

## System Requirements  

| **Backend** | **Requirements** |
|--------------|------------------|
| DirectML | Windows 10 SDK version 1903 or later |
| MIOpen | Pre-built MIOpen libraries/binaries |
| Apple MPS | macOS 10.13.4 or later |

---

## HIP RT SDK  

**HIP RT** is a ray tracing library in HIP. The APIs are designed to be minimal and low-level, making it easy to integrate ray tracing into any HIP application.  
It is lightweight, modular, and compatible with AMD and NVIDIA GPUs.

### Features  

- Ray-triangle intersection  
- Ray-custom primitive intersection  
- Ray masks for geometry filtering  
- Multiple BVH (Bounding Volume Hierarchy) options  
- Offline BVH load and store  
- BVH import support  
- Motion blur rendering  

### Requirements  

HIP RT runs on both AMD and NVIDIA GPUs.  
HIP and CUDA APIs are dynamically loaded, so full SDKs are not required as long as DLLs are available from the driver package.  
Hardware-accelerated ray tracing is supported only on AMD **RDNA2-based GPUs**.

**Supported AMD GPU Architectures:**

- Navi2x (Radeon RX 6000 series)  
- Navi1x (Radeon RX 5000 series)  
- Vega2x  
- Vega1x  

**Driver Requirements:**  
- Minimum: AMDGPU 21.40  
- Recommended: AMDGPU 21.50 or newer  

### Directories  

| **Directory** | **Description** |
|----------------|-----------------|
| hiprt | Core header and library (downloadable from HIP RT product page). |
| tutorials | Source code tutorials demonstrating HIP RT usage. |
| contrib | External dependencies required by HIP RT. |

### Building the Tutorial  

Clone the repository and initialize submodules (if not cloned recursively):

```bash
git submodule init
git submodule update
```

Download the HIP RT SDK from the product page, then copy the hiprt directory into your project.
Run Premake on Windows to generate Visual Studio 2019 project files:

cd tutorials
../tools/premake5/win/premake5.exe vs2019


Open the generated solution in Visual Studio, build, and run.
The tutorials support both AMD and NVIDIA devices through selectable device indices.

Introduction to HIP RT APIs

# A minimal example can be found in:

tutorials/00_context_creation/main.cpp


# Initialization Example:

- Create a HIP context and device using hiprtCreateContext()

- Provide hiprtContextCreationInput with native API context, device, and type (HIP or CUDA)

- Use hiprtCreateGeometry() and hiprtBuildGeometry() to create and build geometries

- Pass the context object to your kernel for GPU execution

## Intersection Example:

A minimal kernel demonstrates geometry traversal using:

- hiprtRay

- hiprtGeomTraversalClosest

- getNextHit() for performing ray intersections

### Reference:
Introducing HIP RT – a Ray Tracing Library in HIP (GPUOpen Blog)

-- USD / Hydra / Houdini Plugin

### This plugin enables fast GPU or CPU accelerated viewport rendering on all OpenCL 1.2-capable hardware within the USD (Universal Scene Description) and Hydra systems.

### You can build this plugin as either:

- A USDView plugin

- A Houdini plugin

- Supported Platforms
- Platform	Status
- Windows	Supported
- Linux	Experimental
- macOS	Experimental
- Requirements and Resources

## Users should be familiar with Solaris/USD and Houdini fundamentals.
To learn more, refer to:

USD: http://openusd.org

https://graphics.pixar.com/usd/docs/

Houdini: https://www.sidefx.com/docs/

https://www.cgcircuit.com/tutorial/houdini-for-the-new-artist
