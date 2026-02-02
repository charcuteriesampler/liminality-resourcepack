#version 330


uniform sampler2D InSampler;

in vec2 texCoord;

layout(std140) uniform SamplerInfo {
    vec2 OutSize;
    vec2 InSize;
    vec2 ScreenSize;
};

layout(std140) uniform ChromaticAberrationConfig {
    
    vec2 RShift;
    vec2 GShift;
    vec2 BShift;
};

out vec4 fragColor;

vec4 OffsetPosition(vec2 texCoord, vec2 Offset){
    return(clamp(vec2(texCoord + offset), vec2( 1, 1), vec2(0, 0) ));
}


void main(){ 

    float Red = texture(InSampler, OffsetPosition(texCoord, RShift)).r;
    float Green = texture(InSampler, OffsetPosition(texCoord, GShift)).g;
    float Blue = texture(InSampler, OffsetPosition(texCoord, BShift)).b;
    
    fragColor = vec4(Red, Green, Blue, 1);


}
