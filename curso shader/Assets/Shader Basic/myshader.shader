Shader "myShaders/myshader"
{
    Properties
    {
        _MainTex ("Main Texture", 2D) = "white" {}
        _Color ("Color", Color) = (1, 1, 1, 1)
        _Multiplier ("Multiplier", float) = 2.5
        _Intensity ("Intensity", Range(0,5)) = .5
        _Position ("Position", Vector) = (0, 0, 0, 0)
        _Size ("Size", Range(0, 2)) = 1
        _Bright ("Bright", Range(0,10)) = 1
        _faceDistance ("faceDistance", Range(0,5)) = 1
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
            #pragma fragment frag

            #include "UnityCG.cginc"

            struct appdata
            {
                float4 vertex : POSITION;
                float2 uv : TEXCOORD0;
                float3 normal : NORMAL;
            };

            struct v2f
            {
                float4 vertex : SV_POSITION;
                float2 uv: TEXCOORD0;
            };

            sampler2D _MainTex;
            float4 _MainTex_ST;

            float4 _Color;
            float _Intensity;
            float _Multiplier;

            float _Size;
            float _Bright;
            float _faceDistance;

            v2f vert (appdata v)
            {
                float4 pos = v.vertex;
                pos += _faceDistance * (float4(v.normal, 0) * (abs(sin(_Time.y + pos.x + pos.y + pos.z)) + 0.1));
                pos *= _Multiplier * (abs(sin(_Time.y + pos.x + pos.y + pos.z)) + 0.1);
                v2f o;
                o.vertex = UnityObjectToClipPos(pos);
                o.uv = v.uv;
                return o;
            }

            float4 frag (v2f i) : SV_Target
            {
                float d = _Size - distance(i.uv, float2(0.5, 0.5));
                float4 col = d * _Color * _Intensity * abs(sin(_Time.y));
                return col;
            }
            ENDCG
        }
    }
}
