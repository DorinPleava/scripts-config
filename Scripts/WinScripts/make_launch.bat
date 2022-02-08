call activate carla_env
call ue4_carla_export.bat
call "C:\Program Files (x86)\Microsoft Visual Studio\2019\Professional\VC\Auxiliary\Build\vcvars64.bat"
pushd %CARLA_ROOT% 
call make launch
DIR
call conda deactivate