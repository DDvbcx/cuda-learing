// 头文件
#include <iostream>
#ifndef STRNGBAD_H_
#define STRNGBAD_H_
class StringBad
{
    private:
        char* str;
        int len;
        static int num_strings;
    public:
        StringBad(const char* s);  // 构造函数
        StringBad();
        ~StringBad();

        // 友元函数
        friend std::ostream & operator<<(std::ostream & os,
                            const StringBad & st);
};
#endif