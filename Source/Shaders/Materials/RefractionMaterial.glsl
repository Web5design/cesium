uniform samplerCube cubeMap;
uniform float indexOfRefractionRatio;

czm_material czm_getMaterial(czm_materialInput materialInput)
{
    czm_material material = czm_getDefaultMaterial(materialInput);
    
    vec3 normalEC = material.normal;
    vec3 normalWC = normalize(vec3(czm_inverseView * vec4(normalEC, 0.0)));
    vec3 refractedWC = refract(materialInput.positionToEyeWC, -normalWC, indexOfRefractionRatio);
    material.diffuse = textureCube(cubeMap, refractedWC).channels;

    return material;
}