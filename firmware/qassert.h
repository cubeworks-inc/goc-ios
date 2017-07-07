#ifndef __QASSERT_H__
#define __QASSERT_H__

//Uncomment for qassert
//#define DEBUG

#ifdef DEBUG
    #warning "DEBUG Enabled"
    #define qassert(condition)                      \
                do{                                 \
                    while (!(condition)) {}         \
                } while(false)   
#else
    #define qassert(condition)
#endif                

#endif
