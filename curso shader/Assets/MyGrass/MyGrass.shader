Shader "Unlit/MyGrass"
{
    Properties
    {
        _MainTex ("Texture", 2D) = "white" {}
        _Color ("Color", Color) = (1,1,1,1)
        _Color2 ("Color", Color) = (1,1,1,1)
        _Direcional("Direcional", float) = 0
    }
    SubShader
    {
        Tags { "RenderType"="Opaque" }
        LOD 100
        Cull Off

        Pass
        {
            CGPROGRAM
            #pragma vertex vert
            #pragma geometry geom
            #pragma fragment frag

            #include "UnityCG.cginc"

            struct v2g
            {
                float4 vertex : POSITION;
            };

            struct g2f{
                float2 uv : TEXCOORD0;
                float4 vertex : SV_POSITION;
            };

            sampler2D _MainTex;
            float4 _MainTex_ST;
            float4 _Color;
            float4 _Color2;
            float _Direcional;

            StructuredBuffer<float3> buffer;

            v2g vert (uint id : SV_VertexID)
            {
                v2g o;
                o.vertex = float4(buffer[id], 0);
                return o;
            }

            [maxvertexcount(7)]
            void geom(point v2g IN[1], inout TriangleStream<g2f> stream)
            {
                g2f o;
                float3 right = float3(.125f, 0, 0);
                float3 right2 = float3(.125f, 0, 0);
                float3 up = float3(0, .125f, 0);
                float middle = float3(.0625f, .25f, 0);

                float3 v = IN[0].vertex;
                o.vertex = UnityObjectToClipPos(float4(v, 0));
                o.uv = float2(0,0);
                stream.Append(o);

                float3 v1 = v + right;
                o.vertex = UnityObjectToClipPos(float4(v1, 0));
                o.uv = float2(1,0);
                stream.Append(o);

                float3 v2 = v + up;
                o.vertex = UnityObjectToClipPos(float4(v2, 0));
                o.uv = float2(0,.33);
                stream.Append(o);

                float3 v3 = v1 + up;
                o.vertex = UnityObjectToClipPos(float4(v3, 0));
                o.uv = float2(0,.33);
                stream.Append(o);

                float3 v6 = v2 + middle;
                o.vertex = UnityObjectToClipPos(float4(v6, 0));
                o.uv = float2(.5,1);
                stream.Append(o);
            }
            
            fixed4 frag (g2f i) : SV_Target
            {
                fixed4 col = lerp(_Color, _Color2, i.uv.y * _Direcional);//tex2D(_MainTex, i.uv);
                return col;
            }
            ENDCG
        }
    }
}
