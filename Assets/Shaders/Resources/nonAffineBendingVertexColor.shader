Shader "Unlit/nonAffineBendingVertexColor"
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
			float4x4  _worldToNeck;
			float4x4  _neckToWorld;
			v2f vert (appdata v)
			{
				v2f o;

				
			    float4 transferedPos      = mul(unity_ObjectToWorld, v.vertex);
				       transferedPos      = mul(_worldToNeck, transferedPos);
					  
				float       thetaX = cos(_Time.x*50. + transferedPos.y*0.1) *PI * smoothstep(0., 20.,transferedPos.y) * 0.1 *( v.color.r);
							thetaX += cos(_Time.x*40. + transferedPos.y*0.12+ 1.2)*PI* 0.1*smoothstep(0., 20., transferedPos.y)*(v.color.r);

				float4x4 rotationX =  {
			abs(thetaX*1.)+1.0,          0.,          0.,  0.,
				    0., cos(thetaX),-sin(thetaX), 0.,
					0., sin(thetaX), cos(thetaX), 0.,
				    0.,          0.,          0.,  1.
				};

				float thetaY = cos(_Time.x*70. +1.2  )*0.04 * abs(sin(_Time*5.)) *(v.color.r) *  transferedPos.y;
				float4x4 rotationY =  {
					cos(thetaY), 0., sin(thetaY), 0.,
				            0., 1.,         0., 0.,
				   -sin(thetaY), 0., cos(thetaY), 0.,
				            0., 0.,         0., 1.
				};
				
				rotationX = mul(rotationY, rotationX);

					   transferedPos      = mul(rotationX, transferedPos);
					   transferedPos      = mul(_neckToWorld, transferedPos);
				       o.vertex           = mul(UNITY_MATRIX_VP, transferedPos);
				o.uv     = TRANSFORM_TEX(v.uv, _MainTex);
				o.color  = v.color;
				return o;
			}
			
			fixed4 frag (v2f i) : SV_Target
			{
				// sample the texture
				fixed4 col = tex2D(_MainTex, i.uv);
			col *= i.color;
				return col ;
			}
			ENDCG
		}
	}
}
