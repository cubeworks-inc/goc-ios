#ifndef __QASSERT_H__
#define __QASSERT_H__

//quick assert
#define qassert(condition)                      \
            do{                                 \
                while (!(condition)) {}         \
            } while (false)                     \



#endif
