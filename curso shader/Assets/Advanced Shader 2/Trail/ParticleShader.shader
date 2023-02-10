Shader "Unlit/ParticleShader"
{
    Properties
    {
        _MainTex ("Texture", 2D) = "white" {}
        _Size("Size", float) = 1
        _Color("Color", Color) = (1,1,1,1)
        _Alpha("Alpha", Range(0, 2)) = 0.7
    }
    SubShader
    {
        Tags { "Queue"="Transparent" "RenderType"="Transparent" }
        LOD 100
        Cull Off
        Blend SrcAlpha OneMinusSrcAlpha
        ZWrite Off

        Pass
        {
            CGPROGRAM
            #pragma vertex vert
            #pragma geometry geom
            #pragma fragment frag

            #include "UnityCG.cginc"
            #include "Structs.cginc"
            #include "Quad.cginc"

            sampler2D _MainTex;
            float4 _MainTex_ST;

            float _Size;
            float _Radius;
            float4 _Color;
            float _Intensity;
            float _Alpha;

            StructuredBuffer<float3> buffer;

            v2g vert (uint id: SV_VertexID)
            {
                v2g o;
                o.vertex = float4(buffer[id], 0);
                return o;
            }

            [maxvertexcount(4)]
            void geom(point v2g IN[1], inout TriangleStream<g2f> stream)
            {
                float3 v = IN[0].vertex;
                g2f o[4];
                quad(o, v, _Size);

                stream.Append(o[0]);
                stream.Append(o[1]);
                stream.Append(o[2]);
                stream.Append(o[3]);
            }

            fixed4 frag (g2f i) : SV_Target
            {
                float d = _Alpha - distance(i.uv, float2(0.5, 0.5));
                fixed4 col = tex2D(_MainTex, i.uv) * _Color;
                col.a *= clamp(d, 0, 1);
                return col;
            }
            ENDCG
        }
    }
}