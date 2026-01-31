#version 330


uniform sampler2D InSampler;
uniform sampler2D EntityOutlineSampler;
uniform sampler2D MainDepthSampler;

in vec2 texCoord;

layout(std140) uniform SamplerInfo {
    vec2 OutSize;
    vec2 InSize;
    vec2 ScreenSize;
};

layout(std140) uniform FogConfig {
    
    float FOV;
};

out vec4 fragColor;

float near = 0.1; 
float far  = 1000.0;
float LinearizeDepth(float depth) 
{
    float z = depth * 2.0 - 1.0;
    return (near * far) / (far + near - z * (far - near));    
}


void main(){ 
    float AmbientBrightness = float(texture(EntityOutlineSampler, vec2(0.0,1.0)).r);
    float FlashlightPower = float(256 * texture(EntityOutlineSampler, vec2(0.0,1.0)).g);
    
    float BlockDepth = LinearizeDepth(texture(MainDepthSampler, texCoord).r);
    float BlockDistance = length(vec3(1., (2.*texCoord - 1.) * vec2(ScreenSize.x/ScreenSize.y,1.) * tan(radians(FOV / 2.))) * BlockDepth);
    
    float DistanceFromScreenCenter = distance(vec2(texCoord*vec2(ScreenSize.x/ScreenSize.y,1.)), vec2(vec2(ScreenSize.x/ScreenSize.y,1.) * 0.5));
    float FlashlightRaduis = (0.9 / BlockDistance) + 0.1;
    float Brightness = max((FlashlightPower / BlockDistance) * ((FlashlightRaduis - DistanceFromScreenCenter)/0.2) , AmbientBrightness);
    
    fragColor = (texture(InSampler, texCoord)* Brightness);


}


