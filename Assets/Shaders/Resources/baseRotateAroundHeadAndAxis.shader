Shader "Unlit/baseRotateAroundHeadAndAxis"
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

				float4 c1   = float4(-1., 0., -1., 0.);
				float4 c2   = float4( 0.,-1.,  0., 0.);
				float4 c3   = float4(-1., 0.,  1., 0.);
				float4 c4   = float4( 0., 0.,  0., 1.);

				c1 = normalize(c1);
				c2 = normalize(c2);
				c3 = normalize(c3);
				c4 = normalize(c4);

				float4x4 R2Axis = {
					c1.x,   c2.x,   c3.x,  c4.x,
					c1.y,   c2.y,   c3.y,  c4.y,
					c1.z,   c2.z,   c3.z,  c4.z,
					c1.w,   c2.w,   c3.w,  c4.w,

				};
				float4x4 RfromAxis = {
					c1.x,   c1.y,   c1.z,  c1.w,
					c2.x,   c2.y,   c2.z,  c2.w,
					c3.x,   c3.y,   c3.z,  c3.w,
					c4.x,   c4.y,   c4.z,  c4.w,

				};

				float theta = sin(_Time*10.)*2.*PI;
				float4x4 rotation =
				{
					1.,          0.,          0., 0.,
					0.,  cos(theta), -sin(theta), 0.,
					0.,  sin(theta),  cos(theta), 0.,
					0.,          0.,          0., 1.

				};

				float4x4 T2Head =
				{
					1.,   0.,   0.,   0.,
					0.,   1.,   0., -20.,
					0.,   0.,   1.,   0.,
					0.,   0.,   0.,   1.

				};

				float4x4 TFromHead =
				{
					1.,   0.,   0.,   0.,
					0.,   1.,   0.,  20.,
					0.,   0.,   1.,   0.,
					0.,   0.,   0.,   1.

				};

				//float4x4 myTransformation   = R2Axis;
				         //myTransformation = mul(rotation, myTransformation);
						 //myTransformation = mul(TFromHead, myTransformation);

				float4x4 myTransformation = mul(TFromHead,mul(RfromAxis, mul( rotation, mul(R2Axis, T2Head))));

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
