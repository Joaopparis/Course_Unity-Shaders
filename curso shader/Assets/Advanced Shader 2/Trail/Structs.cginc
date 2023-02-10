struct Data{
    float3 pos;
    float vel;
};

struct v2g
{
    float4 vertex : POSITION;
};

struct g2f{
    float2 uv : TEXCOORD0;
    float4 vertex : SV_POSITION;
    float3 wPos : TEXCOORD1;
};