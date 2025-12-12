uniform float uTime;
uniform sampler2D uPerlinTexture;

varying vec2 vUv;
  
//rotate2d function
    vec2 rotate2D(vec2 value, float angle)
    {
        float sine =  sin(angle);
        float cosine = cos(angle);
        mat2 matrix = mat2(cosine, sine, -sine, cosine);
        return matrix*value;
    }
void main() 
{
    vec3 newPosition = position;

    //twist
    float twistPerlin = texture(uPerlinTexture, vec2(0.5, uv.y * 0.2- uTime * 0.005)).r;
    float angle = twistPerlin * 10.0 ;
    newPosition.xz = rotate2D(newPosition.xz, angle);

    //wind
    vec2 windOffset = vec2(
        texture(uPerlinTexture, vec2(0.25, uTime * 0.01)).r - 0.5,
        texture(uPerlinTexture, vec2(0.75, uTime * 0.01)).r - 0.5
    );
    windOffset *= pow(uv.y, 2.0) * 0.07; //multiply the windoffset by a small amount to not have that much smoke
    newPosition.xz += windOffset;
    //Final Position
    gl_Position = projectionMatrix * modelViewMatrix * vec4(newPosition, 1.0);
  
    //varying
    vUv = uv;
}