Shader "Unlit/FireShader"
{
    Properties
    {
        _MainTex ("Texture", 2D) = "white" {}
        _Size("Size", float) = 1
        _Radius("Radius", Range(0, 1)) = 1 
        _Color("Color", Color) = (1,1,1,1)
        _Intensity("Intensity", Range(0,10)) = 1
        _Velocity("Velocity", float) = 1
        _MaxHeight("MaxHeight", Range(1, 3)) = 3
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
            float _Velocity;
            float _MaxHeight;

            StructuredBuffer<Data> buffer;

            v2g vert (uint id: SV_VertexID)
            {
                float3 v = buffer[id].pos * _Radius;
                v.y += _Time.y * buffer[id].vel * _Velocity;

                float n = trunc(v.y / _MaxHeight);
                v.y -= n * _MaxHeight;

                v2g o;
                o.vertex = float4(v, 0);
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
                fixed4 col = tex2D(_MainTex, i.uv);

                float d = 1 - distance(i.wPos.y, 0) / _MaxHeight;
                float d_xyz = 1 - distance(i.wPos, float3(0,0,0)) / _MaxHeight;

                col.rgb *= d_xyz * _Color * _Intensity;
                col.a *= clamp(d, 0, 1);

                return col;
            }
            ENDCG
        }
    }
}
