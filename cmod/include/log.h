// ================================================================
// NVDLA Open Source Project
// 
// Copyright(c) 2016 - 2017 NVIDIA Corporation.  Licensed under the
// NVDLA Open Hardware License; Check "LICENSE" which comes with 
// this distribution for more information.
// ================================================================

// File Name: log.h

#ifndef __LOG_H__
#define __LOG_H__

#include <string.h>
#include <systemc.h>

#if defined(__cplusplus)
// some c++ headers for csl
#include <iostream> // for ostream, cerr
#include <sstream>
#include <cstdlib> // for std::abort()
#endif

// There're 2 strrchr, might not good for performance;
#define __FILENAME__ (strrchr(__FILE__, '/') ? (strrchr(__FILE__, '/') + 1):__FILE__)
#define MSG_BUF_SIZE    2048

#define cslDebugInternal(lvl, ...)          do {\
                                                char msg_buf[MSG_BUF_SIZE]; \
                                                int pos = snprintf(msg_buf, MSG_BUF_SIZE, "%d:", __LINE__); \
                                                snprintf(msg_buf + pos, MSG_BUF_SIZE - pos, __VA_ARGS__); \
                                                SC_REPORT_INFO_VERB(__FILENAME__, msg_buf, SC_DEBUG ); \
                                            } while(0)
#define cslDebug(args)                      cslDebugInternal args

#define cslInfoInternal(...)                do {\
                                                char msg_buf[MSG_BUF_SIZE]; \
                                                int pos = snprintf(msg_buf, MSG_BUF_SIZE, "%d:", __LINE__); \
                                                snprintf(msg_buf + pos, MSG_BUF_SIZE - pos, __VA_ARGS__); \
                                                SC_REPORT_INFO_VERB(__FILENAME__, msg_buf, SC_FULL ); \
                                            } while(0)
#define cslInfo(args)                       cslInfoInternal args

#define FAILInternal(...)                   do {\
                                                char msg_buf[MSG_BUF_SIZE]; \
                                                int pos = snprintf(msg_buf, MSG_BUF_SIZE, "%d:", __LINE__); \
                                                snprintf(msg_buf + pos, MSG_BUF_SIZE - pos, __VA_ARGS__); \
                                                SC_REPORT_FATAL(__FILENAME__, msg_buf ); \
                                            } while(0)
#define FAIL(args)                          FAILInternal args
#define Fail(...)                           FAILInternal(__VA_ARGS__)

#define cslAssert(expr)                     do {\
                                                sc_assert(expr ); \
                                            } while(0)




#endif
