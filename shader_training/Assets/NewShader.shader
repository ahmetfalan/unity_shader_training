Shader "Unlit/NewShader"
{
    Properties
    {
        _Color ("Color", Color) = (1, 1, 1, 1)

        //_MainTex ("Texture", 2D) = "white" {}
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
            #include "Lighting.cginc"
            #include "AutoLight.cginc"

            struct VertexInput
            {
                float4 vertex : POSITION;
                float2 uv0 : TEXCOORD0;
                float3 normal : NORMAL;
            };

            struct VerteOutput
            {
                float4 clipSpacePosition : SV_POSITION;
                float2 uv0 : TEXCOORD0;
                float3 normal : TEXCOORD1;
                float3 worldPosition : TEXCOORD2;
            };

            //sampler2D _MainTex;
            float4 _Color;

            VerteOutput vert (VertexInput i)
            {
                VerteOutput o;
                o.uv0 = i.uv0;
                o.normal = i.normal;
                o.worldPosition = mul(unity_ObjectToWorld, i.vertex);
                o.clipSpacePosition = UnityObjectToClipPos(i.vertex);
                return o;
            }

            fixed4 frag (VerteOutput o) : SV_Target
            {
                float2 uv = o.uv0;

                //return float4(o.worldPosition, 1);
                //direct diffuse light
                float3 lightDirection = _WorldSpaceLightPos0.xyz;
                float3 lightFalloff = max(0, dot(lightDirection, o.normal));
                float3 lightColor = _LightColor0.rgb;
                float3 directDfiffuseLight = lightFalloff * lightColor;


                //ambient light
                float3 ambientLight  = float3(0.2, 0.35, 0.4);
                float3 diffuseLight = ambientLight + directDfiffuseLight;


                //direct specılar light
                float3 cameraPosition = _WorldSpaceCameraPos;



                //composite
                float3 finalSurfaceColor = diffuseLight * _Color.rgb;


                return float4(finalSurfaceColor, 0);
            }
            ENDCG
        }
    }
}
