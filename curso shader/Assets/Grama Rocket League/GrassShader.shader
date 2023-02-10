Shader "Unlit/GrassShader"
{
    Properties
    {
        _MainTex ("Texture", 2D) = "white" {}
        _Mask ("Mask", 2D) = "white" {}

        _Width("Width", float) = 1
        _Height("Height", float) = 1
        _Cutout("Cutout", Range(0,1)) = 0
        _Tilling("Tilling", float) = 1
        _Wind("Wind", Range(0,1)) = 0
        _OffsetUv("OffsetUv", float) = 1

        _Color("Color", Color) = (1,1,1,1)
        _Diffuse("Diffuse", Range(0,5)) = 1
    }
    SubShader
    {
        Tags { "Queue"="Transparent" "RenderType"="TransparentCutout" }
        LOD 100
        Cull Off

        Pass
        {
            CGPROGRAM
            #pragma vertex vert
            #pragma geometry geom
            #pragma fragment frag

            #include "UnityCG.cginc"
            #include "Structs.cginc"

            sampler2D _MainTex;
            sampler2D _Mask;
            float4 _MainTex_ST;

            float _Width;
            float _Height;
            float _Cutout;
            float _Tilling;
            float _Wind;
            float _OffsetUv;

            float3 lightPos;
            float4 _Color;
            float _Diffuse;

            StructuredBuffer<Point> buffer;

            v2g vert (uint id : SV_VertexID)
            {
                v2g o;
                o.vertex = float4(buffer[id].pos, 0);
                o.dir = buffer[id].dir;
                return o;
            }

            [maxvertexcount(4)]
            void geom(point v2g IN[1], inout TriangleStream<g2f> stream)
            {
                float3 v = IN[0].vertex;
                float3 dir = IN[0].dir;

                float3 up = float3(0, 1, 0);

                float3 windDir = (v.x, v.z) * 1000%2==0 ? dir : -dir;
                float3 wind = windDir * cos(_Time.y) * _Wind;

                float offsetUv = (v.x + v.z) * _OffsetUv;

                g2f o;

                float3 v1 = v;
                o.vertex = UnityObjectToClipPos(v1);
                o.uv = float2(offsetUv,0);
                o.wPos = mul(unity_ObjectToWorld, v1);
                stream.Append(o);

                float3 v2 = v + dir * _Width;
                o.vertex = UnityObjectToClipPos(v2);
                o.uv = float2(_Tilling + offsetUv,0);
                o.wPos = mul(unity_ObjectToWorld, v2);
                stream.Append(o);

                float3 v3 = v1 + up * _Height + wind;
                o.vertex = UnityObjectToClipPos(v3);
                o.uv = float2(offsetUv,1);
                o.wPos = mul(unity_ObjectToWorld, v3);
                stream.Append(o);

                float3 v4 = v2 + up * _Height + wind;
                o.vertex = UnityObjectToClipPos(v4);
                o.uv = float2(_Tilling + offsetUv,1);
                o.wPos = mul(unity_ObjectToWorld, v4);
                stream.Append(o);
            }

            fixed4 frag (g2f i) : SV_Target
            {
                float3 normal = normalize(lightPos - i.wPos);

                float2 uv = i.uv;

                float3 worldToUv = i.wPos / _Width;
                fixed4 mask = tex2D(_Mask, float2(worldToUv.x, worldToUv.z));

                fixed4 col = tex2D(_MainTex, uv) * _Color;

                if(mask.r>0.9){
                    col.rgb = float3(1,1,1);
                }

                col.rgb *= pow(uv.y,2) * dot(normal, _WorldSpaceLightPos0) * _Diffuse;
                clip(col.a - _Cutout);
                return col;
            }
            ENDCG
        }
    }
}
