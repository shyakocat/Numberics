{$M 100000000,0,100000000}
unit Numberics;

interface

type
 NumFP=array of longint;
 pint=^longint;
 BigInteger=record
  n,sign:longint;
  a:NumFP
 end;
const
 p:int64=998244353;
 g:int64=3;
var
 base,base_inv:longint;
 R,eps,eps_inv,U,V,W:NumFP;


procedure printf(const a:BigInteger);                                            //输出大数
procedure PrintfLn(const a:BigInteger);                                          //换行输出大数
operator :=(a:Longint)c:BigInteger;                                              //隐式将   Longint转换成BigInteger
operator :=(const a:ansistring)c:BigInteger;                                     //隐式将Ansistring转换成BigInteger
operator :=(c:BigInteger)a:longint;                                              //隐式将BigInteger转换成Longint
operator :=(c:BigInteger)b:real;                                                 //隐式将BigInteger转换成Real
operator :=(c:BigInteger)s:ansistring;                                           //隐式将BigInteger转换成Ansistring
operator +(const a,b:BigInteger)c:BigInteger;                                    //定义大数加法
operator -(const a:BigInteger)c:BigInteger;                                      //定义大数取负
operator -(const a,b:BigInteger)c:BigInteger;                                    //定义大数相减
operator =(const a,b:BigInteger)c:boolean;                                       //定义大数判断等于
operator <(const a,b:BigInteger)c:boolean;                                       //定义大数判断小于
operator <=(const a,b:BigInteger)c:boolean;                                      //定义大数判断小于等于
operator >(const a,b:BigInteger)c:boolean;                                       //定义大数判断大于
operator >=(const a,b:BigInteger)c:boolean;                                      //定义大数判断大于等于
operator *(const a,b:BigInteger)c:BigInteger;                                    //定义大数乘法
operator *(const a:BigInteger;b:longint)c:BigInteger;
operator div(const a,b:BigInteger)c:BigInteger;                                  //定义大数除法
operator mod(const a,b:BigInteger)d:BigInteger;                                  //定义大数取余

function BigInteger_abs(const a:BigInteger):BigInteger;                          //大数取绝对值
function BigInteger_copy(const a:BigInteger;l,r:longint):BigInteger;             //大数取位
function BigInteger_move(const a:BigInteger;x:longint):BigInteger;               //大数乘以10的幂次





implementation

function max(a,b:longint):longint;
begin if a>b then exit(a); exit(b) end;

function min(a,b:longint):longint;
begin if a>b then exit(b); exit(a) end;

procedure sw(var a,b:longint);
var c:longint; begin c:=a; a:=b; b:=c end;

procedure printf(const a:BigInteger);
var
 i:longint;
begin
 if a.n=0 then begin write(0); exit end;
 if a.sign=-1 then write('-');
 for i:=a.n-1 downto 0 do write(a.a[i])
end;

procedure PrintfLn(const a:BigInteger);
begin
 Printf(a);
 writeln
end;

operator :=(a:Longint)c:BigInteger;
begin
 if a=0 then begin c.n:=0; c.sign:=0; setlength(c.a,1); c.a[0]:=0; exit end;
 c.n:=0;
 setlength(c.a,20);
 if a<0 then begin c.sign:=-1; a:=-a end else c.sign:=1;
 while a>0 do
 begin
  c.a[c.n]:=a mod 10;
  a:=a div 10;
  inc(c.n)
 end;
 setlength(c.a,c.n)
end;

operator :=(const a:ansistring)c:BigInteger;
var
 x,i,t:longint;
begin
 if (a='')or(a='-0')or(a='0') then begin c:=0;  exit end;
 if a[1]='-' then begin x:=2; c.sign:=-1 end
             else begin x:=1; c.sign:=1  end;
 for i:=x to length(a) do if (a[i]<'0')or(a[i]>'9') then begin c:=0; exit end;
 c.n:=length(a)-x+1;
 setlength(c.a,c.n);
 for i:=0 to c.n-1 do c.a[i]:=ord(a[length(a)-i])-48;
 while (c.n>0)and(c.a[c.n-1]=0) do dec(c.n);
 if c.n=0 then begin c:=0; exit end;
 setlength(c.a,c.n)
