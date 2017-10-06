#ifdef BIG
    DEFINE CMAC 2048
#elif MEDIUM
    DEFINE CMAC 256
#elif SMALL
    DEFINE CMAC 32
#else
    #error "we only support BIG, MEDIUM and SMALL"
#endif
