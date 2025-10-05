#!/bin/bash
#

rm *.so
rm *.pyd

for platform in linux-64 win-64 osx-64 osx-arm64
do
    conda create --platform $platform -n $platform -c conda-forge -y --no-deps --no-default-packages
    conda activate $platform
    conda install symjit -n $platform -c conda-forge --no-deps -y
    find ~/miniforge3/envs/$platform -name '_lib*' -exec mv {} . \;
    tar -czf symjit_$platform.tar.gz _lib*
    rm _lib*
    conda remove symjit -n $platform -y
    conda env remove -n $platform -y
done

./create_artifacts.jl