end;

operator :=(c:BigInteger)a:longint;var i:longint; begin a:=0; for i:=c.n-1 downto 0 do a:=a*10+c.a[i]; a:=a*c.sign end;
operator :=(c:BigInteger)b:real;var i:longint; begin b:=0; for i:=c.n-1 downto 0 do b:=b*10+c.a[i] end;
operator :=(c:BigInteger)s:ansistring;
var
 i:longint;
begin
 if c.sign=0 then begin s:='0'; exit end;
 if c.sign=1 then s:='' else s:='-';
 for i:=c.n-1 downto 0 do s:=s+char(c.a[i]+48)
end;

operator +(const a,b:BigInteger)c:BigInteger;
var
 i:longint;
begin
 c.n:=max(a.n,b.n);
 setlength(c.a,c.n);
 for i:=0 to c.n-1 do
 begin
  c.a[i]:=0;
  with a do if i<n then inc(c.a[i],a[i]*sign);
  with b do if i<n then inc(c.a[i],a[i]*sign)
 end;
 while (c.n>0)and(c.a[c.n-1]=0) do dec(c.n);
 if c.n=0 then begin c:=0; exit end;
 setlength(c.a,c.n);
 if c.a[c.n-1]<0 then
 begin c.sign:=-1; for i:=0 to c.n-1 do c.a[i]:=-c.a[i] end
 else c.sign:=1;
 for i:=0 to c.n-2 do
 if c.a[i]<0 then begin inc(c.a[i],10); dec(c.a[i+1]) end else
 if c.a[i]>9 then begin dec(c.a[i],10); inc(c.a[i+1]) end;
 while (c.n>0)and(c.a[c.n-1]=0) do dec(c.n);
 if c.n=0 then begin c:=0; exit end;
 if c.a[c.n-1]>9 then begin inc(c.n); setlength(c.a,c.n);
  dec(c.a[c.n-2],10); c.a[c.n-1]:=1 end;
end;

operator -(const a:BigInteger)c:BigInteger;
var i:longint;
begin
 c.sign:=-a.sign;
 c.n:=a.n;
 setlength(c.a,c.n);
 for i:=0 to c.n-1 do c.a[i]:=a.a[i]
end;

operator -(const a,b:BigInteger)c:BigInteger;
begin
 c:=a+(-b)
end;

operator =(const a,b:BigInteger)c:boolean;
var
 i:longint;
begin
 if a.sign<>b.sign then begin c:=false; exit end;
 if a.n<>b.n then begin c:=false; exit end;
 for i:=0 to a.n-1 do if a.a[i]<>b.a[i] then begin c:=false; exit end;
 c:=true
end;

operator <(const a,b:BigInteger)c:boolean;
var
 i:longint;
begin
 if a.sign<b.sign then begin c:=true; exit end;
 if a.sign>b.sign then begin c:=false; exit end;
 c:=a.sign=1;
 if a.n<b.n then exit;
 if a.n>b.n then begin c:=not c; exit end;
 for i:=a.n-1 downto 0 do
 if a.a[i]<b.a[i] then exit else
 if a.a[i]>b.a[i] then begin c:=not c; exit end;
 c:=not c
end;

