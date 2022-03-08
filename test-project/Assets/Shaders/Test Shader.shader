Shader "Custom/Test Shader"
{
   Properties
    {
        _MainTex ("Texture", 2D) = "white" {}
        _BoxSize("Box Size", float) = 8
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
            float _BoxSize;
            fixed4 _AverageColor;
            float _PixelIndexX = 1;

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


            //PRE: i is a well defined v2f.
            //POST: returns color of leftmost bottommost pixel in cell of size 
            //      (_BoxSize / Window SizeX, _BoxSize / Window Size Y) in normalized space between 0 and 1.   
            fixed4 frag(v2f i) : SV_Target
            {
                float pixelSizeX = 1 / _ScreenParams.x; // size of pixel on x axis in normalized space
                float pixelSizeY = 1 / _ScreenParams.y; // size of pixel on y axis in normalized space
                float CellSizeX = _BoxSize * pixelSizeX; // "Upscaled" pixel x size in normalized space 
                float CellSizeY = _BoxSize * pixelSizeY; // "Upscaled" pixel y size in normalized space
                float bottomLeftPixelOfCellX = CellSizeX * floor(i.uv.x / CellSizeX); // u coordinate of pixel at bottom most leftmost part of square
                float bottomLeftPixelOfCellY = CellSizeY * floor(i.uv.y / CellSizeY); // v coordinate of pixel at bottom most leftmost part of square

                float2 bottomLeftPixelOfCell = float2(bottomLeftPixelOfCellX, bottomLeftPixelOfCellY);

                fixed4 col = tex2D(_MainTex, bottomLeftPixelOfCell); // set color of pixel sampled from MainTex at position of bottom most left most pixel of the cell of size CellSizeX x CellSizeY
                
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
