struct v2g
{
    float3 dir : TEXCOORD0;
    float4 vertex : POSITION;
};

struct g2f{
    float2 uv : TEXCOORD0;
    float4 vertex : SV_POSITION;
    float3 wPos : TEXCOORD1;
};

struct Point{
    float3 pos;
    float3 dir;
};