operator <=(const a,b:BigInteger)c:boolean;begin c:=(a<b)or(a=b) end;
operator >(const a,b:BigInteger)c:boolean;begin c:=not(a<=b) end;
operator >=(const a,b:BigInteger)c:boolean;begin c:=not(a<b) end;


 function pw(const x,y:int64):int64;
 var t:int64;
 begin
  if y=0 then exit(1);
  if y=1 then exit(x);
  t:=pw(x,y>>1);
  if odd(y) then exit(t*t mod p*x mod p);
                 exit(t*t mod p)
 end;

 function init(m:longint):longint;
 var
  n,i,L:longint;
 begin
  n:=1; L:=0; while n<=m do begin n:=n<<1; inc(L) end;
  if high(eps)<0 then
  begin
   setlength(eps,n);
   setlength(eps_inv,n);
   base:=pw(g,(p-1)div n);
   base_inv:=pw(base,p-2);
   eps[0]:=1;
   eps_inv[0]:=1;
   for i:=1 to n-1 do
   begin
    eps[i]:=int64(eps[i-1])*base mod p;
    eps_inv[i]:=int64(eps_inv[i-1])*base_inv mod p
   end
  end
  else
  begin
   i:=high(eps)+1;
   setlength(eps,n);
   setlength(eps_inv,n);
   for i:=i to n-1 do
   begin
    eps[i]:=int64(eps[i-1])*base mod p;
    eps_inv[i]:=int64(eps_inv[i-1])*base_inv mod p
   end
  end;
  setlength(R,n);
  for i:=0 to n-1 do R[i]:=(R[i>>1]>>1)or((i and 1)<<(L-1));
  exit(n)
 end;

 procedure NTT(n:longint;var a,b:NumFP);
 var
  i,j,k,t,x,y:longint;
 begin
  for i:=0 to n-1 do if i<R[i] then sw(a[i],a[R[i]]);
  i:=1; while i<n do begin t:=i<<1;
  j:=0; while j<n do begin
  for k:=0 to i-1 do begin
   x:=a[j+k]; y:=a[j+k+i]*int64(b[n div t*k])mod p;
   a[j+k]:=(x+y)mod p; a[j+k+i]:=(x-y)mod p end;
  j:=j+t end;
  i:=t end
 end;


operator *(const a,b:BigInteger)c:BigInteger;
var
 n,i,inv:longint;
begin
 c.sign:=a.sign*b.sign;
 if c.sign=0 then begin c:=0; exit end;
 n:=init(a.n+b.n);
 setlength(U,n);
 setlength(V,n);
 for i:=0 to a.n-1 do U[i]:=a.a[i]; for i:=a.n to n-1 do U[i]:=0;
 for i:=0 to b.n-1 do V[i]:=b.a[i]; for i:=b.n to n-1 do V[i]:=0;
 NTT(n,U,eps); NTT(n,V,eps);
 for i:=0 to n-1 do U[i]:=int64(U[i])*V[i]mod p;
 NTT(n,U,eps_inv);
 inv:=pw(n,p-2);
 for i:=0 to n-1 do U[i]:=(int64(U[i])*inv mod p+p)mod p;
 for i:=0 to n-2 do
 begin inc(U[i+1],U[i]div 10); U[i]:=U[i]mod 10 end;
 while (n>0)and(U[n-1]=0) do dec(n);
 c.n:=n;
 setlength(c.a,n);
 for i:=0 to n-1 do c.a[i]:=U[i];
end;

{
 procedure Inverse(deg:longint;var a,b:NumFP);
 var
  n,i,inv:longint;
  c:NumFP;
 begin
  if deg=1 then begin b[0]:=pw(a[0],p-2); exit end;
  Inverse((deg+1)>>1,a,b);
  n:=1; while n<deg<<1 do n:=n<<1;
  setlength(c,n);
  for i:=0 to deg-1 do c[i]:=a[i];
  for i:=deg to n-1 do c[i]:=0;
  NTT(n,c,eps);
  NTT(n,b,eps);
  for i:=0 to n-1 do b[i]:=(2-int64(c[i])*b[i])mod p*b[i]mod p;
  NTT(n,b,eps_inv);
  inv:=pw(n,p-2);
  for i:=0 to n-1 do b[i]:=b[i]*int64(inv)mod p;
  for i:=deg to n-1 do b[i]:=0
 end;

operator div(const a,b:BigInteger)c:BigInteger;
var
 n,m,i:longint;
 A0,B0:NumFP;
begin
 if b=0 then begin write('BigInteger Div 0!'); halt end;
 if (a=0)or(BigInteger_abs(a)<BigInteger_abs(b)) then begin c:=0; exit end;
 c.sign:=a.sign*b.sign;
 m:=a.n-b.n+1; n:=init(m);
 setlength(A0,n); for i:=0 to n-1 do A0[i]:=0;
 setlength(B0,n); for i:=0 to n-1 do B0[i]:=0;
 for i:=0 to b.n-1 do A0[i]:=B.a[b.n-1-i];
 Inverse(m,A0,B0);
 for i:=m to n-1 do B0[i]:=0;
 NTT(n,B0,eps);
 for i:=0 to   n-1 do A0[i]:=0;
 for i:=0 to a.n-1 do A0[i]:=A.a[a.n-1-i];
 NTT(n,A0,eps);
 for i:=0 to n-1 do A0[i]:=int64(A0[i])*B0[i]mod p;
 NTT(n,A0,eps_inv);
 c.n:=m;
 setlength(c.a,m);
 for i:=0 to m-1 do c.a[m-1-i]:=(A0[i]mod p+p)mod p;

end;
}

