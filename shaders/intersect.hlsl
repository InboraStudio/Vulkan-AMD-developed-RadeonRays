//*********************************************************
// Optimized DXR Shader
//*********************************************************

#define INVALID_ID 0xFFFFFFFFu

struct Ray
{
    float3 origin;
    float  min_t;
    float3 direction;
    float  max_t;
};

typedef BuiltInTriangleIntersectionAttributes MyAttributes;

struct HitData
{
    uint inst_id;

#ifdef ASM_QUERY_OUTPUT_FULL_HIT
    float2 uv;
    uint   prim_id;
#endif
};

// Resources
RaytracingAccelerationStructure g_scene : register(t0, space0);
RWStructuredBuffer<Ray>         g_rays  : register(u0);
RWStructuredBuffer<HitData>     g_hits  : register(u1);

//---------------------------------------------------------
// Ray Generation
//---------------------------------------------------------
[shader("raygeneration")]
void FetchAndSpawn()
{
    const uint ray_index = DispatchRaysIndex().x;

    // Load once → reduce global memory reads
    Ray r = g_rays[ray_index];

    RayDesc ray;
    ray.Origin    = r.origin;
    ray.Direction = r.direction;
    ray.TMin      = r.min_t;
    ray.TMax      = r.max_t;

    // Initialize hit (important to avoid undefined values)
    HitData hit;
    hit.inst_id = INVALID_ID;

#ifdef ASM_QUERY_OUTPUT_FULL_HIT
    hit.uv      = 0.0;
    hit.prim_id = INVALID_ID;
#endif

    TraceRay(
        g_scene,
        RAY_FLAG_NONE,   // explicit flag instead of 0
        0xFF,            // instance mask
        0,               // ray contribution
        1,               // multiplier
        0,               // miss index
        ray,
        hit
    );

    // Coalesced write
    g_hits[ray_index] = hit;
}

//---------------------------------------------------------
// Hit Shader (Unified)
//---------------------------------------------------------
[shader(
#ifdef ASM_QUERY_FIRST_HIT
    "anyhit"
#else
    "closesthit"
#endif
)]
void Hit(inout HitData hit, in MyAttributes attr)
{
    // Always write inst_id first (fast path)
    hit.inst_id = InstanceIndex();

#ifdef ASM_QUERY_OUTPUT_FULL_HIT
    hit.uv      = attr.barycentrics.xy;
    hit.prim_id = PrimitiveIndex();
#endif

#ifdef ASM_QUERY_FIRST_HIT
    // Early terminate for performance
    AcceptHitAndEndSearch();
#endif
}

//---------------------------------------------------------
// Miss Shader
//---------------------------------------------------------
[shader("miss")]
void Miss(inout HitData hit)
{
    // Only write what’s necessary
    hit.inst_id = INVALID_ID;
}
