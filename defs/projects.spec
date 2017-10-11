//define number of CMAC
#ifdef NV_LARGE
    %define CMAC 2048
#elif NV_SMALL
    %define CMAC 32
#else
    #error "Please add more configrations to build, for now only support NV_LARGE and NV_SMALL"
#endif
