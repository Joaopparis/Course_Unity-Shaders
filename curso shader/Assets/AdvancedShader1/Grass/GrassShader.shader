Shader "Unlit/GrassShader"
{
    Properties
    {
        _MainTex ("Texture", 2D) = "white" {}
        _Color ("Color", Color) = (1,1,1,1)
        _Color2("Color2", Color) = (1,1,1,1)
        _Cutout("Cutout", Range(0,1)) = 0
        _Width("Width", float) = 1
        _Height("Height", float) = 1
        _WindVelocity("Wind Velocity", Range(0,5)) = 1
        _GradientIntensity("Gradient Intensity", Range(0,1)) = 0.5
    }
    SubShader
    {
        Tags { "Queue"="Transparent" "RenderType"="CutoutTransparent" }
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
                float2 uv: TEXCOORD0;
                float4 vertex: SV_POSITION;
            };

            sampler2D _MainTex;
            float4 _MainTex_ST;
            float4 _Color;
            float4 _Color2;
            float _Cutout;
            float _Width;
            float _Height;
            float _WindVelocity;
            float _GradientIntensity;

            StructuredBuffer<float3> buffer;

            v2g vert (uint id : SV_VertexID)
            {
                v2g o;
                o.vertex = float4(buffer[id], 0);
                return o;
            }

            [maxvertexcount(4)]
            void geom(point v2g IN[1], inout TriangleStream<g2f> stream)
            {
                g2f o;

                float3 v = IN[0].vertex;
                float3 wind = ((int)v.z)%2==0 ? float3(0, 0, 1) : float3(0, 0, -1);
                wind *= cos(_Time.y * _WindVelocity);

                float3 direction = normalize(float3(cos(v.x), 0, cos(v.z)));
                float3 up = float3(0, 1, 0);

                o.vertex = UnityObjectToClipPos(float4(v, 0));
                o.uv = float2(0, 0);
                stream.Append(o);

                float3 v1 = v + direction * _Width;
                o.vertex = UnityObjectToClipPos(float4(v1, 0));
                o.uv = float2(1, 0);
                stream.Append(o);

                float3 v2 = v + up * _Height + wind;
                o.vertex = UnityObjectToClipPos(float4(v2, 0));;
                o.uv = float2(0, 1);
                stream.Append(o);

                float3 v3 = v1 + up * _Height + wind;
                o.vertex = UnityObjectToClipPos(float4(v3, 0));
                o.uv = float2(1, 1);
                stream.Append(o);
            }

            fixed4 frag (g2f i) : SV_Target
            {
                fixed4 col = tex2D(_MainTex, i.uv);
                col.rgb = lerp( _Color, _Color2, i.uv.y / _GradientIntensity);
                clip(col.a - _Cutout);
                return col;
            }
            ENDCG
        }
    }
}