operator *(const a:BigInteger;b:longint)c:BigInteger;
var i,t:longint;
begin
 if (a.sign=0)or(b=0) then exit(0);
 c.sign:=a.sign;
 if b<0 then begin b:=-b; c.sign:=-c.sign end;
 c.n:=a.n;
 setlength(c.a,c.n+30);
 t:=0;
 for i:=0 to a.n-1 do
 begin
  c.a[i]:=a.a[i]*b+t;
       t:=c.a[i]div 10;
  c.a[i]:=c.a[i]mod 10
 end;
 while t>0 do
 begin
  c.a[c.n]:=t mod 10;
         t:=t div 10;
  inc(c.n)
 end;
 setlength(c.a,c.n)
end;

function BigInteger_abs(const a:BigInteger):BigInteger;
var i:longint; b:BigInteger;
begin
 b.sign:=abs(a.sign);
 b.n:=a.n;
 setlength(b.a,b.n);
 for i:=0 to b.n-1 do b.a[i]:=a.a[i];
 exit(b)
end;

function BigInteger_copy(const a:BigInteger;l,r:longint):BigInteger;
var i:longint; b:BigInteger;
begin
 b.sign:=a.sign;
 b.n:=r-l+1;
 setlength(b.a,b.n);
 for i:=l to min(r,a.n-1) do b.a[i-l]:=a.a[i];
 for i:=i+1 to r do b.a[i-l]:=0;
 while (b.n>0)and(b.a[b.n-1]=0) do dec(b.n);
 if b.n=0 then exit(0);
 exit(b)
end;

function BigInteger_move(const a:BigInteger;x:longint):BigInteger;
var i:longint; b:BigInteger;
begin
 if a=0 then exit(0);
 if x>=0 then
  begin
   b.sign:=a.sign;
   b.n:=a.n+x;
   setlength(b.a,b.n);
   for i:=0 to x-1 do b.a[i]:=0;
   for i:=0 to a.n-1 do b.a[i+x]:=a.a[i]
  end
 else
  begin
   if a.n<=x then exit(0);
   b.sign:=a.sign;
   b.n:=a.n-x;
   setlength(b.a,b.n);
   for i:=0 to b.n-1 do b.a[i]:=a.a[i+x]
  end;
 exit(b)
end;

procedure Division(const a,b:BigInteger;var c,d:BigInteger);
var i,l,r,mid:longint;
begin
 c:=0;
 d:=0;
 for i:=a.n-1 downto 0 do
 begin
  d:=BigInteger_move(d,1)+a.a[i];
  c:=BigInteger_move(c,1);
  while d>=b do
  begin
   d:=d-b;
   c:=c+1
  end
 end
end;

operator div(const a,b:BigInteger)c:BigInteger;
var d:BigInteger;
begin
 if b.sign=0 then begin write('BigInteger Div 0!'); halt end;
 Division(a,b,c,d)
end;

operator mod(const a,b:BigInteger)d:BigInteger;
var c:BigInteger;
begin
 if b.sign=0 then begin write('BigInteger Div 0!'); halt end;
 Division(a,b,c,d)
end;

begin
end.
