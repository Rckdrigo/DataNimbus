﻿Shader "MyShaders/OutlineShader"
{
    Properties {
		_MainColor ("Main Color" , Color) = (1,1,1,1)
        _OutlineColor ("Outline Color", Color) = (0,0,0,1)
        _Outline ("Outline width", Range (0, 0.1)) = .005
    }
 
    SubShader {
        Tags { "RenderType"="Opaque" }
        Pass
        {
            // Pass drawing outline
            Cull Front
       
           
            CGPROGRAM
            #include "UnityCG.cginc"
            #pragma vertex vert
            #pragma fragment frag
           
		   
            uniform float _Outline;
            uniform float4 _OutlineColor;

            //uniform float4 _MainTex_ST;
            //uniform sampler2D _MainTex;
 
            struct v2f
            {
                float4 pos : POSITION;
                float4 color : COLOR;
            };
           
            v2f vert(appdata_base v)
            {
                v2f o;
                o.pos = mul (UNITY_MATRIX_MVP, v.vertex);
                float3 norm   = mul ((float3x3)UNITY_MATRIX_IT_MV, v.normal);
                float2 offset = TransformViewToProjection(norm.xy);
                o.pos.xy += offset  * _Outline;
                o.color = _OutlineColor;
                return o;
            }
           
            half4 frag(v2f i) :COLOR
            {
                return i.color;
            }
                   
            ENDCG
        }
       
        Pass
        {  
            // pass drawing object
           
            CGPROGRAM
            #include "UnityCG.cginc"
            #pragma vertex vert
            #pragma fragment frag
           

			uniform float4 _MainColor;
 
            struct v2f {
                float4 pos : POSITION;
                //float2 uv : TEXCOORD0;
            };
           
            v2f vert(appdata_base v) {
                v2f o;
                o.pos = mul (UNITY_MATRIX_MVP, v.vertex);
                //o.uv = v.texcoord;
                return o;
            }
           
            half4 frag(v2f i) :COLOR
            {
                return _MainColor;//tex2D (_MainTex, _MainTex_ST.xy * i.uv.xy + _MainTex_ST.zw);
            }
                   
            ENDCG
        }
    }
   
    Fallback Off
}