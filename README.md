# Numberics
◆Pascal高精度整数库

# 样例
```
Uses Numberics;
var
 a:BigInteger;
 b:ansistring;
begin
 readln(b); a:=b;
 readln(b);
 PrintfLn(a+b);
 PrintfLn(a-b);
 PrintfLn(a*b);
 Printf(a div b)
end.
```

上述样例可以读入2行大数a,b
分别输出4行a+b,a-b,a\*b,a div b.

**2017/02/14 Ver 1.0.0**  
●大数和许多类型可以直接隐式转换或者用BigInteger()强制转换  
■大数并无压位，常数大  
■大数间不能直接赋值  
■大数除法的时间复杂度是O(n^2)，大数乘法的时间复杂度是O(nlogn)，大数加法的时间复杂度是O(n)  
