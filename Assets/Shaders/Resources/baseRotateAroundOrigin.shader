Shader "Unlit/RotateAroundOrigin"
{
	Properties
	{
		_MainTex ("Texture", 2D) = "white" {}
	}
	SubShader
	{
		Tags { "RenderType"="Opaque" }
		LOD 100

		Pass
		{
			CGPROGRAM
			#pragma vertex   vert
			#pragma fragment frag
			
			#include "UnityCG.cginc"
            #define PI 3.1415926
			struct appdata
			{
				float4 vertex : POSITION;
				float2 uv     : TEXCOORD0;
				float4 color  : COLOR;
			};

			struct v2f
			{
				float2 uv     : TEXCOORD0;
				float4 vertex : SV_POSITION;
				float4 color  : COLOR;
			};

			sampler2D _MainTex;
			float4    _MainTex_ST;
			
			v2f vert (appdata v)
			{
				v2f o;
				float theta = sin(_Time*10.)*2.*PI;
				float4x4 myTransformation =
				{
					1.,          0.,          0., 0.,
					0.,  cos(theta), -sin(theta), 0.,
					0.,  sin(theta),  cos(theta), 0.,
					0.,          0.,          0., 1.

				};

				float4 transferedPos      = mul(unity_ObjectToWorld, v.vertex);
				       transferedPos      = mul(myTransformation, transferedPos);
				       o.vertex           = mul(UNITY_MATRIX_VP, transferedPos);
				o.uv     = TRANSFORM_TEX(v.uv, _MainTex);
				o.color  = v.color;
				return o;
			}
			
			fixed4 frag (v2f i) : SV_Target
			{
				// sample the texture
				fixed4 col = tex2D(_MainTex, i.uv);
				return col ;
			}
			ENDCG
		}
	}
}
