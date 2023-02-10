Shader "myShaders/LightShader"
{
    Properties
    {
        _Color("Color", Color) = (1,1,1,1)
        _LColor("LColor", Color) = (1,1,1,1)

        _Ambient("Ambient", Range(0,1)) = 0
        _Diffuse ("Diffuse", Range(0,1)) = 0
        _Specular("Specular", Range(0, 10)) = 1
    }
    SubShader
    {
        Tags { "RenderType"="Opaque" }
        LOD 100

        Pass
        {
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag

            #include "UnityCG.cginc"

            float4 _Color;
            float4 _LColor;
            float  _Ambient;
            float _Diffuse;
            float _Specular;

            struct appdata
            {
                float4 vertex : POSITION;
                float3 normal: NORMAL;
            };

            struct v2f
            {
                float4 vertex : SV_POSITION;
                float3 normal: NORMAL;
                float3 wPos: TEXCOORD0;
            };

            v2f vert (appdata v)
            {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.normal = v.normal;
                o.wPos = mul(unity_ObjectToWorld, v.vertex);
                return o;
            }

            fixed4 frag (v2f i) : SV_Target
            {
                float4 ambient = _LColor * _Ambient;
                float4 diffuse = _LColor * dot( i.normal, _WorldSpaceLightPos0) * _Diffuse;

                float3 Reflect = reflect(_WorldSpaceLightPos0, i.normal);
                float3 ViewDir = -normalize(_WorldSpaceCameraPos - i.wPos);
                float spec = dot(Reflect, ViewDir);
                float4 Specular = _LColor * pow(max(0, spec), _Specular);

                fixed4 col = _Color * (ambient + diffuse + Specular);
                return col;
            }
            ENDCG
        }
    }
}
