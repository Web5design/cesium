uniform vec4 u_intersectionColor;

bool inSensorShadow(vec3 coneVertexWC, czm_ellipsoid ellipsoidEC, vec3 pointEC)
{
    // Diagonal matrix from the unscaled ellipsoid space to the scaled space.    
    vec3 D = ellipsoidEC.inverseRadii;

    // Sensor vertex in the scaled ellipsoid space
    vec3 q = D * coneVertexWC;
    float qMagnitudeSquared = dot(q, q);
    float test = qMagnitudeSquared - 1.0;
    
    // Fragment in the ellipsoid frame
    vec3 t = (czm_inverseView * vec4(pointEC, 1.0)).xyz;

    // Sensor vertex to fragment vector in the ellipsoid's scaled space
    vec3 temp = D * t - q;
    float d = dot(temp, q);
    
    // Behind silhouette plane and inside silhouette cone
    return (d < -test) && (d / length(temp) < -sqrt(test));
}

///////////////////////////////////////////////////////////////////////////////

#ifndef RENDER_FOR_PICK

vec4 getIntersectionColor(float sensorRadius, vec3 pointEC)
{
    return u_intersectionColor;
}

vec2 sensor2dTextureCoordinates(float sensorRadius, vec3 pointMC)
{
    // (s, t) both in the range [0, 1]
    float t = pointMC.z / sensorRadius;
    float s = 1.0 + (atan(pointMC.y, pointMC.x) / czm_twoPi);
    s = s - floor(s);
    
    return vec2(s, t);
}

#endif