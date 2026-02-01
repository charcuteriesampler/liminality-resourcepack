#version 330

float near = 0.1; 
float far  = 1000.0;

float LinearizeDepth(float depth) 
{
    float z = depth * 2.0 - 1.0;
    return (near * far) / (far + near - z * (far - near));    
}

#define GFX_INPUT_1 vec2(0.25, 0.25)
#define GFX_INPUT_2 vec2(0.75, 0.25)
#define GFX_INPUT_3 vec2(0.25, 0.75)
#define GFX_INPUT_4 vec2(0.75, 0.75)
