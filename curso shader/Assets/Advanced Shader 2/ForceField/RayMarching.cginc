#define STEPS 30

float sphere_sdf(float3 p){
    float d = length(p - _Center) - _Radius;
    return d;
}

int raymarching(float3 ro, float3 rd, inout float3 pos){
    float total_dist = 0;

    for(int i = 0; i < STEPS; i++){
        pos = ro + rd * total_dist;
        float d = sphere_sdf(pos);

        if(d < 0.001){
            return 1;
        }
        if( d > 1000){
            return 0;
        }

        total_dist += d;
    }

    return 0;
}


float3 calculate_normal(float3 pos){
    float offset = 0.001;

    float grad_x = sphere_sdf(float3(pos.x + offset, pos.y, pos.z)) - sphere_sdf(float3(pos.x - offset, pos.y, pos.z));
    float grad_y = sphere_sdf(float3(pos.x, pos.y + offset, pos.z)) - sphere_sdf(float3(pos.x, pos.y - offset, pos.z));
    float grad_z = sphere_sdf(float3(pos.x, pos.y, pos.z + offset)) - sphere_sdf(float3(pos.x, pos.y, pos.z - offset));

    float3 normal = float3(grad_x, grad_y, grad_z);
    return normalize(normal);
}