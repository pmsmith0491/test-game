Shader "Custom/Test Shader"
{
   Properties
    {
        _MainTex ("Texture", 2D) = "white" {}
        _BlurSize ("Blur Size", Range(0, 0.1)) = 0
    }
    SubShader
    {
        // No culling or depth
        Cull Off ZWrite Off ZTest Always

        Pass
        {
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag

            #include "UnityCG.cginc"

            sampler2D _MainTex;
            float _BlurSize;

            struct appdata
            {
                float4 vertex : POSITION;
                float2 uv : TEXCOORD0;
            };

            struct v2f
            {
                float2 uv : TEXCOORD0;
                float4 vertex : SV_POSITION;
            };

            v2f vert (appdata v)
            {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.uv = v.uv;
                return o;
            }

          
            fixed4 frag(v2f i) : SV_Target
            {
                fixed4 col = 0;
                
                for (float index = 0; index < 10; index++) {
                    float2 uv = i.uv + float2(0, (index / 9 - 0.5) * _BlurSize);
                    col += tex2D(_MainTex, uv);
                }

                col = col / 10;

                return col;
            }
            ENDCG
        }
    }
}
