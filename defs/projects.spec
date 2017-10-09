#ifdef NV_LARGE
    DEFINE CMAC 2048
#elif NV_SMALL
    DEFINE CMAC 32
#else
    #error "Please add more configrations to build, for now only support NV_LARGE and NV_SMALL"
#endif

    DEFINE HAHA 4
