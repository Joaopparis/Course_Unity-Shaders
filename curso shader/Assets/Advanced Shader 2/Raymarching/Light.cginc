float light_diffuse(float3 normal){
    return dot(normal, _WorldSpaceLightPos0);
}

float light_specular(float3 normal, float wPos){
    float3 ref = normalize(reflect(-_WorldSpaceLightPos0, normal));
    float3 view = normalize(_WorldSpaceCameraPos - wPos);
    float spec = dot(view, ref);
    return pow(max(spec, 0), 2);
}