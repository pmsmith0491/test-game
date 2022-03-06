Shader "Custom/Test Shader"
{
   Properties
    {
        _MainTex ("Texture", 2D) = "white" {}
        //_ResolutionWidth ("Resolution Width", float) = 1280
        //_ResolutionHeight("Resolution Height", float) = 720
        _PixelSize("Pixel Size", float) = 16
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
            float _ResolutionWidth;
            float _ResolutionHeight;
            float _PixelSize;

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

            v2f vert(appdata v)
            {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.uv = v.uv;
                return o;
            }

            
            fixed4 frag(v2f i) : SV_Target
            {
                // instead of taking the average of the color, we scale the UV 
                // of the fragment to encompass more pixels based on pixel size and 
                // screen resolution
                float CellSizeX = _PixelSize / _ScreenParams.x;
                float CellSizeY = _PixelSize / _ScreenParams.y;
                float ScaledX = CellSizeX * floor(i.uv.x / CellSizeX);
                float ScaledY = CellSizeY * floor(i.uv.y / CellSizeY);

                float2 ScaledUV = float2(ScaledX, ScaledY);

                fixed4 col = tex2D(_MainTex, ScaledUV);
                
                return col;
            }
            ENDCG

        }
        

        /* BOX BLUR FILTER (Set pixel to average of pixels around it)
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
                    // box blur: we want to make the pixel of interest's color the average of all pixels surrounding it. 
                     //    If our region of interest is 10 pixels, we want to find the average of the 9 pixels around it. 
                    //    Below, we subtract 0.5 b/c we do not want to focus on the pixel we are currently on, but rather the pixels around it 
                    float2 uv = i.uv + float2(0, (index / 9 - 0.5) * _BlurSize);
                    col += tex2D(_MainTex, uv);
                }

                col = col / 10;

                return col;
            }
            ENDCG
        }
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

            v2f vert(appdata v)
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

                    // box blur: we want to make the pixel of interest's color the average of all pixels surrounding it. 
                    //    If our region of interest is 10 pixels, we want to find the average of the 9 pixels around it. 
                    //    Below, we subtract 0.5 b/c we do not want to focus on the pixel we are currently on, but rather the pixels around it 
                    float2 uv = i.uv + float2((index / 9 - 0.5) * _BlurSize, 0);
                    
                    
                    col += tex2D(_MainTex, uv);
                }

                col = col / 10;

                return col;
            }
            ENDCG
        }*/
    }
}
