package.preload['lunajson._str_lib']=(function(...)
local e=math.huge
local u,h,l=string.byte,string.char,string.sub
local a=setmetatable
local o=math.floor
local t=nil
local t={
0,1,2,3,4,5,6,7,8,9,e,e,e,e,e,e,
e,10,11,12,13,14,15,e,e,e,e,e,e,e,e,e,
e,e,e,e,e,e,e,e,e,e,e,e,e,e,e,e,
e,10,11,12,13,14,15,e,e,e,e,e,e,e,e,e,
}
t.__index=function()
return e
end
a(t,t)
return function(r)
local s={
['"']='"',
['\\']='\\',
['/']='/',
['b']='\b',
['f']='\f',
['n']='\n',
['r']='\r',
['t']='\t'
}
s.__index=function()
r("invalid escape sequence")
end
a(s,s)
local a=0
local function c(d,n)
local i
if d=='u'then
local u,d,c,s=u(n,1,4)
local t=t[u-47]*4096+t[d-47]*256+t[c-47]*16+t[s-47]
if t==e then
r("invalid unicode charcode")
end
n=l(n,5)
if t<128 then
i=h(t)
elseif t<2048 then
i=h(192+o(t*.015625),128+t%64)
elseif t<55296 or 57344<=t then
i=h(224+o(t*.000244140625),128+o(t*.015625)%64,128+t%64)
elseif 55296<=t and t<56320 then
if a==0 then
a=t
if n==''then
return''
end
end
else
if a==0 then
a=1
else
t=65536+(a-55296)*1024+(t-56320)
a=0
i=h(240+o(t*3814697265625e-18),128+o(t*.000244140625)%64,128+o(t*.015625)%64,128+t%64)
end
end
end
if a~=0 then
r("invalid surrogate pair")
end
return(i or s[d])..n
end
local function e()
return a==0
end
return{
subst=c,
surrogateok=e
}
end
end)
package.preload['lunajson.decoder']=(function(...)
local w=error
local s,e,h,f,l,u=string.byte,string.char,string.find,string.gsub,string.match,string.sub
local r=tonumber
local n,y=tostring,setmetatable
local m
if _VERSION=="Lua 5.3"then
m=require'lunajson._str_lib_lua53'
else
m=require'lunajson._str_lib'
end
local e=nil
local function k()
local a,t,p,v
local d,o
local function i(e)
w("parse error at "..t..": "..e)
end
local function e()
i('invalid value')
end
local function g()
if u(a,t,t+2)=='ull'then
t=t+3
return p
end
i('invalid value')
end
local function k()
if u(a,t,t+3)=='alse'then
t=t+4
return false
end
i('invalid value')
end
local function q()
if u(a,t,t+2)=='rue'then
t=t+3
return true
end
i('invalid value')
end
local n=l(n(.5),'[^0-9]')
local c=r
if n~='.'then
if h(n,'%W')then
n='%'..n
end
c=function(e)
return r(f(e,'.',n))
end
end
local function n()
i('invalid number')
end
local function b(h)
local i=t
local e
local o=s(a,i)
if not o then
return n()
end
if o==46 then
e=l(a,'^.[0-9]*',t)
local e=#e
if e==1 then
return n()
end
i=t+e
o=s(a,i)
end
if o==69 or o==101 then
local a=l(a,'^[^eE]*[eE][-+]?[0-9]+',t)
if not a then
return n()
end
if e then
e=a
end
i=t+#a
end
t=i
if e then
e=c(e)
else
e=0
end
if h then
e=-e
end
return e
end
local function r(h)
t=t-1
local e=l(a,'^.[0-9]*%.?[0-9]*',t)
if s(e,-1)==46 then
return n()
end
local o=t+#e
local i=s(a,o)
if i==69 or i==101 then
e=l(a,'^[^eE]*[eE][-+]?[0-9]+',t)
if not e then
return n()
end
o=t+#e
end
t=o
e=c(e)-0
if h then
e=-e
end
return e
end
local function j()
local e=s(a,t)
if e then
t=t+1
if e>48 then
if e<58 then
return r(true)
end
else
if e>47 then
return b(true)
end
end
end
i('invalid number')
end
local n=m(i)
local x=n.surrogateok
local m=n.subst
local c=y({},{__mode="v"})
local function l(r)
local e=t-2
local o=t
local d,n
repeat
e=h(a,'"',o,true)
if not e then
i("unterminated string")
end
o=e+1
while true do
d,n=s(a,e-2,e-1)
if n~=92 or d~=92 then
break
end
e=e-2
end
until n~=92
local a=u(a,t,o-2)
t=o
if r then
local e=c[a]
if e then
return e
end
end
local e=a
if h(e,'\\',1,true)then
e=f(e,'\\(.)([^\\]*)',m)
if not x()then
i("invalid surrogate pair")
end
end
if r then
c[a]=e
end
return e
end
local function c()
local r={}
o,t=h(a,'^[ \n\r\t]*',t)
t=t+1
local n=0
if s(a,t)~=93 then
local e=t-1
repeat
n=n+1
o=d[s(a,e+1)]
t=e+2
r[n]=o()
o,e=h(a,'^[ \n\r\t]*,[ \n\r\t]*',t)
until not e
o,e=h(a,'^[ \n\r\t]*%]',t)
if not e then
i("no closing bracket of an array")
end
t=e
end
t=t+1
if v then
r[0]=n
end
return r
end
local function u()
local r={}
o,t=h(a,'^[ \n\r\t]*',t)
t=t+1
if s(a,t)~=125 then
local n=t-1
repeat
t=n+1
if s(a,t)~=34 then
i("not key")
end
t=t+1
local l=l(true)
o=e
do
local i,e,a=s(a,t,t+3)
if i==58 then
n=t
if e==32 then
n=n+1
e=a
end
o=d[e]
end
end
if o==e then
o,n=h(a,'^[ \n\r\t]*:[ \n\r\t]*',t)
if not n then
i("no colon after a key")
end
end
o=d[s(a,n+1)]
t=n+2
r[l]=o()
o,n=h(a,'^[ \n\r\t]*,[ \n\r\t]*',t)
until not n
o,n=h(a,'^[ \n\r\t]*}',t)
if not n then
i("no closing bracket of an object")
end
t=n
end
t=t+1
return r
end
d={
e,e,e,e,e,e,e,e,e,e,e,e,e,e,e,
e,e,e,e,e,e,e,e,e,e,e,e,e,e,e,e,
e,e,l,e,e,e,e,e,e,e,e,e,e,j,e,e,
b,r,r,r,r,r,r,r,r,r,e,e,e,e,e,e,
e,e,e,e,e,e,e,e,e,e,e,e,e,e,e,e,
e,e,e,e,e,e,e,e,e,e,e,c,e,e,e,e,
e,e,e,e,e,e,k,e,e,e,e,e,e,e,g,e,
e,e,e,e,q,e,e,e,e,e,e,u,e,e,e,e,
}
d[0]=e
d.__index=function()
i("unexpected termination")
end
y(d,d)
local function r(r,e,n,i)
a,t,p,v=r,e,n,i
t=t or 1
o,t=h(a,'^[ \n\r\t]*',t)
t=t+1
o=d[s(a,t)]
t=t+1
local i=o()
if e then
return i,t
else
o,t=h(a,'^[ \n\r\t]*',t)
if t~=#a then
w('json ended')
end
return i
end
end
return r
end
return k
end)
package.preload['lunajson.encoder']=(function(...)
local h=error
local v,r,f,d,i=string.byte,string.find,string.format,string.gsub,string.match
local p=table.concat
local o=tostring
local b,l=pairs,type
local m=setmetatable
local k,g=1/0,-1/0
local s
if _VERSION=="Lua 5.1"then
s='[^ -!#-[%]^-\255]'
else
s='[\0-\31"\\]'
end
local e=nil
local function q()
local u,c
local e,t,n
local function y(a)
t[e]=o(a)
e=e+1
end
local a=i(o(.5),'[^0-9]')
local o=i(o(12345.12345),'[^0-9'..a..']')
if a=='.'then
a=nil
end
local w
if a or o then
w=true
if a and r(a,'%W')then
a='%'..a
end
if o and r(o,'%W')then
o='%'..o
end
end
local w=function(i)
if g<i and i<k then
local i=f("%.17g",i)
if w then
if o then
i=d(i,o,'')
end
if a then
i=d(i,a,'.')
end
end
t[e]=i
e=e+1
return
end
h('invalid number')
end
local i
local o={
['"']='\\"',
['\\']='\\\\',
['\b']='\\b',
['\f']='\\f',
['\n']='\\n',
['\r']='\\r',
['\t']='\\t',
__index=function(t,e)
return f('\\u00%02X',v(e))
end
}
m(o,o)
local function f(a)
t[e]='"'
if r(a,s)then
a=d(a,s,o)
end
t[e+1]=a
t[e+2]='"'
e=e+3
end
local function s(o)
if n[o]then
h("loop detected")
end
n[o]=true
local a=o[0]
if l(a)=='number'then
t[e]='['
e=e+1
for a=1,a do
i(o[a])
t[e]=','
e=e+1
end
if a>0 then
e=e-1
end
t[e]=']'
else
a=o[1]
if a~=nil then
t[e]='['
e=e+1
local n=2
repeat
i(a)
a=o[n]
if a==nil then
break
end
n=n+1
t[e]=','
e=e+1
until false
t[e]=']'
else
t[e]='{'
e=e+1
local n=e
for a,o in b(o)do
if l(a)~='string'then
h("non-string key")
end
f(a)
t[e]=':'
e=e+1
i(o)
t[e]=','
e=e+1
end
if e>n then
e=e-1
end
t[e]='}'
end
end
e=e+1
n[o]=nil
end
local a={
boolean=y,
number=w,
string=f,
table=s,
__index=function()
h("invalid type value")
end
}
m(a,a)
function i(o)
if o==c then
t[e]='null'
e=e+1
return
end
return a[l(o)](o)
end
local function o(o,a)
u,c=o,a
e,t,n=1,{},{}
i(u)
return p(t)
end
return o
end
return q
end)
package.preload['lunajson.sax']=(function(...)
local q=error
local i,S,l,k,f,u=string.byte,string.char,string.find,string.gsub,string.match,string.sub
local j=tonumber
local N,r,_=tostring,type,table.unpack or unpack
local p
if _VERSION=="Lua 5.3"then
p=require'lunajson._str_lib_lua53'
else
p=require'lunajson._str_lib'
end
local e=nil
local function e()end
local function g(s,n)
local a,d
local o,t,y=0,1,0
local m,h
if r(s)=='string'then
a=s
o=#a
d=function()
a=''
o=0
d=e
end
else
d=function()
y=y+o
t=1
repeat
a=s()
if not a then
a=''
o=0
d=e
return
end
o=#a
until o>0
end
d()
end
local z=n.startobject or e
local E=n.key or e
local A=n.endobject or e
local T=n.startarray or e
local O=n.endarray or e
local I=n.string or e
local v=n.number or e
local r=n.boolean or e
local w=n.null or e
local function b()
local e=i(a,t)
if not e then
d()
e=i(a,t)
end
return e
end
local function n(e)
q("parse error at "..y+t..": "..e)
end
local function x()
return b()or n("unexpected termination")
end
local function s()
while true do
h,t=l(a,'^[ \n\r\t]*',t)
if t~=o then
t=t+1
return
end
if o==0 then
n("unexpected termination")
end
d()
end
end
local function e()
n('invalid value')
end
local function c(a,e,s,o)
for e=1,e do
local o=x()
if i(a,e)~=o then
n("invalid char")
end
t=t+1
end
return o(s)
end
local function R()
if u(a,t,t+2)=='ull'then
t=t+3
return w(nil)
end
return c('ull',3,nil,w)
end
local function D()
if u(a,t,t+3)=='alse'then
t=t+4
return r(false)
end
return c('alse',4,false,r)
end
local function H()
if u(a,t,t+2)=='rue'then
t=t+3
return r(true)
end
return c('rue',3,true,r)
end
local r=f(N(.5),'[^0-9]')
local w=j
if r~='.'then
if l(r,'%W')then
r='%'..r
end
w=function(e)
return j(k(e,'.',r))
end
end
local function c(h)
local s={}
local o=1
local e=i(a,t)
t=t+1
local function a()
s[o]=e
o=o+1
e=b()
t=t+1
end
if e==48 then
a()
else
repeat a()until not(e and 48<=e and e<58)
end
if e==46 then
a()
if not(e and 48<=e and e<58)then
n('invalid number')
end
repeat a()until not(e and 48<=e and e<58)
end
if e==69 or e==101 then
a()
if e==43 or e==45 then
a()
end
if not(e and 48<=e and e<58)then
n('invalid number')
end
repeat a()until not(e and 48<=e and e<58)
end
t=t-1
local e=S(_(s))
e=w(e)-0
if h then
e=-e
end
return v(e)
end
local function g(h)
local n=t
local e
local s=i(a,n)
if s==46 then
e=f(a,'^.[0-9]*',t)
local e=#e
if e==1 then
t=t-1
return c(h)
end
n=t+e
s=i(a,n)
end
if s==69 or s==101 then
local a=f(a,'^[^eE]*[eE][-+]?[0-9]+',t)
if not a then
t=t-1
return c(h)
end
if e then
e=a
end
n=t+#a
end
if n>o then
t=t-1
return c(h)
end
t=n
if e then
e=w(e)
else
e=0
end
if h then
e=-e
end
return v(e)
end
local function r(n)
t=t-1
local e=f(a,'^.[0-9]*%.?[0-9]*',t)
if i(e,-1)==46 then
return c(n)
end
local s=t+#e
local i=i(a,s)
if i==69 or i==101 then
e=f(a,'^[^eE]*[eE][-+]?[0-9]+',t)
if not e then
return c(n)
end
s=t+#e
end
if s>o then
return c(n)
end
t=s
e=w(e)-0
if n then
e=-e
end
return v(e)
end
local function v()
local e=i(a,t)or x()
if e then
t=t+1
if e>48 then
if e<58 then
return r(true)
end
else
if e>47 then
return g(true)
end
end
end
n("invalid number")
end
local c=p(n)
local w=c.surrogateok
local f=c.subst
local function c(c)
local h=t
local s
local e=''
local r
while true do
while true do
s=l(a,'[\\"]',h)
if s then
break
end
e=e..u(a,t,o)
if h==o+2 then
h=2
else
h=1
end
d()
end
if i(a,s)==34 then
break
end
h=s+2
r=true
end
e=e..u(a,t,s-1)
t=s+1
if r then
e=k(e,'\\(.)([^\\]*)',f)
if not w()then
n("invalid surrogate pair")
end
end
if c then
return E(e)
end
return I(e)
end
local function w()
T()
s()
if i(a,t)~=93 then
local e
while true do
h=m[i(a,t)]
t=t+1
h()
h,e=l(a,'^[ \n\r\t]*,[ \n\r\t]*',t)
if not e then
h,e=l(a,'^[ \n\r\t]*%]',t)
if e then
t=e
break
end
s()
local a=i(a,t)
if a==44 then
t=t+1
s()
e=t-1
elseif a==93 then
break
else
n("no closing bracket of an array")
end
end
t=e+1
if t>o then
s()
end
end
end
t=t+1
return O()
end
local function f()
z()
s()
if i(a,t)~=125 then
local e
while true do
if i(a,t)~=34 then
n("not key")
end
t=t+1
c(true)
h,e=l(a,'^[ \n\r\t]*:[ \n\r\t]*',t)
if not e then
s()
if i(a,t)~=58 then
n("no colon after a key")
end
t=t+1
s()
e=t-1
end
t=e+1
if t>o then
s()
end
h=m[i(a,t)]
t=t+1
h()
h,e=l(a,'^[ \n\r\t]*,[ \n\r\t]*',t)
if not e then
h,e=l(a,'^[ \n\r\t]*}',t)
if e then
t=e
break
end
s()
local a=i(a,t)
if a==44 then
t=t+1
s()
e=t-1
elseif a==125 then
break
else
n("no closing bracket of an object")
end
end
t=e+1
if t>o then
s()
end
end
end
t=t+1
return A()
end
m={
e,e,e,e,e,e,e,e,e,e,e,e,e,e,e,
e,e,e,e,e,e,e,e,e,e,e,e,e,e,e,e,
e,e,c,e,e,e,e,e,e,e,e,e,e,v,e,e,
g,r,r,r,r,r,r,r,r,r,e,e,e,e,e,e,
e,e,e,e,e,e,e,e,e,e,e,e,e,e,e,e,
e,e,e,e,e,e,e,e,e,e,e,w,e,e,e,e,
e,e,e,e,e,e,D,e,e,e,e,e,e,e,R,e,
e,e,e,e,H,e,e,e,e,e,e,f,e,e,e,e,
}
m[0]=e
local function n()
s()
h=m[i(a,t)]
t=t+1
h()
end
local function s(e)
if e<0 then
q("the argument must be non-negative")
end
local e=(t-1)+e
local i=u(a,t,e)
while e>o and o~=0 do
d()
e=e-(o-(t-1))
i=i..u(a,t,e)
end
if o~=0 then
t=e+1
end
return i
end
local function e()
return y+t
end
return{
run=n,
tryc=b,
read=s,
tellpos=e,
}
end
local function a(e,o)
local e=io.open(e)
local function a()
local t
if e then
t=e:read(8192)
if not t then
e:close()
e=nil
end
end
return t
end
return g(a,o)
end
return{
newparser=g,
newfileparser=a
}
end)
package.preload['lunajson']=(function(...)
local t=require'lunajson.decoder'
local a=require'lunajson.encoder'
local e=require'lunajson.sax'
return{
decode=t(),
encode=a(),
newparser=e.newparser,
newfileparser=e.newfileparser,
}
end)
package.preload['slaxml']=(function(...)
local w={
VERSION="0.7",
_call={
pi=function(t,e)
print(string.format("<?%s %s?>",t,e))
end,
comment=function(e)
print(string.format("<!-- %s -->",e))
end,
startElement=function(a,e,t)
io.write("<")
if t then io.write(t,":")end
io.write(a)
if e then io.write(" (ns='",e,"')")end
print(">")
end,
attribute=function(o,a,t,e)
io.write('  ')
if e then io.write(e,":")end
io.write(o,'=',string.format('%q',a))
if t then io.write(" (ns='",t,"')")end
io.write("\n")
end,
text=function(e)
print(string.format("  text: %q",e))
end,
closeElement=function(e,t,t)
print(string.format("</%s>",e))
end,
}
}
function w:parser(e)
return{_call=e or self._call,parse=w.parse}
end
function w:parse(s,y)
if not y then y={stripWhitespace=false}end
local r,q,p,l,z,g,b=string.find,string.sub,string.gsub,string.char,table.insert,table.remove,table.concat
local t,a,o,i,e,w,m
local v=unpack or table.unpack
local e=1
local f="text"
local d=1
local h={}
local u={}
local c
local n={}
local k=false
local x={{2047,192},{65535,224},{2097151,240}}
local function j(e)
if e<128 then return l(e)end
local t={}
for o,a in ipairs(x)do
if e<=a[1]then
for o=o+1,2,-1 do
local a=e%64
e=(e-a)/64
t[o]=l(128+a)
end
t[1]=l(a[2]+e)
return b(t)
end
end
end
local l={["lt"]="<",["gt"]=">",["amp"]="&",["quot"]='"',["apos"]="'"}
local l=function(a,t,e)return l[e]or t=="#"and j(tonumber('0'..e))or a end
local function b(e)return p(e,'(&(#?)([%d%a]+);)',l)end
local function l()
if t>d and self._call.text then
local e=q(s,d,t-1)
if y.stripWhitespace then
e=p(e,'^%s+','')
e=p(e,'%s+$','')
if#e==0 then e=nil end
end
if e then self._call.text(b(e))end
end
end
local function _()
t,a,o,i=r(s,'^<%?([:%a_][:%w_.-]*) ?(.-)%?>',e)
if t then
l()
if self._call.pi then self._call.pi(o,i)end
e=a+1
d=e
return true
end
end
local function j()
t,a,o=r(s,'^<!%-%-(.-)%-%->',e)
if t then
l()
if self._call.comment then self._call.comment(o)end
e=a+1
d=e
return true
end
end
local function y(e)
if e=='xml'then return'http://www.w3.org/XML/1998/namespace'end
for t=#n,1,-1 do if n[t][e]then return n[t][e]end end
error(("Cannot find namespace for prefix %s"):format(e))
end
local function x()
k=true
t,a,o=r(s,'^<([%a_][%w_.-]*)',e)
if t then
h[2]=nil
h[3]=nil
l()
e=a+1
t,a,i=r(s,'^:([%a_][%w_.-]*)',e)
if t then
h[1]=i
h[3]=o
o=i
e=a+1
else
h[1]=o
for e=#n,1,-1 do if n[e]['!']then h[2]=n[e]['!'];break end end
end
c=0
z(n,{})
return true
end
end
local function q()
t,a,o=r(s,'^%s+([:%a_][:%w_.-]*)%s*=%s*',e)
if t then
w=a+1
t,a,i=r(s,'^"([^<"]*)"',w)
if t then
e=a+1
i=b(i)
else
t,a,i=r(s,"^'([^<']*)'",w)
if t then
e=a+1
i=b(i)
end
end
end
if o and i then
local t={o,i}
local e,a=string.match(o,'^([^:]+):([^:]+)$')
if e then
if e=='xmlns'then
n[#n][a]=i
else
t[1]=a
t[4]=e
end
else
if o=='xmlns'then
n[#n]['!']=i
h[2]=i
end
end
c=c+1
u[c]=t
return true
end
end
local function p()
t,a,o=r(s,'^<!%[CDATA%[(.-)%]%]>',e)
if t then
l()
if self._call.text then self._call.text(o)end
e=a+1
d=e
return true
end
end
local function w()
t,a,o=r(s,'^%s*(/?)>',e)
if t then
f="text"
e=a+1
d=e
if h[3]then h[2]=y(h[3])end
if self._call.startElement then self._call.startElement(v(h))end
if self._call.attribute then
for e=1,c do
if u[e][4]then u[e][3]=y(u[e][4])end
self._call.attribute(v(u[e]))
end
end
if o=="/"then
g(n)
if self._call.closeElement then self._call.closeElement(v(h))end
end
return true
end
end
local function h()
t,a,o,i=r(s,'^</([%a_][%w_.-]*)%s*>',e)
if t then
m=nil
for e=#n,1,-1 do if n[e]['!']then m=n[e]['!'];break end end
else
t,a,i,o=r(s,'^</([%a_][%w_.-]*):([%a_][%w_.-]*)%s*>',e)
if t then m=y(i)end
end
if t then
l()
if self._call.closeElement then self._call.closeElement(o,m)end
e=a+1
d=e
g(n)
return true
end
end
while e<#s do
if f=="text"then
if not(_()or j()or p()or h())then
if x()then
f="attributes"
else
t,a=r(s,'^[^<]+',e)
e=(t and a or e)+1
end
end
elseif f=="attributes"then
if not q()then
if not w()then
error("Was in an element and couldn't find attributes or the close.")
end
end
end
end
if not k then error("Parsing did not discover any elements")end
if#n>0 then error("Parsing ended with unclosed elements")end
end
return w
end)
package.preload['pure-xml-dump']=(function(...)
local c,a,o,n,
e,u=
ipairs,pairs,table.insert,type,
string.match,tostring
local function h(e)
if n(e)=='boolean'then
return e and'true'or'false'
else
return e:gsub('&','&amp;'):gsub('>','&gt;'):gsub('<','&lt;'):gsub("'",'&apos;')
end
end
local function r(e)
local t=e.xml or'table'
for e,a in a(e)do
if e~='xml'and n(e)=='string'then
t=t..' '..e.."='"..h(a).."'"
end
end
return t
end
local function d(a,i,t,e,l,s)
if l>s then
error(string.format("Could not dump table to XML. Maximal depth of %i reached.",s))
end
if a[1]then
o(t,(e=='n'and i or'')..'<'..r(a)..'>')
e='n'
local r=i..'  '
for i,a in c(a)do
local i=n(a)
if i=='table'then
d(a,r,t,e,l+1,s)
e='n'
elseif i=='number'then
o(t,u(a))
else
local a=h(a)
o(t,a)
e='s'
end
end
o(t,(e=='n'and i or'')..'</'..(a.xml or'table')..'>')
e='n'
else
o(t,(e=='n'and i or'')..'<'..r(a)..'/>')
e='n'
end
end
local function a(t,e)
local a=e or 3e3
local e={}
d(t,'\n',e,'s',1,a)
return table.concat(e,'')
end
return a
end)
package.preload['pure-xml-load']=(function(...)
local i=require'slaxml'
local o={}
local e={o}
local t={}
local a=function(i,a,o)
local o=e[#e]
if a~=t[#t]then
t[#t+1]=a
else
a=nil
end
o[#o+1]={xml=i,xmlns=a}
e[#e+1]=o[#o]
end
local n=function(t,a)
local e=e[#e]
e[t]=a
end
local s=function(o,a)
table.remove(e)
if a~=t[#t]then
t[#t]=nil
end
end
local h=function(t)
local e=e[#e]
e[#e+1]=t
end
local i=i:parser{
startElement=a,
attribute=n,
closeElement=s,
text=h
}
local function a(a)
o={}
e={o}
t={}
i:parse(a,{stripWhitespace=true})
return select(2,next(o))
end
return a
end)
package.preload['resty.prettycjson']=(function(...)
local a=require"cjson.safe".encode
local n=table.concat
local c=string.sub
local d=string.rep
return function(t,r,i,l,e)
local t,e=(e or a)(t)
if not t then return t,e end
r,i,l=r or"\n",i or"\t",l or" "
local e,a,u,m,o,h,s=1,0,0,#t,{},nil,nil
local f=c(l,-1)=="\n"
for m=1,m do
local t=c(t,m,m)
if not s and(t=="{"or t=="[")then
o[e]=h==":"and n{t,r}or n{d(i,a),t,r}
a=a+1
elseif not s and(t=="}"or t=="]")then
a=a-1
if h=="{"or h=="["then
e=e-1
o[e]=n{d(i,a),h,t}
else
o[e]=n{r,d(i,a),t}
end
elseif not s and t==","then
o[e]=n{t,r}
u=-1
elseif not s and t==":"then
o[e]=n{t,l}
if f then
e=e+1
o[e]=d(i,a)
end
else
if t=='"'and h~="\\"then
s=not s and true or nil
end
if a~=u then
o[e]=d(i,a)
e,u=e+1,a
end
o[e]=t
end
h,e=t,e+1
end
return n(o)
end
end)
do local t={};
t["fhir-data/fhir-elements.json"]="[\
	{\
		\"min\": \"0\",\
		\"path\": \"integer\",\
		\"weight\": 1,\
		\"max\": \"*\",\
		\"type\": \"Element\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"integer.id\",\
		\"weight\": 2,\
		\"max\": \"1\",\
		\"type\": \"id\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"integer.extension\",\
		\"weight\": 3,\
		\"max\": \"*\",\
		\"type\": \"Extension\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"integer.value\",\
		\"type_xml\": \"int\",\
		\"weight\": 4,\
		\"max\": \"1\",\
		\"type_json\": \"number\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"dateTime\",\
		\"weight\": 5,\
		\"max\": \"*\",\
		\"type\": \"Element\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"dateTime.id\",\
		\"weight\": 6,\
		\"max\": \"1\",\
		\"type\": \"id\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"dateTime.extension\",\
		\"weight\": 7,\
		\"max\": \"*\",\
		\"type\": \"Extension\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"dateTime.value\",\
		\"type_xml\": \"xs:gYear, xs:gYearMonth, xs:date, xs:dateTime\",\
		\"weight\": 8,\
		\"max\": \"1\",\
		\"type_json\": \"string\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"date\",\
		\"weight\": 9,\
		\"max\": \"*\",\
		\"type\": \"Element\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"date.id\",\
		\"weight\": 10,\
		\"max\": \"1\",\
		\"type\": \"id\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"date.extension\",\
		\"weight\": 11,\
		\"max\": \"*\",\
		\"type\": \"Extension\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"date.value\",\
		\"type_xml\": \"xs:gYear, xs:gYearMonth, xs:date\",\
		\"weight\": 12,\
		\"max\": \"1\",\
		\"type_json\": \"string\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"decimal\",\
		\"weight\": 13,\
		\"max\": \"*\",\
		\"type\": \"Element\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"decimal.id\",\
		\"weight\": 14,\
		\"max\": \"1\",\
		\"type\": \"id\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"decimal.extension\",\
		\"weight\": 15,\
		\"max\": \"*\",\
		\"type\": \"Extension\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"decimal.value\",\
		\"type_xml\": \"decimal\",\
		\"weight\": 16,\
		\"max\": \"1\",\
		\"type_json\": \"number\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"uri\",\
		\"weight\": 17,\
		\"max\": \"*\",\
		\"type\": \"Element\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"uri.id\",\
		\"weight\": 18,\
		\"max\": \"1\",\
		\"type\": \"id\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"uri.extension\",\
		\"weight\": 19,\
		\"max\": \"*\",\
		\"type\": \"Extension\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"uri.value\",\
		\"type_xml\": \"anyURI\",\
		\"weight\": 20,\
		\"max\": \"1\",\
		\"type_json\": \"string\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"base64Binary\",\
		\"weight\": 21,\
		\"max\": \"*\",\
		\"type\": \"Element\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"base64Binary.id\",\
		\"weight\": 22,\
		\"max\": \"1\",\
		\"type\": \"id\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"base64Binary.extension\",\
		\"weight\": 23,\
		\"max\": \"*\",\
		\"type\": \"Extension\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"base64Binary.value\",\
		\"type_xml\": \"base64Binary\",\
		\"weight\": 24,\
		\"max\": \"1\",\
		\"type_json\": \"string\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"time\",\
		\"weight\": 25,\
		\"max\": \"*\",\
		\"type\": \"Element\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"time.id\",\
		\"weight\": 26,\
		\"max\": \"1\",\
		\"type\": \"id\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"time.extension\",\
		\"weight\": 27,\
		\"max\": \"*\",\
		\"type\": \"Extension\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"time.value\",\
		\"type_xml\": \"time\",\
		\"weight\": 28,\
		\"max\": \"1\",\
		\"type_json\": \"string\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"string\",\
		\"weight\": 29,\
		\"max\": \"*\",\
		\"type\": \"Element\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"string.id\",\
		\"weight\": 30,\
		\"max\": \"1\",\
		\"type\": \"id\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"string.extension\",\
		\"weight\": 31,\
		\"max\": \"*\",\
		\"type\": \"Extension\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"string.value\",\
		\"type_xml\": \"string\",\
		\"weight\": 32,\
		\"max\": \"1\",\
		\"type_json\": \"string\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"boolean\",\
		\"weight\": 33,\
		\"max\": \"*\",\
		\"type\": \"Element\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"boolean.id\",\
		\"weight\": 34,\
		\"max\": \"1\",\
		\"type\": \"id\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"boolean.extension\",\
		\"weight\": 35,\
		\"max\": \"*\",\
		\"type\": \"Extension\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"boolean.value\",\
		\"type_xml\": \"boolean\",\
		\"weight\": 36,\
		\"max\": \"1\",\
		\"type_json\": \"true | false\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"instant\",\
		\"weight\": 37,\
		\"max\": \"*\",\
		\"type\": \"Element\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"instant.id\",\
		\"weight\": 38,\
		\"max\": \"1\",\
		\"type\": \"id\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"instant.extension\",\
		\"weight\": 39,\
		\"max\": \"*\",\
		\"type\": \"Extension\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"instant.value\",\
		\"type_xml\": \"dateTime\",\
		\"weight\": 40,\
		\"max\": \"1\",\
		\"type_json\": \"string\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Period\",\
		\"weight\": 41,\
		\"max\": \"*\",\
		\"type\": \"Element\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Period.id\",\
		\"weight\": 42,\
		\"max\": \"1\",\
		\"type\": \"id\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Period.extension\",\
		\"weight\": 43,\
		\"max\": \"*\",\
		\"type\": \"Extension\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Period.start\",\
		\"weight\": 44,\
		\"max\": \"1\",\
		\"type\": \"dateTime\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Period.end\",\
		\"weight\": 45,\
		\"max\": \"1\",\
		\"type\": \"dateTime\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Coding\",\
		\"weight\": 46,\
		\"max\": \"*\",\
		\"type\": \"Element\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Coding.id\",\
		\"weight\": 47,\
		\"max\": \"1\",\
		\"type\": \"id\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Coding.extension\",\
		\"weight\": 48,\
		\"max\": \"*\",\
		\"type\": \"Extension\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Coding.system\",\
		\"weight\": 49,\
		\"max\": \"1\",\
		\"type\": \"uri\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Coding.version\",\
		\"weight\": 50,\
		\"max\": \"1\",\
		\"type\": \"string\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Coding.code\",\
		\"weight\": 51,\
		\"max\": \"1\",\
		\"type\": \"code\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Coding.display\",\
		\"weight\": 52,\
		\"max\": \"1\",\
		\"type\": \"string\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Coding.userSelected\",\
		\"weight\": 53,\
		\"max\": \"1\",\
		\"type\": \"boolean\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Range\",\
		\"weight\": 54,\
		\"max\": \"*\",\
		\"type\": \"Element\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Range.id\",\
		\"weight\": 55,\
		\"max\": \"1\",\
		\"type\": \"id\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Range.extension\",\
		\"weight\": 56,\
		\"max\": \"*\",\
		\"type\": \"Extension\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Range.low\",\
		\"weight\": 57,\
		\"max\": \"1\",\
		\"type\": \"Quantity\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Range.high\",\
		\"weight\": 58,\
		\"max\": \"1\",\
		\"type\": \"Quantity\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Quantity\",\
		\"weight\": 59,\
		\"max\": \"*\",\
		\"type\": \"Element\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Quantity.id\",\
		\"weight\": 60,\
		\"max\": \"1\",\
		\"type\": \"id\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Quantity.extension\",\
		\"weight\": 61,\
		\"max\": \"*\",\
		\"type\": \"Extension\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Quantity.value\",\
		\"weight\": 62,\
		\"max\": \"1\",\
		\"type\": \"decimal\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Quantity.comparator\",\
		\"weight\": 63,\
		\"max\": \"1\",\
		\"type\": \"code\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Quantity.unit\",\
		\"weight\": 64,\
		\"max\": \"1\",\
		\"type\": \"string\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Quantity.system\",\
		\"weight\": 65,\
		\"max\": \"1\",\
		\"type\": \"uri\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Quantity.code\",\
		\"weight\": 66,\
		\"max\": \"1\",\
		\"type\": \"code\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Attachment\",\
		\"weight\": 67,\
		\"max\": \"*\",\
		\"type\": \"Element\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Attachment.id\",\
		\"weight\": 68,\
		\"max\": \"1\",\
		\"type\": \"id\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Attachment.extension\",\
		\"weight\": 69,\
		\"max\": \"*\",\
		\"type\": \"Extension\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Attachment.contentType\",\
		\"weight\": 70,\
		\"max\": \"1\",\
		\"type\": \"code\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Attachment.language\",\
		\"weight\": 71,\
		\"max\": \"1\",\
		\"type\": \"code\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Attachment.data\",\
		\"weight\": 72,\
		\"max\": \"1\",\
		\"type\": \"base64Binary\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Attachment.url\",\
		\"weight\": 73,\
		\"max\": \"1\",\
		\"type\": \"uri\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Attachment.size\",\
		\"weight\": 74,\
		\"max\": \"1\",\
		\"type\": \"unsignedInt\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Attachment.hash\",\
		\"weight\": 75,\
		\"max\": \"1\",\
		\"type\": \"base64Binary\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Attachment.title\",\
		\"weight\": 76,\
		\"max\": \"1\",\
		\"type\": \"string\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Attachment.creation\",\
		\"weight\": 77,\
		\"max\": \"1\",\
		\"type\": \"dateTime\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Ratio\",\
		\"weight\": 78,\
		\"max\": \"*\",\
		\"type\": \"Element\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Ratio.id\",\
		\"weight\": 79,\
		\"max\": \"1\",\
		\"type\": \"id\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Ratio.extension\",\
		\"weight\": 80,\
		\"max\": \"*\",\
		\"type\": \"Extension\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Ratio.numerator\",\
		\"weight\": 81,\
		\"max\": \"1\",\
		\"type\": \"Quantity\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Ratio.denominator\",\
		\"weight\": 82,\
		\"max\": \"1\",\
		\"type\": \"Quantity\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Annotation\",\
		\"weight\": 83,\
		\"max\": \"*\",\
		\"type\": \"Element\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Annotation.id\",\
		\"weight\": 84,\
		\"max\": \"1\",\
		\"type\": \"id\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Annotation.extension\",\
		\"weight\": 85,\
		\"max\": \"*\",\
		\"type\": \"Extension\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Annotation.authorReference\",\
		\"weight\": 86,\
		\"max\": \"1\",\
		\"type\": \"Reference\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Annotation.authorReference\",\
		\"weight\": 86,\
		\"max\": \"1\",\
		\"type\": \"Reference\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Annotation.authorReference\",\
		\"weight\": 86,\
		\"max\": \"1\",\
		\"type\": \"Reference\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Annotation.authorString\",\
		\"weight\": 86,\
		\"max\": \"1\",\
		\"type\": \"string\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Annotation.time\",\
		\"weight\": 87,\
		\"max\": \"1\",\
		\"type\": \"dateTime\"\
	},\
	{\
		\"min\": \"1\",\
		\"path\": \"Annotation.text\",\
		\"weight\": 88,\
		\"max\": \"1\",\
		\"type\": \"string\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"SampledData\",\
		\"weight\": 89,\
		\"max\": \"*\",\
		\"type\": \"Element\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"SampledData.id\",\
		\"weight\": 90,\
		\"max\": \"1\",\
		\"type\": \"id\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"SampledData.extension\",\
		\"weight\": 91,\
		\"max\": \"*\",\
		\"type\": \"Extension\"\
	},\
	{\
		\"min\": \"1\",\
		\"path\": \"SampledData.origin\",\
		\"weight\": 92,\
		\"max\": \"1\",\
		\"type\": \"Quantity\"\
	},\
	{\
		\"min\": \"1\",\
		\"path\": \"SampledData.period\",\
		\"weight\": 93,\
		\"max\": \"1\",\
		\"type\": \"decimal\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"SampledData.factor\",\
		\"weight\": 94,\
		\"max\": \"1\",\
		\"type\": \"decimal\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"SampledData.lowerLimit\",\
		\"weight\": 95,\
		\"max\": \"1\",\
		\"type\": \"decimal\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"SampledData.upperLimit\",\
		\"weight\": 96,\
		\"max\": \"1\",\
		\"type\": \"decimal\"\
	},\
	{\
		\"min\": \"1\",\
		\"path\": \"SampledData.dimensions\",\
		\"weight\": 97,\
		\"max\": \"1\",\
		\"type\": \"positiveInt\"\
	},\
	{\
		\"min\": \"1\",\
		\"path\": \"SampledData.data\",\
		\"weight\": 98,\
		\"max\": \"1\",\
		\"type\": \"string\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Reference\",\
		\"weight\": 99,\
		\"max\": \"*\",\
		\"type\": \"Element\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Reference.id\",\
		\"weight\": 100,\
		\"max\": \"1\",\
		\"type\": \"id\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Reference.extension\",\
		\"weight\": 101,\
		\"max\": \"*\",\
		\"type\": \"Extension\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Reference.reference\",\
		\"weight\": 102,\
		\"max\": \"1\",\
		\"type\": \"string\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Reference.display\",\
		\"weight\": 103,\
		\"max\": \"1\",\
		\"type\": \"string\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"CodeableConcept\",\
		\"weight\": 104,\
		\"max\": \"*\",\
		\"type\": \"Element\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"CodeableConcept.id\",\
		\"weight\": 105,\
		\"max\": \"1\",\
		\"type\": \"id\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"CodeableConcept.extension\",\
		\"weight\": 106,\
		\"max\": \"*\",\
		\"type\": \"Extension\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"CodeableConcept.coding\",\
		\"weight\": 107,\
		\"max\": \"*\",\
		\"type\": \"Coding\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"CodeableConcept.text\",\
		\"weight\": 108,\
		\"max\": \"1\",\
		\"type\": \"string\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Identifier\",\
		\"weight\": 109,\
		\"max\": \"*\",\
		\"type\": \"Element\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Identifier.id\",\
		\"weight\": 110,\
		\"max\": \"1\",\
		\"type\": \"id\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Identifier.extension\",\
		\"weight\": 111,\
		\"max\": \"*\",\
		\"type\": \"Extension\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Identifier.use\",\
		\"weight\": 112,\
		\"max\": \"1\",\
		\"type\": \"code\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Identifier.type\",\
		\"weight\": 113,\
		\"max\": \"1\",\
		\"type\": \"CodeableConcept\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Identifier.system\",\
		\"weight\": 114,\
		\"max\": \"1\",\
		\"type\": \"uri\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Identifier.value\",\
		\"weight\": 115,\
		\"max\": \"1\",\
		\"type\": \"string\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Identifier.period\",\
		\"weight\": 116,\
		\"max\": \"1\",\
		\"type\": \"Period\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Identifier.assigner\",\
		\"weight\": 117,\
		\"max\": \"1\",\
		\"type\": \"Reference\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Signature\",\
		\"weight\": 118,\
		\"max\": \"*\",\
		\"type\": \"Element\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Signature.id\",\
		\"weight\": 119,\
		\"max\": \"1\",\
		\"type\": \"id\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Signature.extension\",\
		\"weight\": 120,\
		\"max\": \"*\",\
		\"type\": \"Extension\"\
	},\
	{\
		\"min\": \"1\",\
		\"path\": \"Signature.type\",\
		\"weight\": 121,\
		\"max\": \"*\",\
		\"type\": \"Coding\"\
	},\
	{\
		\"min\": \"1\",\
		\"path\": \"Signature.when\",\
		\"weight\": 122,\
		\"max\": \"1\",\
		\"type\": \"instant\"\
	},\
	{\
		\"min\": \"1\",\
		\"path\": \"Signature.whoUri\",\
		\"weight\": 123,\
		\"max\": \"1\",\
		\"type\": \"uri\"\
	},\
	{\
		\"min\": \"1\",\
		\"path\": \"Signature.whoReference\",\
		\"weight\": 123,\
		\"max\": \"1\",\
		\"type\": \"Reference\"\
	},\
	{\
		\"min\": \"1\",\
		\"path\": \"Signature.whoReference\",\
		\"weight\": 123,\
		\"max\": \"1\",\
		\"type\": \"Reference\"\
	},\
	{\
		\"min\": \"1\",\
		\"path\": \"Signature.whoReference\",\
		\"weight\": 123,\
		\"max\": \"1\",\
		\"type\": \"Reference\"\
	},\
	{\
		\"min\": \"1\",\
		\"path\": \"Signature.whoReference\",\
		\"weight\": 123,\
		\"max\": \"1\",\
		\"type\": \"Reference\"\
	},\
	{\
		\"min\": \"1\",\
		\"path\": \"Signature.whoReference\",\
		\"weight\": 123,\
		\"max\": \"1\",\
		\"type\": \"Reference\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Signature.contentType\",\
		\"weight\": 124,\
		\"max\": \"1\",\
		\"type\": \"code\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Signature.blob\",\
		\"weight\": 125,\
		\"max\": \"1\",\
		\"type\": \"base64Binary\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Extension\",\
		\"weight\": 126,\
		\"max\": \"*\",\
		\"type\": \"Element\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Extension.id\",\
		\"weight\": 127,\
		\"max\": \"1\",\
		\"type\": \"id\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Extension.extension\",\
		\"weight\": 128,\
		\"max\": \"*\",\
		\"type\": \"Extension\"\
	},\
	{\
		\"min\": \"1\",\
		\"path\": \"Extension.url\",\
		\"weight\": 129,\
		\"max\": \"1\",\
		\"type\": \"uri\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Extension.valueBoolean\",\
		\"weight\": 130,\
		\"max\": \"1\",\
		\"type\": \"boolean\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Extension.valueInteger\",\
		\"weight\": 130,\
		\"max\": \"1\",\
		\"type\": \"integer\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Extension.valueDecimal\",\
		\"weight\": 130,\
		\"max\": \"1\",\
		\"type\": \"decimal\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Extension.valueBase64Binary\",\
		\"weight\": 130,\
		\"max\": \"1\",\
		\"type\": \"base64Binary\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Extension.valueInstant\",\
		\"weight\": 130,\
		\"max\": \"1\",\
		\"type\": \"instant\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Extension.valueString\",\
		\"weight\": 130,\
		\"max\": \"1\",\
		\"type\": \"string\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Extension.valueUri\",\
		\"weight\": 130,\
		\"max\": \"1\",\
		\"type\": \"uri\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Extension.valueDate\",\
		\"weight\": 130,\
		\"max\": \"1\",\
		\"type\": \"date\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Extension.valueDateTime\",\
		\"weight\": 130,\
		\"max\": \"1\",\
		\"type\": \"dateTime\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Extension.valueTime\",\
		\"weight\": 130,\
		\"max\": \"1\",\
		\"type\": \"time\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Extension.valueCode\",\
		\"weight\": 130,\
		\"max\": \"1\",\
		\"type\": \"code\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Extension.valueOid\",\
		\"weight\": 130,\
		\"max\": \"1\",\
		\"type\": \"oid\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Extension.valueId\",\
		\"weight\": 130,\
		\"max\": \"1\",\
		\"type\": \"id\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Extension.valueUnsignedInt\",\
		\"weight\": 130,\
		\"max\": \"1\",\
		\"type\": \"unsignedInt\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Extension.valuePositiveInt\",\
		\"weight\": 130,\
		\"max\": \"1\",\
		\"type\": \"positiveInt\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Extension.valueMarkdown\",\
		\"weight\": 130,\
		\"max\": \"1\",\
		\"type\": \"markdown\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Extension.valueAnnotation\",\
		\"weight\": 130,\
		\"max\": \"1\",\
		\"type\": \"Annotation\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Extension.valueAttachment\",\
		\"weight\": 130,\
		\"max\": \"1\",\
		\"type\": \"Attachment\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Extension.valueIdentifier\",\
		\"weight\": 130,\
		\"max\": \"1\",\
		\"type\": \"Identifier\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Extension.valueCodeableConcept\",\
		\"weight\": 130,\
		\"max\": \"1\",\
		\"type\": \"CodeableConcept\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Extension.valueCoding\",\
		\"weight\": 130,\
		\"max\": \"1\",\
		\"type\": \"Coding\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Extension.valueQuantity\",\
		\"weight\": 130,\
		\"max\": \"1\",\
		\"type\": \"Quantity\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Extension.valueRange\",\
		\"weight\": 130,\
		\"max\": \"1\",\
		\"type\": \"Range\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Extension.valuePeriod\",\
		\"weight\": 130,\
		\"max\": \"1\",\
		\"type\": \"Period\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Extension.valueRatio\",\
		\"weight\": 130,\
		\"max\": \"1\",\
		\"type\": \"Ratio\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Extension.valueSampledData\",\
		\"weight\": 130,\
		\"max\": \"1\",\
		\"type\": \"SampledData\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Extension.valueSignature\",\
		\"weight\": 130,\
		\"max\": \"1\",\
		\"type\": \"Signature\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Extension.valueHumanName\",\
		\"weight\": 130,\
		\"max\": \"1\",\
		\"type\": \"HumanName\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Extension.valueAddress\",\
		\"weight\": 130,\
		\"max\": \"1\",\
		\"type\": \"Address\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Extension.valueContactPoint\",\
		\"weight\": 130,\
		\"max\": \"1\",\
		\"type\": \"ContactPoint\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Extension.valueTiming\",\
		\"weight\": 130,\
		\"max\": \"1\",\
		\"type\": \"Timing\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Extension.valueReference\",\
		\"weight\": 130,\
		\"max\": \"1\",\
		\"type\": \"Reference\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Extension.valueMeta\",\
		\"weight\": 130,\
		\"max\": \"1\",\
		\"type\": \"Meta\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"BackboneElement\",\
		\"weight\": 131,\
		\"max\": \"*\",\
		\"type\": \"Element\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"BackboneElement.id\",\
		\"weight\": 132,\
		\"max\": \"1\",\
		\"type\": \"id\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"BackboneElement.extension\",\
		\"weight\": 133,\
		\"max\": \"*\",\
		\"type\": \"Extension\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"BackboneElement.modifierExtension\",\
		\"weight\": 134,\
		\"max\": \"*\",\
		\"type\": \"Extension\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Narrative\",\
		\"weight\": 135,\
		\"max\": \"*\",\
		\"type\": \"Element\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Narrative.id\",\
		\"weight\": 136,\
		\"max\": \"1\",\
		\"type\": \"id\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Narrative.extension\",\
		\"weight\": 137,\
		\"max\": \"*\",\
		\"type\": \"Extension\"\
	},\
	{\
		\"min\": \"1\",\
		\"path\": \"Narrative.status\",\
		\"weight\": 138,\
		\"max\": \"1\",\
		\"type\": \"code\"\
	},\
	{\
		\"min\": \"1\",\
		\"path\": \"Narrative.div\",\
		\"weight\": 139,\
		\"max\": \"1\",\
		\"type\": \"xhtml\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Element\",\
		\"weight\": 140,\
		\"max\": \"*\",\
		\"derivations\": [\
			\"ActionDefinition\",\
			\"Address\",\
			\"Annotation\",\
			\"Attachment\",\
			\"BackboneElement\",\
			\"CodeableConcept\",\
			\"Coding\",\
			\"ContactPoint\",\
			\"DataRequirement\",\
			\"ElementDefinition\",\
			\"Extension\",\
			\"HumanName\",\
			\"Identifier\",\
			\"Meta\",\
			\"ModuleMetadata\",\
			\"Narrative\",\
			\"ParameterDefinition\",\
			\"Period\",\
			\"Quantity\",\
			\"Range\",\
			\"Ratio\",\
			\"Reference\",\
			\"SampledData\",\
			\"Signature\",\
			\"Timing\",\
			\"TriggerDefinition\",\
			\"base64Binary\",\
			\"boolean\",\
			\"date\",\
			\"dateTime\",\
			\"decimal\",\
			\"instant\",\
			\"integer\",\
			\"string\",\
			\"time\",\
			\"uri\"\
		]\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Element.id\",\
		\"weight\": 141,\
		\"max\": \"1\",\
		\"type\": \"id\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Element.extension\",\
		\"weight\": 142,\
		\"max\": \"*\",\
		\"type\": \"Extension\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"TriggerDefinition\",\
		\"weight\": 143,\
		\"max\": \"*\",\
		\"type\": \"Element\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"TriggerDefinition.id\",\
		\"weight\": 144,\
		\"max\": \"1\",\
		\"type\": \"id\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"TriggerDefinition.extension\",\
		\"weight\": 145,\
		\"max\": \"*\",\
		\"type\": \"Extension\"\
	},\
	{\
		\"min\": \"1\",\
		\"path\": \"TriggerDefinition.type\",\
		\"weight\": 146,\
		\"max\": \"1\",\
		\"type\": \"code\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"TriggerDefinition.eventName\",\
		\"weight\": 147,\
		\"max\": \"1\",\
		\"type\": \"string\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"TriggerDefinition.eventTimingTiming\",\
		\"weight\": 148,\
		\"max\": \"1\",\
		\"type\": \"Timing\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"TriggerDefinition.eventTimingReference\",\
		\"weight\": 148,\
		\"max\": \"1\",\
		\"type\": \"Reference\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"TriggerDefinition.eventTimingDate\",\
		\"weight\": 148,\
		\"max\": \"1\",\
		\"type\": \"date\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"TriggerDefinition.eventTimingDateTime\",\
		\"weight\": 148,\
		\"max\": \"1\",\
		\"type\": \"dateTime\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"TriggerDefinition.eventData\",\
		\"weight\": 149,\
		\"max\": \"1\",\
		\"type\": \"DataRequirement\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"ElementDefinition\",\
		\"weight\": 150,\
		\"max\": \"*\",\
		\"type\": \"Element\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"ElementDefinition.id\",\
		\"weight\": 151,\
		\"max\": \"1\",\
		\"type\": \"id\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"ElementDefinition.extension\",\
		\"weight\": 152,\
		\"max\": \"*\",\
		\"type\": \"Extension\"\
	},\
	{\
		\"min\": \"1\",\
		\"path\": \"ElementDefinition.path\",\
		\"weight\": 153,\
		\"max\": \"1\",\
		\"type\": \"string\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"ElementDefinition.representation\",\
		\"weight\": 154,\
		\"max\": \"*\",\
		\"type\": \"code\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"ElementDefinition.name\",\
		\"weight\": 155,\
		\"max\": \"1\",\
		\"type\": \"string\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"ElementDefinition.label\",\
		\"weight\": 156,\
		\"max\": \"1\",\
		\"type\": \"string\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"ElementDefinition.code\",\
		\"weight\": 157,\
		\"max\": \"*\",\
		\"type\": \"Coding\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"ElementDefinition.slicing\",\
		\"weight\": 158,\
		\"max\": \"1\",\
		\"type\": \"Element\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"ElementDefinition.slicing.id\",\
		\"weight\": 159,\
		\"max\": \"1\",\
		\"type\": \"id\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"ElementDefinition.slicing.extension\",\
		\"weight\": 160,\
		\"max\": \"*\",\
		\"type\": \"Extension\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"ElementDefinition.slicing.discriminator\",\
		\"weight\": 161,\
		\"max\": \"*\",\
		\"type\": \"string\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"ElementDefinition.slicing.description\",\
		\"weight\": 162,\
		\"max\": \"1\",\
		\"type\": \"string\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"ElementDefinition.slicing.ordered\",\
		\"weight\": 163,\
		\"max\": \"1\",\
		\"type\": \"boolean\"\
	},\
	{\
		\"min\": \"1\",\
		\"path\": \"ElementDefinition.slicing.rules\",\
		\"weight\": 164,\
		\"max\": \"1\",\
		\"type\": \"code\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"ElementDefinition.short\",\
		\"weight\": 165,\
		\"max\": \"1\",\
		\"type\": \"string\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"ElementDefinition.definition\",\
		\"weight\": 166,\
		\"max\": \"1\",\
		\"type\": \"markdown\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"ElementDefinition.comments\",\
		\"weight\": 167,\
		\"max\": \"1\",\
		\"type\": \"markdown\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"ElementDefinition.requirements\",\
		\"weight\": 168,\
		\"max\": \"1\",\
		\"type\": \"markdown\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"ElementDefinition.alias\",\
		\"weight\": 169,\
		\"max\": \"*\",\
		\"type\": \"string\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"ElementDefinition.min\",\
		\"weight\": 170,\
		\"max\": \"1\",\
		\"type\": \"integer\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"ElementDefinition.max\",\
		\"weight\": 171,\
		\"max\": \"1\",\
		\"type\": \"string\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"ElementDefinition.base\",\
		\"weight\": 172,\
		\"max\": \"1\",\
		\"type\": \"Element\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"ElementDefinition.base.id\",\
		\"weight\": 173,\
		\"max\": \"1\",\
		\"type\": \"id\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"ElementDefinition.base.extension\",\
		\"weight\": 174,\
		\"max\": \"*\",\
		\"type\": \"Extension\"\
	},\
	{\
		\"min\": \"1\",\
		\"path\": \"ElementDefinition.base.path\",\
		\"weight\": 175,\
		\"max\": \"1\",\
		\"type\": \"string\"\
	},\
	{\
		\"min\": \"1\",\
		\"path\": \"ElementDefinition.base.min\",\
		\"weight\": 176,\
		\"max\": \"1\",\
		\"type\": \"integer\"\
	},\
	{\
		\"min\": \"1\",\
		\"path\": \"ElementDefinition.base.max\",\
		\"weight\": 177,\
		\"max\": \"1\",\
		\"type\": \"string\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"ElementDefinition.contentReference\",\
		\"weight\": 178,\
		\"max\": \"1\",\
		\"type\": \"uri\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"ElementDefinition.type\",\
		\"weight\": 179,\
		\"max\": \"*\",\
		\"type\": \"Element\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"ElementDefinition.type.id\",\
		\"weight\": 180,\
		\"max\": \"1\",\
		\"type\": \"id\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"ElementDefinition.type.extension\",\
		\"weight\": 181,\
		\"max\": \"*\",\
		\"type\": \"Extension\"\
	},\
	{\
		\"min\": \"1\",\
		\"path\": \"ElementDefinition.type.code\",\
		\"weight\": 182,\
		\"max\": \"1\",\
		\"type\": \"code\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"ElementDefinition.type.profile\",\
		\"weight\": 183,\
		\"max\": \"*\",\
		\"type\": \"uri\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"ElementDefinition.type.aggregation\",\
		\"weight\": 184,\
		\"max\": \"*\",\
		\"type\": \"code\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"ElementDefinition.type.versioning\",\
		\"weight\": 185,\
		\"max\": \"1\",\
		\"type\": \"code\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"ElementDefinition.defaultValueBoolean\",\
		\"weight\": 186,\
		\"max\": \"1\",\
		\"type\": \"boolean\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"ElementDefinition.defaultValueInteger\",\
		\"weight\": 186,\
		\"max\": \"1\",\
		\"type\": \"integer\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"ElementDefinition.defaultValueDecimal\",\
		\"weight\": 186,\
		\"max\": \"1\",\
		\"type\": \"decimal\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"ElementDefinition.defaultValueBase64Binary\",\
		\"weight\": 186,\
		\"max\": \"1\",\
		\"type\": \"base64Binary\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"ElementDefinition.defaultValueInstant\",\
		\"weight\": 186,\
		\"max\": \"1\",\
		\"type\": \"instant\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"ElementDefinition.defaultValueString\",\
		\"weight\": 186,\
		\"max\": \"1\",\
		\"type\": \"string\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"ElementDefinition.defaultValueUri\",\
		\"weight\": 186,\
		\"max\": \"1\",\
		\"type\": \"uri\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"ElementDefinition.defaultValueDate\",\
		\"weight\": 186,\
		\"max\": \"1\",\
		\"type\": \"date\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"ElementDefinition.defaultValueDateTime\",\
		\"weight\": 186,\
		\"max\": \"1\",\
		\"type\": \"dateTime\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"ElementDefinition.defaultValueTime\",\
		\"weight\": 186,\
		\"max\": \"1\",\
		\"type\": \"time\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"ElementDefinition.defaultValueCode\",\
		\"weight\": 186,\
		\"max\": \"1\",\
		\"type\": \"code\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"ElementDefinition.defaultValueOid\",\
		\"weight\": 186,\
		\"max\": \"1\",\
		\"type\": \"oid\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"ElementDefinition.defaultValueId\",\
		\"weight\": 186,\
		\"max\": \"1\",\
		\"type\": \"id\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"ElementDefinition.defaultValueUnsignedInt\",\
		\"weight\": 186,\
		\"max\": \"1\",\
		\"type\": \"unsignedInt\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"ElementDefinition.defaultValuePositiveInt\",\
		\"weight\": 186,\
		\"max\": \"1\",\
		\"type\": \"positiveInt\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"ElementDefinition.defaultValueMarkdown\",\
		\"weight\": 186,\
		\"max\": \"1\",\
		\"type\": \"markdown\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"ElementDefinition.defaultValueAnnotation\",\
		\"weight\": 186,\
		\"max\": \"1\",\
		\"type\": \"Annotation\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"ElementDefinition.defaultValueAttachment\",\
		\"weight\": 186,\
		\"max\": \"1\",\
		\"type\": \"Attachment\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"ElementDefinition.defaultValueIdentifier\",\
		\"weight\": 186,\
		\"max\": \"1\",\
		\"type\": \"Identifier\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"ElementDefinition.defaultValueCodeableConcept\",\
		\"weight\": 186,\
		\"max\": \"1\",\
		\"type\": \"CodeableConcept\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"ElementDefinition.defaultValueCoding\",\
		\"weight\": 186,\
		\"max\": \"1\",\
		\"type\": \"Coding\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"ElementDefinition.defaultValueQuantity\",\
		\"weight\": 186,\
		\"max\": \"1\",\
		\"type\": \"Quantity\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"ElementDefinition.defaultValueRange\",\
		\"weight\": 186,\
		\"max\": \"1\",\
		\"type\": \"Range\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"ElementDefinition.defaultValuePeriod\",\
		\"weight\": 186,\
		\"max\": \"1\",\
		\"type\": \"Period\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"ElementDefinition.defaultValueRatio\",\
		\"weight\": 186,\
		\"max\": \"1\",\
		\"type\": \"Ratio\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"ElementDefinition.defaultValueSampledData\",\
		\"weight\": 186,\
		\"max\": \"1\",\
		\"type\": \"SampledData\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"ElementDefinition.defaultValueSignature\",\
		\"weight\": 186,\
		\"max\": \"1\",\
		\"type\": \"Signature\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"ElementDefinition.defaultValueHumanName\",\
		\"weight\": 186,\
		\"max\": \"1\",\
		\"type\": \"HumanName\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"ElementDefinition.defaultValueAddress\",\
		\"weight\": 186,\
		\"max\": \"1\",\
		\"type\": \"Address\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"ElementDefinition.defaultValueContactPoint\",\
		\"weight\": 186,\
		\"max\": \"1\",\
		\"type\": \"ContactPoint\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"ElementDefinition.defaultValueTiming\",\
		\"weight\": 186,\
		\"max\": \"1\",\
		\"type\": \"Timing\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"ElementDefinition.defaultValueReference\",\
		\"weight\": 186,\
		\"max\": \"1\",\
		\"type\": \"Reference\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"ElementDefinition.defaultValueMeta\",\
		\"weight\": 186,\
		\"max\": \"1\",\
		\"type\": \"Meta\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"ElementDefinition.meaningWhenMissing\",\
		\"weight\": 187,\
		\"max\": \"1\",\
		\"type\": \"markdown\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"ElementDefinition.fixedBoolean\",\
		\"weight\": 188,\
		\"max\": \"1\",\
		\"type\": \"boolean\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"ElementDefinition.fixedInteger\",\
		\"weight\": 188,\
		\"max\": \"1\",\
		\"type\": \"integer\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"ElementDefinition.fixedDecimal\",\
		\"weight\": 188,\
		\"max\": \"1\",\
		\"type\": \"decimal\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"ElementDefinition.fixedBase64Binary\",\
		\"weight\": 188,\
		\"max\": \"1\",\
		\"type\": \"base64Binary\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"ElementDefinition.fixedInstant\",\
		\"weight\": 188,\
		\"max\": \"1\",\
		\"type\": \"instant\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"ElementDefinition.fixedString\",\
		\"weight\": 188,\
		\"max\": \"1\",\
		\"type\": \"string\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"ElementDefinition.fixedUri\",\
		\"weight\": 188,\
		\"max\": \"1\",\
		\"type\": \"uri\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"ElementDefinition.fixedDate\",\
		\"weight\": 188,\
		\"max\": \"1\",\
		\"type\": \"date\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"ElementDefinition.fixedDateTime\",\
		\"weight\": 188,\
		\"max\": \"1\",\
		\"type\": \"dateTime\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"ElementDefinition.fixedTime\",\
		\"weight\": 188,\
		\"max\": \"1\",\
		\"type\": \"time\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"ElementDefinition.fixedCode\",\
		\"weight\": 188,\
		\"max\": \"1\",\
		\"type\": \"code\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"ElementDefinition.fixedOid\",\
		\"weight\": 188,\
		\"max\": \"1\",\
		\"type\": \"oid\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"ElementDefinition.fixedId\",\
		\"weight\": 188,\
		\"max\": \"1\",\
		\"type\": \"id\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"ElementDefinition.fixedUnsignedInt\",\
		\"weight\": 188,\
		\"max\": \"1\",\
		\"type\": \"unsignedInt\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"ElementDefinition.fixedPositiveInt\",\
		\"weight\": 188,\
		\"max\": \"1\",\
		\"type\": \"positiveInt\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"ElementDefinition.fixedMarkdown\",\
		\"weight\": 188,\
		\"max\": \"1\",\
		\"type\": \"markdown\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"ElementDefinition.fixedAnnotation\",\
		\"weight\": 188,\
		\"max\": \"1\",\
		\"type\": \"Annotation\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"ElementDefinition.fixedAttachment\",\
		\"weight\": 188,\
		\"max\": \"1\",\
		\"type\": \"Attachment\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"ElementDefinition.fixedIdentifier\",\
		\"weight\": 188,\
		\"max\": \"1\",\
		\"type\": \"Identifier\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"ElementDefinition.fixedCodeableConcept\",\
		\"weight\": 188,\
		\"max\": \"1\",\
		\"type\": \"CodeableConcept\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"ElementDefinition.fixedCoding\",\
		\"weight\": 188,\
		\"max\": \"1\",\
		\"type\": \"Coding\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"ElementDefinition.fixedQuantity\",\
		\"weight\": 188,\
		\"max\": \"1\",\
		\"type\": \"Quantity\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"ElementDefinition.fixedRange\",\
		\"weight\": 188,\
		\"max\": \"1\",\
		\"type\": \"Range\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"ElementDefinition.fixedPeriod\",\
		\"weight\": 188,\
		\"max\": \"1\",\
		\"type\": \"Period\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"ElementDefinition.fixedRatio\",\
		\"weight\": 188,\
		\"max\": \"1\",\
		\"type\": \"Ratio\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"ElementDefinition.fixedSampledData\",\
		\"weight\": 188,\
		\"max\": \"1\",\
		\"type\": \"SampledData\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"ElementDefinition.fixedSignature\",\
		\"weight\": 188,\
		\"max\": \"1\",\
		\"type\": \"Signature\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"ElementDefinition.fixedHumanName\",\
		\"weight\": 188,\
		\"max\": \"1\",\
		\"type\": \"HumanName\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"ElementDefinition.fixedAddress\",\
		\"weight\": 188,\
		\"max\": \"1\",\
		\"type\": \"Address\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"ElementDefinition.fixedContactPoint\",\
		\"weight\": 188,\
		\"max\": \"1\",\
		\"type\": \"ContactPoint\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"ElementDefinition.fixedTiming\",\
		\"weight\": 188,\
		\"max\": \"1\",\
		\"type\": \"Timing\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"ElementDefinition.fixedReference\",\
		\"weight\": 188,\
		\"max\": \"1\",\
		\"type\": \"Reference\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"ElementDefinition.fixedMeta\",\
		\"weight\": 188,\
		\"max\": \"1\",\
		\"type\": \"Meta\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"ElementDefinition.patternBoolean\",\
		\"weight\": 189,\
		\"max\": \"1\",\
		\"type\": \"boolean\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"ElementDefinition.patternInteger\",\
		\"weight\": 189,\
		\"max\": \"1\",\
		\"type\": \"integer\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"ElementDefinition.patternDecimal\",\
		\"weight\": 189,\
		\"max\": \"1\",\
		\"type\": \"decimal\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"ElementDefinition.patternBase64Binary\",\
		\"weight\": 189,\
		\"max\": \"1\",\
		\"type\": \"base64Binary\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"ElementDefinition.patternInstant\",\
		\"weight\": 189,\
		\"max\": \"1\",\
		\"type\": \"instant\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"ElementDefinition.patternString\",\
		\"weight\": 189,\
		\"max\": \"1\",\
		\"type\": \"string\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"ElementDefinition.patternUri\",\
		\"weight\": 189,\
		\"max\": \"1\",\
		\"type\": \"uri\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"ElementDefinition.patternDate\",\
		\"weight\": 189,\
		\"max\": \"1\",\
		\"type\": \"date\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"ElementDefinition.patternDateTime\",\
		\"weight\": 189,\
		\"max\": \"1\",\
		\"type\": \"dateTime\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"ElementDefinition.patternTime\",\
		\"weight\": 189,\
		\"max\": \"1\",\
		\"type\": \"time\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"ElementDefinition.patternCode\",\
		\"weight\": 189,\
		\"max\": \"1\",\
		\"type\": \"code\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"ElementDefinition.patternOid\",\
		\"weight\": 189,\
		\"max\": \"1\",\
		\"type\": \"oid\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"ElementDefinition.patternId\",\
		\"weight\": 189,\
		\"max\": \"1\",\
		\"type\": \"id\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"ElementDefinition.patternUnsignedInt\",\
		\"weight\": 189,\
		\"max\": \"1\",\
		\"type\": \"unsignedInt\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"ElementDefinition.patternPositiveInt\",\
		\"weight\": 189,\
		\"max\": \"1\",\
		\"type\": \"positiveInt\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"ElementDefinition.patternMarkdown\",\
		\"weight\": 189,\
		\"max\": \"1\",\
		\"type\": \"markdown\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"ElementDefinition.patternAnnotation\",\
		\"weight\": 189,\
		\"max\": \"1\",\
		\"type\": \"Annotation\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"ElementDefinition.patternAttachment\",\
		\"weight\": 189,\
		\"max\": \"1\",\
		\"type\": \"Attachment\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"ElementDefinition.patternIdentifier\",\
		\"weight\": 189,\
		\"max\": \"1\",\
		\"type\": \"Identifier\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"ElementDefinition.patternCodeableConcept\",\
		\"weight\": 189,\
		\"max\": \"1\",\
		\"type\": \"CodeableConcept\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"ElementDefinition.patternCoding\",\
		\"weight\": 189,\
		\"max\": \"1\",\
		\"type\": \"Coding\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"ElementDefinition.patternQuantity\",\
		\"weight\": 189,\
		\"max\": \"1\",\
		\"type\": \"Quantity\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"ElementDefinition.patternRange\",\
		\"weight\": 189,\
		\"max\": \"1\",\
		\"type\": \"Range\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"ElementDefinition.patternPeriod\",\
		\"weight\": 189,\
		\"max\": \"1\",\
		\"type\": \"Period\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"ElementDefinition.patternRatio\",\
		\"weight\": 189,\
		\"max\": \"1\",\
		\"type\": \"Ratio\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"ElementDefinition.patternSampledData\",\
		\"weight\": 189,\
		\"max\": \"1\",\
		\"type\": \"SampledData\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"ElementDefinition.patternSignature\",\
		\"weight\": 189,\
		\"max\": \"1\",\
		\"type\": \"Signature\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"ElementDefinition.patternHumanName\",\
		\"weight\": 189,\
		\"max\": \"1\",\
		\"type\": \"HumanName\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"ElementDefinition.patternAddress\",\
		\"weight\": 189,\
		\"max\": \"1\",\
		\"type\": \"Address\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"ElementDefinition.patternContactPoint\",\
		\"weight\": 189,\
		\"max\": \"1\",\
		\"type\": \"ContactPoint\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"ElementDefinition.patternTiming\",\
		\"weight\": 189,\
		\"max\": \"1\",\
		\"type\": \"Timing\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"ElementDefinition.patternReference\",\
		\"weight\": 189,\
		\"max\": \"1\",\
		\"type\": \"Reference\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"ElementDefinition.patternMeta\",\
		\"weight\": 189,\
		\"max\": \"1\",\
		\"type\": \"Meta\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"ElementDefinition.exampleBoolean\",\
		\"weight\": 190,\
		\"max\": \"1\",\
		\"type\": \"boolean\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"ElementDefinition.exampleInteger\",\
		\"weight\": 190,\
		\"max\": \"1\",\
		\"type\": \"integer\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"ElementDefinition.exampleDecimal\",\
		\"weight\": 190,\
		\"max\": \"1\",\
		\"type\": \"decimal\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"ElementDefinition.exampleBase64Binary\",\
		\"weight\": 190,\
		\"max\": \"1\",\
		\"type\": \"base64Binary\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"ElementDefinition.exampleInstant\",\
		\"weight\": 190,\
		\"max\": \"1\",\
		\"type\": \"instant\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"ElementDefinition.exampleString\",\
		\"weight\": 190,\
		\"max\": \"1\",\
		\"type\": \"string\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"ElementDefinition.exampleUri\",\
		\"weight\": 190,\
		\"max\": \"1\",\
		\"type\": \"uri\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"ElementDefinition.exampleDate\",\
		\"weight\": 190,\
		\"max\": \"1\",\
		\"type\": \"date\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"ElementDefinition.exampleDateTime\",\
		\"weight\": 190,\
		\"max\": \"1\",\
		\"type\": \"dateTime\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"ElementDefinition.exampleTime\",\
		\"weight\": 190,\
		\"max\": \"1\",\
		\"type\": \"time\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"ElementDefinition.exampleCode\",\
		\"weight\": 190,\
		\"max\": \"1\",\
		\"type\": \"code\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"ElementDefinition.exampleOid\",\
		\"weight\": 190,\
		\"max\": \"1\",\
		\"type\": \"oid\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"ElementDefinition.exampleId\",\
		\"weight\": 190,\
		\"max\": \"1\",\
		\"type\": \"id\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"ElementDefinition.exampleUnsignedInt\",\
		\"weight\": 190,\
		\"max\": \"1\",\
		\"type\": \"unsignedInt\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"ElementDefinition.examplePositiveInt\",\
		\"weight\": 190,\
		\"max\": \"1\",\
		\"type\": \"positiveInt\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"ElementDefinition.exampleMarkdown\",\
		\"weight\": 190,\
		\"max\": \"1\",\
		\"type\": \"markdown\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"ElementDefinition.exampleAnnotation\",\
		\"weight\": 190,\
		\"max\": \"1\",\
		\"type\": \"Annotation\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"ElementDefinition.exampleAttachment\",\
		\"weight\": 190,\
		\"max\": \"1\",\
		\"type\": \"Attachment\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"ElementDefinition.exampleIdentifier\",\
		\"weight\": 190,\
		\"max\": \"1\",\
		\"type\": \"Identifier\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"ElementDefinition.exampleCodeableConcept\",\
		\"weight\": 190,\
		\"max\": \"1\",\
		\"type\": \"CodeableConcept\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"ElementDefinition.exampleCoding\",\
		\"weight\": 190,\
		\"max\": \"1\",\
		\"type\": \"Coding\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"ElementDefinition.exampleQuantity\",\
		\"weight\": 190,\
		\"max\": \"1\",\
		\"type\": \"Quantity\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"ElementDefinition.exampleRange\",\
		\"weight\": 190,\
		\"max\": \"1\",\
		\"type\": \"Range\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"ElementDefinition.examplePeriod\",\
		\"weight\": 190,\
		\"max\": \"1\",\
		\"type\": \"Period\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"ElementDefinition.exampleRatio\",\
		\"weight\": 190,\
		\"max\": \"1\",\
		\"type\": \"Ratio\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"ElementDefinition.exampleSampledData\",\
		\"weight\": 190,\
		\"max\": \"1\",\
		\"type\": \"SampledData\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"ElementDefinition.exampleSignature\",\
		\"weight\": 190,\
		\"max\": \"1\",\
		\"type\": \"Signature\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"ElementDefinition.exampleHumanName\",\
		\"weight\": 190,\
		\"max\": \"1\",\
		\"type\": \"HumanName\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"ElementDefinition.exampleAddress\",\
		\"weight\": 190,\
		\"max\": \"1\",\
		\"type\": \"Address\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"ElementDefinition.exampleContactPoint\",\
		\"weight\": 190,\
		\"max\": \"1\",\
		\"type\": \"ContactPoint\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"ElementDefinition.exampleTiming\",\
		\"weight\": 190,\
		\"max\": \"1\",\
		\"type\": \"Timing\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"ElementDefinition.exampleReference\",\
		\"weight\": 190,\
		\"max\": \"1\",\
		\"type\": \"Reference\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"ElementDefinition.exampleMeta\",\
		\"weight\": 190,\
		\"max\": \"1\",\
		\"type\": \"Meta\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"ElementDefinition.minValueBoolean\",\
		\"weight\": 191,\
		\"max\": \"1\",\
		\"type\": \"boolean\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"ElementDefinition.minValueInteger\",\
		\"weight\": 191,\
		\"max\": \"1\",\
		\"type\": \"integer\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"ElementDefinition.minValueDecimal\",\
		\"weight\": 191,\
		\"max\": \"1\",\
		\"type\": \"decimal\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"ElementDefinition.minValueBase64Binary\",\
		\"weight\": 191,\
		\"max\": \"1\",\
		\"type\": \"base64Binary\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"ElementDefinition.minValueInstant\",\
		\"weight\": 191,\
		\"max\": \"1\",\
		\"type\": \"instant\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"ElementDefinition.minValueString\",\
		\"weight\": 191,\
		\"max\": \"1\",\
		\"type\": \"string\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"ElementDefinition.minValueUri\",\
		\"weight\": 191,\
		\"max\": \"1\",\
		\"type\": \"uri\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"ElementDefinition.minValueDate\",\
		\"weight\": 191,\
		\"max\": \"1\",\
		\"type\": \"date\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"ElementDefinition.minValueDateTime\",\
		\"weight\": 191,\
		\"max\": \"1\",\
		\"type\": \"dateTime\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"ElementDefinition.minValueTime\",\
		\"weight\": 191,\
		\"max\": \"1\",\
		\"type\": \"time\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"ElementDefinition.minValueCode\",\
		\"weight\": 191,\
		\"max\": \"1\",\
		\"type\": \"code\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"ElementDefinition.minValueOid\",\
		\"weight\": 191,\
		\"max\": \"1\",\
		\"type\": \"oid\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"ElementDefinition.minValueId\",\
		\"weight\": 191,\
		\"max\": \"1\",\
		\"type\": \"id\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"ElementDefinition.minValueUnsignedInt\",\
		\"weight\": 191,\
		\"max\": \"1\",\
		\"type\": \"unsignedInt\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"ElementDefinition.minValuePositiveInt\",\
		\"weight\": 191,\
		\"max\": \"1\",\
		\"type\": \"positiveInt\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"ElementDefinition.minValueMarkdown\",\
		\"weight\": 191,\
		\"max\": \"1\",\
		\"type\": \"markdown\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"ElementDefinition.minValueAnnotation\",\
		\"weight\": 191,\
		\"max\": \"1\",\
		\"type\": \"Annotation\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"ElementDefinition.minValueAttachment\",\
		\"weight\": 191,\
		\"max\": \"1\",\
		\"type\": \"Attachment\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"ElementDefinition.minValueIdentifier\",\
		\"weight\": 191,\
		\"max\": \"1\",\
		\"type\": \"Identifier\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"ElementDefinition.minValueCodeableConcept\",\
		\"weight\": 191,\
		\"max\": \"1\",\
		\"type\": \"CodeableConcept\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"ElementDefinition.minValueCoding\",\
		\"weight\": 191,\
		\"max\": \"1\",\
		\"type\": \"Coding\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"ElementDefinition.minValueQuantity\",\
		\"weight\": 191,\
		\"max\": \"1\",\
		\"type\": \"Quantity\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"ElementDefinition.minValueRange\",\
		\"weight\": 191,\
		\"max\": \"1\",\
		\"type\": \"Range\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"ElementDefinition.minValuePeriod\",\
		\"weight\": 191,\
		\"max\": \"1\",\
		\"type\": \"Period\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"ElementDefinition.minValueRatio\",\
		\"weight\": 191,\
		\"max\": \"1\",\
		\"type\": \"Ratio\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"ElementDefinition.minValueSampledData\",\
		\"weight\": 191,\
		\"max\": \"1\",\
		\"type\": \"SampledData\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"ElementDefinition.minValueSignature\",\
		\"weight\": 191,\
		\"max\": \"1\",\
		\"type\": \"Signature\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"ElementDefinition.minValueHumanName\",\
		\"weight\": 191,\
		\"max\": \"1\",\
		\"type\": \"HumanName\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"ElementDefinition.minValueAddress\",\
		\"weight\": 191,\
		\"max\": \"1\",\
		\"type\": \"Address\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"ElementDefinition.minValueContactPoint\",\
		\"weight\": 191,\
		\"max\": \"1\",\
		\"type\": \"ContactPoint\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"ElementDefinition.minValueTiming\",\
		\"weight\": 191,\
		\"max\": \"1\",\
		\"type\": \"Timing\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"ElementDefinition.minValueReference\",\
		\"weight\": 191,\
		\"max\": \"1\",\
		\"type\": \"Reference\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"ElementDefinition.minValueMeta\",\
		\"weight\": 191,\
		\"max\": \"1\",\
		\"type\": \"Meta\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"ElementDefinition.maxValueBoolean\",\
		\"weight\": 192,\
		\"max\": \"1\",\
		\"type\": \"boolean\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"ElementDefinition.maxValueInteger\",\
		\"weight\": 192,\
		\"max\": \"1\",\
		\"type\": \"integer\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"ElementDefinition.maxValueDecimal\",\
		\"weight\": 192,\
		\"max\": \"1\",\
		\"type\": \"decimal\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"ElementDefinition.maxValueBase64Binary\",\
		\"weight\": 192,\
		\"max\": \"1\",\
		\"type\": \"base64Binary\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"ElementDefinition.maxValueInstant\",\
		\"weight\": 192,\
		\"max\": \"1\",\
		\"type\": \"instant\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"ElementDefinition.maxValueString\",\
		\"weight\": 192,\
		\"max\": \"1\",\
		\"type\": \"string\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"ElementDefinition.maxValueUri\",\
		\"weight\": 192,\
		\"max\": \"1\",\
		\"type\": \"uri\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"ElementDefinition.maxValueDate\",\
		\"weight\": 192,\
		\"max\": \"1\",\
		\"type\": \"date\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"ElementDefinition.maxValueDateTime\",\
		\"weight\": 192,\
		\"max\": \"1\",\
		\"type\": \"dateTime\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"ElementDefinition.maxValueTime\",\
		\"weight\": 192,\
		\"max\": \"1\",\
		\"type\": \"time\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"ElementDefinition.maxValueCode\",\
		\"weight\": 192,\
		\"max\": \"1\",\
		\"type\": \"code\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"ElementDefinition.maxValueOid\",\
		\"weight\": 192,\
		\"max\": \"1\",\
		\"type\": \"oid\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"ElementDefinition.maxValueId\",\
		\"weight\": 192,\
		\"max\": \"1\",\
		\"type\": \"id\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"ElementDefinition.maxValueUnsignedInt\",\
		\"weight\": 192,\
		\"max\": \"1\",\
		\"type\": \"unsignedInt\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"ElementDefinition.maxValuePositiveInt\",\
		\"weight\": 192,\
		\"max\": \"1\",\
		\"type\": \"positiveInt\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"ElementDefinition.maxValueMarkdown\",\
		\"weight\": 192,\
		\"max\": \"1\",\
		\"type\": \"markdown\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"ElementDefinition.maxValueAnnotation\",\
		\"weight\": 192,\
		\"max\": \"1\",\
		\"type\": \"Annotation\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"ElementDefinition.maxValueAttachment\",\
		\"weight\": 192,\
		\"max\": \"1\",\
		\"type\": \"Attachment\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"ElementDefinition.maxValueIdentifier\",\
		\"weight\": 192,\
		\"max\": \"1\",\
		\"type\": \"Identifier\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"ElementDefinition.maxValueCodeableConcept\",\
		\"weight\": 192,\
		\"max\": \"1\",\
		\"type\": \"CodeableConcept\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"ElementDefinition.maxValueCoding\",\
		\"weight\": 192,\
		\"max\": \"1\",\
		\"type\": \"Coding\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"ElementDefinition.maxValueQuantity\",\
		\"weight\": 192,\
		\"max\": \"1\",\
		\"type\": \"Quantity\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"ElementDefinition.maxValueRange\",\
		\"weight\": 192,\
		\"max\": \"1\",\
		\"type\": \"Range\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"ElementDefinition.maxValuePeriod\",\
		\"weight\": 192,\
		\"max\": \"1\",\
		\"type\": \"Period\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"ElementDefinition.maxValueRatio\",\
		\"weight\": 192,\
		\"max\": \"1\",\
		\"type\": \"Ratio\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"ElementDefinition.maxValueSampledData\",\
		\"weight\": 192,\
		\"max\": \"1\",\
		\"type\": \"SampledData\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"ElementDefinition.maxValueSignature\",\
		\"weight\": 192,\
		\"max\": \"1\",\
		\"type\": \"Signature\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"ElementDefinition.maxValueHumanName\",\
		\"weight\": 192,\
		\"max\": \"1\",\
		\"type\": \"HumanName\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"ElementDefinition.maxValueAddress\",\
		\"weight\": 192,\
		\"max\": \"1\",\
		\"type\": \"Address\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"ElementDefinition.maxValueContactPoint\",\
		\"weight\": 192,\
		\"max\": \"1\",\
		\"type\": \"ContactPoint\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"ElementDefinition.maxValueTiming\",\
		\"weight\": 192,\
		\"max\": \"1\",\
		\"type\": \"Timing\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"ElementDefinition.maxValueReference\",\
		\"weight\": 192,\
		\"max\": \"1\",\
		\"type\": \"Reference\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"ElementDefinition.maxValueMeta\",\
		\"weight\": 192,\
		\"max\": \"1\",\
		\"type\": \"Meta\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"ElementDefinition.maxLength\",\
		\"weight\": 193,\
		\"max\": \"1\",\
		\"type\": \"integer\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"ElementDefinition.condition\",\
		\"weight\": 194,\
		\"max\": \"*\",\
		\"type\": \"id\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"ElementDefinition.constraint\",\
		\"weight\": 195,\
		\"max\": \"*\",\
		\"type\": \"Element\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"ElementDefinition.constraint.id\",\
		\"weight\": 196,\
		\"max\": \"1\",\
		\"type\": \"id\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"ElementDefinition.constraint.extension\",\
		\"weight\": 197,\
		\"max\": \"*\",\
		\"type\": \"Extension\"\
	},\
	{\
		\"min\": \"1\",\
		\"path\": \"ElementDefinition.constraint.key\",\
		\"weight\": 198,\
		\"max\": \"1\",\
		\"type\": \"id\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"ElementDefinition.constraint.requirements\",\
		\"weight\": 199,\
		\"max\": \"1\",\
		\"type\": \"string\"\
	},\
	{\
		\"min\": \"1\",\
		\"path\": \"ElementDefinition.constraint.severity\",\
		\"weight\": 200,\
		\"max\": \"1\",\
		\"type\": \"code\"\
	},\
	{\
		\"min\": \"1\",\
		\"path\": \"ElementDefinition.constraint.human\",\
		\"weight\": 201,\
		\"max\": \"1\",\
		\"type\": \"string\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"ElementDefinition.constraint.expression\",\
		\"weight\": 202,\
		\"max\": \"1\",\
		\"type\": \"string\"\
	},\
	{\
		\"min\": \"1\",\
		\"path\": \"ElementDefinition.constraint.xpath\",\
		\"weight\": 203,\
		\"max\": \"1\",\
		\"type\": \"string\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"ElementDefinition.mustSupport\",\
		\"weight\": 204,\
		\"max\": \"1\",\
		\"type\": \"boolean\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"ElementDefinition.isModifier\",\
		\"weight\": 205,\
		\"max\": \"1\",\
		\"type\": \"boolean\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"ElementDefinition.isSummary\",\
		\"weight\": 206,\
		\"max\": \"1\",\
		\"type\": \"boolean\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"ElementDefinition.binding\",\
		\"weight\": 207,\
		\"max\": \"1\",\
		\"type\": \"Element\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"ElementDefinition.binding.id\",\
		\"weight\": 208,\
		\"max\": \"1\",\
		\"type\": \"id\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"ElementDefinition.binding.extension\",\
		\"weight\": 209,\
		\"max\": \"*\",\
		\"type\": \"Extension\"\
	},\
	{\
		\"min\": \"1\",\
		\"path\": \"ElementDefinition.binding.strength\",\
		\"weight\": 210,\
		\"max\": \"1\",\
		\"type\": \"code\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"ElementDefinition.binding.description\",\
		\"weight\": 211,\
		\"max\": \"1\",\
		\"type\": \"string\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"ElementDefinition.binding.valueSetUri\",\
		\"weight\": 212,\
		\"max\": \"1\",\
		\"type\": \"uri\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"ElementDefinition.binding.valueSetReference\",\
		\"weight\": 212,\
		\"max\": \"1\",\
		\"type\": \"Reference\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"ElementDefinition.mapping\",\
		\"weight\": 213,\
		\"max\": \"*\",\
		\"type\": \"Element\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"ElementDefinition.mapping.id\",\
		\"weight\": 214,\
		\"max\": \"1\",\
		\"type\": \"id\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"ElementDefinition.mapping.extension\",\
		\"weight\": 215,\
		\"max\": \"*\",\
		\"type\": \"Extension\"\
	},\
	{\
		\"min\": \"1\",\
		\"path\": \"ElementDefinition.mapping.identity\",\
		\"weight\": 216,\
		\"max\": \"1\",\
		\"type\": \"id\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"ElementDefinition.mapping.language\",\
		\"weight\": 217,\
		\"max\": \"1\",\
		\"type\": \"code\"\
	},\
	{\
		\"min\": \"1\",\
		\"path\": \"ElementDefinition.mapping.map\",\
		\"weight\": 218,\
		\"max\": \"1\",\
		\"type\": \"string\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Timing\",\
		\"weight\": 219,\
		\"max\": \"*\",\
		\"type\": \"Element\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Timing.id\",\
		\"weight\": 220,\
		\"max\": \"1\",\
		\"type\": \"id\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Timing.extension\",\
		\"weight\": 221,\
		\"max\": \"*\",\
		\"type\": \"Extension\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Timing.event\",\
		\"weight\": 222,\
		\"max\": \"*\",\
		\"type\": \"dateTime\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Timing.repeat\",\
		\"weight\": 223,\
		\"max\": \"1\",\
		\"type\": \"Element\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Timing.repeat.id\",\
		\"weight\": 224,\
		\"max\": \"1\",\
		\"type\": \"id\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Timing.repeat.extension\",\
		\"weight\": 225,\
		\"max\": \"*\",\
		\"type\": \"Extension\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Timing.repeat.boundsQuantity\",\
		\"weight\": 226,\
		\"max\": \"1\",\
		\"type\": \"Quantity\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Timing.repeat.boundsRange\",\
		\"weight\": 226,\
		\"max\": \"1\",\
		\"type\": \"Range\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Timing.repeat.boundsPeriod\",\
		\"weight\": 226,\
		\"max\": \"1\",\
		\"type\": \"Period\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Timing.repeat.count\",\
		\"weight\": 227,\
		\"max\": \"1\",\
		\"type\": \"integer\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Timing.repeat.countMax\",\
		\"weight\": 228,\
		\"max\": \"1\",\
		\"type\": \"integer\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Timing.repeat.duration\",\
		\"weight\": 229,\
		\"max\": \"1\",\
		\"type\": \"decimal\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Timing.repeat.durationMax\",\
		\"weight\": 230,\
		\"max\": \"1\",\
		\"type\": \"decimal\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Timing.repeat.durationUnit\",\
		\"weight\": 231,\
		\"max\": \"1\",\
		\"type\": \"code\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Timing.repeat.frequency\",\
		\"weight\": 232,\
		\"max\": \"1\",\
		\"type\": \"integer\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Timing.repeat.frequencyMax\",\
		\"weight\": 233,\
		\"max\": \"1\",\
		\"type\": \"integer\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Timing.repeat.period\",\
		\"weight\": 234,\
		\"max\": \"1\",\
		\"type\": \"decimal\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Timing.repeat.periodMax\",\
		\"weight\": 235,\
		\"max\": \"1\",\
		\"type\": \"decimal\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Timing.repeat.periodUnit\",\
		\"weight\": 236,\
		\"max\": \"1\",\
		\"type\": \"code\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Timing.repeat.when\",\
		\"weight\": 237,\
		\"max\": \"1\",\
		\"type\": \"code\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Timing.repeat.offset\",\
		\"weight\": 238,\
		\"max\": \"1\",\
		\"type\": \"unsignedInt\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Timing.code\",\
		\"weight\": 239,\
		\"max\": \"1\",\
		\"type\": \"CodeableConcept\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"ModuleMetadata\",\
		\"weight\": 240,\
		\"max\": \"*\",\
		\"type\": \"Element\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"ModuleMetadata.id\",\
		\"weight\": 241,\
		\"max\": \"1\",\
		\"type\": \"id\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"ModuleMetadata.extension\",\
		\"weight\": 242,\
		\"max\": \"*\",\
		\"type\": \"Extension\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"ModuleMetadata.url\",\
		\"weight\": 243,\
		\"max\": \"1\",\
		\"type\": \"uri\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"ModuleMetadata.identifier\",\
		\"weight\": 244,\
		\"max\": \"*\",\
		\"type\": \"Identifier\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"ModuleMetadata.version\",\
		\"weight\": 245,\
		\"max\": \"1\",\
		\"type\": \"string\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"ModuleMetadata.name\",\
		\"weight\": 246,\
		\"max\": \"1\",\
		\"type\": \"string\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"ModuleMetadata.title\",\
		\"weight\": 247,\
		\"max\": \"1\",\
		\"type\": \"string\"\
	},\
	{\
		\"min\": \"1\",\
		\"path\": \"ModuleMetadata.type\",\
		\"weight\": 248,\
		\"max\": \"1\",\
		\"type\": \"code\"\
	},\
	{\
		\"min\": \"1\",\
		\"path\": \"ModuleMetadata.status\",\
		\"weight\": 249,\
		\"max\": \"1\",\
		\"type\": \"code\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"ModuleMetadata.experimental\",\
		\"weight\": 250,\
		\"max\": \"1\",\
		\"type\": \"boolean\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"ModuleMetadata.description\",\
		\"weight\": 251,\
		\"max\": \"1\",\
		\"type\": \"string\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"ModuleMetadata.purpose\",\
		\"weight\": 252,\
		\"max\": \"1\",\
		\"type\": \"string\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"ModuleMetadata.usage\",\
		\"weight\": 253,\
		\"max\": \"1\",\
		\"type\": \"string\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"ModuleMetadata.publicationDate\",\
		\"weight\": 254,\
		\"max\": \"1\",\
		\"type\": \"date\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"ModuleMetadata.lastReviewDate\",\
		\"weight\": 255,\
		\"max\": \"1\",\
		\"type\": \"date\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"ModuleMetadata.effectivePeriod\",\
		\"weight\": 256,\
		\"max\": \"1\",\
		\"type\": \"Period\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"ModuleMetadata.coverage\",\
		\"weight\": 257,\
		\"max\": \"*\",\
		\"type\": \"Element\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"ModuleMetadata.coverage.id\",\
		\"weight\": 258,\
		\"max\": \"1\",\
		\"type\": \"id\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"ModuleMetadata.coverage.extension\",\
		\"weight\": 259,\
		\"max\": \"*\",\
		\"type\": \"Extension\"\
	},\
	{\
		\"min\": \"1\",\
		\"path\": \"ModuleMetadata.coverage.focus\",\
		\"weight\": 260,\
		\"max\": \"1\",\
		\"type\": \"Coding\"\
	},\
	{\
		\"min\": \"1\",\
		\"path\": \"ModuleMetadata.coverage.value\",\
		\"weight\": 261,\
		\"max\": \"1\",\
		\"type\": \"CodeableConcept\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"ModuleMetadata.topic\",\
		\"weight\": 262,\
		\"max\": \"*\",\
		\"type\": \"CodeableConcept\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"ModuleMetadata.contributor\",\
		\"weight\": 263,\
		\"max\": \"*\",\
		\"type\": \"Element\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"ModuleMetadata.contributor.id\",\
		\"weight\": 264,\
		\"max\": \"1\",\
		\"type\": \"id\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"ModuleMetadata.contributor.extension\",\
		\"weight\": 265,\
		\"max\": \"*\",\
		\"type\": \"Extension\"\
	},\
	{\
		\"min\": \"1\",\
		\"path\": \"ModuleMetadata.contributor.type\",\
		\"weight\": 266,\
		\"max\": \"1\",\
		\"type\": \"code\"\
	},\
	{\
		\"min\": \"1\",\
		\"path\": \"ModuleMetadata.contributor.name\",\
		\"weight\": 267,\
		\"max\": \"1\",\
		\"type\": \"string\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"ModuleMetadata.contributor.contact\",\
		\"weight\": 268,\
		\"max\": \"*\",\
		\"type\": \"Element\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"ModuleMetadata.contributor.contact.id\",\
		\"weight\": 269,\
		\"max\": \"1\",\
		\"type\": \"id\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"ModuleMetadata.contributor.contact.extension\",\
		\"weight\": 270,\
		\"max\": \"*\",\
		\"type\": \"Extension\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"ModuleMetadata.contributor.contact.name\",\
		\"weight\": 271,\
		\"max\": \"1\",\
		\"type\": \"string\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"ModuleMetadata.contributor.contact.telecom\",\
		\"weight\": 272,\
		\"max\": \"*\",\
		\"type\": \"ContactPoint\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"ModuleMetadata.publisher\",\
		\"weight\": 273,\
		\"max\": \"1\",\
		\"type\": \"string\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"ModuleMetadata.contact\",\
		\"weight\": 274,\
		\"max\": \"*\",\
		\"type\": \"Element\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"ModuleMetadata.contact.id\",\
		\"weight\": 275,\
		\"max\": \"1\",\
		\"type\": \"id\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"ModuleMetadata.contact.extension\",\
		\"weight\": 276,\
		\"max\": \"*\",\
		\"type\": \"Extension\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"ModuleMetadata.contact.name\",\
		\"weight\": 277,\
		\"max\": \"1\",\
		\"type\": \"string\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"ModuleMetadata.contact.telecom\",\
		\"weight\": 278,\
		\"max\": \"*\",\
		\"type\": \"ContactPoint\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"ModuleMetadata.copyright\",\
		\"weight\": 279,\
		\"max\": \"1\",\
		\"type\": \"string\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"ModuleMetadata.relatedResource\",\
		\"weight\": 280,\
		\"max\": \"*\",\
		\"type\": \"Element\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"ModuleMetadata.relatedResource.id\",\
		\"weight\": 281,\
		\"max\": \"1\",\
		\"type\": \"id\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"ModuleMetadata.relatedResource.extension\",\
		\"weight\": 282,\
		\"max\": \"*\",\
		\"type\": \"Extension\"\
	},\
	{\
		\"min\": \"1\",\
		\"path\": \"ModuleMetadata.relatedResource.type\",\
		\"weight\": 283,\
		\"max\": \"1\",\
		\"type\": \"code\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"ModuleMetadata.relatedResource.document\",\
		\"weight\": 284,\
		\"max\": \"1\",\
		\"type\": \"Attachment\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"ModuleMetadata.relatedResource.resource\",\
		\"weight\": 285,\
		\"max\": \"1\",\
		\"type\": \"Reference\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"ActionDefinition\",\
		\"weight\": 286,\
		\"max\": \"*\",\
		\"type\": \"Element\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"ActionDefinition.id\",\
		\"weight\": 287,\
		\"max\": \"1\",\
		\"type\": \"id\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"ActionDefinition.extension\",\
		\"weight\": 288,\
		\"max\": \"*\",\
		\"type\": \"Extension\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"ActionDefinition.actionIdentifier\",\
		\"weight\": 289,\
		\"max\": \"1\",\
		\"type\": \"Identifier\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"ActionDefinition.label\",\
		\"weight\": 290,\
		\"max\": \"1\",\
		\"type\": \"string\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"ActionDefinition.title\",\
		\"weight\": 291,\
		\"max\": \"1\",\
		\"type\": \"string\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"ActionDefinition.description\",\
		\"weight\": 292,\
		\"max\": \"1\",\
		\"type\": \"string\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"ActionDefinition.textEquivalent\",\
		\"weight\": 293,\
		\"max\": \"1\",\
		\"type\": \"string\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"ActionDefinition.concept\",\
		\"weight\": 294,\
		\"max\": \"*\",\
		\"type\": \"CodeableConcept\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"ActionDefinition.supportingEvidence\",\
		\"weight\": 295,\
		\"max\": \"*\",\
		\"type\": \"Attachment\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"ActionDefinition.documentation\",\
		\"weight\": 296,\
		\"max\": \"*\",\
		\"type\": \"Attachment\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"ActionDefinition.relatedAction\",\
		\"weight\": 297,\
		\"max\": \"1\",\
		\"type\": \"Element\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"ActionDefinition.relatedAction.id\",\
		\"weight\": 298,\
		\"max\": \"1\",\
		\"type\": \"id\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"ActionDefinition.relatedAction.extension\",\
		\"weight\": 299,\
		\"max\": \"*\",\
		\"type\": \"Extension\"\
	},\
	{\
		\"min\": \"1\",\
		\"path\": \"ActionDefinition.relatedAction.actionIdentifier\",\
		\"weight\": 300,\
		\"max\": \"1\",\
		\"type\": \"Identifier\"\
	},\
	{\
		\"min\": \"1\",\
		\"path\": \"ActionDefinition.relatedAction.relationship\",\
		\"weight\": 301,\
		\"max\": \"1\",\
		\"type\": \"code\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"ActionDefinition.relatedAction.offsetQuantity\",\
		\"weight\": 302,\
		\"max\": \"1\",\
		\"type\": \"Quantity\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"ActionDefinition.relatedAction.offsetRange\",\
		\"weight\": 302,\
		\"max\": \"1\",\
		\"type\": \"Range\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"ActionDefinition.relatedAction.anchor\",\
		\"weight\": 303,\
		\"max\": \"1\",\
		\"type\": \"code\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"ActionDefinition.participantType\",\
		\"weight\": 304,\
		\"max\": \"*\",\
		\"type\": \"code\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"ActionDefinition.type\",\
		\"weight\": 305,\
		\"max\": \"1\",\
		\"type\": \"code\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"ActionDefinition.behavior\",\
		\"weight\": 306,\
		\"max\": \"*\",\
		\"type\": \"Element\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"ActionDefinition.behavior.id\",\
		\"weight\": 307,\
		\"max\": \"1\",\
		\"type\": \"id\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"ActionDefinition.behavior.extension\",\
		\"weight\": 308,\
		\"max\": \"*\",\
		\"type\": \"Extension\"\
	},\
	{\
		\"min\": \"1\",\
		\"path\": \"ActionDefinition.behavior.type\",\
		\"weight\": 309,\
		\"max\": \"1\",\
		\"type\": \"Coding\"\
	},\
	{\
		\"min\": \"1\",\
		\"path\": \"ActionDefinition.behavior.value\",\
		\"weight\": 310,\
		\"max\": \"1\",\
		\"type\": \"Coding\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"ActionDefinition.resource\",\
		\"weight\": 311,\
		\"max\": \"1\",\
		\"type\": \"Reference\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"ActionDefinition.customization\",\
		\"weight\": 312,\
		\"max\": \"*\",\
		\"type\": \"Element\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"ActionDefinition.customization.id\",\
		\"weight\": 313,\
		\"max\": \"1\",\
		\"type\": \"id\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"ActionDefinition.customization.extension\",\
		\"weight\": 314,\
		\"max\": \"*\",\
		\"type\": \"Extension\"\
	},\
	{\
		\"min\": \"1\",\
		\"path\": \"ActionDefinition.customization.path\",\
		\"weight\": 315,\
		\"max\": \"1\",\
		\"type\": \"string\"\
	},\
	{\
		\"min\": \"1\",\
		\"path\": \"ActionDefinition.customization.expression\",\
		\"weight\": 316,\
		\"max\": \"1\",\
		\"type\": \"string\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"ActionDefinition.action\",\
		\"weight\": 317,\
		\"max\": \"*\",\
		\"type\": \"ActionDefinition\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Address\",\
		\"weight\": 318,\
		\"max\": \"*\",\
		\"type\": \"Element\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Address.id\",\
		\"weight\": 319,\
		\"max\": \"1\",\
		\"type\": \"id\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Address.extension\",\
		\"weight\": 320,\
		\"max\": \"*\",\
		\"type\": \"Extension\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Address.use\",\
		\"weight\": 321,\
		\"max\": \"1\",\
		\"type\": \"code\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Address.type\",\
		\"weight\": 322,\
		\"max\": \"1\",\
		\"type\": \"code\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Address.text\",\
		\"weight\": 323,\
		\"max\": \"1\",\
		\"type\": \"string\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Address.line\",\
		\"weight\": 324,\
		\"max\": \"*\",\
		\"type\": \"string\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Address.city\",\
		\"weight\": 325,\
		\"max\": \"1\",\
		\"type\": \"string\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Address.district\",\
		\"weight\": 326,\
		\"max\": \"1\",\
		\"type\": \"string\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Address.state\",\
		\"weight\": 327,\
		\"max\": \"1\",\
		\"type\": \"string\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Address.postalCode\",\
		\"weight\": 328,\
		\"max\": \"1\",\
		\"type\": \"string\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Address.country\",\
		\"weight\": 329,\
		\"max\": \"1\",\
		\"type\": \"string\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Address.period\",\
		\"weight\": 330,\
		\"max\": \"1\",\
		\"type\": \"Period\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"HumanName\",\
		\"weight\": 331,\
		\"max\": \"*\",\
		\"type\": \"Element\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"HumanName.id\",\
		\"weight\": 332,\
		\"max\": \"1\",\
		\"type\": \"id\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"HumanName.extension\",\
		\"weight\": 333,\
		\"max\": \"*\",\
		\"type\": \"Extension\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"HumanName.use\",\
		\"weight\": 334,\
		\"max\": \"1\",\
		\"type\": \"code\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"HumanName.text\",\
		\"weight\": 335,\
		\"max\": \"1\",\
		\"type\": \"string\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"HumanName.family\",\
		\"weight\": 336,\
		\"max\": \"*\",\
		\"type\": \"string\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"HumanName.given\",\
		\"weight\": 337,\
		\"max\": \"*\",\
		\"type\": \"string\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"HumanName.prefix\",\
		\"weight\": 338,\
		\"max\": \"*\",\
		\"type\": \"string\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"HumanName.suffix\",\
		\"weight\": 339,\
		\"max\": \"*\",\
		\"type\": \"string\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"HumanName.period\",\
		\"weight\": 340,\
		\"max\": \"1\",\
		\"type\": \"Period\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"DataRequirement\",\
		\"weight\": 341,\
		\"max\": \"*\",\
		\"type\": \"Element\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"DataRequirement.id\",\
		\"weight\": 342,\
		\"max\": \"1\",\
		\"type\": \"id\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"DataRequirement.extension\",\
		\"weight\": 343,\
		\"max\": \"*\",\
		\"type\": \"Extension\"\
	},\
	{\
		\"min\": \"1\",\
		\"path\": \"DataRequirement.type\",\
		\"weight\": 344,\
		\"max\": \"1\",\
		\"type\": \"code\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"DataRequirement.profile\",\
		\"weight\": 345,\
		\"max\": \"1\",\
		\"type\": \"Reference\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"DataRequirement.mustSupport\",\
		\"weight\": 346,\
		\"max\": \"*\",\
		\"type\": \"string\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"DataRequirement.codeFilter\",\
		\"weight\": 347,\
		\"max\": \"*\",\
		\"type\": \"Element\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"DataRequirement.codeFilter.id\",\
		\"weight\": 348,\
		\"max\": \"1\",\
		\"type\": \"id\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"DataRequirement.codeFilter.extension\",\
		\"weight\": 349,\
		\"max\": \"*\",\
		\"type\": \"Extension\"\
	},\
	{\
		\"min\": \"1\",\
		\"path\": \"DataRequirement.codeFilter.path\",\
		\"weight\": 350,\
		\"max\": \"1\",\
		\"type\": \"string\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"DataRequirement.codeFilter.valueSetString\",\
		\"weight\": 351,\
		\"max\": \"1\",\
		\"type\": \"string\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"DataRequirement.codeFilter.valueSetReference\",\
		\"weight\": 351,\
		\"max\": \"1\",\
		\"type\": \"Reference\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"DataRequirement.codeFilter.valueCode\",\
		\"weight\": 352,\
		\"max\": \"*\",\
		\"type\": \"code\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"DataRequirement.codeFilter.valueCoding\",\
		\"weight\": 353,\
		\"max\": \"*\",\
		\"type\": \"Coding\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"DataRequirement.codeFilter.valueCodeableConcept\",\
		\"weight\": 354,\
		\"max\": \"*\",\
		\"type\": \"CodeableConcept\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"DataRequirement.dateFilter\",\
		\"weight\": 355,\
		\"max\": \"*\",\
		\"type\": \"Element\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"DataRequirement.dateFilter.id\",\
		\"weight\": 356,\
		\"max\": \"1\",\
		\"type\": \"id\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"DataRequirement.dateFilter.extension\",\
		\"weight\": 357,\
		\"max\": \"*\",\
		\"type\": \"Extension\"\
	},\
	{\
		\"min\": \"1\",\
		\"path\": \"DataRequirement.dateFilter.path\",\
		\"weight\": 358,\
		\"max\": \"1\",\
		\"type\": \"string\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"DataRequirement.dateFilter.valueDateTime\",\
		\"weight\": 359,\
		\"max\": \"1\",\
		\"type\": \"dateTime\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"DataRequirement.dateFilter.valuePeriod\",\
		\"weight\": 359,\
		\"max\": \"1\",\
		\"type\": \"Period\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Meta\",\
		\"weight\": 360,\
		\"max\": \"*\",\
		\"type\": \"Element\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Meta.id\",\
		\"weight\": 361,\
		\"max\": \"1\",\
		\"type\": \"id\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Meta.extension\",\
		\"weight\": 362,\
		\"max\": \"*\",\
		\"type\": \"Extension\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Meta.versionId\",\
		\"weight\": 363,\
		\"max\": \"1\",\
		\"type\": \"id\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Meta.lastUpdated\",\
		\"weight\": 364,\
		\"max\": \"1\",\
		\"type\": \"instant\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Meta.profile\",\
		\"weight\": 365,\
		\"max\": \"*\",\
		\"type\": \"uri\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Meta.security\",\
		\"weight\": 366,\
		\"max\": \"*\",\
		\"type\": \"Coding\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Meta.tag\",\
		\"weight\": 367,\
		\"max\": \"*\",\
		\"type\": \"Coding\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"ParameterDefinition\",\
		\"weight\": 368,\
		\"max\": \"*\",\
		\"type\": \"Element\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"ParameterDefinition.id\",\
		\"weight\": 369,\
		\"max\": \"1\",\
		\"type\": \"id\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"ParameterDefinition.extension\",\
		\"weight\": 370,\
		\"max\": \"*\",\
		\"type\": \"Extension\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"ParameterDefinition.name\",\
		\"weight\": 371,\
		\"max\": \"1\",\
		\"type\": \"code\"\
	},\
	{\
		\"min\": \"1\",\
		\"path\": \"ParameterDefinition.use\",\
		\"weight\": 372,\
		\"max\": \"1\",\
		\"type\": \"code\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"ParameterDefinition.min\",\
		\"weight\": 373,\
		\"max\": \"1\",\
		\"type\": \"integer\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"ParameterDefinition.max\",\
		\"weight\": 374,\
		\"max\": \"1\",\
		\"type\": \"string\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"ParameterDefinition.documentation\",\
		\"weight\": 375,\
		\"max\": \"1\",\
		\"type\": \"string\"\
	},\
	{\
		\"min\": \"1\",\
		\"path\": \"ParameterDefinition.type\",\
		\"weight\": 376,\
		\"max\": \"1\",\
		\"type\": \"code\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"ParameterDefinition.profile\",\
		\"weight\": 377,\
		\"max\": \"1\",\
		\"type\": \"Reference\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"ContactPoint\",\
		\"weight\": 378,\
		\"max\": \"*\",\
		\"type\": \"Element\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"ContactPoint.id\",\
		\"weight\": 379,\
		\"max\": \"1\",\
		\"type\": \"id\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"ContactPoint.extension\",\
		\"weight\": 380,\
		\"max\": \"*\",\
		\"type\": \"Extension\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"ContactPoint.system\",\
		\"weight\": 381,\
		\"max\": \"1\",\
		\"type\": \"code\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"ContactPoint.value\",\
		\"weight\": 382,\
		\"max\": \"1\",\
		\"type\": \"string\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"ContactPoint.use\",\
		\"weight\": 383,\
		\"max\": \"1\",\
		\"type\": \"code\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"ContactPoint.rank\",\
		\"weight\": 384,\
		\"max\": \"1\",\
		\"type\": \"positiveInt\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"ContactPoint.period\",\
		\"weight\": 385,\
		\"max\": \"1\",\
		\"type\": \"Period\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"CodeSystem\",\
		\"weight\": 386,\
		\"max\": \"*\",\
		\"type\": \"DomainResource\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"CodeSystem.id\",\
		\"weight\": 387,\
		\"max\": \"1\",\
		\"type\": \"id\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"CodeSystem.meta\",\
		\"weight\": 388,\
		\"max\": \"1\",\
		\"type\": \"Meta\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"CodeSystem.implicitRules\",\
		\"weight\": 389,\
		\"max\": \"1\",\
		\"type\": \"uri\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"CodeSystem.language\",\
		\"weight\": 390,\
		\"max\": \"1\",\
		\"type\": \"code\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"CodeSystem.text\",\
		\"weight\": 391,\
		\"max\": \"1\",\
		\"type\": \"Narrative\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"CodeSystem.contained\",\
		\"weight\": 392,\
		\"max\": \"*\",\
		\"type\": \"Resource\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"CodeSystem.extension\",\
		\"weight\": 393,\
		\"max\": \"*\",\
		\"type\": \"Extension\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"CodeSystem.modifierExtension\",\
		\"weight\": 394,\
		\"max\": \"*\",\
		\"type\": \"Extension\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"CodeSystem.url\",\
		\"weight\": 395,\
		\"max\": \"1\",\
		\"type\": \"uri\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"CodeSystem.identifier\",\
		\"weight\": 396,\
		\"max\": \"1\",\
		\"type\": \"Identifier\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"CodeSystem.version\",\
		\"weight\": 397,\
		\"max\": \"1\",\
		\"type\": \"string\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"CodeSystem.name\",\
		\"weight\": 398,\
		\"max\": \"1\",\
		\"type\": \"string\"\
	},\
	{\
		\"min\": \"1\",\
		\"path\": \"CodeSystem.status\",\
		\"weight\": 399,\
		\"max\": \"1\",\
		\"type\": \"code\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"CodeSystem.experimental\",\
		\"weight\": 400,\
		\"max\": \"1\",\
		\"type\": \"boolean\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"CodeSystem.publisher\",\
		\"weight\": 401,\
		\"max\": \"1\",\
		\"type\": \"string\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"CodeSystem.contact\",\
		\"weight\": 402,\
		\"max\": \"*\",\
		\"type\": \"BackboneElement\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"CodeSystem.contact.id\",\
		\"weight\": 403,\
		\"max\": \"1\",\
		\"type\": \"id\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"CodeSystem.contact.extension\",\
		\"weight\": 404,\
		\"max\": \"*\",\
		\"type\": \"Extension\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"CodeSystem.contact.modifierExtension\",\
		\"weight\": 405,\
		\"max\": \"*\",\
		\"type\": \"Extension\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"CodeSystem.contact.name\",\
		\"weight\": 406,\
		\"max\": \"1\",\
		\"type\": \"string\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"CodeSystem.contact.telecom\",\
		\"weight\": 407,\
		\"max\": \"*\",\
		\"type\": \"ContactPoint\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"CodeSystem.date\",\
		\"weight\": 408,\
		\"max\": \"1\",\
		\"type\": \"dateTime\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"CodeSystem.description\",\
		\"weight\": 409,\
		\"max\": \"1\",\
		\"type\": \"string\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"CodeSystem.useContext\",\
		\"weight\": 410,\
		\"max\": \"*\",\
		\"type\": \"CodeableConcept\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"CodeSystem.requirements\",\
		\"weight\": 411,\
		\"max\": \"1\",\
		\"type\": \"string\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"CodeSystem.copyright\",\
		\"weight\": 412,\
		\"max\": \"1\",\
		\"type\": \"string\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"CodeSystem.caseSensitive\",\
		\"weight\": 413,\
		\"max\": \"1\",\
		\"type\": \"boolean\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"CodeSystem.valueSet\",\
		\"weight\": 414,\
		\"max\": \"1\",\
		\"type\": \"uri\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"CodeSystem.compositional\",\
		\"weight\": 415,\
		\"max\": \"1\",\
		\"type\": \"boolean\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"CodeSystem.versionNeeded\",\
		\"weight\": 416,\
		\"max\": \"1\",\
		\"type\": \"boolean\"\
	},\
	{\
		\"min\": \"1\",\
		\"path\": \"CodeSystem.content\",\
		\"weight\": 417,\
		\"max\": \"1\",\
		\"type\": \"code\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"CodeSystem.count\",\
		\"weight\": 418,\
		\"max\": \"1\",\
		\"type\": \"unsignedInt\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"CodeSystem.filter\",\
		\"weight\": 419,\
		\"max\": \"*\",\
		\"type\": \"BackboneElement\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"CodeSystem.filter.id\",\
		\"weight\": 420,\
		\"max\": \"1\",\
		\"type\": \"id\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"CodeSystem.filter.extension\",\
		\"weight\": 421,\
		\"max\": \"*\",\
		\"type\": \"Extension\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"CodeSystem.filter.modifierExtension\",\
		\"weight\": 422,\
		\"max\": \"*\",\
		\"type\": \"Extension\"\
	},\
	{\
		\"min\": \"1\",\
		\"path\": \"CodeSystem.filter.code\",\
		\"weight\": 423,\
		\"max\": \"1\",\
		\"type\": \"code\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"CodeSystem.filter.description\",\
		\"weight\": 424,\
		\"max\": \"1\",\
		\"type\": \"string\"\
	},\
	{\
		\"min\": \"1\",\
		\"path\": \"CodeSystem.filter.operator\",\
		\"weight\": 425,\
		\"max\": \"*\",\
		\"type\": \"code\"\
	},\
	{\
		\"min\": \"1\",\
		\"path\": \"CodeSystem.filter.value\",\
		\"weight\": 426,\
		\"max\": \"1\",\
		\"type\": \"string\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"CodeSystem.property\",\
		\"weight\": 427,\
		\"max\": \"*\",\
		\"type\": \"BackboneElement\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"CodeSystem.property.id\",\
		\"weight\": 428,\
		\"max\": \"1\",\
		\"type\": \"id\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"CodeSystem.property.extension\",\
		\"weight\": 429,\
		\"max\": \"*\",\
		\"type\": \"Extension\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"CodeSystem.property.modifierExtension\",\
		\"weight\": 430,\
		\"max\": \"*\",\
		\"type\": \"Extension\"\
	},\
	{\
		\"min\": \"1\",\
		\"path\": \"CodeSystem.property.code\",\
		\"weight\": 431,\
		\"max\": \"1\",\
		\"type\": \"code\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"CodeSystem.property.description\",\
		\"weight\": 432,\
		\"max\": \"1\",\
		\"type\": \"string\"\
	},\
	{\
		\"min\": \"1\",\
		\"path\": \"CodeSystem.property.type\",\
		\"weight\": 433,\
		\"max\": \"1\",\
		\"type\": \"code\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"CodeSystem.concept\",\
		\"weight\": 434,\
		\"max\": \"*\",\
		\"type\": \"BackboneElement\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"CodeSystem.concept.id\",\
		\"weight\": 435,\
		\"max\": \"1\",\
		\"type\": \"id\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"CodeSystem.concept.extension\",\
		\"weight\": 436,\
		\"max\": \"*\",\
		\"type\": \"Extension\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"CodeSystem.concept.modifierExtension\",\
		\"weight\": 437,\
		\"max\": \"*\",\
		\"type\": \"Extension\"\
	},\
	{\
		\"min\": \"1\",\
		\"path\": \"CodeSystem.concept.code\",\
		\"weight\": 438,\
		\"max\": \"1\",\
		\"type\": \"code\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"CodeSystem.concept.display\",\
		\"weight\": 439,\
		\"max\": \"1\",\
		\"type\": \"string\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"CodeSystem.concept.definition\",\
		\"weight\": 440,\
		\"max\": \"1\",\
		\"type\": \"string\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"CodeSystem.concept.designation\",\
		\"weight\": 441,\
		\"max\": \"*\",\
		\"type\": \"BackboneElement\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"CodeSystem.concept.designation.id\",\
		\"weight\": 442,\
		\"max\": \"1\",\
		\"type\": \"id\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"CodeSystem.concept.designation.extension\",\
		\"weight\": 443,\
		\"max\": \"*\",\
		\"type\": \"Extension\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"CodeSystem.concept.designation.modifierExtension\",\
		\"weight\": 444,\
		\"max\": \"*\",\
		\"type\": \"Extension\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"CodeSystem.concept.designation.language\",\
		\"weight\": 445,\
		\"max\": \"1\",\
		\"type\": \"code\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"CodeSystem.concept.designation.use\",\
		\"weight\": 446,\
		\"max\": \"1\",\
		\"type\": \"Coding\"\
	},\
	{\
		\"min\": \"1\",\
		\"path\": \"CodeSystem.concept.designation.value\",\
		\"weight\": 447,\
		\"max\": \"1\",\
		\"type\": \"string\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"CodeSystem.concept.property\",\
		\"weight\": 448,\
		\"max\": \"*\",\
		\"type\": \"BackboneElement\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"CodeSystem.concept.property.id\",\
		\"weight\": 449,\
		\"max\": \"1\",\
		\"type\": \"id\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"CodeSystem.concept.property.extension\",\
		\"weight\": 450,\
		\"max\": \"*\",\
		\"type\": \"Extension\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"CodeSystem.concept.property.modifierExtension\",\
		\"weight\": 451,\
		\"max\": \"*\",\
		\"type\": \"Extension\"\
	},\
	{\
		\"min\": \"1\",\
		\"path\": \"CodeSystem.concept.property.code\",\
		\"weight\": 452,\
		\"max\": \"1\",\
		\"type\": \"code\"\
	},\
	{\
		\"min\": \"1\",\
		\"path\": \"CodeSystem.concept.property.valueCode\",\
		\"weight\": 453,\
		\"max\": \"1\",\
		\"type\": \"code\"\
	},\
	{\
		\"min\": \"1\",\
		\"path\": \"CodeSystem.concept.property.valueCoding\",\
		\"weight\": 453,\
		\"max\": \"1\",\
		\"type\": \"Coding\"\
	},\
	{\
		\"min\": \"1\",\
		\"path\": \"CodeSystem.concept.property.valueString\",\
		\"weight\": 453,\
		\"max\": \"1\",\
		\"type\": \"string\"\
	},\
	{\
		\"min\": \"1\",\
		\"path\": \"CodeSystem.concept.property.valueInteger\",\
		\"weight\": 453,\
		\"max\": \"1\",\
		\"type\": \"integer\"\
	},\
	{\
		\"min\": \"1\",\
		\"path\": \"CodeSystem.concept.property.valueBoolean\",\
		\"weight\": 453,\
		\"max\": \"1\",\
		\"type\": \"boolean\"\
	},\
	{\
		\"min\": \"1\",\
		\"path\": \"CodeSystem.concept.property.valueDateTime\",\
		\"weight\": 453,\
		\"max\": \"1\",\
		\"type\": \"dateTime\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"CodeSystem.concept.concept\",\
		\"weight\": 454,\
		\"max\": \"*\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"ValueSet\",\
		\"weight\": 455,\
		\"max\": \"*\",\
		\"type\": \"DomainResource\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"ValueSet.id\",\
		\"weight\": 456,\
		\"max\": \"1\",\
		\"type\": \"id\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"ValueSet.meta\",\
		\"weight\": 457,\
		\"max\": \"1\",\
		\"type\": \"Meta\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"ValueSet.implicitRules\",\
		\"weight\": 458,\
		\"max\": \"1\",\
		\"type\": \"uri\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"ValueSet.language\",\
		\"weight\": 459,\
		\"max\": \"1\",\
		\"type\": \"code\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"ValueSet.text\",\
		\"weight\": 460,\
		\"max\": \"1\",\
		\"type\": \"Narrative\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"ValueSet.contained\",\
		\"weight\": 461,\
		\"max\": \"*\",\
		\"type\": \"Resource\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"ValueSet.extension\",\
		\"weight\": 462,\
		\"max\": \"*\",\
		\"type\": \"Extension\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"ValueSet.modifierExtension\",\
		\"weight\": 463,\
		\"max\": \"*\",\
		\"type\": \"Extension\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"ValueSet.url\",\
		\"weight\": 464,\
		\"max\": \"1\",\
		\"type\": \"uri\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"ValueSet.identifier\",\
		\"weight\": 465,\
		\"max\": \"1\",\
		\"type\": \"Identifier\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"ValueSet.version\",\
		\"weight\": 466,\
		\"max\": \"1\",\
		\"type\": \"string\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"ValueSet.name\",\
		\"weight\": 467,\
		\"max\": \"1\",\
		\"type\": \"string\"\
	},\
	{\
		\"min\": \"1\",\
		\"path\": \"ValueSet.status\",\
		\"weight\": 468,\
		\"max\": \"1\",\
		\"type\": \"code\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"ValueSet.experimental\",\
		\"weight\": 469,\
		\"max\": \"1\",\
		\"type\": \"boolean\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"ValueSet.publisher\",\
		\"weight\": 470,\
		\"max\": \"1\",\
		\"type\": \"string\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"ValueSet.contact\",\
		\"weight\": 471,\
		\"max\": \"*\",\
		\"type\": \"BackboneElement\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"ValueSet.contact.id\",\
		\"weight\": 472,\
		\"max\": \"1\",\
		\"type\": \"id\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"ValueSet.contact.extension\",\
		\"weight\": 473,\
		\"max\": \"*\",\
		\"type\": \"Extension\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"ValueSet.contact.modifierExtension\",\
		\"weight\": 474,\
		\"max\": \"*\",\
		\"type\": \"Extension\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"ValueSet.contact.name\",\
		\"weight\": 475,\
		\"max\": \"1\",\
		\"type\": \"string\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"ValueSet.contact.telecom\",\
		\"weight\": 476,\
		\"max\": \"*\",\
		\"type\": \"ContactPoint\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"ValueSet.date\",\
		\"weight\": 477,\
		\"max\": \"1\",\
		\"type\": \"dateTime\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"ValueSet.lockedDate\",\
		\"weight\": 478,\
		\"max\": \"1\",\
		\"type\": \"date\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"ValueSet.description\",\
		\"weight\": 479,\
		\"max\": \"1\",\
		\"type\": \"string\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"ValueSet.useContext\",\
		\"weight\": 480,\
		\"max\": \"*\",\
		\"type\": \"CodeableConcept\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"ValueSet.immutable\",\
		\"weight\": 481,\
		\"max\": \"1\",\
		\"type\": \"boolean\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"ValueSet.requirements\",\
		\"weight\": 482,\
		\"max\": \"1\",\
		\"type\": \"string\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"ValueSet.copyright\",\
		\"weight\": 483,\
		\"max\": \"1\",\
		\"type\": \"string\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"ValueSet.extensible\",\
		\"weight\": 484,\
		\"max\": \"1\",\
		\"type\": \"boolean\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"ValueSet.compose\",\
		\"weight\": 485,\
		\"max\": \"1\",\
		\"type\": \"BackboneElement\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"ValueSet.compose.id\",\
		\"weight\": 486,\
		\"max\": \"1\",\
		\"type\": \"id\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"ValueSet.compose.extension\",\
		\"weight\": 487,\
		\"max\": \"*\",\
		\"type\": \"Extension\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"ValueSet.compose.modifierExtension\",\
		\"weight\": 488,\
		\"max\": \"*\",\
		\"type\": \"Extension\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"ValueSet.compose.import\",\
		\"weight\": 489,\
		\"max\": \"*\",\
		\"type\": \"uri\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"ValueSet.compose.include\",\
		\"weight\": 490,\
		\"max\": \"*\",\
		\"type\": \"BackboneElement\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"ValueSet.compose.include.id\",\
		\"weight\": 491,\
		\"max\": \"1\",\
		\"type\": \"id\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"ValueSet.compose.include.extension\",\
		\"weight\": 492,\
		\"max\": \"*\",\
		\"type\": \"Extension\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"ValueSet.compose.include.modifierExtension\",\
		\"weight\": 493,\
		\"max\": \"*\",\
		\"type\": \"Extension\"\
	},\
	{\
		\"min\": \"1\",\
		\"path\": \"ValueSet.compose.include.system\",\
		\"weight\": 494,\
		\"max\": \"1\",\
		\"type\": \"uri\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"ValueSet.compose.include.version\",\
		\"weight\": 495,\
		\"max\": \"1\",\
		\"type\": \"string\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"ValueSet.compose.include.concept\",\
		\"weight\": 496,\
		\"max\": \"*\",\
		\"type\": \"BackboneElement\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"ValueSet.compose.include.concept.id\",\
		\"weight\": 497,\
		\"max\": \"1\",\
		\"type\": \"id\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"ValueSet.compose.include.concept.extension\",\
		\"weight\": 498,\
		\"max\": \"*\",\
		\"type\": \"Extension\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"ValueSet.compose.include.concept.modifierExtension\",\
		\"weight\": 499,\
		\"max\": \"*\",\
		\"type\": \"Extension\"\
	},\
	{\
		\"min\": \"1\",\
		\"path\": \"ValueSet.compose.include.concept.code\",\
		\"weight\": 500,\
		\"max\": \"1\",\
		\"type\": \"code\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"ValueSet.compose.include.concept.display\",\
		\"weight\": 501,\
		\"max\": \"1\",\
		\"type\": \"string\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"ValueSet.compose.include.concept.designation\",\
		\"weight\": 502,\
		\"max\": \"*\",\
		\"type\": \"BackboneElement\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"ValueSet.compose.include.concept.designation.id\",\
		\"weight\": 503,\
		\"max\": \"1\",\
		\"type\": \"id\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"ValueSet.compose.include.concept.designation.extension\",\
		\"weight\": 504,\
		\"max\": \"*\",\
		\"type\": \"Extension\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"ValueSet.compose.include.concept.designation.modifierExtension\",\
		\"weight\": 505,\
		\"max\": \"*\",\
		\"type\": \"Extension\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"ValueSet.compose.include.concept.designation.language\",\
		\"weight\": 506,\
		\"max\": \"1\",\
		\"type\": \"code\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"ValueSet.compose.include.concept.designation.use\",\
		\"weight\": 507,\
		\"max\": \"1\",\
		\"type\": \"Coding\"\
	},\
	{\
		\"min\": \"1\",\
		\"path\": \"ValueSet.compose.include.concept.designation.value\",\
		\"weight\": 508,\
		\"max\": \"1\",\
		\"type\": \"string\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"ValueSet.compose.include.filter\",\
		\"weight\": 509,\
		\"max\": \"*\",\
		\"type\": \"BackboneElement\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"ValueSet.compose.include.filter.id\",\
		\"weight\": 510,\
		\"max\": \"1\",\
		\"type\": \"id\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"ValueSet.compose.include.filter.extension\",\
		\"weight\": 511,\
		\"max\": \"*\",\
		\"type\": \"Extension\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"ValueSet.compose.include.filter.modifierExtension\",\
		\"weight\": 512,\
		\"max\": \"*\",\
		\"type\": \"Extension\"\
	},\
	{\
		\"min\": \"1\",\
		\"path\": \"ValueSet.compose.include.filter.property\",\
		\"weight\": 513,\
		\"max\": \"1\",\
		\"type\": \"code\"\
	},\
	{\
		\"min\": \"1\",\
		\"path\": \"ValueSet.compose.include.filter.op\",\
		\"weight\": 514,\
		\"max\": \"1\",\
		\"type\": \"code\"\
	},\
	{\
		\"min\": \"1\",\
		\"path\": \"ValueSet.compose.include.filter.value\",\
		\"weight\": 515,\
		\"max\": \"1\",\
		\"type\": \"code\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"ValueSet.compose.exclude\",\
		\"weight\": 516,\
		\"max\": \"*\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"ValueSet.expansion\",\
		\"weight\": 517,\
		\"max\": \"1\",\
		\"type\": \"BackboneElement\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"ValueSet.expansion.id\",\
		\"weight\": 518,\
		\"max\": \"1\",\
		\"type\": \"id\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"ValueSet.expansion.extension\",\
		\"weight\": 519,\
		\"max\": \"*\",\
		\"type\": \"Extension\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"ValueSet.expansion.modifierExtension\",\
		\"weight\": 520,\
		\"max\": \"*\",\
		\"type\": \"Extension\"\
	},\
	{\
		\"min\": \"1\",\
		\"path\": \"ValueSet.expansion.identifier\",\
		\"weight\": 521,\
		\"max\": \"1\",\
		\"type\": \"uri\"\
	},\
	{\
		\"min\": \"1\",\
		\"path\": \"ValueSet.expansion.timestamp\",\
		\"weight\": 522,\
		\"max\": \"1\",\
		\"type\": \"dateTime\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"ValueSet.expansion.total\",\
		\"weight\": 523,\
		\"max\": \"1\",\
		\"type\": \"integer\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"ValueSet.expansion.offset\",\
		\"weight\": 524,\
		\"max\": \"1\",\
		\"type\": \"integer\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"ValueSet.expansion.parameter\",\
		\"weight\": 525,\
		\"max\": \"*\",\
		\"type\": \"BackboneElement\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"ValueSet.expansion.parameter.id\",\
		\"weight\": 526,\
		\"max\": \"1\",\
		\"type\": \"id\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"ValueSet.expansion.parameter.extension\",\
		\"weight\": 527,\
		\"max\": \"*\",\
		\"type\": \"Extension\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"ValueSet.expansion.parameter.modifierExtension\",\
		\"weight\": 528,\
		\"max\": \"*\",\
		\"type\": \"Extension\"\
	},\
	{\
		\"min\": \"1\",\
		\"path\": \"ValueSet.expansion.parameter.name\",\
		\"weight\": 529,\
		\"max\": \"1\",\
		\"type\": \"string\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"ValueSet.expansion.parameter.valueString\",\
		\"weight\": 530,\
		\"max\": \"1\",\
		\"type\": \"string\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"ValueSet.expansion.parameter.valueBoolean\",\
		\"weight\": 530,\
		\"max\": \"1\",\
		\"type\": \"boolean\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"ValueSet.expansion.parameter.valueInteger\",\
		\"weight\": 530,\
		\"max\": \"1\",\
		\"type\": \"integer\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"ValueSet.expansion.parameter.valueDecimal\",\
		\"weight\": 530,\
		\"max\": \"1\",\
		\"type\": \"decimal\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"ValueSet.expansion.parameter.valueUri\",\
		\"weight\": 530,\
		\"max\": \"1\",\
		\"type\": \"uri\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"ValueSet.expansion.parameter.valueCode\",\
		\"weight\": 530,\
		\"max\": \"1\",\
		\"type\": \"code\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"ValueSet.expansion.contains\",\
		\"weight\": 531,\
		\"max\": \"*\",\
		\"type\": \"BackboneElement\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"ValueSet.expansion.contains.id\",\
		\"weight\": 532,\
		\"max\": \"1\",\
		\"type\": \"id\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"ValueSet.expansion.contains.extension\",\
		\"weight\": 533,\
		\"max\": \"*\",\
		\"type\": \"Extension\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"ValueSet.expansion.contains.modifierExtension\",\
		\"weight\": 534,\
		\"max\": \"*\",\
		\"type\": \"Extension\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"ValueSet.expansion.contains.system\",\
		\"weight\": 535,\
		\"max\": \"1\",\
		\"type\": \"uri\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"ValueSet.expansion.contains.abstract\",\
		\"weight\": 536,\
		\"max\": \"1\",\
		\"type\": \"boolean\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"ValueSet.expansion.contains.version\",\
		\"weight\": 537,\
		\"max\": \"1\",\
		\"type\": \"string\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"ValueSet.expansion.contains.code\",\
		\"weight\": 538,\
		\"max\": \"1\",\
		\"type\": \"code\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"ValueSet.expansion.contains.display\",\
		\"weight\": 539,\
		\"max\": \"1\",\
		\"type\": \"string\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"ValueSet.expansion.contains.contains\",\
		\"weight\": 540,\
		\"max\": \"*\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Parameters\",\
		\"weight\": 541,\
		\"max\": \"*\",\
		\"type\": \"Resource\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Parameters.id\",\
		\"weight\": 542,\
		\"max\": \"1\",\
		\"type\": \"id\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Parameters.meta\",\
		\"weight\": 543,\
		\"max\": \"1\",\
		\"type\": \"Meta\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Parameters.implicitRules\",\
		\"weight\": 544,\
		\"max\": \"1\",\
		\"type\": \"uri\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Parameters.language\",\
		\"weight\": 545,\
		\"max\": \"1\",\
		\"type\": \"code\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Parameters.parameter\",\
		\"weight\": 546,\
		\"max\": \"*\",\
		\"type\": \"BackboneElement\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Parameters.parameter.id\",\
		\"weight\": 547,\
		\"max\": \"1\",\
		\"type\": \"id\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Parameters.parameter.extension\",\
		\"weight\": 548,\
		\"max\": \"*\",\
		\"type\": \"Extension\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Parameters.parameter.modifierExtension\",\
		\"weight\": 549,\
		\"max\": \"*\",\
		\"type\": \"Extension\"\
	},\
	{\
		\"min\": \"1\",\
		\"path\": \"Parameters.parameter.name\",\
		\"weight\": 550,\
		\"max\": \"1\",\
		\"type\": \"string\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Parameters.parameter.valueBoolean\",\
		\"weight\": 551,\
		\"max\": \"1\",\
		\"type\": \"boolean\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Parameters.parameter.valueInteger\",\
		\"weight\": 551,\
		\"max\": \"1\",\
		\"type\": \"integer\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Parameters.parameter.valueDecimal\",\
		\"weight\": 551,\
		\"max\": \"1\",\
		\"type\": \"decimal\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Parameters.parameter.valueBase64Binary\",\
		\"weight\": 551,\
		\"max\": \"1\",\
		\"type\": \"base64Binary\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Parameters.parameter.valueInstant\",\
		\"weight\": 551,\
		\"max\": \"1\",\
		\"type\": \"instant\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Parameters.parameter.valueString\",\
		\"weight\": 551,\
		\"max\": \"1\",\
		\"type\": \"string\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Parameters.parameter.valueUri\",\
		\"weight\": 551,\
		\"max\": \"1\",\
		\"type\": \"uri\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Parameters.parameter.valueDate\",\
		\"weight\": 551,\
		\"max\": \"1\",\
		\"type\": \"date\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Parameters.parameter.valueDateTime\",\
		\"weight\": 551,\
		\"max\": \"1\",\
		\"type\": \"dateTime\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Parameters.parameter.valueTime\",\
		\"weight\": 551,\
		\"max\": \"1\",\
		\"type\": \"time\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Parameters.parameter.valueCode\",\
		\"weight\": 551,\
		\"max\": \"1\",\
		\"type\": \"code\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Parameters.parameter.valueOid\",\
		\"weight\": 551,\
		\"max\": \"1\",\
		\"type\": \"oid\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Parameters.parameter.valueId\",\
		\"weight\": 551,\
		\"max\": \"1\",\
		\"type\": \"id\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Parameters.parameter.valueUnsignedInt\",\
		\"weight\": 551,\
		\"max\": \"1\",\
		\"type\": \"unsignedInt\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Parameters.parameter.valuePositiveInt\",\
		\"weight\": 551,\
		\"max\": \"1\",\
		\"type\": \"positiveInt\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Parameters.parameter.valueMarkdown\",\
		\"weight\": 551,\
		\"max\": \"1\",\
		\"type\": \"markdown\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Parameters.parameter.valueAnnotation\",\
		\"weight\": 551,\
		\"max\": \"1\",\
		\"type\": \"Annotation\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Parameters.parameter.valueAttachment\",\
		\"weight\": 551,\
		\"max\": \"1\",\
		\"type\": \"Attachment\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Parameters.parameter.valueIdentifier\",\
		\"weight\": 551,\
		\"max\": \"1\",\
		\"type\": \"Identifier\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Parameters.parameter.valueCodeableConcept\",\
		\"weight\": 551,\
		\"max\": \"1\",\
		\"type\": \"CodeableConcept\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Parameters.parameter.valueCoding\",\
		\"weight\": 551,\
		\"max\": \"1\",\
		\"type\": \"Coding\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Parameters.parameter.valueQuantity\",\
		\"weight\": 551,\
		\"max\": \"1\",\
		\"type\": \"Quantity\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Parameters.parameter.valueRange\",\
		\"weight\": 551,\
		\"max\": \"1\",\
		\"type\": \"Range\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Parameters.parameter.valuePeriod\",\
		\"weight\": 551,\
		\"max\": \"1\",\
		\"type\": \"Period\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Parameters.parameter.valueRatio\",\
		\"weight\": 551,\
		\"max\": \"1\",\
		\"type\": \"Ratio\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Parameters.parameter.valueSampledData\",\
		\"weight\": 551,\
		\"max\": \"1\",\
		\"type\": \"SampledData\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Parameters.parameter.valueSignature\",\
		\"weight\": 551,\
		\"max\": \"1\",\
		\"type\": \"Signature\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Parameters.parameter.valueHumanName\",\
		\"weight\": 551,\
		\"max\": \"1\",\
		\"type\": \"HumanName\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Parameters.parameter.valueAddress\",\
		\"weight\": 551,\
		\"max\": \"1\",\
		\"type\": \"Address\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Parameters.parameter.valueContactPoint\",\
		\"weight\": 551,\
		\"max\": \"1\",\
		\"type\": \"ContactPoint\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Parameters.parameter.valueTiming\",\
		\"weight\": 551,\
		\"max\": \"1\",\
		\"type\": \"Timing\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Parameters.parameter.valueReference\",\
		\"weight\": 551,\
		\"max\": \"1\",\
		\"type\": \"Reference\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Parameters.parameter.valueMeta\",\
		\"weight\": 551,\
		\"max\": \"1\",\
		\"type\": \"Meta\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Parameters.parameter.resource\",\
		\"weight\": 552,\
		\"max\": \"1\",\
		\"type\": \"Resource\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Parameters.parameter.part\",\
		\"weight\": 553,\
		\"max\": \"*\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Resource\",\
		\"weight\": 554,\
		\"max\": \"*\",\
		\"derivations\": [\
			\"Binary\",\
			\"Bundle\",\
			\"DomainResource\",\
			\"Parameters\"\
		]\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Resource.id\",\
		\"weight\": 555,\
		\"max\": \"1\",\
		\"type\": \"id\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Resource.meta\",\
		\"weight\": 556,\
		\"max\": \"1\",\
		\"type\": \"Meta\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Resource.implicitRules\",\
		\"weight\": 557,\
		\"max\": \"1\",\
		\"type\": \"uri\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Resource.language\",\
		\"weight\": 558,\
		\"max\": \"1\",\
		\"type\": \"code\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"DomainResource\",\
		\"weight\": 559,\
		\"max\": \"*\",\
		\"derivations\": [\
			\"Account\",\
			\"AllergyIntolerance\",\
			\"Appointment\",\
			\"AppointmentResponse\",\
			\"AuditEvent\",\
			\"Basic\",\
			\"BodySite\",\
			\"CarePlan\",\
			\"CareTeam\",\
			\"Claim\",\
			\"ClaimResponse\",\
			\"ClinicalImpression\",\
			\"CodeSystem\",\
			\"Communication\",\
			\"CommunicationRequest\",\
			\"CompartmentDefinition\",\
			\"Composition\",\
			\"ConceptMap\",\
			\"Condition\",\
			\"Conformance\",\
			\"Contract\",\
			\"Coverage\",\
			\"DataElement\",\
			\"DecisionSupportRule\",\
			\"DecisionSupportServiceModule\",\
			\"DetectedIssue\",\
			\"Device\",\
			\"DeviceComponent\",\
			\"DeviceMetric\",\
			\"DeviceUseRequest\",\
			\"DeviceUseStatement\",\
			\"DiagnosticOrder\",\
			\"DiagnosticReport\",\
			\"DocumentManifest\",\
			\"DocumentReference\",\
			\"EligibilityRequest\",\
			\"EligibilityResponse\",\
			\"Encounter\",\
			\"EnrollmentRequest\",\
			\"EnrollmentResponse\",\
			\"EpisodeOfCare\",\
			\"ExpansionProfile\",\
			\"ExplanationOfBenefit\",\
			\"FamilyMemberHistory\",\
			\"Flag\",\
			\"Goal\",\
			\"Group\",\
			\"GuidanceResponse\",\
			\"HealthcareService\",\
			\"ImagingExcerpt\",\
			\"ImagingObjectSelection\",\
			\"ImagingStudy\",\
			\"Immunization\",\
			\"ImmunizationRecommendation\",\
			\"ImplementationGuide\",\
			\"Library\",\
			\"Linkage\",\
			\"List\",\
			\"Location\",\
			\"Measure\",\
			\"MeasureReport\",\
			\"Media\",\
			\"Medication\",\
			\"MedicationAdministration\",\
			\"MedicationDispense\",\
			\"MedicationOrder\",\
			\"MedicationStatement\",\
			\"MessageHeader\",\
			\"ModuleDefinition\",\
			\"NamingSystem\",\
			\"NutritionOrder\",\
			\"Observation\",\
			\"OperationDefinition\",\
			\"OperationOutcome\",\
			\"Order\",\
			\"OrderResponse\",\
			\"OrderSet\",\
			\"Organization\",\
			\"Patient\",\
			\"PaymentNotice\",\
			\"PaymentReconciliation\",\
			\"Person\",\
			\"Practitioner\",\
			\"PractitionerRole\",\
			\"Procedure\",\
			\"ProcedureRequest\",\
			\"ProcessRequest\",\
			\"ProcessResponse\",\
			\"Protocol\",\
			\"Provenance\",\
			\"Questionnaire\",\
			\"QuestionnaireResponse\",\
			\"ReferralRequest\",\
			\"RelatedPerson\",\
			\"RiskAssessment\",\
			\"Schedule\",\
			\"SearchParameter\",\
			\"Sequence\",\
			\"Slot\",\
			\"Specimen\",\
			\"StructureDefinition\",\
			\"StructureMap\",\
			\"Subscription\",\
			\"Substance\",\
			\"SupplyDelivery\",\
			\"SupplyRequest\",\
			\"Task\",\
			\"TestScript\",\
			\"ValueSet\",\
			\"VisionPrescription\"\
		],\
		\"type\": \"Resource\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"DomainResource.id\",\
		\"weight\": 560,\
		\"max\": \"1\",\
		\"type\": \"id\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"DomainResource.meta\",\
		\"weight\": 561,\
		\"max\": \"1\",\
		\"type\": \"Meta\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"DomainResource.implicitRules\",\
		\"weight\": 562,\
		\"max\": \"1\",\
		\"type\": \"uri\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"DomainResource.language\",\
		\"weight\": 563,\
		\"max\": \"1\",\
		\"type\": \"code\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"DomainResource.text\",\
		\"weight\": 564,\
		\"max\": \"1\",\
		\"type\": \"Narrative\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"DomainResource.contained\",\
		\"weight\": 565,\
		\"max\": \"*\",\
		\"type\": \"Resource\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"DomainResource.extension\",\
		\"weight\": 566,\
		\"max\": \"*\",\
		\"type\": \"Extension\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"DomainResource.modifierExtension\",\
		\"weight\": 567,\
		\"max\": \"*\",\
		\"type\": \"Extension\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Account\",\
		\"weight\": 568,\
		\"max\": \"*\",\
		\"type\": \"DomainResource\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Account.id\",\
		\"weight\": 569,\
		\"max\": \"1\",\
		\"type\": \"id\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Account.meta\",\
		\"weight\": 570,\
		\"max\": \"1\",\
		\"type\": \"Meta\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Account.implicitRules\",\
		\"weight\": 571,\
		\"max\": \"1\",\
		\"type\": \"uri\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Account.language\",\
		\"weight\": 572,\
		\"max\": \"1\",\
		\"type\": \"code\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Account.text\",\
		\"weight\": 573,\
		\"max\": \"1\",\
		\"type\": \"Narrative\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Account.contained\",\
		\"weight\": 574,\
		\"max\": \"*\",\
		\"type\": \"Resource\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Account.extension\",\
		\"weight\": 575,\
		\"max\": \"*\",\
		\"type\": \"Extension\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Account.modifierExtension\",\
		\"weight\": 576,\
		\"max\": \"*\",\
		\"type\": \"Extension\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Account.identifier\",\
		\"weight\": 577,\
		\"max\": \"*\",\
		\"type\": \"Identifier\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Account.name\",\
		\"weight\": 578,\
		\"max\": \"1\",\
		\"type\": \"string\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Account.type\",\
		\"weight\": 579,\
		\"max\": \"1\",\
		\"type\": \"CodeableConcept\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Account.status\",\
		\"weight\": 580,\
		\"max\": \"1\",\
		\"type\": \"code\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Account.activePeriod\",\
		\"weight\": 581,\
		\"max\": \"1\",\
		\"type\": \"Period\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Account.currency\",\
		\"weight\": 582,\
		\"max\": \"1\",\
		\"type\": \"Coding\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Account.balance\",\
		\"weight\": 583,\
		\"max\": \"1\",\
		\"type\": \"Quantity\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Account.coveragePeriod\",\
		\"weight\": 584,\
		\"max\": \"1\",\
		\"type\": \"Period\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Account.subject\",\
		\"weight\": 585,\
		\"max\": \"1\",\
		\"type\": \"Reference\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Account.owner\",\
		\"weight\": 586,\
		\"max\": \"1\",\
		\"type\": \"Reference\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Account.description\",\
		\"weight\": 587,\
		\"max\": \"1\",\
		\"type\": \"string\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"AllergyIntolerance\",\
		\"weight\": 588,\
		\"max\": \"*\",\
		\"type\": \"DomainResource\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"AllergyIntolerance.id\",\
		\"weight\": 589,\
		\"max\": \"1\",\
		\"type\": \"id\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"AllergyIntolerance.meta\",\
		\"weight\": 590,\
		\"max\": \"1\",\
		\"type\": \"Meta\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"AllergyIntolerance.implicitRules\",\
		\"weight\": 591,\
		\"max\": \"1\",\
		\"type\": \"uri\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"AllergyIntolerance.language\",\
		\"weight\": 592,\
		\"max\": \"1\",\
		\"type\": \"code\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"AllergyIntolerance.text\",\
		\"weight\": 593,\
		\"max\": \"1\",\
		\"type\": \"Narrative\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"AllergyIntolerance.contained\",\
		\"weight\": 594,\
		\"max\": \"*\",\
		\"type\": \"Resource\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"AllergyIntolerance.extension\",\
		\"weight\": 595,\
		\"max\": \"*\",\
		\"type\": \"Extension\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"AllergyIntolerance.modifierExtension\",\
		\"weight\": 596,\
		\"max\": \"*\",\
		\"type\": \"Extension\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"AllergyIntolerance.identifier\",\
		\"weight\": 597,\
		\"max\": \"*\",\
		\"type\": \"Identifier\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"AllergyIntolerance.status\",\
		\"weight\": 598,\
		\"max\": \"1\",\
		\"type\": \"code\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"AllergyIntolerance.type\",\
		\"weight\": 599,\
		\"max\": \"1\",\
		\"type\": \"code\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"AllergyIntolerance.category\",\
		\"weight\": 600,\
		\"max\": \"1\",\
		\"type\": \"code\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"AllergyIntolerance.criticality\",\
		\"weight\": 601,\
		\"max\": \"1\",\
		\"type\": \"code\"\
	},\
	{\
		\"min\": \"1\",\
		\"path\": \"AllergyIntolerance.substance\",\
		\"weight\": 602,\
		\"max\": \"1\",\
		\"type\": \"CodeableConcept\"\
	},\
	{\
		\"min\": \"1\",\
		\"path\": \"AllergyIntolerance.patient\",\
		\"weight\": 603,\
		\"max\": \"1\",\
		\"type\": \"Reference\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"AllergyIntolerance.recordedDate\",\
		\"weight\": 604,\
		\"max\": \"1\",\
		\"type\": \"dateTime\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"AllergyIntolerance.recorder\",\
		\"weight\": 605,\
		\"max\": \"1\",\
		\"type\": \"Reference\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"AllergyIntolerance.reporter\",\
		\"weight\": 606,\
		\"max\": \"1\",\
		\"type\": \"Reference\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"AllergyIntolerance.onset\",\
		\"weight\": 607,\
		\"max\": \"1\",\
		\"type\": \"dateTime\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"AllergyIntolerance.lastOccurence\",\
		\"weight\": 608,\
		\"max\": \"1\",\
		\"type\": \"dateTime\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"AllergyIntolerance.note\",\
		\"weight\": 609,\
		\"max\": \"*\",\
		\"type\": \"Annotation\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"AllergyIntolerance.reaction\",\
		\"weight\": 610,\
		\"max\": \"*\",\
		\"type\": \"BackboneElement\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"AllergyIntolerance.reaction.id\",\
		\"weight\": 611,\
		\"max\": \"1\",\
		\"type\": \"id\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"AllergyIntolerance.reaction.extension\",\
		\"weight\": 612,\
		\"max\": \"*\",\
		\"type\": \"Extension\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"AllergyIntolerance.reaction.modifierExtension\",\
		\"weight\": 613,\
		\"max\": \"*\",\
		\"type\": \"Extension\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"AllergyIntolerance.reaction.substance\",\
		\"weight\": 614,\
		\"max\": \"1\",\
		\"type\": \"CodeableConcept\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"AllergyIntolerance.reaction.certainty\",\
		\"weight\": 615,\
		\"max\": \"1\",\
		\"type\": \"code\"\
	},\
	{\
		\"min\": \"1\",\
		\"path\": \"AllergyIntolerance.reaction.manifestation\",\
		\"weight\": 616,\
		\"max\": \"*\",\
		\"type\": \"CodeableConcept\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"AllergyIntolerance.reaction.description\",\
		\"weight\": 617,\
		\"max\": \"1\",\
		\"type\": \"string\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"AllergyIntolerance.reaction.onset\",\
		\"weight\": 618,\
		\"max\": \"1\",\
		\"type\": \"dateTime\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"AllergyIntolerance.reaction.severity\",\
		\"weight\": 619,\
		\"max\": \"1\",\
		\"type\": \"code\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"AllergyIntolerance.reaction.exposureRoute\",\
		\"weight\": 620,\
		\"max\": \"1\",\
		\"type\": \"CodeableConcept\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"AllergyIntolerance.reaction.note\",\
		\"weight\": 621,\
		\"max\": \"*\",\
		\"type\": \"Annotation\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Appointment\",\
		\"weight\": 622,\
		\"max\": \"*\",\
		\"type\": \"DomainResource\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Appointment.id\",\
		\"weight\": 623,\
		\"max\": \"1\",\
		\"type\": \"id\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Appointment.meta\",\
		\"weight\": 624,\
		\"max\": \"1\",\
		\"type\": \"Meta\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Appointment.implicitRules\",\
		\"weight\": 625,\
		\"max\": \"1\",\
		\"type\": \"uri\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Appointment.language\",\
		\"weight\": 626,\
		\"max\": \"1\",\
		\"type\": \"code\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Appointment.text\",\
		\"weight\": 627,\
		\"max\": \"1\",\
		\"type\": \"Narrative\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Appointment.contained\",\
		\"weight\": 628,\
		\"max\": \"*\",\
		\"type\": \"Resource\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Appointment.extension\",\
		\"weight\": 629,\
		\"max\": \"*\",\
		\"type\": \"Extension\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Appointment.modifierExtension\",\
		\"weight\": 630,\
		\"max\": \"*\",\
		\"type\": \"Extension\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Appointment.identifier\",\
		\"weight\": 631,\
		\"max\": \"*\",\
		\"type\": \"Identifier\"\
	},\
	{\
		\"min\": \"1\",\
		\"path\": \"Appointment.status\",\
		\"weight\": 632,\
		\"max\": \"1\",\
		\"type\": \"code\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Appointment.serviceCategory\",\
		\"weight\": 633,\
		\"max\": \"1\",\
		\"type\": \"CodeableConcept\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Appointment.serviceType\",\
		\"weight\": 634,\
		\"max\": \"*\",\
		\"type\": \"CodeableConcept\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Appointment.specialty\",\
		\"weight\": 635,\
		\"max\": \"*\",\
		\"type\": \"CodeableConcept\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Appointment.appointmentType\",\
		\"weight\": 636,\
		\"max\": \"1\",\
		\"type\": \"CodeableConcept\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Appointment.reason\",\
		\"weight\": 637,\
		\"max\": \"1\",\
		\"type\": \"CodeableConcept\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Appointment.priority\",\
		\"weight\": 638,\
		\"max\": \"1\",\
		\"type\": \"unsignedInt\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Appointment.description\",\
		\"weight\": 639,\
		\"max\": \"1\",\
		\"type\": \"string\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Appointment.start\",\
		\"weight\": 640,\
		\"max\": \"1\",\
		\"type\": \"instant\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Appointment.end\",\
		\"weight\": 641,\
		\"max\": \"1\",\
		\"type\": \"instant\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Appointment.minutesDuration\",\
		\"weight\": 642,\
		\"max\": \"1\",\
		\"type\": \"positiveInt\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Appointment.slot\",\
		\"weight\": 643,\
		\"max\": \"*\",\
		\"type\": \"Reference\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Appointment.created\",\
		\"weight\": 644,\
		\"max\": \"1\",\
		\"type\": \"dateTime\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Appointment.comment\",\
		\"weight\": 645,\
		\"max\": \"1\",\
		\"type\": \"string\"\
	},\
	{\
		\"min\": \"1\",\
		\"path\": \"Appointment.participant\",\
		\"weight\": 646,\
		\"max\": \"*\",\
		\"type\": \"BackboneElement\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Appointment.participant.id\",\
		\"weight\": 647,\
		\"max\": \"1\",\
		\"type\": \"id\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Appointment.participant.extension\",\
		\"weight\": 648,\
		\"max\": \"*\",\
		\"type\": \"Extension\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Appointment.participant.modifierExtension\",\
		\"weight\": 649,\
		\"max\": \"*\",\
		\"type\": \"Extension\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Appointment.participant.type\",\
		\"weight\": 650,\
		\"max\": \"*\",\
		\"type\": \"CodeableConcept\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Appointment.participant.actor\",\
		\"weight\": 651,\
		\"max\": \"1\",\
		\"type\": \"Reference\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Appointment.participant.required\",\
		\"weight\": 652,\
		\"max\": \"1\",\
		\"type\": \"code\"\
	},\
	{\
		\"min\": \"1\",\
		\"path\": \"Appointment.participant.status\",\
		\"weight\": 653,\
		\"max\": \"1\",\
		\"type\": \"code\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"AppointmentResponse\",\
		\"weight\": 654,\
		\"max\": \"*\",\
		\"type\": \"DomainResource\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"AppointmentResponse.id\",\
		\"weight\": 655,\
		\"max\": \"1\",\
		\"type\": \"id\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"AppointmentResponse.meta\",\
		\"weight\": 656,\
		\"max\": \"1\",\
		\"type\": \"Meta\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"AppointmentResponse.implicitRules\",\
		\"weight\": 657,\
		\"max\": \"1\",\
		\"type\": \"uri\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"AppointmentResponse.language\",\
		\"weight\": 658,\
		\"max\": \"1\",\
		\"type\": \"code\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"AppointmentResponse.text\",\
		\"weight\": 659,\
		\"max\": \"1\",\
		\"type\": \"Narrative\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"AppointmentResponse.contained\",\
		\"weight\": 660,\
		\"max\": \"*\",\
		\"type\": \"Resource\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"AppointmentResponse.extension\",\
		\"weight\": 661,\
		\"max\": \"*\",\
		\"type\": \"Extension\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"AppointmentResponse.modifierExtension\",\
		\"weight\": 662,\
		\"max\": \"*\",\
		\"type\": \"Extension\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"AppointmentResponse.identifier\",\
		\"weight\": 663,\
		\"max\": \"*\",\
		\"type\": \"Identifier\"\
	},\
	{\
		\"min\": \"1\",\
		\"path\": \"AppointmentResponse.appointment\",\
		\"weight\": 664,\
		\"max\": \"1\",\
		\"type\": \"Reference\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"AppointmentResponse.start\",\
		\"weight\": 665,\
		\"max\": \"1\",\
		\"type\": \"instant\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"AppointmentResponse.end\",\
		\"weight\": 666,\
		\"max\": \"1\",\
		\"type\": \"instant\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"AppointmentResponse.participantType\",\
		\"weight\": 667,\
		\"max\": \"*\",\
		\"type\": \"CodeableConcept\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"AppointmentResponse.actor\",\
		\"weight\": 668,\
		\"max\": \"1\",\
		\"type\": \"Reference\"\
	},\
	{\
		\"min\": \"1\",\
		\"path\": \"AppointmentResponse.participantStatus\",\
		\"weight\": 669,\
		\"max\": \"1\",\
		\"type\": \"code\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"AppointmentResponse.comment\",\
		\"weight\": 670,\
		\"max\": \"1\",\
		\"type\": \"string\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"AuditEvent\",\
		\"weight\": 671,\
		\"max\": \"*\",\
		\"type\": \"DomainResource\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"AuditEvent.id\",\
		\"weight\": 672,\
		\"max\": \"1\",\
		\"type\": \"id\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"AuditEvent.meta\",\
		\"weight\": 673,\
		\"max\": \"1\",\
		\"type\": \"Meta\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"AuditEvent.implicitRules\",\
		\"weight\": 674,\
		\"max\": \"1\",\
		\"type\": \"uri\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"AuditEvent.language\",\
		\"weight\": 675,\
		\"max\": \"1\",\
		\"type\": \"code\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"AuditEvent.text\",\
		\"weight\": 676,\
		\"max\": \"1\",\
		\"type\": \"Narrative\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"AuditEvent.contained\",\
		\"weight\": 677,\
		\"max\": \"*\",\
		\"type\": \"Resource\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"AuditEvent.extension\",\
		\"weight\": 678,\
		\"max\": \"*\",\
		\"type\": \"Extension\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"AuditEvent.modifierExtension\",\
		\"weight\": 679,\
		\"max\": \"*\",\
		\"type\": \"Extension\"\
	},\
	{\
		\"min\": \"1\",\
		\"path\": \"AuditEvent.type\",\
		\"weight\": 680,\
		\"max\": \"1\",\
		\"type\": \"Coding\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"AuditEvent.subtype\",\
		\"weight\": 681,\
		\"max\": \"*\",\
		\"type\": \"Coding\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"AuditEvent.action\",\
		\"weight\": 682,\
		\"max\": \"1\",\
		\"type\": \"code\"\
	},\
	{\
		\"min\": \"1\",\
		\"path\": \"AuditEvent.recorded\",\
		\"weight\": 683,\
		\"max\": \"1\",\
		\"type\": \"instant\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"AuditEvent.outcome\",\
		\"weight\": 684,\
		\"max\": \"1\",\
		\"type\": \"code\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"AuditEvent.outcomeDesc\",\
		\"weight\": 685,\
		\"max\": \"1\",\
		\"type\": \"string\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"AuditEvent.purposeOfEvent\",\
		\"weight\": 686,\
		\"max\": \"*\",\
		\"type\": \"Coding\"\
	},\
	{\
		\"min\": \"1\",\
		\"path\": \"AuditEvent.agent\",\
		\"weight\": 687,\
		\"max\": \"*\",\
		\"type\": \"BackboneElement\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"AuditEvent.agent.id\",\
		\"weight\": 688,\
		\"max\": \"1\",\
		\"type\": \"id\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"AuditEvent.agent.extension\",\
		\"weight\": 689,\
		\"max\": \"*\",\
		\"type\": \"Extension\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"AuditEvent.agent.modifierExtension\",\
		\"weight\": 690,\
		\"max\": \"*\",\
		\"type\": \"Extension\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"AuditEvent.agent.role\",\
		\"weight\": 691,\
		\"max\": \"*\",\
		\"type\": \"CodeableConcept\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"AuditEvent.agent.reference\",\
		\"weight\": 692,\
		\"max\": \"1\",\
		\"type\": \"Reference\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"AuditEvent.agent.userId\",\
		\"weight\": 693,\
		\"max\": \"1\",\
		\"type\": \"Identifier\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"AuditEvent.agent.altId\",\
		\"weight\": 694,\
		\"max\": \"1\",\
		\"type\": \"string\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"AuditEvent.agent.name\",\
		\"weight\": 695,\
		\"max\": \"1\",\
		\"type\": \"string\"\
	},\
	{\
		\"min\": \"1\",\
		\"path\": \"AuditEvent.agent.requestor\",\
		\"weight\": 696,\
		\"max\": \"1\",\
		\"type\": \"boolean\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"AuditEvent.agent.location\",\
		\"weight\": 697,\
		\"max\": \"1\",\
		\"type\": \"Reference\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"AuditEvent.agent.policy\",\
		\"weight\": 698,\
		\"max\": \"*\",\
		\"type\": \"uri\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"AuditEvent.agent.media\",\
		\"weight\": 699,\
		\"max\": \"1\",\
		\"type\": \"Coding\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"AuditEvent.agent.network\",\
		\"weight\": 700,\
		\"max\": \"1\",\
		\"type\": \"BackboneElement\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"AuditEvent.agent.network.id\",\
		\"weight\": 701,\
		\"max\": \"1\",\
		\"type\": \"id\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"AuditEvent.agent.network.extension\",\
		\"weight\": 702,\
		\"max\": \"*\",\
		\"type\": \"Extension\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"AuditEvent.agent.network.modifierExtension\",\
		\"weight\": 703,\
		\"max\": \"*\",\
		\"type\": \"Extension\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"AuditEvent.agent.network.address\",\
		\"weight\": 704,\
		\"max\": \"1\",\
		\"type\": \"string\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"AuditEvent.agent.network.type\",\
		\"weight\": 705,\
		\"max\": \"1\",\
		\"type\": \"code\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"AuditEvent.agent.purposeOfUse\",\
		\"weight\": 706,\
		\"max\": \"*\",\
		\"type\": \"Coding\"\
	},\
	{\
		\"min\": \"1\",\
		\"path\": \"AuditEvent.source\",\
		\"weight\": 707,\
		\"max\": \"1\",\
		\"type\": \"BackboneElement\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"AuditEvent.source.id\",\
		\"weight\": 708,\
		\"max\": \"1\",\
		\"type\": \"id\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"AuditEvent.source.extension\",\
		\"weight\": 709,\
		\"max\": \"*\",\
		\"type\": \"Extension\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"AuditEvent.source.modifierExtension\",\
		\"weight\": 710,\
		\"max\": \"*\",\
		\"type\": \"Extension\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"AuditEvent.source.site\",\
		\"weight\": 711,\
		\"max\": \"1\",\
		\"type\": \"string\"\
	},\
	{\
		\"min\": \"1\",\
		\"path\": \"AuditEvent.source.identifier\",\
		\"weight\": 712,\
		\"max\": \"1\",\
		\"type\": \"Identifier\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"AuditEvent.source.type\",\
		\"weight\": 713,\
		\"max\": \"*\",\
		\"type\": \"Coding\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"AuditEvent.entity\",\
		\"weight\": 714,\
		\"max\": \"*\",\
		\"type\": \"BackboneElement\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"AuditEvent.entity.id\",\
		\"weight\": 715,\
		\"max\": \"1\",\
		\"type\": \"id\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"AuditEvent.entity.extension\",\
		\"weight\": 716,\
		\"max\": \"*\",\
		\"type\": \"Extension\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"AuditEvent.entity.modifierExtension\",\
		\"weight\": 717,\
		\"max\": \"*\",\
		\"type\": \"Extension\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"AuditEvent.entity.identifier\",\
		\"weight\": 718,\
		\"max\": \"1\",\
		\"type\": \"Identifier\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"AuditEvent.entity.reference\",\
		\"weight\": 719,\
		\"max\": \"1\",\
		\"type\": \"Reference\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"AuditEvent.entity.type\",\
		\"weight\": 720,\
		\"max\": \"1\",\
		\"type\": \"Coding\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"AuditEvent.entity.role\",\
		\"weight\": 721,\
		\"max\": \"1\",\
		\"type\": \"Coding\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"AuditEvent.entity.lifecycle\",\
		\"weight\": 722,\
		\"max\": \"1\",\
		\"type\": \"Coding\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"AuditEvent.entity.securityLabel\",\
		\"weight\": 723,\
		\"max\": \"*\",\
		\"type\": \"Coding\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"AuditEvent.entity.name\",\
		\"weight\": 724,\
		\"max\": \"1\",\
		\"type\": \"string\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"AuditEvent.entity.description\",\
		\"weight\": 725,\
		\"max\": \"1\",\
		\"type\": \"string\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"AuditEvent.entity.query\",\
		\"weight\": 726,\
		\"max\": \"1\",\
		\"type\": \"base64Binary\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"AuditEvent.entity.detail\",\
		\"weight\": 727,\
		\"max\": \"*\",\
		\"type\": \"BackboneElement\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"AuditEvent.entity.detail.id\",\
		\"weight\": 728,\
		\"max\": \"1\",\
		\"type\": \"id\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"AuditEvent.entity.detail.extension\",\
		\"weight\": 729,\
		\"max\": \"*\",\
		\"type\": \"Extension\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"AuditEvent.entity.detail.modifierExtension\",\
		\"weight\": 730,\
		\"max\": \"*\",\
		\"type\": \"Extension\"\
	},\
	{\
		\"min\": \"1\",\
		\"path\": \"AuditEvent.entity.detail.type\",\
		\"weight\": 731,\
		\"max\": \"1\",\
		\"type\": \"string\"\
	},\
	{\
		\"min\": \"1\",\
		\"path\": \"AuditEvent.entity.detail.value\",\
		\"weight\": 732,\
		\"max\": \"1\",\
		\"type\": \"base64Binary\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Basic\",\
		\"weight\": 733,\
		\"max\": \"*\",\
		\"type\": \"DomainResource\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Basic.id\",\
		\"weight\": 734,\
		\"max\": \"1\",\
		\"type\": \"id\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Basic.meta\",\
		\"weight\": 735,\
		\"max\": \"1\",\
		\"type\": \"Meta\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Basic.implicitRules\",\
		\"weight\": 736,\
		\"max\": \"1\",\
		\"type\": \"uri\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Basic.language\",\
		\"weight\": 737,\
		\"max\": \"1\",\
		\"type\": \"code\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Basic.text\",\
		\"weight\": 738,\
		\"max\": \"1\",\
		\"type\": \"Narrative\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Basic.contained\",\
		\"weight\": 739,\
		\"max\": \"*\",\
		\"type\": \"Resource\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Basic.extension\",\
		\"weight\": 740,\
		\"max\": \"*\",\
		\"type\": \"Extension\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Basic.modifierExtension\",\
		\"weight\": 741,\
		\"max\": \"*\",\
		\"type\": \"Extension\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Basic.identifier\",\
		\"weight\": 742,\
		\"max\": \"*\",\
		\"type\": \"Identifier\"\
	},\
	{\
		\"min\": \"1\",\
		\"path\": \"Basic.code\",\
		\"weight\": 743,\
		\"max\": \"1\",\
		\"type\": \"CodeableConcept\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Basic.subject\",\
		\"weight\": 744,\
		\"max\": \"1\",\
		\"type\": \"Reference\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Basic.created\",\
		\"weight\": 745,\
		\"max\": \"1\",\
		\"type\": \"date\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Basic.author\",\
		\"weight\": 746,\
		\"max\": \"1\",\
		\"type\": \"Reference\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Binary\",\
		\"weight\": 747,\
		\"max\": \"*\",\
		\"type\": \"Resource\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Binary.id\",\
		\"weight\": 748,\
		\"max\": \"1\",\
		\"type\": \"id\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Binary.meta\",\
		\"weight\": 749,\
		\"max\": \"1\",\
		\"type\": \"Meta\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Binary.implicitRules\",\
		\"weight\": 750,\
		\"max\": \"1\",\
		\"type\": \"uri\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Binary.language\",\
		\"weight\": 751,\
		\"max\": \"1\",\
		\"type\": \"code\"\
	},\
	{\
		\"min\": \"1\",\
		\"path\": \"Binary.contentType\",\
		\"weight\": 752,\
		\"max\": \"1\",\
		\"type\": \"code\"\
	},\
	{\
		\"min\": \"1\",\
		\"path\": \"Binary.content\",\
		\"weight\": 753,\
		\"max\": \"1\",\
		\"type\": \"base64Binary\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"BodySite\",\
		\"weight\": 754,\
		\"max\": \"*\",\
		\"type\": \"DomainResource\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"BodySite.id\",\
		\"weight\": 755,\
		\"max\": \"1\",\
		\"type\": \"id\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"BodySite.meta\",\
		\"weight\": 756,\
		\"max\": \"1\",\
		\"type\": \"Meta\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"BodySite.implicitRules\",\
		\"weight\": 757,\
		\"max\": \"1\",\
		\"type\": \"uri\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"BodySite.language\",\
		\"weight\": 758,\
		\"max\": \"1\",\
		\"type\": \"code\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"BodySite.text\",\
		\"weight\": 759,\
		\"max\": \"1\",\
		\"type\": \"Narrative\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"BodySite.contained\",\
		\"weight\": 760,\
		\"max\": \"*\",\
		\"type\": \"Resource\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"BodySite.extension\",\
		\"weight\": 761,\
		\"max\": \"*\",\
		\"type\": \"Extension\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"BodySite.modifierExtension\",\
		\"weight\": 762,\
		\"max\": \"*\",\
		\"type\": \"Extension\"\
	},\
	{\
		\"min\": \"1\",\
		\"path\": \"BodySite.patient\",\
		\"weight\": 763,\
		\"max\": \"1\",\
		\"type\": \"Reference\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"BodySite.identifier\",\
		\"weight\": 764,\
		\"max\": \"*\",\
		\"type\": \"Identifier\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"BodySite.code\",\
		\"weight\": 765,\
		\"max\": \"1\",\
		\"type\": \"CodeableConcept\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"BodySite.modifier\",\
		\"weight\": 766,\
		\"max\": \"*\",\
		\"type\": \"CodeableConcept\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"BodySite.description\",\
		\"weight\": 767,\
		\"max\": \"1\",\
		\"type\": \"string\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"BodySite.image\",\
		\"weight\": 768,\
		\"max\": \"*\",\
		\"type\": \"Attachment\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Bundle\",\
		\"weight\": 769,\
		\"max\": \"*\",\
		\"type\": \"Resource\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Bundle.id\",\
		\"weight\": 770,\
		\"max\": \"1\",\
		\"type\": \"id\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Bundle.meta\",\
		\"weight\": 771,\
		\"max\": \"1\",\
		\"type\": \"Meta\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Bundle.implicitRules\",\
		\"weight\": 772,\
		\"max\": \"1\",\
		\"type\": \"uri\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Bundle.language\",\
		\"weight\": 773,\
		\"max\": \"1\",\
		\"type\": \"code\"\
	},\
	{\
		\"min\": \"1\",\
		\"path\": \"Bundle.type\",\
		\"weight\": 774,\
		\"max\": \"1\",\
		\"type\": \"code\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Bundle.total\",\
		\"weight\": 775,\
		\"max\": \"1\",\
		\"type\": \"unsignedInt\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Bundle.link\",\
		\"weight\": 776,\
		\"max\": \"*\",\
		\"type\": \"BackboneElement\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Bundle.link.id\",\
		\"weight\": 777,\
		\"max\": \"1\",\
		\"type\": \"id\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Bundle.link.extension\",\
		\"weight\": 778,\
		\"max\": \"*\",\
		\"type\": \"Extension\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Bundle.link.modifierExtension\",\
		\"weight\": 779,\
		\"max\": \"*\",\
		\"type\": \"Extension\"\
	},\
	{\
		\"min\": \"1\",\
		\"path\": \"Bundle.link.relation\",\
		\"weight\": 780,\
		\"max\": \"1\",\
		\"type\": \"string\"\
	},\
	{\
		\"min\": \"1\",\
		\"path\": \"Bundle.link.url\",\
		\"weight\": 781,\
		\"max\": \"1\",\
		\"type\": \"uri\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Bundle.entry\",\
		\"weight\": 782,\
		\"max\": \"*\",\
		\"type\": \"BackboneElement\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Bundle.entry.id\",\
		\"weight\": 783,\
		\"max\": \"1\",\
		\"type\": \"id\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Bundle.entry.extension\",\
		\"weight\": 784,\
		\"max\": \"*\",\
		\"type\": \"Extension\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Bundle.entry.modifierExtension\",\
		\"weight\": 785,\
		\"max\": \"*\",\
		\"type\": \"Extension\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Bundle.entry.link\",\
		\"weight\": 786,\
		\"max\": \"*\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Bundle.entry.fullUrl\",\
		\"weight\": 787,\
		\"max\": \"1\",\
		\"type\": \"uri\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Bundle.entry.resource\",\
		\"weight\": 788,\
		\"max\": \"1\",\
		\"type\": \"Resource\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Bundle.entry.search\",\
		\"weight\": 789,\
		\"max\": \"1\",\
		\"type\": \"BackboneElement\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Bundle.entry.search.id\",\
		\"weight\": 790,\
		\"max\": \"1\",\
		\"type\": \"id\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Bundle.entry.search.extension\",\
		\"weight\": 791,\
		\"max\": \"*\",\
		\"type\": \"Extension\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Bundle.entry.search.modifierExtension\",\
		\"weight\": 792,\
		\"max\": \"*\",\
		\"type\": \"Extension\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Bundle.entry.search.mode\",\
		\"weight\": 793,\
		\"max\": \"1\",\
		\"type\": \"code\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Bundle.entry.search.score\",\
		\"weight\": 794,\
		\"max\": \"1\",\
		\"type\": \"decimal\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Bundle.entry.request\",\
		\"weight\": 795,\
		\"max\": \"1\",\
		\"type\": \"BackboneElement\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Bundle.entry.request.id\",\
		\"weight\": 796,\
		\"max\": \"1\",\
		\"type\": \"id\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Bundle.entry.request.extension\",\
		\"weight\": 797,\
		\"max\": \"*\",\
		\"type\": \"Extension\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Bundle.entry.request.modifierExtension\",\
		\"weight\": 798,\
		\"max\": \"*\",\
		\"type\": \"Extension\"\
	},\
	{\
		\"min\": \"1\",\
		\"path\": \"Bundle.entry.request.method\",\
		\"weight\": 799,\
		\"max\": \"1\",\
		\"type\": \"code\"\
	},\
	{\
		\"min\": \"1\",\
		\"path\": \"Bundle.entry.request.url\",\
		\"weight\": 800,\
		\"max\": \"1\",\
		\"type\": \"uri\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Bundle.entry.request.ifNoneMatch\",\
		\"weight\": 801,\
		\"max\": \"1\",\
		\"type\": \"string\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Bundle.entry.request.ifModifiedSince\",\
		\"weight\": 802,\
		\"max\": \"1\",\
		\"type\": \"instant\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Bundle.entry.request.ifMatch\",\
		\"weight\": 803,\
		\"max\": \"1\",\
		\"type\": \"string\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Bundle.entry.request.ifNoneExist\",\
		\"weight\": 804,\
		\"max\": \"1\",\
		\"type\": \"string\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Bundle.entry.response\",\
		\"weight\": 805,\
		\"max\": \"1\",\
		\"type\": \"BackboneElement\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Bundle.entry.response.id\",\
		\"weight\": 806,\
		\"max\": \"1\",\
		\"type\": \"id\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Bundle.entry.response.extension\",\
		\"weight\": 807,\
		\"max\": \"*\",\
		\"type\": \"Extension\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Bundle.entry.response.modifierExtension\",\
		\"weight\": 808,\
		\"max\": \"*\",\
		\"type\": \"Extension\"\
	},\
	{\
		\"min\": \"1\",\
		\"path\": \"Bundle.entry.response.status\",\
		\"weight\": 809,\
		\"max\": \"1\",\
		\"type\": \"string\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Bundle.entry.response.location\",\
		\"weight\": 810,\
		\"max\": \"1\",\
		\"type\": \"uri\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Bundle.entry.response.etag\",\
		\"weight\": 811,\
		\"max\": \"1\",\
		\"type\": \"string\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Bundle.entry.response.lastModified\",\
		\"weight\": 812,\
		\"max\": \"1\",\
		\"type\": \"instant\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Bundle.signature\",\
		\"weight\": 813,\
		\"max\": \"1\",\
		\"type\": \"Signature\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"CarePlan\",\
		\"weight\": 814,\
		\"max\": \"*\",\
		\"type\": \"DomainResource\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"CarePlan.id\",\
		\"weight\": 815,\
		\"max\": \"1\",\
		\"type\": \"id\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"CarePlan.meta\",\
		\"weight\": 816,\
		\"max\": \"1\",\
		\"type\": \"Meta\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"CarePlan.implicitRules\",\
		\"weight\": 817,\
		\"max\": \"1\",\
		\"type\": \"uri\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"CarePlan.language\",\
		\"weight\": 818,\
		\"max\": \"1\",\
		\"type\": \"code\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"CarePlan.text\",\
		\"weight\": 819,\
		\"max\": \"1\",\
		\"type\": \"Narrative\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"CarePlan.contained\",\
		\"weight\": 820,\
		\"max\": \"*\",\
		\"type\": \"Resource\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"CarePlan.extension\",\
		\"weight\": 821,\
		\"max\": \"*\",\
		\"type\": \"Extension\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"CarePlan.modifierExtension\",\
		\"weight\": 822,\
		\"max\": \"*\",\
		\"type\": \"Extension\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"CarePlan.identifier\",\
		\"weight\": 823,\
		\"max\": \"*\",\
		\"type\": \"Identifier\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"CarePlan.subject\",\
		\"weight\": 824,\
		\"max\": \"1\",\
		\"type\": \"Reference\"\
	},\
	{\
		\"min\": \"1\",\
		\"path\": \"CarePlan.status\",\
		\"weight\": 825,\
		\"max\": \"1\",\
		\"type\": \"code\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"CarePlan.context\",\
		\"weight\": 826,\
		\"max\": \"1\",\
		\"type\": \"Reference\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"CarePlan.period\",\
		\"weight\": 827,\
		\"max\": \"1\",\
		\"type\": \"Period\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"CarePlan.author\",\
		\"weight\": 828,\
		\"max\": \"*\",\
		\"type\": \"Reference\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"CarePlan.modified\",\
		\"weight\": 829,\
		\"max\": \"1\",\
		\"type\": \"dateTime\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"CarePlan.category\",\
		\"weight\": 830,\
		\"max\": \"*\",\
		\"type\": \"CodeableConcept\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"CarePlan.description\",\
		\"weight\": 831,\
		\"max\": \"1\",\
		\"type\": \"string\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"CarePlan.addresses\",\
		\"weight\": 832,\
		\"max\": \"*\",\
		\"type\": \"Reference\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"CarePlan.support\",\
		\"weight\": 833,\
		\"max\": \"*\",\
		\"type\": \"Reference\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"CarePlan.relatedPlan\",\
		\"weight\": 834,\
		\"max\": \"*\",\
		\"type\": \"BackboneElement\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"CarePlan.relatedPlan.id\",\
		\"weight\": 835,\
		\"max\": \"1\",\
		\"type\": \"id\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"CarePlan.relatedPlan.extension\",\
		\"weight\": 836,\
		\"max\": \"*\",\
		\"type\": \"Extension\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"CarePlan.relatedPlan.modifierExtension\",\
		\"weight\": 837,\
		\"max\": \"*\",\
		\"type\": \"Extension\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"CarePlan.relatedPlan.code\",\
		\"weight\": 838,\
		\"max\": \"1\",\
		\"type\": \"code\"\
	},\
	{\
		\"min\": \"1\",\
		\"path\": \"CarePlan.relatedPlan.plan\",\
		\"weight\": 839,\
		\"max\": \"1\",\
		\"type\": \"Reference\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"CarePlan.participant\",\
		\"weight\": 840,\
		\"max\": \"*\",\
		\"type\": \"BackboneElement\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"CarePlan.participant.id\",\
		\"weight\": 841,\
		\"max\": \"1\",\
		\"type\": \"id\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"CarePlan.participant.extension\",\
		\"weight\": 842,\
		\"max\": \"*\",\
		\"type\": \"Extension\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"CarePlan.participant.modifierExtension\",\
		\"weight\": 843,\
		\"max\": \"*\",\
		\"type\": \"Extension\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"CarePlan.participant.role\",\
		\"weight\": 844,\
		\"max\": \"1\",\
		\"type\": \"CodeableConcept\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"CarePlan.participant.member\",\
		\"weight\": 845,\
		\"max\": \"1\",\
		\"type\": \"Reference\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"CarePlan.goal\",\
		\"weight\": 846,\
		\"max\": \"*\",\
		\"type\": \"Reference\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"CarePlan.activity\",\
		\"weight\": 847,\
		\"max\": \"*\",\
		\"type\": \"BackboneElement\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"CarePlan.activity.id\",\
		\"weight\": 848,\
		\"max\": \"1\",\
		\"type\": \"id\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"CarePlan.activity.extension\",\
		\"weight\": 849,\
		\"max\": \"*\",\
		\"type\": \"Extension\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"CarePlan.activity.modifierExtension\",\
		\"weight\": 850,\
		\"max\": \"*\",\
		\"type\": \"Extension\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"CarePlan.activity.actionResulting\",\
		\"weight\": 851,\
		\"max\": \"*\",\
		\"type\": \"Reference\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"CarePlan.activity.progress\",\
		\"weight\": 852,\
		\"max\": \"*\",\
		\"type\": \"Annotation\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"CarePlan.activity.reference\",\
		\"weight\": 853,\
		\"max\": \"1\",\
		\"type\": \"Reference\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"CarePlan.activity.detail\",\
		\"weight\": 854,\
		\"max\": \"1\",\
		\"type\": \"BackboneElement\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"CarePlan.activity.detail.id\",\
		\"weight\": 855,\
		\"max\": \"1\",\
		\"type\": \"id\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"CarePlan.activity.detail.extension\",\
		\"weight\": 856,\
		\"max\": \"*\",\
		\"type\": \"Extension\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"CarePlan.activity.detail.modifierExtension\",\
		\"weight\": 857,\
		\"max\": \"*\",\
		\"type\": \"Extension\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"CarePlan.activity.detail.category\",\
		\"weight\": 858,\
		\"max\": \"1\",\
		\"type\": \"CodeableConcept\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"CarePlan.activity.detail.code\",\
		\"weight\": 859,\
		\"max\": \"1\",\
		\"type\": \"CodeableConcept\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"CarePlan.activity.detail.reasonCode\",\
		\"weight\": 860,\
		\"max\": \"*\",\
		\"type\": \"CodeableConcept\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"CarePlan.activity.detail.reasonReference\",\
		\"weight\": 861,\
		\"max\": \"*\",\
		\"type\": \"Reference\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"CarePlan.activity.detail.goal\",\
		\"weight\": 862,\
		\"max\": \"*\",\
		\"type\": \"Reference\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"CarePlan.activity.detail.status\",\
		\"weight\": 863,\
		\"max\": \"1\",\
		\"type\": \"code\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"CarePlan.activity.detail.statusReason\",\
		\"weight\": 864,\
		\"max\": \"1\",\
		\"type\": \"CodeableConcept\"\
	},\
	{\
		\"min\": \"1\",\
		\"path\": \"CarePlan.activity.detail.prohibited\",\
		\"weight\": 865,\
		\"max\": \"1\",\
		\"type\": \"boolean\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"CarePlan.activity.detail.scheduledTiming\",\
		\"weight\": 866,\
		\"max\": \"1\",\
		\"type\": \"Timing\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"CarePlan.activity.detail.scheduledPeriod\",\
		\"weight\": 866,\
		\"max\": \"1\",\
		\"type\": \"Period\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"CarePlan.activity.detail.scheduledString\",\
		\"weight\": 866,\
		\"max\": \"1\",\
		\"type\": \"string\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"CarePlan.activity.detail.location\",\
		\"weight\": 867,\
		\"max\": \"1\",\
		\"type\": \"Reference\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"CarePlan.activity.detail.performer\",\
		\"weight\": 868,\
		\"max\": \"*\",\
		\"type\": \"Reference\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"CarePlan.activity.detail.productCodeableConcept\",\
		\"weight\": 869,\
		\"max\": \"1\",\
		\"type\": \"CodeableConcept\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"CarePlan.activity.detail.productReference\",\
		\"weight\": 869,\
		\"max\": \"1\",\
		\"type\": \"Reference\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"CarePlan.activity.detail.productReference\",\
		\"weight\": 869,\
		\"max\": \"1\",\
		\"type\": \"Reference\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"CarePlan.activity.detail.dailyAmount\",\
		\"weight\": 870,\
		\"max\": \"1\",\
		\"type\": \"Quantity\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"CarePlan.activity.detail.quantity\",\
		\"weight\": 871,\
		\"max\": \"1\",\
		\"type\": \"Quantity\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"CarePlan.activity.detail.description\",\
		\"weight\": 872,\
		\"max\": \"1\",\
		\"type\": \"string\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"CarePlan.note\",\
		\"weight\": 873,\
		\"max\": \"1\",\
		\"type\": \"Annotation\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"CareTeam\",\
		\"weight\": 874,\
		\"max\": \"*\",\
		\"type\": \"DomainResource\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"CareTeam.id\",\
		\"weight\": 875,\
		\"max\": \"1\",\
		\"type\": \"id\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"CareTeam.meta\",\
		\"weight\": 876,\
		\"max\": \"1\",\
		\"type\": \"Meta\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"CareTeam.implicitRules\",\
		\"weight\": 877,\
		\"max\": \"1\",\
		\"type\": \"uri\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"CareTeam.language\",\
		\"weight\": 878,\
		\"max\": \"1\",\
		\"type\": \"code\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"CareTeam.text\",\
		\"weight\": 879,\
		\"max\": \"1\",\
		\"type\": \"Narrative\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"CareTeam.contained\",\
		\"weight\": 880,\
		\"max\": \"*\",\
		\"type\": \"Resource\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"CareTeam.extension\",\
		\"weight\": 881,\
		\"max\": \"*\",\
		\"type\": \"Extension\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"CareTeam.modifierExtension\",\
		\"weight\": 882,\
		\"max\": \"*\",\
		\"type\": \"Extension\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"CareTeam.identifier\",\
		\"weight\": 883,\
		\"max\": \"*\",\
		\"type\": \"Identifier\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"CareTeam.status\",\
		\"weight\": 884,\
		\"max\": \"1\",\
		\"type\": \"CodeableConcept\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"CareTeam.type\",\
		\"weight\": 885,\
		\"max\": \"*\",\
		\"type\": \"CodeableConcept\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"CareTeam.name\",\
		\"weight\": 886,\
		\"max\": \"1\",\
		\"type\": \"string\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"CareTeam.subject\",\
		\"weight\": 887,\
		\"max\": \"1\",\
		\"type\": \"Reference\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"CareTeam.period\",\
		\"weight\": 888,\
		\"max\": \"1\",\
		\"type\": \"Period\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"CareTeam.participant\",\
		\"weight\": 889,\
		\"max\": \"*\",\
		\"type\": \"BackboneElement\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"CareTeam.participant.id\",\
		\"weight\": 890,\
		\"max\": \"1\",\
		\"type\": \"id\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"CareTeam.participant.extension\",\
		\"weight\": 891,\
		\"max\": \"*\",\
		\"type\": \"Extension\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"CareTeam.participant.modifierExtension\",\
		\"weight\": 892,\
		\"max\": \"*\",\
		\"type\": \"Extension\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"CareTeam.participant.role\",\
		\"weight\": 893,\
		\"max\": \"1\",\
		\"type\": \"CodeableConcept\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"CareTeam.participant.member\",\
		\"weight\": 894,\
		\"max\": \"1\",\
		\"type\": \"Reference\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"CareTeam.participant.period\",\
		\"weight\": 895,\
		\"max\": \"1\",\
		\"type\": \"Period\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"CareTeam.managingOrganization\",\
		\"weight\": 896,\
		\"max\": \"1\",\
		\"type\": \"Reference\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Claim\",\
		\"weight\": 897,\
		\"max\": \"*\",\
		\"type\": \"DomainResource\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Claim.id\",\
		\"weight\": 898,\
		\"max\": \"1\",\
		\"type\": \"id\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Claim.meta\",\
		\"weight\": 899,\
		\"max\": \"1\",\
		\"type\": \"Meta\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Claim.implicitRules\",\
		\"weight\": 900,\
		\"max\": \"1\",\
		\"type\": \"uri\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Claim.language\",\
		\"weight\": 901,\
		\"max\": \"1\",\
		\"type\": \"code\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Claim.text\",\
		\"weight\": 902,\
		\"max\": \"1\",\
		\"type\": \"Narrative\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Claim.contained\",\
		\"weight\": 903,\
		\"max\": \"*\",\
		\"type\": \"Resource\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Claim.extension\",\
		\"weight\": 904,\
		\"max\": \"*\",\
		\"type\": \"Extension\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Claim.modifierExtension\",\
		\"weight\": 905,\
		\"max\": \"*\",\
		\"type\": \"Extension\"\
	},\
	{\
		\"min\": \"1\",\
		\"path\": \"Claim.type\",\
		\"weight\": 906,\
		\"max\": \"1\",\
		\"type\": \"code\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Claim.subType\",\
		\"weight\": 907,\
		\"max\": \"*\",\
		\"type\": \"Coding\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Claim.identifier\",\
		\"weight\": 908,\
		\"max\": \"*\",\
		\"type\": \"Identifier\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Claim.ruleset\",\
		\"weight\": 909,\
		\"max\": \"1\",\
		\"type\": \"Coding\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Claim.originalRuleset\",\
		\"weight\": 910,\
		\"max\": \"1\",\
		\"type\": \"Coding\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Claim.created\",\
		\"weight\": 911,\
		\"max\": \"1\",\
		\"type\": \"dateTime\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Claim.billablePeriod\",\
		\"weight\": 912,\
		\"max\": \"1\",\
		\"type\": \"Period\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Claim.targetIdentifier\",\
		\"weight\": 913,\
		\"max\": \"1\",\
		\"type\": \"Identifier\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Claim.targetReference\",\
		\"weight\": 913,\
		\"max\": \"1\",\
		\"type\": \"Reference\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Claim.providerIdentifier\",\
		\"weight\": 914,\
		\"max\": \"1\",\
		\"type\": \"Identifier\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Claim.providerReference\",\
		\"weight\": 914,\
		\"max\": \"1\",\
		\"type\": \"Reference\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Claim.organizationIdentifier\",\
		\"weight\": 915,\
		\"max\": \"1\",\
		\"type\": \"Identifier\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Claim.organizationReference\",\
		\"weight\": 915,\
		\"max\": \"1\",\
		\"type\": \"Reference\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Claim.use\",\
		\"weight\": 916,\
		\"max\": \"1\",\
		\"type\": \"code\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Claim.priority\",\
		\"weight\": 917,\
		\"max\": \"1\",\
		\"type\": \"Coding\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Claim.fundsReserve\",\
		\"weight\": 918,\
		\"max\": \"1\",\
		\"type\": \"Coding\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Claim.entererIdentifier\",\
		\"weight\": 919,\
		\"max\": \"1\",\
		\"type\": \"Identifier\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Claim.entererReference\",\
		\"weight\": 919,\
		\"max\": \"1\",\
		\"type\": \"Reference\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Claim.facilityIdentifier\",\
		\"weight\": 920,\
		\"max\": \"1\",\
		\"type\": \"Identifier\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Claim.facilityReference\",\
		\"weight\": 920,\
		\"max\": \"1\",\
		\"type\": \"Reference\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Claim.related\",\
		\"weight\": 921,\
		\"max\": \"*\",\
		\"type\": \"BackboneElement\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Claim.related.id\",\
		\"weight\": 922,\
		\"max\": \"1\",\
		\"type\": \"id\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Claim.related.extension\",\
		\"weight\": 923,\
		\"max\": \"*\",\
		\"type\": \"Extension\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Claim.related.modifierExtension\",\
		\"weight\": 924,\
		\"max\": \"*\",\
		\"type\": \"Extension\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Claim.related.claimIdentifier\",\
		\"weight\": 925,\
		\"max\": \"1\",\
		\"type\": \"Identifier\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Claim.related.claimReference\",\
		\"weight\": 925,\
		\"max\": \"1\",\
		\"type\": \"Reference\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Claim.related.relationship\",\
		\"weight\": 926,\
		\"max\": \"1\",\
		\"type\": \"Coding\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Claim.related.reference\",\
		\"weight\": 927,\
		\"max\": \"1\",\
		\"type\": \"Identifier\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Claim.prescriptionIdentifier\",\
		\"weight\": 928,\
		\"max\": \"1\",\
		\"type\": \"Identifier\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Claim.prescriptionReference\",\
		\"weight\": 928,\
		\"max\": \"1\",\
		\"type\": \"Reference\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Claim.prescriptionReference\",\
		\"weight\": 928,\
		\"max\": \"1\",\
		\"type\": \"Reference\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Claim.originalPrescriptionIdentifier\",\
		\"weight\": 929,\
		\"max\": \"1\",\
		\"type\": \"Identifier\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Claim.originalPrescriptionReference\",\
		\"weight\": 929,\
		\"max\": \"1\",\
		\"type\": \"Reference\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Claim.payee\",\
		\"weight\": 930,\
		\"max\": \"1\",\
		\"type\": \"BackboneElement\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Claim.payee.id\",\
		\"weight\": 931,\
		\"max\": \"1\",\
		\"type\": \"id\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Claim.payee.extension\",\
		\"weight\": 932,\
		\"max\": \"*\",\
		\"type\": \"Extension\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Claim.payee.modifierExtension\",\
		\"weight\": 933,\
		\"max\": \"*\",\
		\"type\": \"Extension\"\
	},\
	{\
		\"min\": \"1\",\
		\"path\": \"Claim.payee.type\",\
		\"weight\": 934,\
		\"max\": \"1\",\
		\"type\": \"Coding\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Claim.payee.partyIdentifier\",\
		\"weight\": 935,\
		\"max\": \"1\",\
		\"type\": \"Identifier\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Claim.payee.partyReference\",\
		\"weight\": 935,\
		\"max\": \"1\",\
		\"type\": \"Reference\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Claim.payee.partyReference\",\
		\"weight\": 935,\
		\"max\": \"1\",\
		\"type\": \"Reference\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Claim.payee.partyReference\",\
		\"weight\": 935,\
		\"max\": \"1\",\
		\"type\": \"Reference\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Claim.payee.partyReference\",\
		\"weight\": 935,\
		\"max\": \"1\",\
		\"type\": \"Reference\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Claim.referralIdentifier\",\
		\"weight\": 936,\
		\"max\": \"1\",\
		\"type\": \"Identifier\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Claim.referralReference\",\
		\"weight\": 936,\
		\"max\": \"1\",\
		\"type\": \"Reference\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Claim.occurrenceCode\",\
		\"weight\": 937,\
		\"max\": \"*\",\
		\"type\": \"Coding\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Claim.occurenceSpanCode\",\
		\"weight\": 938,\
		\"max\": \"*\",\
		\"type\": \"Coding\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Claim.valueCode\",\
		\"weight\": 939,\
		\"max\": \"*\",\
		\"type\": \"Coding\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Claim.diagnosis\",\
		\"weight\": 940,\
		\"max\": \"*\",\
		\"type\": \"BackboneElement\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Claim.diagnosis.id\",\
		\"weight\": 941,\
		\"max\": \"1\",\
		\"type\": \"id\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Claim.diagnosis.extension\",\
		\"weight\": 942,\
		\"max\": \"*\",\
		\"type\": \"Extension\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Claim.diagnosis.modifierExtension\",\
		\"weight\": 943,\
		\"max\": \"*\",\
		\"type\": \"Extension\"\
	},\
	{\
		\"min\": \"1\",\
		\"path\": \"Claim.diagnosis.sequence\",\
		\"weight\": 944,\
		\"max\": \"1\",\
		\"type\": \"positiveInt\"\
	},\
	{\
		\"min\": \"1\",\
		\"path\": \"Claim.diagnosis.diagnosis\",\
		\"weight\": 945,\
		\"max\": \"1\",\
		\"type\": \"Coding\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Claim.procedure\",\
		\"weight\": 946,\
		\"max\": \"*\",\
		\"type\": \"BackboneElement\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Claim.procedure.id\",\
		\"weight\": 947,\
		\"max\": \"1\",\
		\"type\": \"id\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Claim.procedure.extension\",\
		\"weight\": 948,\
		\"max\": \"*\",\
		\"type\": \"Extension\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Claim.procedure.modifierExtension\",\
		\"weight\": 949,\
		\"max\": \"*\",\
		\"type\": \"Extension\"\
	},\
	{\
		\"min\": \"1\",\
		\"path\": \"Claim.procedure.sequence\",\
		\"weight\": 950,\
		\"max\": \"1\",\
		\"type\": \"positiveInt\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Claim.procedure.date\",\
		\"weight\": 951,\
		\"max\": \"1\",\
		\"type\": \"dateTime\"\
	},\
	{\
		\"min\": \"1\",\
		\"path\": \"Claim.procedure.procedureCoding\",\
		\"weight\": 952,\
		\"max\": \"1\",\
		\"type\": \"Coding\"\
	},\
	{\
		\"min\": \"1\",\
		\"path\": \"Claim.procedure.procedureReference\",\
		\"weight\": 952,\
		\"max\": \"1\",\
		\"type\": \"Reference\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Claim.specialCondition\",\
		\"weight\": 953,\
		\"max\": \"*\",\
		\"type\": \"Coding\"\
	},\
	{\
		\"min\": \"1\",\
		\"path\": \"Claim.patientIdentifier\",\
		\"weight\": 954,\
		\"max\": \"1\",\
		\"type\": \"Identifier\"\
	},\
	{\
		\"min\": \"1\",\
		\"path\": \"Claim.patientReference\",\
		\"weight\": 954,\
		\"max\": \"1\",\
		\"type\": \"Reference\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Claim.coverage\",\
		\"weight\": 955,\
		\"max\": \"*\",\
		\"type\": \"BackboneElement\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Claim.coverage.id\",\
		\"weight\": 956,\
		\"max\": \"1\",\
		\"type\": \"id\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Claim.coverage.extension\",\
		\"weight\": 957,\
		\"max\": \"*\",\
		\"type\": \"Extension\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Claim.coverage.modifierExtension\",\
		\"weight\": 958,\
		\"max\": \"*\",\
		\"type\": \"Extension\"\
	},\
	{\
		\"min\": \"1\",\
		\"path\": \"Claim.coverage.sequence\",\
		\"weight\": 959,\
		\"max\": \"1\",\
		\"type\": \"positiveInt\"\
	},\
	{\
		\"min\": \"1\",\
		\"path\": \"Claim.coverage.focal\",\
		\"weight\": 960,\
		\"max\": \"1\",\
		\"type\": \"boolean\"\
	},\
	{\
		\"min\": \"1\",\
		\"path\": \"Claim.coverage.coverageIdentifier\",\
		\"weight\": 961,\
		\"max\": \"1\",\
		\"type\": \"Identifier\"\
	},\
	{\
		\"min\": \"1\",\
		\"path\": \"Claim.coverage.coverageReference\",\
		\"weight\": 961,\
		\"max\": \"1\",\
		\"type\": \"Reference\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Claim.coverage.businessArrangement\",\
		\"weight\": 962,\
		\"max\": \"1\",\
		\"type\": \"string\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Claim.coverage.preAuthRef\",\
		\"weight\": 963,\
		\"max\": \"*\",\
		\"type\": \"string\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Claim.coverage.claimResponse\",\
		\"weight\": 964,\
		\"max\": \"1\",\
		\"type\": \"Reference\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Claim.coverage.originalRuleset\",\
		\"weight\": 965,\
		\"max\": \"1\",\
		\"type\": \"Coding\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Claim.accidentDate\",\
		\"weight\": 966,\
		\"max\": \"1\",\
		\"type\": \"date\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Claim.accidentType\",\
		\"weight\": 967,\
		\"max\": \"1\",\
		\"type\": \"Coding\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Claim.accidentLocationAddress\",\
		\"weight\": 968,\
		\"max\": \"1\",\
		\"type\": \"Address\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Claim.accidentLocationReference\",\
		\"weight\": 968,\
		\"max\": \"1\",\
		\"type\": \"Reference\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Claim.interventionException\",\
		\"weight\": 969,\
		\"max\": \"*\",\
		\"type\": \"Coding\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Claim.onset\",\
		\"weight\": 970,\
		\"max\": \"*\",\
		\"type\": \"BackboneElement\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Claim.onset.id\",\
		\"weight\": 971,\
		\"max\": \"1\",\
		\"type\": \"id\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Claim.onset.extension\",\
		\"weight\": 972,\
		\"max\": \"*\",\
		\"type\": \"Extension\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Claim.onset.modifierExtension\",\
		\"weight\": 973,\
		\"max\": \"*\",\
		\"type\": \"Extension\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Claim.onset.timeDate\",\
		\"weight\": 974,\
		\"max\": \"1\",\
		\"type\": \"date\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Claim.onset.timePeriod\",\
		\"weight\": 974,\
		\"max\": \"1\",\
		\"type\": \"Period\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Claim.onset.type\",\
		\"weight\": 975,\
		\"max\": \"1\",\
		\"type\": \"Coding\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Claim.employmentImpacted\",\
		\"weight\": 976,\
		\"max\": \"1\",\
		\"type\": \"Period\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Claim.hospitalization\",\
		\"weight\": 977,\
		\"max\": \"1\",\
		\"type\": \"Period\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Claim.item\",\
		\"weight\": 978,\
		\"max\": \"*\",\
		\"type\": \"BackboneElement\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Claim.item.id\",\
		\"weight\": 979,\
		\"max\": \"1\",\
		\"type\": \"id\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Claim.item.extension\",\
		\"weight\": 980,\
		\"max\": \"*\",\
		\"type\": \"Extension\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Claim.item.modifierExtension\",\
		\"weight\": 981,\
		\"max\": \"*\",\
		\"type\": \"Extension\"\
	},\
	{\
		\"min\": \"1\",\
		\"path\": \"Claim.item.sequence\",\
		\"weight\": 982,\
		\"max\": \"1\",\
		\"type\": \"positiveInt\"\
	},\
	{\
		\"min\": \"1\",\
		\"path\": \"Claim.item.type\",\
		\"weight\": 983,\
		\"max\": \"1\",\
		\"type\": \"Coding\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Claim.item.providerIdentifier\",\
		\"weight\": 984,\
		\"max\": \"1\",\
		\"type\": \"Identifier\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Claim.item.providerReference\",\
		\"weight\": 984,\
		\"max\": \"1\",\
		\"type\": \"Reference\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Claim.item.supervisorIdentifier\",\
		\"weight\": 985,\
		\"max\": \"1\",\
		\"type\": \"Identifier\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Claim.item.supervisorReference\",\
		\"weight\": 985,\
		\"max\": \"1\",\
		\"type\": \"Reference\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Claim.item.providerQualification\",\
		\"weight\": 986,\
		\"max\": \"1\",\
		\"type\": \"Coding\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Claim.item.diagnosisLinkId\",\
		\"weight\": 987,\
		\"max\": \"*\",\
		\"type\": \"positiveInt\"\
	},\
	{\
		\"min\": \"1\",\
		\"path\": \"Claim.item.service\",\
		\"weight\": 988,\
		\"max\": \"1\",\
		\"type\": \"Coding\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Claim.item.serviceModifier\",\
		\"weight\": 989,\
		\"max\": \"*\",\
		\"type\": \"Coding\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Claim.item.modifier\",\
		\"weight\": 990,\
		\"max\": \"*\",\
		\"type\": \"Coding\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Claim.item.programCode\",\
		\"weight\": 991,\
		\"max\": \"*\",\
		\"type\": \"Coding\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Claim.item.servicedDate\",\
		\"weight\": 992,\
		\"max\": \"1\",\
		\"type\": \"date\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Claim.item.servicedPeriod\",\
		\"weight\": 992,\
		\"max\": \"1\",\
		\"type\": \"Period\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Claim.item.place\",\
		\"weight\": 993,\
		\"max\": \"1\",\
		\"type\": \"Coding\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Claim.item.quantity\",\
		\"weight\": 994,\
		\"max\": \"1\",\
		\"type\": \"Quantity\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Claim.item.unitPrice\",\
		\"weight\": 995,\
		\"max\": \"1\",\
		\"type\": \"Quantity\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Claim.item.factor\",\
		\"weight\": 996,\
		\"max\": \"1\",\
		\"type\": \"decimal\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Claim.item.points\",\
		\"weight\": 997,\
		\"max\": \"1\",\
		\"type\": \"decimal\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Claim.item.net\",\
		\"weight\": 998,\
		\"max\": \"1\",\
		\"type\": \"Quantity\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Claim.item.udi\",\
		\"weight\": 999,\
		\"max\": \"*\",\
		\"type\": \"Reference\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Claim.item.bodySite\",\
		\"weight\": 1000,\
		\"max\": \"1\",\
		\"type\": \"Coding\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Claim.item.subSite\",\
		\"weight\": 1001,\
		\"max\": \"*\",\
		\"type\": \"Coding\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Claim.item.detail\",\
		\"weight\": 1002,\
		\"max\": \"*\",\
		\"type\": \"BackboneElement\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Claim.item.detail.id\",\
		\"weight\": 1003,\
		\"max\": \"1\",\
		\"type\": \"id\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Claim.item.detail.extension\",\
		\"weight\": 1004,\
		\"max\": \"*\",\
		\"type\": \"Extension\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Claim.item.detail.modifierExtension\",\
		\"weight\": 1005,\
		\"max\": \"*\",\
		\"type\": \"Extension\"\
	},\
	{\
		\"min\": \"1\",\
		\"path\": \"Claim.item.detail.sequence\",\
		\"weight\": 1006,\
		\"max\": \"1\",\
		\"type\": \"positiveInt\"\
	},\
	{\
		\"min\": \"1\",\
		\"path\": \"Claim.item.detail.type\",\
		\"weight\": 1007,\
		\"max\": \"1\",\
		\"type\": \"Coding\"\
	},\
	{\
		\"min\": \"1\",\
		\"path\": \"Claim.item.detail.service\",\
		\"weight\": 1008,\
		\"max\": \"1\",\
		\"type\": \"Coding\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Claim.item.detail.programCode\",\
		\"weight\": 1009,\
		\"max\": \"*\",\
		\"type\": \"Coding\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Claim.item.detail.quantity\",\
		\"weight\": 1010,\
		\"max\": \"1\",\
		\"type\": \"Quantity\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Claim.item.detail.unitPrice\",\
		\"weight\": 1011,\
		\"max\": \"1\",\
		\"type\": \"Quantity\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Claim.item.detail.factor\",\
		\"weight\": 1012,\
		\"max\": \"1\",\
		\"type\": \"decimal\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Claim.item.detail.points\",\
		\"weight\": 1013,\
		\"max\": \"1\",\
		\"type\": \"decimal\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Claim.item.detail.net\",\
		\"weight\": 1014,\
		\"max\": \"1\",\
		\"type\": \"Quantity\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Claim.item.detail.udi\",\
		\"weight\": 1015,\
		\"max\": \"*\",\
		\"type\": \"Reference\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Claim.item.detail.subDetail\",\
		\"weight\": 1016,\
		\"max\": \"*\",\
		\"type\": \"BackboneElement\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Claim.item.detail.subDetail.id\",\
		\"weight\": 1017,\
		\"max\": \"1\",\
		\"type\": \"id\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Claim.item.detail.subDetail.extension\",\
		\"weight\": 1018,\
		\"max\": \"*\",\
		\"type\": \"Extension\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Claim.item.detail.subDetail.modifierExtension\",\
		\"weight\": 1019,\
		\"max\": \"*\",\
		\"type\": \"Extension\"\
	},\
	{\
		\"min\": \"1\",\
		\"path\": \"Claim.item.detail.subDetail.sequence\",\
		\"weight\": 1020,\
		\"max\": \"1\",\
		\"type\": \"positiveInt\"\
	},\
	{\
		\"min\": \"1\",\
		\"path\": \"Claim.item.detail.subDetail.type\",\
		\"weight\": 1021,\
		\"max\": \"1\",\
		\"type\": \"Coding\"\
	},\
	{\
		\"min\": \"1\",\
		\"path\": \"Claim.item.detail.subDetail.service\",\
		\"weight\": 1022,\
		\"max\": \"1\",\
		\"type\": \"Coding\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Claim.item.detail.subDetail.programCode\",\
		\"weight\": 1023,\
		\"max\": \"*\",\
		\"type\": \"Coding\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Claim.item.detail.subDetail.quantity\",\
		\"weight\": 1024,\
		\"max\": \"1\",\
		\"type\": \"Quantity\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Claim.item.detail.subDetail.unitPrice\",\
		\"weight\": 1025,\
		\"max\": \"1\",\
		\"type\": \"Quantity\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Claim.item.detail.subDetail.factor\",\
		\"weight\": 1026,\
		\"max\": \"1\",\
		\"type\": \"decimal\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Claim.item.detail.subDetail.points\",\
		\"weight\": 1027,\
		\"max\": \"1\",\
		\"type\": \"decimal\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Claim.item.detail.subDetail.net\",\
		\"weight\": 1028,\
		\"max\": \"1\",\
		\"type\": \"Quantity\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Claim.item.detail.subDetail.udi\",\
		\"weight\": 1029,\
		\"max\": \"*\",\
		\"type\": \"Reference\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Claim.item.prosthesis\",\
		\"weight\": 1030,\
		\"max\": \"1\",\
		\"type\": \"BackboneElement\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Claim.item.prosthesis.id\",\
		\"weight\": 1031,\
		\"max\": \"1\",\
		\"type\": \"id\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Claim.item.prosthesis.extension\",\
		\"weight\": 1032,\
		\"max\": \"*\",\
		\"type\": \"Extension\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Claim.item.prosthesis.modifierExtension\",\
		\"weight\": 1033,\
		\"max\": \"*\",\
		\"type\": \"Extension\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Claim.item.prosthesis.initial\",\
		\"weight\": 1034,\
		\"max\": \"1\",\
		\"type\": \"boolean\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Claim.item.prosthesis.priorDate\",\
		\"weight\": 1035,\
		\"max\": \"1\",\
		\"type\": \"date\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Claim.item.prosthesis.priorMaterial\",\
		\"weight\": 1036,\
		\"max\": \"1\",\
		\"type\": \"Coding\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Claim.total\",\
		\"weight\": 1037,\
		\"max\": \"1\",\
		\"type\": \"Quantity\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Claim.additionalMaterial\",\
		\"weight\": 1038,\
		\"max\": \"*\",\
		\"type\": \"Coding\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Claim.missingTeeth\",\
		\"weight\": 1039,\
		\"max\": \"*\",\
		\"type\": \"BackboneElement\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Claim.missingTeeth.id\",\
		\"weight\": 1040,\
		\"max\": \"1\",\
		\"type\": \"id\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Claim.missingTeeth.extension\",\
		\"weight\": 1041,\
		\"max\": \"*\",\
		\"type\": \"Extension\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Claim.missingTeeth.modifierExtension\",\
		\"weight\": 1042,\
		\"max\": \"*\",\
		\"type\": \"Extension\"\
	},\
	{\
		\"min\": \"1\",\
		\"path\": \"Claim.missingTeeth.tooth\",\
		\"weight\": 1043,\
		\"max\": \"1\",\
		\"type\": \"Coding\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Claim.missingTeeth.reason\",\
		\"weight\": 1044,\
		\"max\": \"1\",\
		\"type\": \"Coding\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Claim.missingTeeth.extractionDate\",\
		\"weight\": 1045,\
		\"max\": \"1\",\
		\"type\": \"date\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"ClaimResponse\",\
		\"weight\": 1046,\
		\"max\": \"*\",\
		\"type\": \"DomainResource\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"ClaimResponse.id\",\
		\"weight\": 1047,\
		\"max\": \"1\",\
		\"type\": \"id\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"ClaimResponse.meta\",\
		\"weight\": 1048,\
		\"max\": \"1\",\
		\"type\": \"Meta\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"ClaimResponse.implicitRules\",\
		\"weight\": 1049,\
		\"max\": \"1\",\
		\"type\": \"uri\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"ClaimResponse.language\",\
		\"weight\": 1050,\
		\"max\": \"1\",\
		\"type\": \"code\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"ClaimResponse.text\",\
		\"weight\": 1051,\
		\"max\": \"1\",\
		\"type\": \"Narrative\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"ClaimResponse.contained\",\
		\"weight\": 1052,\
		\"max\": \"*\",\
		\"type\": \"Resource\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"ClaimResponse.extension\",\
		\"weight\": 1053,\
		\"max\": \"*\",\
		\"type\": \"Extension\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"ClaimResponse.modifierExtension\",\
		\"weight\": 1054,\
		\"max\": \"*\",\
		\"type\": \"Extension\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"ClaimResponse.identifier\",\
		\"weight\": 1055,\
		\"max\": \"*\",\
		\"type\": \"Identifier\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"ClaimResponse.requestIdentifier\",\
		\"weight\": 1056,\
		\"max\": \"1\",\
		\"type\": \"Identifier\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"ClaimResponse.requestReference\",\
		\"weight\": 1056,\
		\"max\": \"1\",\
		\"type\": \"Reference\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"ClaimResponse.ruleset\",\
		\"weight\": 1057,\
		\"max\": \"1\",\
		\"type\": \"Coding\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"ClaimResponse.originalRuleset\",\
		\"weight\": 1058,\
		\"max\": \"1\",\
		\"type\": \"Coding\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"ClaimResponse.created\",\
		\"weight\": 1059,\
		\"max\": \"1\",\
		\"type\": \"dateTime\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"ClaimResponse.organizationIdentifier\",\
		\"weight\": 1060,\
		\"max\": \"1\",\
		\"type\": \"Identifier\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"ClaimResponse.organizationReference\",\
		\"weight\": 1060,\
		\"max\": \"1\",\
		\"type\": \"Reference\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"ClaimResponse.requestProviderIdentifier\",\
		\"weight\": 1061,\
		\"max\": \"1\",\
		\"type\": \"Identifier\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"ClaimResponse.requestProviderReference\",\
		\"weight\": 1061,\
		\"max\": \"1\",\
		\"type\": \"Reference\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"ClaimResponse.requestOrganizationIdentifier\",\
		\"weight\": 1062,\
		\"max\": \"1\",\
		\"type\": \"Identifier\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"ClaimResponse.requestOrganizationReference\",\
		\"weight\": 1062,\
		\"max\": \"1\",\
		\"type\": \"Reference\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"ClaimResponse.outcome\",\
		\"weight\": 1063,\
		\"max\": \"1\",\
		\"type\": \"code\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"ClaimResponse.disposition\",\
		\"weight\": 1064,\
		\"max\": \"1\",\
		\"type\": \"string\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"ClaimResponse.payeeType\",\
		\"weight\": 1065,\
		\"max\": \"1\",\
		\"type\": \"Coding\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"ClaimResponse.item\",\
		\"weight\": 1066,\
		\"max\": \"*\",\
		\"type\": \"BackboneElement\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"ClaimResponse.item.id\",\
		\"weight\": 1067,\
		\"max\": \"1\",\
		\"type\": \"id\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"ClaimResponse.item.extension\",\
		\"weight\": 1068,\
		\"max\": \"*\",\
		\"type\": \"Extension\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"ClaimResponse.item.modifierExtension\",\
		\"weight\": 1069,\
		\"max\": \"*\",\
		\"type\": \"Extension\"\
	},\
	{\
		\"min\": \"1\",\
		\"path\": \"ClaimResponse.item.sequenceLinkId\",\
		\"weight\": 1070,\
		\"max\": \"1\",\
		\"type\": \"positiveInt\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"ClaimResponse.item.noteNumber\",\
		\"weight\": 1071,\
		\"max\": \"*\",\
		\"type\": \"positiveInt\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"ClaimResponse.item.adjudication\",\
		\"weight\": 1072,\
		\"max\": \"*\",\
		\"type\": \"BackboneElement\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"ClaimResponse.item.adjudication.id\",\
		\"weight\": 1073,\
		\"max\": \"1\",\
		\"type\": \"id\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"ClaimResponse.item.adjudication.extension\",\
		\"weight\": 1074,\
		\"max\": \"*\",\
		\"type\": \"Extension\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"ClaimResponse.item.adjudication.modifierExtension\",\
		\"weight\": 1075,\
		\"max\": \"*\",\
		\"type\": \"Extension\"\
	},\
	{\
		\"min\": \"1\",\
		\"path\": \"ClaimResponse.item.adjudication.category\",\
		\"weight\": 1076,\
		\"max\": \"1\",\
		\"type\": \"Coding\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"ClaimResponse.item.adjudication.reason\",\
		\"weight\": 1077,\
		\"max\": \"1\",\
		\"type\": \"Coding\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"ClaimResponse.item.adjudication.amount\",\
		\"weight\": 1078,\
		\"max\": \"1\",\
		\"type\": \"Quantity\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"ClaimResponse.item.adjudication.value\",\
		\"weight\": 1079,\
		\"max\": \"1\",\
		\"type\": \"decimal\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"ClaimResponse.item.detail\",\
		\"weight\": 1080,\
		\"max\": \"*\",\
		\"type\": \"BackboneElement\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"ClaimResponse.item.detail.id\",\
		\"weight\": 1081,\
		\"max\": \"1\",\
		\"type\": \"id\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"ClaimResponse.item.detail.extension\",\
		\"weight\": 1082,\
		\"max\": \"*\",\
		\"type\": \"Extension\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"ClaimResponse.item.detail.modifierExtension\",\
		\"weight\": 1083,\
		\"max\": \"*\",\
		\"type\": \"Extension\"\
	},\
	{\
		\"min\": \"1\",\
		\"path\": \"ClaimResponse.item.detail.sequenceLinkId\",\
		\"weight\": 1084,\
		\"max\": \"1\",\
		\"type\": \"positiveInt\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"ClaimResponse.item.detail.adjudication\",\
		\"weight\": 1085,\
		\"max\": \"*\",\
		\"type\": \"BackboneElement\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"ClaimResponse.item.detail.adjudication.id\",\
		\"weight\": 1086,\
		\"max\": \"1\",\
		\"type\": \"id\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"ClaimResponse.item.detail.adjudication.extension\",\
		\"weight\": 1087,\
		\"max\": \"*\",\
		\"type\": \"Extension\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"ClaimResponse.item.detail.adjudication.modifierExtension\",\
		\"weight\": 1088,\
		\"max\": \"*\",\
		\"type\": \"Extension\"\
	},\
	{\
		\"min\": \"1\",\
		\"path\": \"ClaimResponse.item.detail.adjudication.category\",\
		\"weight\": 1089,\
		\"max\": \"1\",\
		\"type\": \"Coding\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"ClaimResponse.item.detail.adjudication.reason\",\
		\"weight\": 1090,\
		\"max\": \"1\",\
		\"type\": \"Coding\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"ClaimResponse.item.detail.adjudication.amount\",\
		\"weight\": 1091,\
		\"max\": \"1\",\
		\"type\": \"Quantity\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"ClaimResponse.item.detail.adjudication.value\",\
		\"weight\": 1092,\
		\"max\": \"1\",\
		\"type\": \"decimal\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"ClaimResponse.item.detail.subDetail\",\
		\"weight\": 1093,\
		\"max\": \"*\",\
		\"type\": \"BackboneElement\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"ClaimResponse.item.detail.subDetail.id\",\
		\"weight\": 1094,\
		\"max\": \"1\",\
		\"type\": \"id\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"ClaimResponse.item.detail.subDetail.extension\",\
		\"weight\": 1095,\
		\"max\": \"*\",\
		\"type\": \"Extension\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"ClaimResponse.item.detail.subDetail.modifierExtension\",\
		\"weight\": 1096,\
		\"max\": \"*\",\
		\"type\": \"Extension\"\
	},\
	{\
		\"min\": \"1\",\
		\"path\": \"ClaimResponse.item.detail.subDetail.sequenceLinkId\",\
		\"weight\": 1097,\
		\"max\": \"1\",\
		\"type\": \"positiveInt\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"ClaimResponse.item.detail.subDetail.adjudication\",\
		\"weight\": 1098,\
		\"max\": \"*\",\
		\"type\": \"BackboneElement\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"ClaimResponse.item.detail.subDetail.adjudication.id\",\
		\"weight\": 1099,\
		\"max\": \"1\",\
		\"type\": \"id\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"ClaimResponse.item.detail.subDetail.adjudication.extension\",\
		\"weight\": 1100,\
		\"max\": \"*\",\
		\"type\": \"Extension\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"ClaimResponse.item.detail.subDetail.adjudication.modifierExtension\",\
		\"weight\": 1101,\
		\"max\": \"*\",\
		\"type\": \"Extension\"\
	},\
	{\
		\"min\": \"1\",\
		\"path\": \"ClaimResponse.item.detail.subDetail.adjudication.category\",\
		\"weight\": 1102,\
		\"max\": \"1\",\
		\"type\": \"Coding\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"ClaimResponse.item.detail.subDetail.adjudication.reason\",\
		\"weight\": 1103,\
		\"max\": \"1\",\
		\"type\": \"Coding\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"ClaimResponse.item.detail.subDetail.adjudication.amount\",\
		\"weight\": 1104,\
		\"max\": \"1\",\
		\"type\": \"Quantity\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"ClaimResponse.item.detail.subDetail.adjudication.value\",\
		\"weight\": 1105,\
		\"max\": \"1\",\
		\"type\": \"decimal\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"ClaimResponse.addItem\",\
		\"weight\": 1106,\
		\"max\": \"*\",\
		\"type\": \"BackboneElement\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"ClaimResponse.addItem.id\",\
		\"weight\": 1107,\
		\"max\": \"1\",\
		\"type\": \"id\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"ClaimResponse.addItem.extension\",\
		\"weight\": 1108,\
		\"max\": \"*\",\
		\"type\": \"Extension\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"ClaimResponse.addItem.modifierExtension\",\
		\"weight\": 1109,\
		\"max\": \"*\",\
		\"type\": \"Extension\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"ClaimResponse.addItem.sequenceLinkId\",\
		\"weight\": 1110,\
		\"max\": \"*\",\
		\"type\": \"positiveInt\"\
	},\
	{\
		\"min\": \"1\",\
		\"path\": \"ClaimResponse.addItem.service\",\
		\"weight\": 1111,\
		\"max\": \"1\",\
		\"type\": \"Coding\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"ClaimResponse.addItem.fee\",\
		\"weight\": 1112,\
		\"max\": \"1\",\
		\"type\": \"Quantity\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"ClaimResponse.addItem.noteNumberLinkId\",\
		\"weight\": 1113,\
		\"max\": \"*\",\
		\"type\": \"positiveInt\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"ClaimResponse.addItem.adjudication\",\
		\"weight\": 1114,\
		\"max\": \"*\",\
		\"type\": \"BackboneElement\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"ClaimResponse.addItem.adjudication.id\",\
		\"weight\": 1115,\
		\"max\": \"1\",\
		\"type\": \"id\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"ClaimResponse.addItem.adjudication.extension\",\
		\"weight\": 1116,\
		\"max\": \"*\",\
		\"type\": \"Extension\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"ClaimResponse.addItem.adjudication.modifierExtension\",\
		\"weight\": 1117,\
		\"max\": \"*\",\
		\"type\": \"Extension\"\
	},\
	{\
		\"min\": \"1\",\
		\"path\": \"ClaimResponse.addItem.adjudication.category\",\
		\"weight\": 1118,\
		\"max\": \"1\",\
		\"type\": \"Coding\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"ClaimResponse.addItem.adjudication.reason\",\
		\"weight\": 1119,\
		\"max\": \"1\",\
		\"type\": \"Coding\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"ClaimResponse.addItem.adjudication.amount\",\
		\"weight\": 1120,\
		\"max\": \"1\",\
		\"type\": \"Quantity\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"ClaimResponse.addItem.adjudication.value\",\
		\"weight\": 1121,\
		\"max\": \"1\",\
		\"type\": \"decimal\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"ClaimResponse.addItem.detail\",\
		\"weight\": 1122,\
		\"max\": \"*\",\
		\"type\": \"BackboneElement\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"ClaimResponse.addItem.detail.id\",\
		\"weight\": 1123,\
		\"max\": \"1\",\
		\"type\": \"id\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"ClaimResponse.addItem.detail.extension\",\
		\"weight\": 1124,\
		\"max\": \"*\",\
		\"type\": \"Extension\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"ClaimResponse.addItem.detail.modifierExtension\",\
		\"weight\": 1125,\
		\"max\": \"*\",\
		\"type\": \"Extension\"\
	},\
	{\
		\"min\": \"1\",\
		\"path\": \"ClaimResponse.addItem.detail.service\",\
		\"weight\": 1126,\
		\"max\": \"1\",\
		\"type\": \"Coding\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"ClaimResponse.addItem.detail.fee\",\
		\"weight\": 1127,\
		\"max\": \"1\",\
		\"type\": \"Quantity\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"ClaimResponse.addItem.detail.adjudication\",\
		\"weight\": 1128,\
		\"max\": \"*\",\
		\"type\": \"BackboneElement\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"ClaimResponse.addItem.detail.adjudication.id\",\
		\"weight\": 1129,\
		\"max\": \"1\",\
		\"type\": \"id\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"ClaimResponse.addItem.detail.adjudication.extension\",\
		\"weight\": 1130,\
		\"max\": \"*\",\
		\"type\": \"Extension\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"ClaimResponse.addItem.detail.adjudication.modifierExtension\",\
		\"weight\": 1131,\
		\"max\": \"*\",\
		\"type\": \"Extension\"\
	},\
	{\
		\"min\": \"1\",\
		\"path\": \"ClaimResponse.addItem.detail.adjudication.category\",\
		\"weight\": 1132,\
		\"max\": \"1\",\
		\"type\": \"Coding\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"ClaimResponse.addItem.detail.adjudication.reason\",\
		\"weight\": 1133,\
		\"max\": \"1\",\
		\"type\": \"Coding\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"ClaimResponse.addItem.detail.adjudication.amount\",\
		\"weight\": 1134,\
		\"max\": \"1\",\
		\"type\": \"Quantity\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"ClaimResponse.addItem.detail.adjudication.value\",\
		\"weight\": 1135,\
		\"max\": \"1\",\
		\"type\": \"decimal\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"ClaimResponse.error\",\
		\"weight\": 1136,\
		\"max\": \"*\",\
		\"type\": \"BackboneElement\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"ClaimResponse.error.id\",\
		\"weight\": 1137,\
		\"max\": \"1\",\
		\"type\": \"id\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"ClaimResponse.error.extension\",\
		\"weight\": 1138,\
		\"max\": \"*\",\
		\"type\": \"Extension\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"ClaimResponse.error.modifierExtension\",\
		\"weight\": 1139,\
		\"max\": \"*\",\
		\"type\": \"Extension\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"ClaimResponse.error.sequenceLinkId\",\
		\"weight\": 1140,\
		\"max\": \"1\",\
		\"type\": \"positiveInt\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"ClaimResponse.error.detailSequenceLinkId\",\
		\"weight\": 1141,\
		\"max\": \"1\",\
		\"type\": \"positiveInt\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"ClaimResponse.error.subdetailSequenceLinkId\",\
		\"weight\": 1142,\
		\"max\": \"1\",\
		\"type\": \"positiveInt\"\
	},\
	{\
		\"min\": \"1\",\
		\"path\": \"ClaimResponse.error.code\",\
		\"weight\": 1143,\
		\"max\": \"1\",\
		\"type\": \"Coding\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"ClaimResponse.totalCost\",\
		\"weight\": 1144,\
		\"max\": \"1\",\
		\"type\": \"Quantity\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"ClaimResponse.unallocDeductable\",\
		\"weight\": 1145,\
		\"max\": \"1\",\
		\"type\": \"Quantity\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"ClaimResponse.totalBenefit\",\
		\"weight\": 1146,\
		\"max\": \"1\",\
		\"type\": \"Quantity\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"ClaimResponse.paymentAdjustment\",\
		\"weight\": 1147,\
		\"max\": \"1\",\
		\"type\": \"Quantity\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"ClaimResponse.paymentAdjustmentReason\",\
		\"weight\": 1148,\
		\"max\": \"1\",\
		\"type\": \"Coding\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"ClaimResponse.paymentDate\",\
		\"weight\": 1149,\
		\"max\": \"1\",\
		\"type\": \"date\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"ClaimResponse.paymentAmount\",\
		\"weight\": 1150,\
		\"max\": \"1\",\
		\"type\": \"Quantity\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"ClaimResponse.paymentRef\",\
		\"weight\": 1151,\
		\"max\": \"1\",\
		\"type\": \"Identifier\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"ClaimResponse.reserved\",\
		\"weight\": 1152,\
		\"max\": \"1\",\
		\"type\": \"Coding\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"ClaimResponse.form\",\
		\"weight\": 1153,\
		\"max\": \"1\",\
		\"type\": \"Coding\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"ClaimResponse.note\",\
		\"weight\": 1154,\
		\"max\": \"*\",\
		\"type\": \"BackboneElement\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"ClaimResponse.note.id\",\
		\"weight\": 1155,\
		\"max\": \"1\",\
		\"type\": \"id\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"ClaimResponse.note.extension\",\
		\"weight\": 1156,\
		\"max\": \"*\",\
		\"type\": \"Extension\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"ClaimResponse.note.modifierExtension\",\
		\"weight\": 1157,\
		\"max\": \"*\",\
		\"type\": \"Extension\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"ClaimResponse.note.number\",\
		\"weight\": 1158,\
		\"max\": \"1\",\
		\"type\": \"positiveInt\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"ClaimResponse.note.type\",\
		\"weight\": 1159,\
		\"max\": \"1\",\
		\"type\": \"Coding\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"ClaimResponse.note.text\",\
		\"weight\": 1160,\
		\"max\": \"1\",\
		\"type\": \"string\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"ClaimResponse.coverage\",\
		\"weight\": 1161,\
		\"max\": \"*\",\
		\"type\": \"BackboneElement\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"ClaimResponse.coverage.id\",\
		\"weight\": 1162,\
		\"max\": \"1\",\
		\"type\": \"id\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"ClaimResponse.coverage.extension\",\
		\"weight\": 1163,\
		\"max\": \"*\",\
		\"type\": \"Extension\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"ClaimResponse.coverage.modifierExtension\",\
		\"weight\": 1164,\
		\"max\": \"*\",\
		\"type\": \"Extension\"\
	},\
	{\
		\"min\": \"1\",\
		\"path\": \"ClaimResponse.coverage.sequence\",\
		\"weight\": 1165,\
		\"max\": \"1\",\
		\"type\": \"positiveInt\"\
	},\
	{\
		\"min\": \"1\",\
		\"path\": \"ClaimResponse.coverage.focal\",\
		\"weight\": 1166,\
		\"max\": \"1\",\
		\"type\": \"boolean\"\
	},\
	{\
		\"min\": \"1\",\
		\"path\": \"ClaimResponse.coverage.coverageIdentifier\",\
		\"weight\": 1167,\
		\"max\": \"1\",\
		\"type\": \"Identifier\"\
	},\
	{\
		\"min\": \"1\",\
		\"path\": \"ClaimResponse.coverage.coverageReference\",\
		\"weight\": 1167,\
		\"max\": \"1\",\
		\"type\": \"Reference\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"ClaimResponse.coverage.businessArrangement\",\
		\"weight\": 1168,\
		\"max\": \"1\",\
		\"type\": \"string\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"ClaimResponse.coverage.preAuthRef\",\
		\"weight\": 1169,\
		\"max\": \"*\",\
		\"type\": \"string\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"ClaimResponse.coverage.claimResponse\",\
		\"weight\": 1170,\
		\"max\": \"1\",\
		\"type\": \"Reference\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"ClinicalImpression\",\
		\"weight\": 1171,\
		\"max\": \"*\",\
		\"type\": \"DomainResource\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"ClinicalImpression.id\",\
		\"weight\": 1172,\
		\"max\": \"1\",\
		\"type\": \"id\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"ClinicalImpression.meta\",\
		\"weight\": 1173,\
		\"max\": \"1\",\
		\"type\": \"Meta\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"ClinicalImpression.implicitRules\",\
		\"weight\": 1174,\
		\"max\": \"1\",\
		\"type\": \"uri\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"ClinicalImpression.language\",\
		\"weight\": 1175,\
		\"max\": \"1\",\
		\"type\": \"code\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"ClinicalImpression.text\",\
		\"weight\": 1176,\
		\"max\": \"1\",\
		\"type\": \"Narrative\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"ClinicalImpression.contained\",\
		\"weight\": 1177,\
		\"max\": \"*\",\
		\"type\": \"Resource\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"ClinicalImpression.extension\",\
		\"weight\": 1178,\
		\"max\": \"*\",\
		\"type\": \"Extension\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"ClinicalImpression.modifierExtension\",\
		\"weight\": 1179,\
		\"max\": \"*\",\
		\"type\": \"Extension\"\
	},\
	{\
		\"min\": \"1\",\
		\"path\": \"ClinicalImpression.patient\",\
		\"weight\": 1180,\
		\"max\": \"1\",\
		\"type\": \"Reference\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"ClinicalImpression.assessor\",\
		\"weight\": 1181,\
		\"max\": \"1\",\
		\"type\": \"Reference\"\
	},\
	{\
		\"min\": \"1\",\
		\"path\": \"ClinicalImpression.status\",\
		\"weight\": 1182,\
		\"max\": \"1\",\
		\"type\": \"code\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"ClinicalImpression.date\",\
		\"weight\": 1183,\
		\"max\": \"1\",\
		\"type\": \"dateTime\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"ClinicalImpression.description\",\
		\"weight\": 1184,\
		\"max\": \"1\",\
		\"type\": \"string\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"ClinicalImpression.previous\",\
		\"weight\": 1185,\
		\"max\": \"1\",\
		\"type\": \"Reference\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"ClinicalImpression.problem\",\
		\"weight\": 1186,\
		\"max\": \"*\",\
		\"type\": \"Reference\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"ClinicalImpression.triggerCodeableConcept\",\
		\"weight\": 1187,\
		\"max\": \"1\",\
		\"type\": \"CodeableConcept\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"ClinicalImpression.triggerReference\",\
		\"weight\": 1187,\
		\"max\": \"1\",\
		\"type\": \"Reference\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"ClinicalImpression.investigations\",\
		\"weight\": 1188,\
		\"max\": \"*\",\
		\"type\": \"BackboneElement\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"ClinicalImpression.investigations.id\",\
		\"weight\": 1189,\
		\"max\": \"1\",\
		\"type\": \"id\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"ClinicalImpression.investigations.extension\",\
		\"weight\": 1190,\
		\"max\": \"*\",\
		\"type\": \"Extension\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"ClinicalImpression.investigations.modifierExtension\",\
		\"weight\": 1191,\
		\"max\": \"*\",\
		\"type\": \"Extension\"\
	},\
	{\
		\"min\": \"1\",\
		\"path\": \"ClinicalImpression.investigations.code\",\
		\"weight\": 1192,\
		\"max\": \"1\",\
		\"type\": \"CodeableConcept\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"ClinicalImpression.investigations.item\",\
		\"weight\": 1193,\
		\"max\": \"*\",\
		\"type\": \"Reference\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"ClinicalImpression.protocol\",\
		\"weight\": 1194,\
		\"max\": \"1\",\
		\"type\": \"uri\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"ClinicalImpression.summary\",\
		\"weight\": 1195,\
		\"max\": \"1\",\
		\"type\": \"string\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"ClinicalImpression.finding\",\
		\"weight\": 1196,\
		\"max\": \"*\",\
		\"type\": \"BackboneElement\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"ClinicalImpression.finding.id\",\
		\"weight\": 1197,\
		\"max\": \"1\",\
		\"type\": \"id\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"ClinicalImpression.finding.extension\",\
		\"weight\": 1198,\
		\"max\": \"*\",\
		\"type\": \"Extension\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"ClinicalImpression.finding.modifierExtension\",\
		\"weight\": 1199,\
		\"max\": \"*\",\
		\"type\": \"Extension\"\
	},\
	{\
		\"min\": \"1\",\
		\"path\": \"ClinicalImpression.finding.item\",\
		\"weight\": 1200,\
		\"max\": \"1\",\
		\"type\": \"CodeableConcept\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"ClinicalImpression.finding.cause\",\
		\"weight\": 1201,\
		\"max\": \"1\",\
		\"type\": \"string\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"ClinicalImpression.resolved\",\
		\"weight\": 1202,\
		\"max\": \"*\",\
		\"type\": \"CodeableConcept\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"ClinicalImpression.ruledOut\",\
		\"weight\": 1203,\
		\"max\": \"*\",\
		\"type\": \"BackboneElement\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"ClinicalImpression.ruledOut.id\",\
		\"weight\": 1204,\
		\"max\": \"1\",\
		\"type\": \"id\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"ClinicalImpression.ruledOut.extension\",\
		\"weight\": 1205,\
		\"max\": \"*\",\
		\"type\": \"Extension\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"ClinicalImpression.ruledOut.modifierExtension\",\
		\"weight\": 1206,\
		\"max\": \"*\",\
		\"type\": \"Extension\"\
	},\
	{\
		\"min\": \"1\",\
		\"path\": \"ClinicalImpression.ruledOut.item\",\
		\"weight\": 1207,\
		\"max\": \"1\",\
		\"type\": \"CodeableConcept\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"ClinicalImpression.ruledOut.reason\",\
		\"weight\": 1208,\
		\"max\": \"1\",\
		\"type\": \"string\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"ClinicalImpression.prognosis\",\
		\"weight\": 1209,\
		\"max\": \"1\",\
		\"type\": \"string\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"ClinicalImpression.plan\",\
		\"weight\": 1210,\
		\"max\": \"*\",\
		\"type\": \"Reference\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"ClinicalImpression.action\",\
		\"weight\": 1211,\
		\"max\": \"*\",\
		\"type\": \"Reference\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Communication\",\
		\"weight\": 1212,\
		\"max\": \"*\",\
		\"type\": \"DomainResource\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Communication.id\",\
		\"weight\": 1213,\
		\"max\": \"1\",\
		\"type\": \"id\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Communication.meta\",\
		\"weight\": 1214,\
		\"max\": \"1\",\
		\"type\": \"Meta\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Communication.implicitRules\",\
		\"weight\": 1215,\
		\"max\": \"1\",\
		\"type\": \"uri\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Communication.language\",\
		\"weight\": 1216,\
		\"max\": \"1\",\
		\"type\": \"code\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Communication.text\",\
		\"weight\": 1217,\
		\"max\": \"1\",\
		\"type\": \"Narrative\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Communication.contained\",\
		\"weight\": 1218,\
		\"max\": \"*\",\
		\"type\": \"Resource\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Communication.extension\",\
		\"weight\": 1219,\
		\"max\": \"*\",\
		\"type\": \"Extension\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Communication.modifierExtension\",\
		\"weight\": 1220,\
		\"max\": \"*\",\
		\"type\": \"Extension\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Communication.identifier\",\
		\"weight\": 1221,\
		\"max\": \"*\",\
		\"type\": \"Identifier\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Communication.category\",\
		\"weight\": 1222,\
		\"max\": \"1\",\
		\"type\": \"CodeableConcept\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Communication.sender\",\
		\"weight\": 1223,\
		\"max\": \"1\",\
		\"type\": \"Reference\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Communication.recipient\",\
		\"weight\": 1224,\
		\"max\": \"*\",\
		\"type\": \"Reference\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Communication.payload\",\
		\"weight\": 1225,\
		\"max\": \"*\",\
		\"type\": \"BackboneElement\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Communication.payload.id\",\
		\"weight\": 1226,\
		\"max\": \"1\",\
		\"type\": \"id\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Communication.payload.extension\",\
		\"weight\": 1227,\
		\"max\": \"*\",\
		\"type\": \"Extension\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Communication.payload.modifierExtension\",\
		\"weight\": 1228,\
		\"max\": \"*\",\
		\"type\": \"Extension\"\
	},\
	{\
		\"min\": \"1\",\
		\"path\": \"Communication.payload.contentString\",\
		\"weight\": 1229,\
		\"max\": \"1\",\
		\"type\": \"string\"\
	},\
	{\
		\"min\": \"1\",\
		\"path\": \"Communication.payload.contentAttachment\",\
		\"weight\": 1229,\
		\"max\": \"1\",\
		\"type\": \"Attachment\"\
	},\
	{\
		\"min\": \"1\",\
		\"path\": \"Communication.payload.contentReference\",\
		\"weight\": 1229,\
		\"max\": \"1\",\
		\"type\": \"Reference\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Communication.medium\",\
		\"weight\": 1230,\
		\"max\": \"*\",\
		\"type\": \"CodeableConcept\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Communication.status\",\
		\"weight\": 1231,\
		\"max\": \"1\",\
		\"type\": \"code\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Communication.encounter\",\
		\"weight\": 1232,\
		\"max\": \"1\",\
		\"type\": \"Reference\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Communication.sent\",\
		\"weight\": 1233,\
		\"max\": \"1\",\
		\"type\": \"dateTime\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Communication.received\",\
		\"weight\": 1234,\
		\"max\": \"1\",\
		\"type\": \"dateTime\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Communication.reason\",\
		\"weight\": 1235,\
		\"max\": \"*\",\
		\"type\": \"CodeableConcept\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Communication.subject\",\
		\"weight\": 1236,\
		\"max\": \"1\",\
		\"type\": \"Reference\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Communication.requestDetail\",\
		\"weight\": 1237,\
		\"max\": \"1\",\
		\"type\": \"Reference\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"CommunicationRequest\",\
		\"weight\": 1238,\
		\"max\": \"*\",\
		\"type\": \"DomainResource\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"CommunicationRequest.id\",\
		\"weight\": 1239,\
		\"max\": \"1\",\
		\"type\": \"id\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"CommunicationRequest.meta\",\
		\"weight\": 1240,\
		\"max\": \"1\",\
		\"type\": \"Meta\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"CommunicationRequest.implicitRules\",\
		\"weight\": 1241,\
		\"max\": \"1\",\
		\"type\": \"uri\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"CommunicationRequest.language\",\
		\"weight\": 1242,\
		\"max\": \"1\",\
		\"type\": \"code\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"CommunicationRequest.text\",\
		\"weight\": 1243,\
		\"max\": \"1\",\
		\"type\": \"Narrative\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"CommunicationRequest.contained\",\
		\"weight\": 1244,\
		\"max\": \"*\",\
		\"type\": \"Resource\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"CommunicationRequest.extension\",\
		\"weight\": 1245,\
		\"max\": \"*\",\
		\"type\": \"Extension\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"CommunicationRequest.modifierExtension\",\
		\"weight\": 1246,\
		\"max\": \"*\",\
		\"type\": \"Extension\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"CommunicationRequest.identifier\",\
		\"weight\": 1247,\
		\"max\": \"*\",\
		\"type\": \"Identifier\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"CommunicationRequest.category\",\
		\"weight\": 1248,\
		\"max\": \"1\",\
		\"type\": \"CodeableConcept\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"CommunicationRequest.sender\",\
		\"weight\": 1249,\
		\"max\": \"1\",\
		\"type\": \"Reference\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"CommunicationRequest.recipient\",\
		\"weight\": 1250,\
		\"max\": \"*\",\
		\"type\": \"Reference\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"CommunicationRequest.payload\",\
		\"weight\": 1251,\
		\"max\": \"*\",\
		\"type\": \"BackboneElement\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"CommunicationRequest.payload.id\",\
		\"weight\": 1252,\
		\"max\": \"1\",\
		\"type\": \"id\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"CommunicationRequest.payload.extension\",\
		\"weight\": 1253,\
		\"max\": \"*\",\
		\"type\": \"Extension\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"CommunicationRequest.payload.modifierExtension\",\
		\"weight\": 1254,\
		\"max\": \"*\",\
		\"type\": \"Extension\"\
	},\
	{\
		\"min\": \"1\",\
		\"path\": \"CommunicationRequest.payload.contentString\",\
		\"weight\": 1255,\
		\"max\": \"1\",\
		\"type\": \"string\"\
	},\
	{\
		\"min\": \"1\",\
		\"path\": \"CommunicationRequest.payload.contentAttachment\",\
		\"weight\": 1255,\
		\"max\": \"1\",\
		\"type\": \"Attachment\"\
	},\
	{\
		\"min\": \"1\",\
		\"path\": \"CommunicationRequest.payload.contentReference\",\
		\"weight\": 1255,\
		\"max\": \"1\",\
		\"type\": \"Reference\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"CommunicationRequest.medium\",\
		\"weight\": 1256,\
		\"max\": \"*\",\
		\"type\": \"CodeableConcept\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"CommunicationRequest.requester\",\
		\"weight\": 1257,\
		\"max\": \"1\",\
		\"type\": \"Reference\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"CommunicationRequest.status\",\
		\"weight\": 1258,\
		\"max\": \"1\",\
		\"type\": \"code\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"CommunicationRequest.encounter\",\
		\"weight\": 1259,\
		\"max\": \"1\",\
		\"type\": \"Reference\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"CommunicationRequest.scheduledDateTime\",\
		\"weight\": 1260,\
		\"max\": \"1\",\
		\"type\": \"dateTime\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"CommunicationRequest.scheduledPeriod\",\
		\"weight\": 1260,\
		\"max\": \"1\",\
		\"type\": \"Period\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"CommunicationRequest.reason\",\
		\"weight\": 1261,\
		\"max\": \"*\",\
		\"type\": \"CodeableConcept\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"CommunicationRequest.requestedOn\",\
		\"weight\": 1262,\
		\"max\": \"1\",\
		\"type\": \"dateTime\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"CommunicationRequest.subject\",\
		\"weight\": 1263,\
		\"max\": \"1\",\
		\"type\": \"Reference\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"CommunicationRequest.priority\",\
		\"weight\": 1264,\
		\"max\": \"1\",\
		\"type\": \"CodeableConcept\"\
	},\
	{\
		\"min\": \"1\",\
		\"path\": \"CompartmentDefinition\",\
		\"weight\": 1265,\
		\"max\": \"1\",\
		\"type\": \"DomainResource\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"CompartmentDefinition.id\",\
		\"weight\": 1266,\
		\"max\": \"1\",\
		\"type\": \"id\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"CompartmentDefinition.meta\",\
		\"weight\": 1267,\
		\"max\": \"1\",\
		\"type\": \"Meta\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"CompartmentDefinition.implicitRules\",\
		\"weight\": 1268,\
		\"max\": \"1\",\
		\"type\": \"uri\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"CompartmentDefinition.language\",\
		\"weight\": 1269,\
		\"max\": \"1\",\
		\"type\": \"code\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"CompartmentDefinition.text\",\
		\"weight\": 1270,\
		\"max\": \"1\",\
		\"type\": \"Narrative\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"CompartmentDefinition.contained\",\
		\"weight\": 1271,\
		\"max\": \"*\",\
		\"type\": \"Resource\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"CompartmentDefinition.extension\",\
		\"weight\": 1272,\
		\"max\": \"*\",\
		\"type\": \"Extension\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"CompartmentDefinition.modifierExtension\",\
		\"weight\": 1273,\
		\"max\": \"*\",\
		\"type\": \"Extension\"\
	},\
	{\
		\"min\": \"1\",\
		\"path\": \"CompartmentDefinition.url\",\
		\"weight\": 1274,\
		\"max\": \"1\",\
		\"type\": \"uri\"\
	},\
	{\
		\"min\": \"1\",\
		\"path\": \"CompartmentDefinition.name\",\
		\"weight\": 1275,\
		\"max\": \"1\",\
		\"type\": \"string\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"CompartmentDefinition.status\",\
		\"weight\": 1276,\
		\"max\": \"1\",\
		\"type\": \"code\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"CompartmentDefinition.experimental\",\
		\"weight\": 1277,\
		\"max\": \"1\",\
		\"type\": \"boolean\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"CompartmentDefinition.publisher\",\
		\"weight\": 1278,\
		\"max\": \"1\",\
		\"type\": \"string\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"CompartmentDefinition.contact\",\
		\"weight\": 1279,\
		\"max\": \"*\",\
		\"type\": \"BackboneElement\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"CompartmentDefinition.contact.id\",\
		\"weight\": 1280,\
		\"max\": \"1\",\
		\"type\": \"id\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"CompartmentDefinition.contact.extension\",\
		\"weight\": 1281,\
		\"max\": \"*\",\
		\"type\": \"Extension\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"CompartmentDefinition.contact.modifierExtension\",\
		\"weight\": 1282,\
		\"max\": \"*\",\
		\"type\": \"Extension\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"CompartmentDefinition.contact.name\",\
		\"weight\": 1283,\
		\"max\": \"1\",\
		\"type\": \"string\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"CompartmentDefinition.contact.telecom\",\
		\"weight\": 1284,\
		\"max\": \"*\",\
		\"type\": \"ContactPoint\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"CompartmentDefinition.date\",\
		\"weight\": 1285,\
		\"max\": \"1\",\
		\"type\": \"dateTime\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"CompartmentDefinition.description\",\
		\"weight\": 1286,\
		\"max\": \"1\",\
		\"type\": \"string\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"CompartmentDefinition.requirements\",\
		\"weight\": 1287,\
		\"max\": \"1\",\
		\"type\": \"string\"\
	},\
	{\
		\"min\": \"1\",\
		\"path\": \"CompartmentDefinition.code\",\
		\"weight\": 1288,\
		\"max\": \"1\",\
		\"type\": \"code\"\
	},\
	{\
		\"min\": \"1\",\
		\"path\": \"CompartmentDefinition.search\",\
		\"weight\": 1289,\
		\"max\": \"1\",\
		\"type\": \"boolean\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"CompartmentDefinition.resource\",\
		\"weight\": 1290,\
		\"max\": \"*\",\
		\"type\": \"BackboneElement\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"CompartmentDefinition.resource.id\",\
		\"weight\": 1291,\
		\"max\": \"1\",\
		\"type\": \"id\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"CompartmentDefinition.resource.extension\",\
		\"weight\": 1292,\
		\"max\": \"*\",\
		\"type\": \"Extension\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"CompartmentDefinition.resource.modifierExtension\",\
		\"weight\": 1293,\
		\"max\": \"*\",\
		\"type\": \"Extension\"\
	},\
	{\
		\"min\": \"1\",\
		\"path\": \"CompartmentDefinition.resource.code\",\
		\"weight\": 1294,\
		\"max\": \"1\",\
		\"type\": \"code\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"CompartmentDefinition.resource.param\",\
		\"weight\": 1295,\
		\"max\": \"*\",\
		\"type\": \"string\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"CompartmentDefinition.resource.documentation\",\
		\"weight\": 1296,\
		\"max\": \"1\",\
		\"type\": \"string\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Composition\",\
		\"weight\": 1297,\
		\"max\": \"*\",\
		\"type\": \"DomainResource\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Composition.id\",\
		\"weight\": 1298,\
		\"max\": \"1\",\
		\"type\": \"id\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Composition.meta\",\
		\"weight\": 1299,\
		\"max\": \"1\",\
		\"type\": \"Meta\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Composition.implicitRules\",\
		\"weight\": 1300,\
		\"max\": \"1\",\
		\"type\": \"uri\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Composition.language\",\
		\"weight\": 1301,\
		\"max\": \"1\",\
		\"type\": \"code\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Composition.text\",\
		\"weight\": 1302,\
		\"max\": \"1\",\
		\"type\": \"Narrative\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Composition.contained\",\
		\"weight\": 1303,\
		\"max\": \"*\",\
		\"type\": \"Resource\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Composition.extension\",\
		\"weight\": 1304,\
		\"max\": \"*\",\
		\"type\": \"Extension\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Composition.modifierExtension\",\
		\"weight\": 1305,\
		\"max\": \"*\",\
		\"type\": \"Extension\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Composition.identifier\",\
		\"weight\": 1306,\
		\"max\": \"1\",\
		\"type\": \"Identifier\"\
	},\
	{\
		\"min\": \"1\",\
		\"path\": \"Composition.date\",\
		\"weight\": 1307,\
		\"max\": \"1\",\
		\"type\": \"dateTime\"\
	},\
	{\
		\"min\": \"1\",\
		\"path\": \"Composition.type\",\
		\"weight\": 1308,\
		\"max\": \"1\",\
		\"type\": \"CodeableConcept\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Composition.class\",\
		\"weight\": 1309,\
		\"max\": \"1\",\
		\"type\": \"CodeableConcept\"\
	},\
	{\
		\"min\": \"1\",\
		\"path\": \"Composition.title\",\
		\"weight\": 1310,\
		\"max\": \"1\",\
		\"type\": \"string\"\
	},\
	{\
		\"min\": \"1\",\
		\"path\": \"Composition.status\",\
		\"weight\": 1311,\
		\"max\": \"1\",\
		\"type\": \"code\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Composition.confidentiality\",\
		\"weight\": 1312,\
		\"max\": \"1\",\
		\"type\": \"code\"\
	},\
	{\
		\"min\": \"1\",\
		\"path\": \"Composition.subject\",\
		\"weight\": 1313,\
		\"max\": \"1\",\
		\"type\": \"Reference\"\
	},\
	{\
		\"min\": \"1\",\
		\"path\": \"Composition.author\",\
		\"weight\": 1314,\
		\"max\": \"*\",\
		\"type\": \"Reference\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Composition.attester\",\
		\"weight\": 1315,\
		\"max\": \"*\",\
		\"type\": \"BackboneElement\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Composition.attester.id\",\
		\"weight\": 1316,\
		\"max\": \"1\",\
		\"type\": \"id\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Composition.attester.extension\",\
		\"weight\": 1317,\
		\"max\": \"*\",\
		\"type\": \"Extension\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Composition.attester.modifierExtension\",\
		\"weight\": 1318,\
		\"max\": \"*\",\
		\"type\": \"Extension\"\
	},\
	{\
		\"min\": \"1\",\
		\"path\": \"Composition.attester.mode\",\
		\"weight\": 1319,\
		\"max\": \"*\",\
		\"type\": \"code\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Composition.attester.time\",\
		\"weight\": 1320,\
		\"max\": \"1\",\
		\"type\": \"dateTime\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Composition.attester.party\",\
		\"weight\": 1321,\
		\"max\": \"1\",\
		\"type\": \"Reference\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Composition.custodian\",\
		\"weight\": 1322,\
		\"max\": \"1\",\
		\"type\": \"Reference\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Composition.event\",\
		\"weight\": 1323,\
		\"max\": \"*\",\
		\"type\": \"BackboneElement\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Composition.event.id\",\
		\"weight\": 1324,\
		\"max\": \"1\",\
		\"type\": \"id\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Composition.event.extension\",\
		\"weight\": 1325,\
		\"max\": \"*\",\
		\"type\": \"Extension\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Composition.event.modifierExtension\",\
		\"weight\": 1326,\
		\"max\": \"*\",\
		\"type\": \"Extension\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Composition.event.code\",\
		\"weight\": 1327,\
		\"max\": \"*\",\
		\"type\": \"CodeableConcept\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Composition.event.period\",\
		\"weight\": 1328,\
		\"max\": \"1\",\
		\"type\": \"Period\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Composition.event.detail\",\
		\"weight\": 1329,\
		\"max\": \"*\",\
		\"type\": \"Reference\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Composition.encounter\",\
		\"weight\": 1330,\
		\"max\": \"1\",\
		\"type\": \"Reference\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Composition.section\",\
		\"weight\": 1331,\
		\"max\": \"*\",\
		\"type\": \"BackboneElement\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Composition.section.id\",\
		\"weight\": 1332,\
		\"max\": \"1\",\
		\"type\": \"id\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Composition.section.extension\",\
		\"weight\": 1333,\
		\"max\": \"*\",\
		\"type\": \"Extension\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Composition.section.modifierExtension\",\
		\"weight\": 1334,\
		\"max\": \"*\",\
		\"type\": \"Extension\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Composition.section.title\",\
		\"weight\": 1335,\
		\"max\": \"1\",\
		\"type\": \"string\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Composition.section.code\",\
		\"weight\": 1336,\
		\"max\": \"1\",\
		\"type\": \"CodeableConcept\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Composition.section.text\",\
		\"weight\": 1337,\
		\"max\": \"1\",\
		\"type\": \"Narrative\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Composition.section.mode\",\
		\"weight\": 1338,\
		\"max\": \"1\",\
		\"type\": \"code\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Composition.section.orderedBy\",\
		\"weight\": 1339,\
		\"max\": \"1\",\
		\"type\": \"CodeableConcept\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Composition.section.entry\",\
		\"weight\": 1340,\
		\"max\": \"*\",\
		\"type\": \"Reference\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Composition.section.emptyReason\",\
		\"weight\": 1341,\
		\"max\": \"1\",\
		\"type\": \"CodeableConcept\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Composition.section.section\",\
		\"weight\": 1342,\
		\"max\": \"*\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"ConceptMap\",\
		\"weight\": 1343,\
		\"max\": \"*\",\
		\"type\": \"DomainResource\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"ConceptMap.id\",\
		\"weight\": 1344,\
		\"max\": \"1\",\
		\"type\": \"id\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"ConceptMap.meta\",\
		\"weight\": 1345,\
		\"max\": \"1\",\
		\"type\": \"Meta\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"ConceptMap.implicitRules\",\
		\"weight\": 1346,\
		\"max\": \"1\",\
		\"type\": \"uri\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"ConceptMap.language\",\
		\"weight\": 1347,\
		\"max\": \"1\",\
		\"type\": \"code\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"ConceptMap.text\",\
		\"weight\": 1348,\
		\"max\": \"1\",\
		\"type\": \"Narrative\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"ConceptMap.contained\",\
		\"weight\": 1349,\
		\"max\": \"*\",\
		\"type\": \"Resource\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"ConceptMap.extension\",\
		\"weight\": 1350,\
		\"max\": \"*\",\
		\"type\": \"Extension\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"ConceptMap.modifierExtension\",\
		\"weight\": 1351,\
		\"max\": \"*\",\
		\"type\": \"Extension\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"ConceptMap.url\",\
		\"weight\": 1352,\
		\"max\": \"1\",\
		\"type\": \"uri\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"ConceptMap.identifier\",\
		\"weight\": 1353,\
		\"max\": \"1\",\
		\"type\": \"Identifier\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"ConceptMap.version\",\
		\"weight\": 1354,\
		\"max\": \"1\",\
		\"type\": \"string\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"ConceptMap.name\",\
		\"weight\": 1355,\
		\"max\": \"1\",\
		\"type\": \"string\"\
	},\
	{\
		\"min\": \"1\",\
		\"path\": \"ConceptMap.status\",\
		\"weight\": 1356,\
		\"max\": \"1\",\
		\"type\": \"code\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"ConceptMap.experimental\",\
		\"weight\": 1357,\
		\"max\": \"1\",\
		\"type\": \"boolean\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"ConceptMap.publisher\",\
		\"weight\": 1358,\
		\"max\": \"1\",\
		\"type\": \"string\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"ConceptMap.contact\",\
		\"weight\": 1359,\
		\"max\": \"*\",\
		\"type\": \"BackboneElement\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"ConceptMap.contact.id\",\
		\"weight\": 1360,\
		\"max\": \"1\",\
		\"type\": \"id\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"ConceptMap.contact.extension\",\
		\"weight\": 1361,\
		\"max\": \"*\",\
		\"type\": \"Extension\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"ConceptMap.contact.modifierExtension\",\
		\"weight\": 1362,\
		\"max\": \"*\",\
		\"type\": \"Extension\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"ConceptMap.contact.name\",\
		\"weight\": 1363,\
		\"max\": \"1\",\
		\"type\": \"string\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"ConceptMap.contact.telecom\",\
		\"weight\": 1364,\
		\"max\": \"*\",\
		\"type\": \"ContactPoint\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"ConceptMap.date\",\
		\"weight\": 1365,\
		\"max\": \"1\",\
		\"type\": \"dateTime\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"ConceptMap.description\",\
		\"weight\": 1366,\
		\"max\": \"1\",\
		\"type\": \"string\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"ConceptMap.useContext\",\
		\"weight\": 1367,\
		\"max\": \"*\",\
		\"type\": \"CodeableConcept\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"ConceptMap.requirements\",\
		\"weight\": 1368,\
		\"max\": \"1\",\
		\"type\": \"string\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"ConceptMap.copyright\",\
		\"weight\": 1369,\
		\"max\": \"1\",\
		\"type\": \"string\"\
	},\
	{\
		\"min\": \"1\",\
		\"path\": \"ConceptMap.sourceUri\",\
		\"weight\": 1370,\
		\"max\": \"1\",\
		\"type\": \"uri\"\
	},\
	{\
		\"min\": \"1\",\
		\"path\": \"ConceptMap.sourceReference\",\
		\"weight\": 1370,\
		\"max\": \"1\",\
		\"type\": \"Reference\"\
	},\
	{\
		\"min\": \"1\",\
		\"path\": \"ConceptMap.sourceReference\",\
		\"weight\": 1370,\
		\"max\": \"1\",\
		\"type\": \"Reference\"\
	},\
	{\
		\"min\": \"1\",\
		\"path\": \"ConceptMap.targetUri\",\
		\"weight\": 1371,\
		\"max\": \"1\",\
		\"type\": \"uri\"\
	},\
	{\
		\"min\": \"1\",\
		\"path\": \"ConceptMap.targetReference\",\
		\"weight\": 1371,\
		\"max\": \"1\",\
		\"type\": \"Reference\"\
	},\
	{\
		\"min\": \"1\",\
		\"path\": \"ConceptMap.targetReference\",\
		\"weight\": 1371,\
		\"max\": \"1\",\
		\"type\": \"Reference\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"ConceptMap.element\",\
		\"weight\": 1372,\
		\"max\": \"*\",\
		\"type\": \"BackboneElement\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"ConceptMap.element.id\",\
		\"weight\": 1373,\
		\"max\": \"1\",\
		\"type\": \"id\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"ConceptMap.element.extension\",\
		\"weight\": 1374,\
		\"max\": \"*\",\
		\"type\": \"Extension\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"ConceptMap.element.modifierExtension\",\
		\"weight\": 1375,\
		\"max\": \"*\",\
		\"type\": \"Extension\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"ConceptMap.element.system\",\
		\"weight\": 1376,\
		\"max\": \"1\",\
		\"type\": \"uri\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"ConceptMap.element.version\",\
		\"weight\": 1377,\
		\"max\": \"1\",\
		\"type\": \"string\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"ConceptMap.element.code\",\
		\"weight\": 1378,\
		\"max\": \"1\",\
		\"type\": \"code\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"ConceptMap.element.target\",\
		\"weight\": 1379,\
		\"max\": \"*\",\
		\"type\": \"BackboneElement\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"ConceptMap.element.target.id\",\
		\"weight\": 1380,\
		\"max\": \"1\",\
		\"type\": \"id\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"ConceptMap.element.target.extension\",\
		\"weight\": 1381,\
		\"max\": \"*\",\
		\"type\": \"Extension\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"ConceptMap.element.target.modifierExtension\",\
		\"weight\": 1382,\
		\"max\": \"*\",\
		\"type\": \"Extension\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"ConceptMap.element.target.system\",\
		\"weight\": 1383,\
		\"max\": \"1\",\
		\"type\": \"uri\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"ConceptMap.element.target.version\",\
		\"weight\": 1384,\
		\"max\": \"1\",\
		\"type\": \"string\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"ConceptMap.element.target.code\",\
		\"weight\": 1385,\
		\"max\": \"1\",\
		\"type\": \"code\"\
	},\
	{\
		\"min\": \"1\",\
		\"path\": \"ConceptMap.element.target.equivalence\",\
		\"weight\": 1386,\
		\"max\": \"1\",\
		\"type\": \"code\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"ConceptMap.element.target.comments\",\
		\"weight\": 1387,\
		\"max\": \"1\",\
		\"type\": \"string\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"ConceptMap.element.target.dependsOn\",\
		\"weight\": 1388,\
		\"max\": \"*\",\
		\"type\": \"BackboneElement\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"ConceptMap.element.target.dependsOn.id\",\
		\"weight\": 1389,\
		\"max\": \"1\",\
		\"type\": \"id\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"ConceptMap.element.target.dependsOn.extension\",\
		\"weight\": 1390,\
		\"max\": \"*\",\
		\"type\": \"Extension\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"ConceptMap.element.target.dependsOn.modifierExtension\",\
		\"weight\": 1391,\
		\"max\": \"*\",\
		\"type\": \"Extension\"\
	},\
	{\
		\"min\": \"1\",\
		\"path\": \"ConceptMap.element.target.dependsOn.element\",\
		\"weight\": 1392,\
		\"max\": \"1\",\
		\"type\": \"uri\"\
	},\
	{\
		\"min\": \"1\",\
		\"path\": \"ConceptMap.element.target.dependsOn.system\",\
		\"weight\": 1393,\
		\"max\": \"1\",\
		\"type\": \"uri\"\
	},\
	{\
		\"min\": \"1\",\
		\"path\": \"ConceptMap.element.target.dependsOn.code\",\
		\"weight\": 1394,\
		\"max\": \"1\",\
		\"type\": \"string\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"ConceptMap.element.target.product\",\
		\"weight\": 1395,\
		\"max\": \"*\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Condition\",\
		\"weight\": 1396,\
		\"max\": \"*\",\
		\"type\": \"DomainResource\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Condition.id\",\
		\"weight\": 1397,\
		\"max\": \"1\",\
		\"type\": \"id\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Condition.meta\",\
		\"weight\": 1398,\
		\"max\": \"1\",\
		\"type\": \"Meta\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Condition.implicitRules\",\
		\"weight\": 1399,\
		\"max\": \"1\",\
		\"type\": \"uri\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Condition.language\",\
		\"weight\": 1400,\
		\"max\": \"1\",\
		\"type\": \"code\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Condition.text\",\
		\"weight\": 1401,\
		\"max\": \"1\",\
		\"type\": \"Narrative\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Condition.contained\",\
		\"weight\": 1402,\
		\"max\": \"*\",\
		\"type\": \"Resource\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Condition.extension\",\
		\"weight\": 1403,\
		\"max\": \"*\",\
		\"type\": \"Extension\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Condition.modifierExtension\",\
		\"weight\": 1404,\
		\"max\": \"*\",\
		\"type\": \"Extension\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Condition.identifier\",\
		\"weight\": 1405,\
		\"max\": \"*\",\
		\"type\": \"Identifier\"\
	},\
	{\
		\"min\": \"1\",\
		\"path\": \"Condition.patient\",\
		\"weight\": 1406,\
		\"max\": \"1\",\
		\"type\": \"Reference\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Condition.encounter\",\
		\"weight\": 1407,\
		\"max\": \"1\",\
		\"type\": \"Reference\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Condition.asserter\",\
		\"weight\": 1408,\
		\"max\": \"1\",\
		\"type\": \"Reference\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Condition.dateRecorded\",\
		\"weight\": 1409,\
		\"max\": \"1\",\
		\"type\": \"date\"\
	},\
	{\
		\"min\": \"1\",\
		\"path\": \"Condition.code\",\
		\"weight\": 1410,\
		\"max\": \"1\",\
		\"type\": \"CodeableConcept\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Condition.category\",\
		\"weight\": 1411,\
		\"max\": \"1\",\
		\"type\": \"CodeableConcept\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Condition.clinicalStatus\",\
		\"weight\": 1412,\
		\"max\": \"1\",\
		\"type\": \"code\"\
	},\
	{\
		\"min\": \"1\",\
		\"path\": \"Condition.verificationStatus\",\
		\"weight\": 1413,\
		\"max\": \"1\",\
		\"type\": \"code\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Condition.severity\",\
		\"weight\": 1414,\
		\"max\": \"1\",\
		\"type\": \"CodeableConcept\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Condition.onsetDateTime\",\
		\"weight\": 1415,\
		\"max\": \"1\",\
		\"type\": \"dateTime\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Condition.onsetQuantity\",\
		\"weight\": 1415,\
		\"max\": \"1\",\
		\"type\": \"Quantity\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Condition.onsetPeriod\",\
		\"weight\": 1415,\
		\"max\": \"1\",\
		\"type\": \"Period\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Condition.onsetRange\",\
		\"weight\": 1415,\
		\"max\": \"1\",\
		\"type\": \"Range\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Condition.onsetString\",\
		\"weight\": 1415,\
		\"max\": \"1\",\
		\"type\": \"string\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Condition.abatementDateTime\",\
		\"weight\": 1416,\
		\"max\": \"1\",\
		\"type\": \"dateTime\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Condition.abatementQuantity\",\
		\"weight\": 1416,\
		\"max\": \"1\",\
		\"type\": \"Quantity\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Condition.abatementBoolean\",\
		\"weight\": 1416,\
		\"max\": \"1\",\
		\"type\": \"boolean\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Condition.abatementPeriod\",\
		\"weight\": 1416,\
		\"max\": \"1\",\
		\"type\": \"Period\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Condition.abatementRange\",\
		\"weight\": 1416,\
		\"max\": \"1\",\
		\"type\": \"Range\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Condition.abatementString\",\
		\"weight\": 1416,\
		\"max\": \"1\",\
		\"type\": \"string\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Condition.stage\",\
		\"weight\": 1417,\
		\"max\": \"1\",\
		\"type\": \"BackboneElement\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Condition.stage.id\",\
		\"weight\": 1418,\
		\"max\": \"1\",\
		\"type\": \"id\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Condition.stage.extension\",\
		\"weight\": 1419,\
		\"max\": \"*\",\
		\"type\": \"Extension\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Condition.stage.modifierExtension\",\
		\"weight\": 1420,\
		\"max\": \"*\",\
		\"type\": \"Extension\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Condition.stage.summary\",\
		\"weight\": 1421,\
		\"max\": \"1\",\
		\"type\": \"CodeableConcept\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Condition.stage.assessment\",\
		\"weight\": 1422,\
		\"max\": \"*\",\
		\"type\": \"Reference\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Condition.evidence\",\
		\"weight\": 1423,\
		\"max\": \"*\",\
		\"type\": \"BackboneElement\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Condition.evidence.id\",\
		\"weight\": 1424,\
		\"max\": \"1\",\
		\"type\": \"id\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Condition.evidence.extension\",\
		\"weight\": 1425,\
		\"max\": \"*\",\
		\"type\": \"Extension\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Condition.evidence.modifierExtension\",\
		\"weight\": 1426,\
		\"max\": \"*\",\
		\"type\": \"Extension\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Condition.evidence.code\",\
		\"weight\": 1427,\
		\"max\": \"1\",\
		\"type\": \"CodeableConcept\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Condition.evidence.detail\",\
		\"weight\": 1428,\
		\"max\": \"*\",\
		\"type\": \"Reference\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Condition.bodySite\",\
		\"weight\": 1429,\
		\"max\": \"*\",\
		\"type\": \"CodeableConcept\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Condition.notes\",\
		\"weight\": 1430,\
		\"max\": \"1\",\
		\"type\": \"string\"\
	},\
	{\
		\"min\": \"1\",\
		\"path\": \"Conformance\",\
		\"weight\": 1431,\
		\"max\": \"1\",\
		\"type\": \"DomainResource\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Conformance.id\",\
		\"weight\": 1432,\
		\"max\": \"1\",\
		\"type\": \"id\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Conformance.meta\",\
		\"weight\": 1433,\
		\"max\": \"1\",\
		\"type\": \"Meta\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Conformance.implicitRules\",\
		\"weight\": 1434,\
		\"max\": \"1\",\
		\"type\": \"uri\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Conformance.language\",\
		\"weight\": 1435,\
		\"max\": \"1\",\
		\"type\": \"code\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Conformance.text\",\
		\"weight\": 1436,\
		\"max\": \"1\",\
		\"type\": \"Narrative\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Conformance.contained\",\
		\"weight\": 1437,\
		\"max\": \"*\",\
		\"type\": \"Resource\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Conformance.extension\",\
		\"weight\": 1438,\
		\"max\": \"*\",\
		\"type\": \"Extension\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Conformance.modifierExtension\",\
		\"weight\": 1439,\
		\"max\": \"*\",\
		\"type\": \"Extension\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Conformance.url\",\
		\"weight\": 1440,\
		\"max\": \"1\",\
		\"type\": \"uri\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Conformance.version\",\
		\"weight\": 1441,\
		\"max\": \"1\",\
		\"type\": \"string\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Conformance.name\",\
		\"weight\": 1442,\
		\"max\": \"1\",\
		\"type\": \"string\"\
	},\
	{\
		\"min\": \"1\",\
		\"path\": \"Conformance.status\",\
		\"weight\": 1443,\
		\"max\": \"1\",\
		\"type\": \"code\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Conformance.experimental\",\
		\"weight\": 1444,\
		\"max\": \"1\",\
		\"type\": \"boolean\"\
	},\
	{\
		\"min\": \"1\",\
		\"path\": \"Conformance.date\",\
		\"weight\": 1445,\
		\"max\": \"1\",\
		\"type\": \"dateTime\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Conformance.publisher\",\
		\"weight\": 1446,\
		\"max\": \"1\",\
		\"type\": \"string\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Conformance.contact\",\
		\"weight\": 1447,\
		\"max\": \"*\",\
		\"type\": \"BackboneElement\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Conformance.contact.id\",\
		\"weight\": 1448,\
		\"max\": \"1\",\
		\"type\": \"id\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Conformance.contact.extension\",\
		\"weight\": 1449,\
		\"max\": \"*\",\
		\"type\": \"Extension\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Conformance.contact.modifierExtension\",\
		\"weight\": 1450,\
		\"max\": \"*\",\
		\"type\": \"Extension\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Conformance.contact.name\",\
		\"weight\": 1451,\
		\"max\": \"1\",\
		\"type\": \"string\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Conformance.contact.telecom\",\
		\"weight\": 1452,\
		\"max\": \"*\",\
		\"type\": \"ContactPoint\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Conformance.description\",\
		\"weight\": 1453,\
		\"max\": \"1\",\
		\"type\": \"string\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Conformance.useContext\",\
		\"weight\": 1454,\
		\"max\": \"*\",\
		\"type\": \"CodeableConcept\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Conformance.requirements\",\
		\"weight\": 1455,\
		\"max\": \"1\",\
		\"type\": \"string\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Conformance.copyright\",\
		\"weight\": 1456,\
		\"max\": \"1\",\
		\"type\": \"string\"\
	},\
	{\
		\"min\": \"1\",\
		\"path\": \"Conformance.kind\",\
		\"weight\": 1457,\
		\"max\": \"1\",\
		\"type\": \"code\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Conformance.software\",\
		\"weight\": 1458,\
		\"max\": \"1\",\
		\"type\": \"BackboneElement\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Conformance.software.id\",\
		\"weight\": 1459,\
		\"max\": \"1\",\
		\"type\": \"id\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Conformance.software.extension\",\
		\"weight\": 1460,\
		\"max\": \"*\",\
		\"type\": \"Extension\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Conformance.software.modifierExtension\",\
		\"weight\": 1461,\
		\"max\": \"*\",\
		\"type\": \"Extension\"\
	},\
	{\
		\"min\": \"1\",\
		\"path\": \"Conformance.software.name\",\
		\"weight\": 1462,\
		\"max\": \"1\",\
		\"type\": \"string\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Conformance.software.version\",\
		\"weight\": 1463,\
		\"max\": \"1\",\
		\"type\": \"string\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Conformance.software.releaseDate\",\
		\"weight\": 1464,\
		\"max\": \"1\",\
		\"type\": \"dateTime\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Conformance.implementation\",\
		\"weight\": 1465,\
		\"max\": \"1\",\
		\"type\": \"BackboneElement\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Conformance.implementation.id\",\
		\"weight\": 1466,\
		\"max\": \"1\",\
		\"type\": \"id\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Conformance.implementation.extension\",\
		\"weight\": 1467,\
		\"max\": \"*\",\
		\"type\": \"Extension\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Conformance.implementation.modifierExtension\",\
		\"weight\": 1468,\
		\"max\": \"*\",\
		\"type\": \"Extension\"\
	},\
	{\
		\"min\": \"1\",\
		\"path\": \"Conformance.implementation.description\",\
		\"weight\": 1469,\
		\"max\": \"1\",\
		\"type\": \"string\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Conformance.implementation.url\",\
		\"weight\": 1470,\
		\"max\": \"1\",\
		\"type\": \"uri\"\
	},\
	{\
		\"min\": \"1\",\
		\"path\": \"Conformance.fhirVersion\",\
		\"weight\": 1471,\
		\"max\": \"1\",\
		\"type\": \"id\"\
	},\
	{\
		\"min\": \"1\",\
		\"path\": \"Conformance.acceptUnknown\",\
		\"weight\": 1472,\
		\"max\": \"1\",\
		\"type\": \"code\"\
	},\
	{\
		\"min\": \"1\",\
		\"path\": \"Conformance.format\",\
		\"weight\": 1473,\
		\"max\": \"*\",\
		\"type\": \"code\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Conformance.profile\",\
		\"weight\": 1474,\
		\"max\": \"*\",\
		\"type\": \"Reference\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Conformance.rest\",\
		\"weight\": 1475,\
		\"max\": \"*\",\
		\"type\": \"BackboneElement\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Conformance.rest.id\",\
		\"weight\": 1476,\
		\"max\": \"1\",\
		\"type\": \"id\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Conformance.rest.extension\",\
		\"weight\": 1477,\
		\"max\": \"*\",\
		\"type\": \"Extension\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Conformance.rest.modifierExtension\",\
		\"weight\": 1478,\
		\"max\": \"*\",\
		\"type\": \"Extension\"\
	},\
	{\
		\"min\": \"1\",\
		\"path\": \"Conformance.rest.mode\",\
		\"weight\": 1479,\
		\"max\": \"1\",\
		\"type\": \"code\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Conformance.rest.documentation\",\
		\"weight\": 1480,\
		\"max\": \"1\",\
		\"type\": \"string\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Conformance.rest.security\",\
		\"weight\": 1481,\
		\"max\": \"1\",\
		\"type\": \"BackboneElement\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Conformance.rest.security.id\",\
		\"weight\": 1482,\
		\"max\": \"1\",\
		\"type\": \"id\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Conformance.rest.security.extension\",\
		\"weight\": 1483,\
		\"max\": \"*\",\
		\"type\": \"Extension\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Conformance.rest.security.modifierExtension\",\
		\"weight\": 1484,\
		\"max\": \"*\",\
		\"type\": \"Extension\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Conformance.rest.security.cors\",\
		\"weight\": 1485,\
		\"max\": \"1\",\
		\"type\": \"boolean\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Conformance.rest.security.service\",\
		\"weight\": 1486,\
		\"max\": \"*\",\
		\"type\": \"CodeableConcept\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Conformance.rest.security.description\",\
		\"weight\": 1487,\
		\"max\": \"1\",\
		\"type\": \"string\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Conformance.rest.security.certificate\",\
		\"weight\": 1488,\
		\"max\": \"*\",\
		\"type\": \"BackboneElement\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Conformance.rest.security.certificate.id\",\
		\"weight\": 1489,\
		\"max\": \"1\",\
		\"type\": \"id\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Conformance.rest.security.certificate.extension\",\
		\"weight\": 1490,\
		\"max\": \"*\",\
		\"type\": \"Extension\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Conformance.rest.security.certificate.modifierExtension\",\
		\"weight\": 1491,\
		\"max\": \"*\",\
		\"type\": \"Extension\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Conformance.rest.security.certificate.type\",\
		\"weight\": 1492,\
		\"max\": \"1\",\
		\"type\": \"code\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Conformance.rest.security.certificate.blob\",\
		\"weight\": 1493,\
		\"max\": \"1\",\
		\"type\": \"base64Binary\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Conformance.rest.resource\",\
		\"weight\": 1494,\
		\"max\": \"*\",\
		\"type\": \"BackboneElement\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Conformance.rest.resource.id\",\
		\"weight\": 1495,\
		\"max\": \"1\",\
		\"type\": \"id\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Conformance.rest.resource.extension\",\
		\"weight\": 1496,\
		\"max\": \"*\",\
		\"type\": \"Extension\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Conformance.rest.resource.modifierExtension\",\
		\"weight\": 1497,\
		\"max\": \"*\",\
		\"type\": \"Extension\"\
	},\
	{\
		\"min\": \"1\",\
		\"path\": \"Conformance.rest.resource.type\",\
		\"weight\": 1498,\
		\"max\": \"1\",\
		\"type\": \"code\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Conformance.rest.resource.profile\",\
		\"weight\": 1499,\
		\"max\": \"1\",\
		\"type\": \"Reference\"\
	},\
	{\
		\"min\": \"1\",\
		\"path\": \"Conformance.rest.resource.interaction\",\
		\"weight\": 1500,\
		\"max\": \"*\",\
		\"type\": \"BackboneElement\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Conformance.rest.resource.interaction.id\",\
		\"weight\": 1501,\
		\"max\": \"1\",\
		\"type\": \"id\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Conformance.rest.resource.interaction.extension\",\
		\"weight\": 1502,\
		\"max\": \"*\",\
		\"type\": \"Extension\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Conformance.rest.resource.interaction.modifierExtension\",\
		\"weight\": 1503,\
		\"max\": \"*\",\
		\"type\": \"Extension\"\
	},\
	{\
		\"min\": \"1\",\
		\"path\": \"Conformance.rest.resource.interaction.code\",\
		\"weight\": 1504,\
		\"max\": \"1\",\
		\"type\": \"code\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Conformance.rest.resource.interaction.documentation\",\
		\"weight\": 1505,\
		\"max\": \"1\",\
		\"type\": \"string\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Conformance.rest.resource.versioning\",\
		\"weight\": 1506,\
		\"max\": \"1\",\
		\"type\": \"code\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Conformance.rest.resource.readHistory\",\
		\"weight\": 1507,\
		\"max\": \"1\",\
		\"type\": \"boolean\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Conformance.rest.resource.updateCreate\",\
		\"weight\": 1508,\
		\"max\": \"1\",\
		\"type\": \"boolean\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Conformance.rest.resource.conditionalCreate\",\
		\"weight\": 1509,\
		\"max\": \"1\",\
		\"type\": \"boolean\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Conformance.rest.resource.conditionalUpdate\",\
		\"weight\": 1510,\
		\"max\": \"1\",\
		\"type\": \"boolean\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Conformance.rest.resource.conditionalDelete\",\
		\"weight\": 1511,\
		\"max\": \"1\",\
		\"type\": \"code\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Conformance.rest.resource.searchInclude\",\
		\"weight\": 1512,\
		\"max\": \"*\",\
		\"type\": \"string\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Conformance.rest.resource.searchRevInclude\",\
		\"weight\": 1513,\
		\"max\": \"*\",\
		\"type\": \"string\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Conformance.rest.resource.searchParam\",\
		\"weight\": 1514,\
		\"max\": \"*\",\
		\"type\": \"BackboneElement\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Conformance.rest.resource.searchParam.id\",\
		\"weight\": 1515,\
		\"max\": \"1\",\
		\"type\": \"id\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Conformance.rest.resource.searchParam.extension\",\
		\"weight\": 1516,\
		\"max\": \"*\",\
		\"type\": \"Extension\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Conformance.rest.resource.searchParam.modifierExtension\",\
		\"weight\": 1517,\
		\"max\": \"*\",\
		\"type\": \"Extension\"\
	},\
	{\
		\"min\": \"1\",\
		\"path\": \"Conformance.rest.resource.searchParam.name\",\
		\"weight\": 1518,\
		\"max\": \"1\",\
		\"type\": \"string\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Conformance.rest.resource.searchParam.definition\",\
		\"weight\": 1519,\
		\"max\": \"1\",\
		\"type\": \"uri\"\
	},\
	{\
		\"min\": \"1\",\
		\"path\": \"Conformance.rest.resource.searchParam.type\",\
		\"weight\": 1520,\
		\"max\": \"1\",\
		\"type\": \"code\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Conformance.rest.resource.searchParam.documentation\",\
		\"weight\": 1521,\
		\"max\": \"1\",\
		\"type\": \"string\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Conformance.rest.resource.searchParam.target\",\
		\"weight\": 1522,\
		\"max\": \"*\",\
		\"type\": \"code\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Conformance.rest.resource.searchParam.modifier\",\
		\"weight\": 1523,\
		\"max\": \"*\",\
		\"type\": \"code\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Conformance.rest.resource.searchParam.chain\",\
		\"weight\": 1524,\
		\"max\": \"*\",\
		\"type\": \"string\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Conformance.rest.interaction\",\
		\"weight\": 1525,\
		\"max\": \"*\",\
		\"type\": \"BackboneElement\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Conformance.rest.interaction.id\",\
		\"weight\": 1526,\
		\"max\": \"1\",\
		\"type\": \"id\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Conformance.rest.interaction.extension\",\
		\"weight\": 1527,\
		\"max\": \"*\",\
		\"type\": \"Extension\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Conformance.rest.interaction.modifierExtension\",\
		\"weight\": 1528,\
		\"max\": \"*\",\
		\"type\": \"Extension\"\
	},\
	{\
		\"min\": \"1\",\
		\"path\": \"Conformance.rest.interaction.code\",\
		\"weight\": 1529,\
		\"max\": \"1\",\
		\"type\": \"code\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Conformance.rest.interaction.documentation\",\
		\"weight\": 1530,\
		\"max\": \"1\",\
		\"type\": \"string\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Conformance.rest.transactionMode\",\
		\"weight\": 1531,\
		\"max\": \"1\",\
		\"type\": \"code\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Conformance.rest.searchParam\",\
		\"weight\": 1532,\
		\"max\": \"*\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Conformance.rest.operation\",\
		\"weight\": 1533,\
		\"max\": \"*\",\
		\"type\": \"BackboneElement\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Conformance.rest.operation.id\",\
		\"weight\": 1534,\
		\"max\": \"1\",\
		\"type\": \"id\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Conformance.rest.operation.extension\",\
		\"weight\": 1535,\
		\"max\": \"*\",\
		\"type\": \"Extension\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Conformance.rest.operation.modifierExtension\",\
		\"weight\": 1536,\
		\"max\": \"*\",\
		\"type\": \"Extension\"\
	},\
	{\
		\"min\": \"1\",\
		\"path\": \"Conformance.rest.operation.name\",\
		\"weight\": 1537,\
		\"max\": \"1\",\
		\"type\": \"string\"\
	},\
	{\
		\"min\": \"1\",\
		\"path\": \"Conformance.rest.operation.definition\",\
		\"weight\": 1538,\
		\"max\": \"1\",\
		\"type\": \"Reference\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Conformance.rest.compartment\",\
		\"weight\": 1539,\
		\"max\": \"*\",\
		\"type\": \"uri\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Conformance.messaging\",\
		\"weight\": 1540,\
		\"max\": \"*\",\
		\"type\": \"BackboneElement\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Conformance.messaging.id\",\
		\"weight\": 1541,\
		\"max\": \"1\",\
		\"type\": \"id\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Conformance.messaging.extension\",\
		\"weight\": 1542,\
		\"max\": \"*\",\
		\"type\": \"Extension\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Conformance.messaging.modifierExtension\",\
		\"weight\": 1543,\
		\"max\": \"*\",\
		\"type\": \"Extension\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Conformance.messaging.endpoint\",\
		\"weight\": 1544,\
		\"max\": \"*\",\
		\"type\": \"BackboneElement\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Conformance.messaging.endpoint.id\",\
		\"weight\": 1545,\
		\"max\": \"1\",\
		\"type\": \"id\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Conformance.messaging.endpoint.extension\",\
		\"weight\": 1546,\
		\"max\": \"*\",\
		\"type\": \"Extension\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Conformance.messaging.endpoint.modifierExtension\",\
		\"weight\": 1547,\
		\"max\": \"*\",\
		\"type\": \"Extension\"\
	},\
	{\
		\"min\": \"1\",\
		\"path\": \"Conformance.messaging.endpoint.protocol\",\
		\"weight\": 1548,\
		\"max\": \"1\",\
		\"type\": \"Coding\"\
	},\
	{\
		\"min\": \"1\",\
		\"path\": \"Conformance.messaging.endpoint.address\",\
		\"weight\": 1549,\
		\"max\": \"1\",\
		\"type\": \"uri\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Conformance.messaging.reliableCache\",\
		\"weight\": 1550,\
		\"max\": \"1\",\
		\"type\": \"unsignedInt\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Conformance.messaging.documentation\",\
		\"weight\": 1551,\
		\"max\": \"1\",\
		\"type\": \"string\"\
	},\
	{\
		\"min\": \"1\",\
		\"path\": \"Conformance.messaging.event\",\
		\"weight\": 1552,\
		\"max\": \"*\",\
		\"type\": \"BackboneElement\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Conformance.messaging.event.id\",\
		\"weight\": 1553,\
		\"max\": \"1\",\
		\"type\": \"id\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Conformance.messaging.event.extension\",\
		\"weight\": 1554,\
		\"max\": \"*\",\
		\"type\": \"Extension\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Conformance.messaging.event.modifierExtension\",\
		\"weight\": 1555,\
		\"max\": \"*\",\
		\"type\": \"Extension\"\
	},\
	{\
		\"min\": \"1\",\
		\"path\": \"Conformance.messaging.event.code\",\
		\"weight\": 1556,\
		\"max\": \"1\",\
		\"type\": \"Coding\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Conformance.messaging.event.category\",\
		\"weight\": 1557,\
		\"max\": \"1\",\
		\"type\": \"code\"\
	},\
	{\
		\"min\": \"1\",\
		\"path\": \"Conformance.messaging.event.mode\",\
		\"weight\": 1558,\
		\"max\": \"1\",\
		\"type\": \"code\"\
	},\
	{\
		\"min\": \"1\",\
		\"path\": \"Conformance.messaging.event.focus\",\
		\"weight\": 1559,\
		\"max\": \"1\",\
		\"type\": \"code\"\
	},\
	{\
		\"min\": \"1\",\
		\"path\": \"Conformance.messaging.event.request\",\
		\"weight\": 1560,\
		\"max\": \"1\",\
		\"type\": \"Reference\"\
	},\
	{\
		\"min\": \"1\",\
		\"path\": \"Conformance.messaging.event.response\",\
		\"weight\": 1561,\
		\"max\": \"1\",\
		\"type\": \"Reference\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Conformance.messaging.event.documentation\",\
		\"weight\": 1562,\
		\"max\": \"1\",\
		\"type\": \"string\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Conformance.document\",\
		\"weight\": 1563,\
		\"max\": \"*\",\
		\"type\": \"BackboneElement\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Conformance.document.id\",\
		\"weight\": 1564,\
		\"max\": \"1\",\
		\"type\": \"id\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Conformance.document.extension\",\
		\"weight\": 1565,\
		\"max\": \"*\",\
		\"type\": \"Extension\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Conformance.document.modifierExtension\",\
		\"weight\": 1566,\
		\"max\": \"*\",\
		\"type\": \"Extension\"\
	},\
	{\
		\"min\": \"1\",\
		\"path\": \"Conformance.document.mode\",\
		\"weight\": 1567,\
		\"max\": \"1\",\
		\"type\": \"code\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Conformance.document.documentation\",\
		\"weight\": 1568,\
		\"max\": \"1\",\
		\"type\": \"string\"\
	},\
	{\
		\"min\": \"1\",\
		\"path\": \"Conformance.document.profile\",\
		\"weight\": 1569,\
		\"max\": \"1\",\
		\"type\": \"Reference\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Contract\",\
		\"weight\": 1570,\
		\"max\": \"*\",\
		\"type\": \"DomainResource\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Contract.id\",\
		\"weight\": 1571,\
		\"max\": \"1\",\
		\"type\": \"id\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Contract.meta\",\
		\"weight\": 1572,\
		\"max\": \"1\",\
		\"type\": \"Meta\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Contract.implicitRules\",\
		\"weight\": 1573,\
		\"max\": \"1\",\
		\"type\": \"uri\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Contract.language\",\
		\"weight\": 1574,\
		\"max\": \"1\",\
		\"type\": \"code\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Contract.text\",\
		\"weight\": 1575,\
		\"max\": \"1\",\
		\"type\": \"Narrative\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Contract.contained\",\
		\"weight\": 1576,\
		\"max\": \"*\",\
		\"type\": \"Resource\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Contract.extension\",\
		\"weight\": 1577,\
		\"max\": \"*\",\
		\"type\": \"Extension\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Contract.modifierExtension\",\
		\"weight\": 1578,\
		\"max\": \"*\",\
		\"type\": \"Extension\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Contract.identifier\",\
		\"weight\": 1579,\
		\"max\": \"1\",\
		\"type\": \"Identifier\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Contract.issued\",\
		\"weight\": 1580,\
		\"max\": \"1\",\
		\"type\": \"dateTime\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Contract.applies\",\
		\"weight\": 1581,\
		\"max\": \"1\",\
		\"type\": \"Period\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Contract.subject\",\
		\"weight\": 1582,\
		\"max\": \"*\",\
		\"type\": \"Reference\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Contract.topic\",\
		\"weight\": 1583,\
		\"max\": \"*\",\
		\"type\": \"Reference\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Contract.authority\",\
		\"weight\": 1584,\
		\"max\": \"*\",\
		\"type\": \"Reference\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Contract.domain\",\
		\"weight\": 1585,\
		\"max\": \"*\",\
		\"type\": \"Reference\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Contract.type\",\
		\"weight\": 1586,\
		\"max\": \"1\",\
		\"type\": \"CodeableConcept\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Contract.subType\",\
		\"weight\": 1587,\
		\"max\": \"*\",\
		\"type\": \"CodeableConcept\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Contract.action\",\
		\"weight\": 1588,\
		\"max\": \"*\",\
		\"type\": \"CodeableConcept\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Contract.actionReason\",\
		\"weight\": 1589,\
		\"max\": \"*\",\
		\"type\": \"CodeableConcept\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Contract.agent\",\
		\"weight\": 1590,\
		\"max\": \"*\",\
		\"type\": \"BackboneElement\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Contract.agent.id\",\
		\"weight\": 1591,\
		\"max\": \"1\",\
		\"type\": \"id\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Contract.agent.extension\",\
		\"weight\": 1592,\
		\"max\": \"*\",\
		\"type\": \"Extension\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Contract.agent.modifierExtension\",\
		\"weight\": 1593,\
		\"max\": \"*\",\
		\"type\": \"Extension\"\
	},\
	{\
		\"min\": \"1\",\
		\"path\": \"Contract.agent.actor\",\
		\"weight\": 1594,\
		\"max\": \"1\",\
		\"type\": \"Reference\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Contract.agent.role\",\
		\"weight\": 1595,\
		\"max\": \"*\",\
		\"type\": \"CodeableConcept\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Contract.signer\",\
		\"weight\": 1596,\
		\"max\": \"*\",\
		\"type\": \"BackboneElement\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Contract.signer.id\",\
		\"weight\": 1597,\
		\"max\": \"1\",\
		\"type\": \"id\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Contract.signer.extension\",\
		\"weight\": 1598,\
		\"max\": \"*\",\
		\"type\": \"Extension\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Contract.signer.modifierExtension\",\
		\"weight\": 1599,\
		\"max\": \"*\",\
		\"type\": \"Extension\"\
	},\
	{\
		\"min\": \"1\",\
		\"path\": \"Contract.signer.type\",\
		\"weight\": 1600,\
		\"max\": \"1\",\
		\"type\": \"Coding\"\
	},\
	{\
		\"min\": \"1\",\
		\"path\": \"Contract.signer.party\",\
		\"weight\": 1601,\
		\"max\": \"1\",\
		\"type\": \"Reference\"\
	},\
	{\
		\"min\": \"1\",\
		\"path\": \"Contract.signer.signature\",\
		\"weight\": 1602,\
		\"max\": \"*\",\
		\"type\": \"Signature\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Contract.valuedItem\",\
		\"weight\": 1603,\
		\"max\": \"*\",\
		\"type\": \"BackboneElement\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Contract.valuedItem.id\",\
		\"weight\": 1604,\
		\"max\": \"1\",\
		\"type\": \"id\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Contract.valuedItem.extension\",\
		\"weight\": 1605,\
		\"max\": \"*\",\
		\"type\": \"Extension\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Contract.valuedItem.modifierExtension\",\
		\"weight\": 1606,\
		\"max\": \"*\",\
		\"type\": \"Extension\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Contract.valuedItem.entityCodeableConcept\",\
		\"weight\": 1607,\
		\"max\": \"1\",\
		\"type\": \"CodeableConcept\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Contract.valuedItem.entityReference\",\
		\"weight\": 1607,\
		\"max\": \"1\",\
		\"type\": \"Reference\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Contract.valuedItem.identifier\",\
		\"weight\": 1608,\
		\"max\": \"1\",\
		\"type\": \"Identifier\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Contract.valuedItem.effectiveTime\",\
		\"weight\": 1609,\
		\"max\": \"1\",\
		\"type\": \"dateTime\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Contract.valuedItem.quantity\",\
		\"weight\": 1610,\
		\"max\": \"1\",\
		\"type\": \"Quantity\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Contract.valuedItem.unitPrice\",\
		\"weight\": 1611,\
		\"max\": \"1\",\
		\"type\": \"Quantity\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Contract.valuedItem.factor\",\
		\"weight\": 1612,\
		\"max\": \"1\",\
		\"type\": \"decimal\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Contract.valuedItem.points\",\
		\"weight\": 1613,\
		\"max\": \"1\",\
		\"type\": \"decimal\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Contract.valuedItem.net\",\
		\"weight\": 1614,\
		\"max\": \"1\",\
		\"type\": \"Quantity\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Contract.term\",\
		\"weight\": 1615,\
		\"max\": \"*\",\
		\"type\": \"BackboneElement\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Contract.term.id\",\
		\"weight\": 1616,\
		\"max\": \"1\",\
		\"type\": \"id\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Contract.term.extension\",\
		\"weight\": 1617,\
		\"max\": \"*\",\
		\"type\": \"Extension\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Contract.term.modifierExtension\",\
		\"weight\": 1618,\
		\"max\": \"*\",\
		\"type\": \"Extension\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Contract.term.identifier\",\
		\"weight\": 1619,\
		\"max\": \"1\",\
		\"type\": \"Identifier\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Contract.term.issued\",\
		\"weight\": 1620,\
		\"max\": \"1\",\
		\"type\": \"dateTime\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Contract.term.applies\",\
		\"weight\": 1621,\
		\"max\": \"1\",\
		\"type\": \"Period\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Contract.term.type\",\
		\"weight\": 1622,\
		\"max\": \"1\",\
		\"type\": \"CodeableConcept\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Contract.term.subType\",\
		\"weight\": 1623,\
		\"max\": \"1\",\
		\"type\": \"CodeableConcept\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Contract.term.topic\",\
		\"weight\": 1624,\
		\"max\": \"*\",\
		\"type\": \"Reference\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Contract.term.action\",\
		\"weight\": 1625,\
		\"max\": \"*\",\
		\"type\": \"CodeableConcept\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Contract.term.actionReason\",\
		\"weight\": 1626,\
		\"max\": \"*\",\
		\"type\": \"CodeableConcept\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Contract.term.agent\",\
		\"weight\": 1627,\
		\"max\": \"*\",\
		\"type\": \"BackboneElement\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Contract.term.agent.id\",\
		\"weight\": 1628,\
		\"max\": \"1\",\
		\"type\": \"id\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Contract.term.agent.extension\",\
		\"weight\": 1629,\
		\"max\": \"*\",\
		\"type\": \"Extension\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Contract.term.agent.modifierExtension\",\
		\"weight\": 1630,\
		\"max\": \"*\",\
		\"type\": \"Extension\"\
	},\
	{\
		\"min\": \"1\",\
		\"path\": \"Contract.term.agent.actor\",\
		\"weight\": 1631,\
		\"max\": \"1\",\
		\"type\": \"Reference\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Contract.term.agent.role\",\
		\"weight\": 1632,\
		\"max\": \"*\",\
		\"type\": \"CodeableConcept\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Contract.term.text\",\
		\"weight\": 1633,\
		\"max\": \"1\",\
		\"type\": \"string\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Contract.term.valuedItem\",\
		\"weight\": 1634,\
		\"max\": \"*\",\
		\"type\": \"BackboneElement\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Contract.term.valuedItem.id\",\
		\"weight\": 1635,\
		\"max\": \"1\",\
		\"type\": \"id\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Contract.term.valuedItem.extension\",\
		\"weight\": 1636,\
		\"max\": \"*\",\
		\"type\": \"Extension\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Contract.term.valuedItem.modifierExtension\",\
		\"weight\": 1637,\
		\"max\": \"*\",\
		\"type\": \"Extension\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Contract.term.valuedItem.entityCodeableConcept\",\
		\"weight\": 1638,\
		\"max\": \"1\",\
		\"type\": \"CodeableConcept\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Contract.term.valuedItem.entityReference\",\
		\"weight\": 1638,\
		\"max\": \"1\",\
		\"type\": \"Reference\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Contract.term.valuedItem.identifier\",\
		\"weight\": 1639,\
		\"max\": \"1\",\
		\"type\": \"Identifier\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Contract.term.valuedItem.effectiveTime\",\
		\"weight\": 1640,\
		\"max\": \"1\",\
		\"type\": \"dateTime\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Contract.term.valuedItem.quantity\",\
		\"weight\": 1641,\
		\"max\": \"1\",\
		\"type\": \"Quantity\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Contract.term.valuedItem.unitPrice\",\
		\"weight\": 1642,\
		\"max\": \"1\",\
		\"type\": \"Quantity\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Contract.term.valuedItem.factor\",\
		\"weight\": 1643,\
		\"max\": \"1\",\
		\"type\": \"decimal\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Contract.term.valuedItem.points\",\
		\"weight\": 1644,\
		\"max\": \"1\",\
		\"type\": \"decimal\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Contract.term.valuedItem.net\",\
		\"weight\": 1645,\
		\"max\": \"1\",\
		\"type\": \"Quantity\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Contract.term.group\",\
		\"weight\": 1646,\
		\"max\": \"*\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Contract.bindingAttachment\",\
		\"weight\": 1647,\
		\"max\": \"1\",\
		\"type\": \"Attachment\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Contract.bindingReference\",\
		\"weight\": 1647,\
		\"max\": \"1\",\
		\"type\": \"Reference\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Contract.bindingReference\",\
		\"weight\": 1647,\
		\"max\": \"1\",\
		\"type\": \"Reference\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Contract.bindingReference\",\
		\"weight\": 1647,\
		\"max\": \"1\",\
		\"type\": \"Reference\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Contract.friendly\",\
		\"weight\": 1648,\
		\"max\": \"*\",\
		\"type\": \"BackboneElement\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Contract.friendly.id\",\
		\"weight\": 1649,\
		\"max\": \"1\",\
		\"type\": \"id\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Contract.friendly.extension\",\
		\"weight\": 1650,\
		\"max\": \"*\",\
		\"type\": \"Extension\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Contract.friendly.modifierExtension\",\
		\"weight\": 1651,\
		\"max\": \"*\",\
		\"type\": \"Extension\"\
	},\
	{\
		\"min\": \"1\",\
		\"path\": \"Contract.friendly.contentAttachment\",\
		\"weight\": 1652,\
		\"max\": \"1\",\
		\"type\": \"Attachment\"\
	},\
	{\
		\"min\": \"1\",\
		\"path\": \"Contract.friendly.contentReference\",\
		\"weight\": 1652,\
		\"max\": \"1\",\
		\"type\": \"Reference\"\
	},\
	{\
		\"min\": \"1\",\
		\"path\": \"Contract.friendly.contentReference\",\
		\"weight\": 1652,\
		\"max\": \"1\",\
		\"type\": \"Reference\"\
	},\
	{\
		\"min\": \"1\",\
		\"path\": \"Contract.friendly.contentReference\",\
		\"weight\": 1652,\
		\"max\": \"1\",\
		\"type\": \"Reference\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Contract.legal\",\
		\"weight\": 1653,\
		\"max\": \"*\",\
		\"type\": \"BackboneElement\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Contract.legal.id\",\
		\"weight\": 1654,\
		\"max\": \"1\",\
		\"type\": \"id\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Contract.legal.extension\",\
		\"weight\": 1655,\
		\"max\": \"*\",\
		\"type\": \"Extension\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Contract.legal.modifierExtension\",\
		\"weight\": 1656,\
		\"max\": \"*\",\
		\"type\": \"Extension\"\
	},\
	{\
		\"min\": \"1\",\
		\"path\": \"Contract.legal.contentAttachment\",\
		\"weight\": 1657,\
		\"max\": \"1\",\
		\"type\": \"Attachment\"\
	},\
	{\
		\"min\": \"1\",\
		\"path\": \"Contract.legal.contentReference\",\
		\"weight\": 1657,\
		\"max\": \"1\",\
		\"type\": \"Reference\"\
	},\
	{\
		\"min\": \"1\",\
		\"path\": \"Contract.legal.contentReference\",\
		\"weight\": 1657,\
		\"max\": \"1\",\
		\"type\": \"Reference\"\
	},\
	{\
		\"min\": \"1\",\
		\"path\": \"Contract.legal.contentReference\",\
		\"weight\": 1657,\
		\"max\": \"1\",\
		\"type\": \"Reference\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Contract.rule\",\
		\"weight\": 1658,\
		\"max\": \"*\",\
		\"type\": \"BackboneElement\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Contract.rule.id\",\
		\"weight\": 1659,\
		\"max\": \"1\",\
		\"type\": \"id\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Contract.rule.extension\",\
		\"weight\": 1660,\
		\"max\": \"*\",\
		\"type\": \"Extension\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Contract.rule.modifierExtension\",\
		\"weight\": 1661,\
		\"max\": \"*\",\
		\"type\": \"Extension\"\
	},\
	{\
		\"min\": \"1\",\
		\"path\": \"Contract.rule.contentAttachment\",\
		\"weight\": 1662,\
		\"max\": \"1\",\
		\"type\": \"Attachment\"\
	},\
	{\
		\"min\": \"1\",\
		\"path\": \"Contract.rule.contentReference\",\
		\"weight\": 1662,\
		\"max\": \"1\",\
		\"type\": \"Reference\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Coverage\",\
		\"weight\": 1663,\
		\"max\": \"*\",\
		\"type\": \"DomainResource\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Coverage.id\",\
		\"weight\": 1664,\
		\"max\": \"1\",\
		\"type\": \"id\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Coverage.meta\",\
		\"weight\": 1665,\
		\"max\": \"1\",\
		\"type\": \"Meta\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Coverage.implicitRules\",\
		\"weight\": 1666,\
		\"max\": \"1\",\
		\"type\": \"uri\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Coverage.language\",\
		\"weight\": 1667,\
		\"max\": \"1\",\
		\"type\": \"code\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Coverage.text\",\
		\"weight\": 1668,\
		\"max\": \"1\",\
		\"type\": \"Narrative\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Coverage.contained\",\
		\"weight\": 1669,\
		\"max\": \"*\",\
		\"type\": \"Resource\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Coverage.extension\",\
		\"weight\": 1670,\
		\"max\": \"*\",\
		\"type\": \"Extension\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Coverage.modifierExtension\",\
		\"weight\": 1671,\
		\"max\": \"*\",\
		\"type\": \"Extension\"\
	},\
	{\
		\"min\": \"1\",\
		\"path\": \"Coverage.issuerIdentifier\",\
		\"weight\": 1672,\
		\"max\": \"1\",\
		\"type\": \"Identifier\"\
	},\
	{\
		\"min\": \"1\",\
		\"path\": \"Coverage.issuerReference\",\
		\"weight\": 1672,\
		\"max\": \"1\",\
		\"type\": \"Reference\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Coverage.bin\",\
		\"weight\": 1673,\
		\"max\": \"1\",\
		\"type\": \"string\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Coverage.period\",\
		\"weight\": 1674,\
		\"max\": \"1\",\
		\"type\": \"Period\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Coverage.type\",\
		\"weight\": 1675,\
		\"max\": \"1\",\
		\"type\": \"Coding\"\
	},\
	{\
		\"min\": \"1\",\
		\"path\": \"Coverage.planholderIdentifier\",\
		\"weight\": 1676,\
		\"max\": \"1\",\
		\"type\": \"Identifier\"\
	},\
	{\
		\"min\": \"1\",\
		\"path\": \"Coverage.planholderReference\",\
		\"weight\": 1676,\
		\"max\": \"1\",\
		\"type\": \"Reference\"\
	},\
	{\
		\"min\": \"1\",\
		\"path\": \"Coverage.planholderReference\",\
		\"weight\": 1676,\
		\"max\": \"1\",\
		\"type\": \"Reference\"\
	},\
	{\
		\"min\": \"1\",\
		\"path\": \"Coverage.beneficiaryIdentifier\",\
		\"weight\": 1677,\
		\"max\": \"1\",\
		\"type\": \"Identifier\"\
	},\
	{\
		\"min\": \"1\",\
		\"path\": \"Coverage.beneficiaryReference\",\
		\"weight\": 1677,\
		\"max\": \"1\",\
		\"type\": \"Reference\"\
	},\
	{\
		\"min\": \"1\",\
		\"path\": \"Coverage.relationship\",\
		\"weight\": 1678,\
		\"max\": \"1\",\
		\"type\": \"Coding\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Coverage.identifier\",\
		\"weight\": 1679,\
		\"max\": \"*\",\
		\"type\": \"Identifier\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Coverage.group\",\
		\"weight\": 1680,\
		\"max\": \"1\",\
		\"type\": \"string\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Coverage.plan\",\
		\"weight\": 1681,\
		\"max\": \"1\",\
		\"type\": \"string\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Coverage.subPlan\",\
		\"weight\": 1682,\
		\"max\": \"1\",\
		\"type\": \"string\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Coverage.dependent\",\
		\"weight\": 1683,\
		\"max\": \"1\",\
		\"type\": \"positiveInt\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Coverage.sequence\",\
		\"weight\": 1684,\
		\"max\": \"1\",\
		\"type\": \"positiveInt\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Coverage.exception\",\
		\"weight\": 1685,\
		\"max\": \"*\",\
		\"type\": \"Coding\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Coverage.school\",\
		\"weight\": 1686,\
		\"max\": \"1\",\
		\"type\": \"string\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Coverage.network\",\
		\"weight\": 1687,\
		\"max\": \"1\",\
		\"type\": \"string\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Coverage.contract\",\
		\"weight\": 1688,\
		\"max\": \"*\",\
		\"type\": \"Reference\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"DataElement\",\
		\"weight\": 1689,\
		\"max\": \"*\",\
		\"type\": \"DomainResource\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"DataElement.id\",\
		\"weight\": 1690,\
		\"max\": \"1\",\
		\"type\": \"id\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"DataElement.meta\",\
		\"weight\": 1691,\
		\"max\": \"1\",\
		\"type\": \"Meta\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"DataElement.implicitRules\",\
		\"weight\": 1692,\
		\"max\": \"1\",\
		\"type\": \"uri\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"DataElement.language\",\
		\"weight\": 1693,\
		\"max\": \"1\",\
		\"type\": \"code\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"DataElement.text\",\
		\"weight\": 1694,\
		\"max\": \"1\",\
		\"type\": \"Narrative\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"DataElement.contained\",\
		\"weight\": 1695,\
		\"max\": \"*\",\
		\"type\": \"Resource\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"DataElement.extension\",\
		\"weight\": 1696,\
		\"max\": \"*\",\
		\"type\": \"Extension\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"DataElement.modifierExtension\",\
		\"weight\": 1697,\
		\"max\": \"*\",\
		\"type\": \"Extension\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"DataElement.url\",\
		\"weight\": 1698,\
		\"max\": \"1\",\
		\"type\": \"uri\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"DataElement.identifier\",\
		\"weight\": 1699,\
		\"max\": \"*\",\
		\"type\": \"Identifier\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"DataElement.version\",\
		\"weight\": 1700,\
		\"max\": \"1\",\
		\"type\": \"string\"\
	},\
	{\
		\"min\": \"1\",\
		\"path\": \"DataElement.status\",\
		\"weight\": 1701,\
		\"max\": \"1\",\
		\"type\": \"code\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"DataElement.experimental\",\
		\"weight\": 1702,\
		\"max\": \"1\",\
		\"type\": \"boolean\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"DataElement.publisher\",\
		\"weight\": 1703,\
		\"max\": \"1\",\
		\"type\": \"string\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"DataElement.date\",\
		\"weight\": 1704,\
		\"max\": \"1\",\
		\"type\": \"dateTime\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"DataElement.name\",\
		\"weight\": 1705,\
		\"max\": \"1\",\
		\"type\": \"string\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"DataElement.contact\",\
		\"weight\": 1706,\
		\"max\": \"*\",\
		\"type\": \"BackboneElement\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"DataElement.contact.id\",\
		\"weight\": 1707,\
		\"max\": \"1\",\
		\"type\": \"id\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"DataElement.contact.extension\",\
		\"weight\": 1708,\
		\"max\": \"*\",\
		\"type\": \"Extension\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"DataElement.contact.modifierExtension\",\
		\"weight\": 1709,\
		\"max\": \"*\",\
		\"type\": \"Extension\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"DataElement.contact.name\",\
		\"weight\": 1710,\
		\"max\": \"1\",\
		\"type\": \"string\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"DataElement.contact.telecom\",\
		\"weight\": 1711,\
		\"max\": \"*\",\
		\"type\": \"ContactPoint\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"DataElement.useContext\",\
		\"weight\": 1712,\
		\"max\": \"*\",\
		\"type\": \"CodeableConcept\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"DataElement.copyright\",\
		\"weight\": 1713,\
		\"max\": \"1\",\
		\"type\": \"string\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"DataElement.stringency\",\
		\"weight\": 1714,\
		\"max\": \"1\",\
		\"type\": \"code\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"DataElement.mapping\",\
		\"weight\": 1715,\
		\"max\": \"*\",\
		\"type\": \"BackboneElement\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"DataElement.mapping.id\",\
		\"weight\": 1716,\
		\"max\": \"1\",\
		\"type\": \"id\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"DataElement.mapping.extension\",\
		\"weight\": 1717,\
		\"max\": \"*\",\
		\"type\": \"Extension\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"DataElement.mapping.modifierExtension\",\
		\"weight\": 1718,\
		\"max\": \"*\",\
		\"type\": \"Extension\"\
	},\
	{\
		\"min\": \"1\",\
		\"path\": \"DataElement.mapping.identity\",\
		\"weight\": 1719,\
		\"max\": \"1\",\
		\"type\": \"id\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"DataElement.mapping.uri\",\
		\"weight\": 1720,\
		\"max\": \"1\",\
		\"type\": \"uri\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"DataElement.mapping.name\",\
		\"weight\": 1721,\
		\"max\": \"1\",\
		\"type\": \"string\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"DataElement.mapping.comment\",\
		\"weight\": 1722,\
		\"max\": \"1\",\
		\"type\": \"string\"\
	},\
	{\
		\"min\": \"1\",\
		\"path\": \"DataElement.element\",\
		\"weight\": 1723,\
		\"max\": \"*\",\
		\"type\": \"ElementDefinition\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"DecisionSupportRule\",\
		\"weight\": 1724,\
		\"max\": \"*\",\
		\"type\": \"DomainResource\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"DecisionSupportRule.id\",\
		\"weight\": 1725,\
		\"max\": \"1\",\
		\"type\": \"id\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"DecisionSupportRule.meta\",\
		\"weight\": 1726,\
		\"max\": \"1\",\
		\"type\": \"Meta\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"DecisionSupportRule.implicitRules\",\
		\"weight\": 1727,\
		\"max\": \"1\",\
		\"type\": \"uri\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"DecisionSupportRule.language\",\
		\"weight\": 1728,\
		\"max\": \"1\",\
		\"type\": \"code\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"DecisionSupportRule.text\",\
		\"weight\": 1729,\
		\"max\": \"1\",\
		\"type\": \"Narrative\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"DecisionSupportRule.contained\",\
		\"weight\": 1730,\
		\"max\": \"*\",\
		\"type\": \"Resource\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"DecisionSupportRule.extension\",\
		\"weight\": 1731,\
		\"max\": \"*\",\
		\"type\": \"Extension\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"DecisionSupportRule.modifierExtension\",\
		\"weight\": 1732,\
		\"max\": \"*\",\
		\"type\": \"Extension\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"DecisionSupportRule.moduleMetadata\",\
		\"weight\": 1733,\
		\"max\": \"1\",\
		\"type\": \"ModuleMetadata\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"DecisionSupportRule.library\",\
		\"weight\": 1734,\
		\"max\": \"*\",\
		\"type\": \"Reference\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"DecisionSupportRule.trigger\",\
		\"weight\": 1735,\
		\"max\": \"*\",\
		\"type\": \"TriggerDefinition\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"DecisionSupportRule.condition\",\
		\"weight\": 1736,\
		\"max\": \"1\",\
		\"type\": \"string\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"DecisionSupportRule.action\",\
		\"weight\": 1737,\
		\"max\": \"*\",\
		\"type\": \"ActionDefinition\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"DecisionSupportServiceModule\",\
		\"weight\": 1738,\
		\"max\": \"*\",\
		\"type\": \"DomainResource\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"DecisionSupportServiceModule.id\",\
		\"weight\": 1739,\
		\"max\": \"1\",\
		\"type\": \"id\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"DecisionSupportServiceModule.meta\",\
		\"weight\": 1740,\
		\"max\": \"1\",\
		\"type\": \"Meta\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"DecisionSupportServiceModule.implicitRules\",\
		\"weight\": 1741,\
		\"max\": \"1\",\
		\"type\": \"uri\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"DecisionSupportServiceModule.language\",\
		\"weight\": 1742,\
		\"max\": \"1\",\
		\"type\": \"code\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"DecisionSupportServiceModule.text\",\
		\"weight\": 1743,\
		\"max\": \"1\",\
		\"type\": \"Narrative\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"DecisionSupportServiceModule.contained\",\
		\"weight\": 1744,\
		\"max\": \"*\",\
		\"type\": \"Resource\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"DecisionSupportServiceModule.extension\",\
		\"weight\": 1745,\
		\"max\": \"*\",\
		\"type\": \"Extension\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"DecisionSupportServiceModule.modifierExtension\",\
		\"weight\": 1746,\
		\"max\": \"*\",\
		\"type\": \"Extension\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"DecisionSupportServiceModule.moduleMetadata\",\
		\"weight\": 1747,\
		\"max\": \"1\",\
		\"type\": \"ModuleMetadata\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"DecisionSupportServiceModule.trigger\",\
		\"weight\": 1748,\
		\"max\": \"*\",\
		\"type\": \"TriggerDefinition\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"DecisionSupportServiceModule.parameter\",\
		\"weight\": 1749,\
		\"max\": \"*\",\
		\"type\": \"ParameterDefinition\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"DecisionSupportServiceModule.dataRequirement\",\
		\"weight\": 1750,\
		\"max\": \"*\",\
		\"type\": \"DataRequirement\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"DetectedIssue\",\
		\"weight\": 1751,\
		\"max\": \"*\",\
		\"type\": \"DomainResource\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"DetectedIssue.id\",\
		\"weight\": 1752,\
		\"max\": \"1\",\
		\"type\": \"id\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"DetectedIssue.meta\",\
		\"weight\": 1753,\
		\"max\": \"1\",\
		\"type\": \"Meta\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"DetectedIssue.implicitRules\",\
		\"weight\": 1754,\
		\"max\": \"1\",\
		\"type\": \"uri\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"DetectedIssue.language\",\
		\"weight\": 1755,\
		\"max\": \"1\",\
		\"type\": \"code\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"DetectedIssue.text\",\
		\"weight\": 1756,\
		\"max\": \"1\",\
		\"type\": \"Narrative\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"DetectedIssue.contained\",\
		\"weight\": 1757,\
		\"max\": \"*\",\
		\"type\": \"Resource\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"DetectedIssue.extension\",\
		\"weight\": 1758,\
		\"max\": \"*\",\
		\"type\": \"Extension\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"DetectedIssue.modifierExtension\",\
		\"weight\": 1759,\
		\"max\": \"*\",\
		\"type\": \"Extension\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"DetectedIssue.patient\",\
		\"weight\": 1760,\
		\"max\": \"1\",\
		\"type\": \"Reference\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"DetectedIssue.category\",\
		\"weight\": 1761,\
		\"max\": \"1\",\
		\"type\": \"CodeableConcept\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"DetectedIssue.severity\",\
		\"weight\": 1762,\
		\"max\": \"1\",\
		\"type\": \"code\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"DetectedIssue.implicated\",\
		\"weight\": 1763,\
		\"max\": \"*\",\
		\"type\": \"Reference\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"DetectedIssue.detail\",\
		\"weight\": 1764,\
		\"max\": \"1\",\
		\"type\": \"string\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"DetectedIssue.date\",\
		\"weight\": 1765,\
		\"max\": \"1\",\
		\"type\": \"dateTime\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"DetectedIssue.author\",\
		\"weight\": 1766,\
		\"max\": \"1\",\
		\"type\": \"Reference\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"DetectedIssue.identifier\",\
		\"weight\": 1767,\
		\"max\": \"1\",\
		\"type\": \"Identifier\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"DetectedIssue.reference\",\
		\"weight\": 1768,\
		\"max\": \"1\",\
		\"type\": \"uri\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"DetectedIssue.mitigation\",\
		\"weight\": 1769,\
		\"max\": \"*\",\
		\"type\": \"BackboneElement\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"DetectedIssue.mitigation.id\",\
		\"weight\": 1770,\
		\"max\": \"1\",\
		\"type\": \"id\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"DetectedIssue.mitigation.extension\",\
		\"weight\": 1771,\
		\"max\": \"*\",\
		\"type\": \"Extension\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"DetectedIssue.mitigation.modifierExtension\",\
		\"weight\": 1772,\
		\"max\": \"*\",\
		\"type\": \"Extension\"\
	},\
	{\
		\"min\": \"1\",\
		\"path\": \"DetectedIssue.mitigation.action\",\
		\"weight\": 1773,\
		\"max\": \"1\",\
		\"type\": \"CodeableConcept\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"DetectedIssue.mitigation.date\",\
		\"weight\": 1774,\
		\"max\": \"1\",\
		\"type\": \"dateTime\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"DetectedIssue.mitigation.author\",\
		\"weight\": 1775,\
		\"max\": \"1\",\
		\"type\": \"Reference\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Device\",\
		\"weight\": 1776,\
		\"max\": \"*\",\
		\"type\": \"DomainResource\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Device.id\",\
		\"weight\": 1777,\
		\"max\": \"1\",\
		\"type\": \"id\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Device.meta\",\
		\"weight\": 1778,\
		\"max\": \"1\",\
		\"type\": \"Meta\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Device.implicitRules\",\
		\"weight\": 1779,\
		\"max\": \"1\",\
		\"type\": \"uri\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Device.language\",\
		\"weight\": 1780,\
		\"max\": \"1\",\
		\"type\": \"code\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Device.text\",\
		\"weight\": 1781,\
		\"max\": \"1\",\
		\"type\": \"Narrative\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Device.contained\",\
		\"weight\": 1782,\
		\"max\": \"*\",\
		\"type\": \"Resource\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Device.extension\",\
		\"weight\": 1783,\
		\"max\": \"*\",\
		\"type\": \"Extension\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Device.modifierExtension\",\
		\"weight\": 1784,\
		\"max\": \"*\",\
		\"type\": \"Extension\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Device.identifier\",\
		\"weight\": 1785,\
		\"max\": \"*\",\
		\"type\": \"Identifier\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Device.udiCarrier\",\
		\"weight\": 1786,\
		\"max\": \"1\",\
		\"type\": \"Identifier\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Device.status\",\
		\"weight\": 1787,\
		\"max\": \"1\",\
		\"type\": \"code\"\
	},\
	{\
		\"min\": \"1\",\
		\"path\": \"Device.type\",\
		\"weight\": 1788,\
		\"max\": \"1\",\
		\"type\": \"CodeableConcept\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Device.lotNumber\",\
		\"weight\": 1789,\
		\"max\": \"1\",\
		\"type\": \"string\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Device.manufacturer\",\
		\"weight\": 1790,\
		\"max\": \"1\",\
		\"type\": \"string\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Device.manufactureDate\",\
		\"weight\": 1791,\
		\"max\": \"1\",\
		\"type\": \"dateTime\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Device.expirationDate\",\
		\"weight\": 1792,\
		\"max\": \"1\",\
		\"type\": \"dateTime\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Device.model\",\
		\"weight\": 1793,\
		\"max\": \"1\",\
		\"type\": \"string\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Device.version\",\
		\"weight\": 1794,\
		\"max\": \"1\",\
		\"type\": \"string\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Device.patient\",\
		\"weight\": 1795,\
		\"max\": \"1\",\
		\"type\": \"Reference\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Device.owner\",\
		\"weight\": 1796,\
		\"max\": \"1\",\
		\"type\": \"Reference\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Device.contact\",\
		\"weight\": 1797,\
		\"max\": \"*\",\
		\"type\": \"ContactPoint\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Device.location\",\
		\"weight\": 1798,\
		\"max\": \"1\",\
		\"type\": \"Reference\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Device.url\",\
		\"weight\": 1799,\
		\"max\": \"1\",\
		\"type\": \"uri\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Device.note\",\
		\"weight\": 1800,\
		\"max\": \"*\",\
		\"type\": \"Annotation\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"DeviceComponent\",\
		\"weight\": 1801,\
		\"max\": \"*\",\
		\"type\": \"DomainResource\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"DeviceComponent.id\",\
		\"weight\": 1802,\
		\"max\": \"1\",\
		\"type\": \"id\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"DeviceComponent.meta\",\
		\"weight\": 1803,\
		\"max\": \"1\",\
		\"type\": \"Meta\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"DeviceComponent.implicitRules\",\
		\"weight\": 1804,\
		\"max\": \"1\",\
		\"type\": \"uri\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"DeviceComponent.language\",\
		\"weight\": 1805,\
		\"max\": \"1\",\
		\"type\": \"code\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"DeviceComponent.text\",\
		\"weight\": 1806,\
		\"max\": \"1\",\
		\"type\": \"Narrative\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"DeviceComponent.contained\",\
		\"weight\": 1807,\
		\"max\": \"*\",\
		\"type\": \"Resource\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"DeviceComponent.extension\",\
		\"weight\": 1808,\
		\"max\": \"*\",\
		\"type\": \"Extension\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"DeviceComponent.modifierExtension\",\
		\"weight\": 1809,\
		\"max\": \"*\",\
		\"type\": \"Extension\"\
	},\
	{\
		\"min\": \"1\",\
		\"path\": \"DeviceComponent.type\",\
		\"weight\": 1810,\
		\"max\": \"1\",\
		\"type\": \"CodeableConcept\"\
	},\
	{\
		\"min\": \"1\",\
		\"path\": \"DeviceComponent.identifier\",\
		\"weight\": 1811,\
		\"max\": \"1\",\
		\"type\": \"Identifier\"\
	},\
	{\
		\"min\": \"1\",\
		\"path\": \"DeviceComponent.lastSystemChange\",\
		\"weight\": 1812,\
		\"max\": \"1\",\
		\"type\": \"instant\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"DeviceComponent.source\",\
		\"weight\": 1813,\
		\"max\": \"1\",\
		\"type\": \"Reference\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"DeviceComponent.parent\",\
		\"weight\": 1814,\
		\"max\": \"1\",\
		\"type\": \"Reference\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"DeviceComponent.operationalStatus\",\
		\"weight\": 1815,\
		\"max\": \"*\",\
		\"type\": \"CodeableConcept\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"DeviceComponent.parameterGroup\",\
		\"weight\": 1816,\
		\"max\": \"1\",\
		\"type\": \"CodeableConcept\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"DeviceComponent.measurementPrinciple\",\
		\"weight\": 1817,\
		\"max\": \"1\",\
		\"type\": \"code\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"DeviceComponent.productionSpecification\",\
		\"weight\": 1818,\
		\"max\": \"*\",\
		\"type\": \"BackboneElement\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"DeviceComponent.productionSpecification.id\",\
		\"weight\": 1819,\
		\"max\": \"1\",\
		\"type\": \"id\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"DeviceComponent.productionSpecification.extension\",\
		\"weight\": 1820,\
		\"max\": \"*\",\
		\"type\": \"Extension\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"DeviceComponent.productionSpecification.modifierExtension\",\
		\"weight\": 1821,\
		\"max\": \"*\",\
		\"type\": \"Extension\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"DeviceComponent.productionSpecification.specType\",\
		\"weight\": 1822,\
		\"max\": \"1\",\
		\"type\": \"CodeableConcept\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"DeviceComponent.productionSpecification.componentId\",\
		\"weight\": 1823,\
		\"max\": \"1\",\
		\"type\": \"Identifier\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"DeviceComponent.productionSpecification.productionSpec\",\
		\"weight\": 1824,\
		\"max\": \"1\",\
		\"type\": \"string\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"DeviceComponent.languageCode\",\
		\"weight\": 1825,\
		\"max\": \"1\",\
		\"type\": \"CodeableConcept\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"DeviceMetric\",\
		\"weight\": 1826,\
		\"max\": \"*\",\
		\"type\": \"DomainResource\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"DeviceMetric.id\",\
		\"weight\": 1827,\
		\"max\": \"1\",\
		\"type\": \"id\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"DeviceMetric.meta\",\
		\"weight\": 1828,\
		\"max\": \"1\",\
		\"type\": \"Meta\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"DeviceMetric.implicitRules\",\
		\"weight\": 1829,\
		\"max\": \"1\",\
		\"type\": \"uri\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"DeviceMetric.language\",\
		\"weight\": 1830,\
		\"max\": \"1\",\
		\"type\": \"code\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"DeviceMetric.text\",\
		\"weight\": 1831,\
		\"max\": \"1\",\
		\"type\": \"Narrative\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"DeviceMetric.contained\",\
		\"weight\": 1832,\
		\"max\": \"*\",\
		\"type\": \"Resource\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"DeviceMetric.extension\",\
		\"weight\": 1833,\
		\"max\": \"*\",\
		\"type\": \"Extension\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"DeviceMetric.modifierExtension\",\
		\"weight\": 1834,\
		\"max\": \"*\",\
		\"type\": \"Extension\"\
	},\
	{\
		\"min\": \"1\",\
		\"path\": \"DeviceMetric.type\",\
		\"weight\": 1835,\
		\"max\": \"1\",\
		\"type\": \"CodeableConcept\"\
	},\
	{\
		\"min\": \"1\",\
		\"path\": \"DeviceMetric.identifier\",\
		\"weight\": 1836,\
		\"max\": \"1\",\
		\"type\": \"Identifier\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"DeviceMetric.unit\",\
		\"weight\": 1837,\
		\"max\": \"1\",\
		\"type\": \"CodeableConcept\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"DeviceMetric.source\",\
		\"weight\": 1838,\
		\"max\": \"1\",\
		\"type\": \"Reference\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"DeviceMetric.parent\",\
		\"weight\": 1839,\
		\"max\": \"1\",\
		\"type\": \"Reference\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"DeviceMetric.operationalStatus\",\
		\"weight\": 1840,\
		\"max\": \"1\",\
		\"type\": \"code\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"DeviceMetric.color\",\
		\"weight\": 1841,\
		\"max\": \"1\",\
		\"type\": \"code\"\
	},\
	{\
		\"min\": \"1\",\
		\"path\": \"DeviceMetric.category\",\
		\"weight\": 1842,\
		\"max\": \"1\",\
		\"type\": \"code\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"DeviceMetric.measurementPeriod\",\
		\"weight\": 1843,\
		\"max\": \"1\",\
		\"type\": \"Timing\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"DeviceMetric.calibration\",\
		\"weight\": 1844,\
		\"max\": \"*\",\
		\"type\": \"BackboneElement\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"DeviceMetric.calibration.id\",\
		\"weight\": 1845,\
		\"max\": \"1\",\
		\"type\": \"id\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"DeviceMetric.calibration.extension\",\
		\"weight\": 1846,\
		\"max\": \"*\",\
		\"type\": \"Extension\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"DeviceMetric.calibration.modifierExtension\",\
		\"weight\": 1847,\
		\"max\": \"*\",\
		\"type\": \"Extension\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"DeviceMetric.calibration.type\",\
		\"weight\": 1848,\
		\"max\": \"1\",\
		\"type\": \"code\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"DeviceMetric.calibration.state\",\
		\"weight\": 1849,\
		\"max\": \"1\",\
		\"type\": \"code\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"DeviceMetric.calibration.time\",\
		\"weight\": 1850,\
		\"max\": \"1\",\
		\"type\": \"instant\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"DeviceUseRequest\",\
		\"weight\": 1851,\
		\"max\": \"*\",\
		\"type\": \"DomainResource\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"DeviceUseRequest.id\",\
		\"weight\": 1852,\
		\"max\": \"1\",\
		\"type\": \"id\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"DeviceUseRequest.meta\",\
		\"weight\": 1853,\
		\"max\": \"1\",\
		\"type\": \"Meta\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"DeviceUseRequest.implicitRules\",\
		\"weight\": 1854,\
		\"max\": \"1\",\
		\"type\": \"uri\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"DeviceUseRequest.language\",\
		\"weight\": 1855,\
		\"max\": \"1\",\
		\"type\": \"code\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"DeviceUseRequest.text\",\
		\"weight\": 1856,\
		\"max\": \"1\",\
		\"type\": \"Narrative\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"DeviceUseRequest.contained\",\
		\"weight\": 1857,\
		\"max\": \"*\",\
		\"type\": \"Resource\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"DeviceUseRequest.extension\",\
		\"weight\": 1858,\
		\"max\": \"*\",\
		\"type\": \"Extension\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"DeviceUseRequest.modifierExtension\",\
		\"weight\": 1859,\
		\"max\": \"*\",\
		\"type\": \"Extension\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"DeviceUseRequest.bodySiteCodeableConcept\",\
		\"weight\": 1860,\
		\"max\": \"1\",\
		\"type\": \"CodeableConcept\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"DeviceUseRequest.bodySiteReference\",\
		\"weight\": 1860,\
		\"max\": \"1\",\
		\"type\": \"Reference\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"DeviceUseRequest.status\",\
		\"weight\": 1861,\
		\"max\": \"1\",\
		\"type\": \"code\"\
	},\
	{\
		\"min\": \"1\",\
		\"path\": \"DeviceUseRequest.device\",\
		\"weight\": 1862,\
		\"max\": \"1\",\
		\"type\": \"Reference\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"DeviceUseRequest.encounter\",\
		\"weight\": 1863,\
		\"max\": \"1\",\
		\"type\": \"Reference\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"DeviceUseRequest.identifier\",\
		\"weight\": 1864,\
		\"max\": \"*\",\
		\"type\": \"Identifier\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"DeviceUseRequest.indication\",\
		\"weight\": 1865,\
		\"max\": \"*\",\
		\"type\": \"CodeableConcept\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"DeviceUseRequest.notes\",\
		\"weight\": 1866,\
		\"max\": \"*\",\
		\"type\": \"string\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"DeviceUseRequest.prnReason\",\
		\"weight\": 1867,\
		\"max\": \"*\",\
		\"type\": \"CodeableConcept\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"DeviceUseRequest.orderedOn\",\
		\"weight\": 1868,\
		\"max\": \"1\",\
		\"type\": \"dateTime\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"DeviceUseRequest.recordedOn\",\
		\"weight\": 1869,\
		\"max\": \"1\",\
		\"type\": \"dateTime\"\
	},\
	{\
		\"min\": \"1\",\
		\"path\": \"DeviceUseRequest.subject\",\
		\"weight\": 1870,\
		\"max\": \"1\",\
		\"type\": \"Reference\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"DeviceUseRequest.timingTiming\",\
		\"weight\": 1871,\
		\"max\": \"1\",\
		\"type\": \"Timing\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"DeviceUseRequest.timingPeriod\",\
		\"weight\": 1871,\
		\"max\": \"1\",\
		\"type\": \"Period\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"DeviceUseRequest.timingDateTime\",\
		\"weight\": 1871,\
		\"max\": \"1\",\
		\"type\": \"dateTime\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"DeviceUseRequest.priority\",\
		\"weight\": 1872,\
		\"max\": \"1\",\
		\"type\": \"code\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"DeviceUseStatement\",\
		\"weight\": 1873,\
		\"max\": \"*\",\
		\"type\": \"DomainResource\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"DeviceUseStatement.id\",\
		\"weight\": 1874,\
		\"max\": \"1\",\
		\"type\": \"id\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"DeviceUseStatement.meta\",\
		\"weight\": 1875,\
		\"max\": \"1\",\
		\"type\": \"Meta\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"DeviceUseStatement.implicitRules\",\
		\"weight\": 1876,\
		\"max\": \"1\",\
		\"type\": \"uri\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"DeviceUseStatement.language\",\
		\"weight\": 1877,\
		\"max\": \"1\",\
		\"type\": \"code\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"DeviceUseStatement.text\",\
		\"weight\": 1878,\
		\"max\": \"1\",\
		\"type\": \"Narrative\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"DeviceUseStatement.contained\",\
		\"weight\": 1879,\
		\"max\": \"*\",\
		\"type\": \"Resource\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"DeviceUseStatement.extension\",\
		\"weight\": 1880,\
		\"max\": \"*\",\
		\"type\": \"Extension\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"DeviceUseStatement.modifierExtension\",\
		\"weight\": 1881,\
		\"max\": \"*\",\
		\"type\": \"Extension\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"DeviceUseStatement.bodySiteCodeableConcept\",\
		\"weight\": 1882,\
		\"max\": \"1\",\
		\"type\": \"CodeableConcept\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"DeviceUseStatement.bodySiteReference\",\
		\"weight\": 1882,\
		\"max\": \"1\",\
		\"type\": \"Reference\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"DeviceUseStatement.whenUsed\",\
		\"weight\": 1883,\
		\"max\": \"1\",\
		\"type\": \"Period\"\
	},\
	{\
		\"min\": \"1\",\
		\"path\": \"DeviceUseStatement.device\",\
		\"weight\": 1884,\
		\"max\": \"1\",\
		\"type\": \"Reference\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"DeviceUseStatement.identifier\",\
		\"weight\": 1885,\
		\"max\": \"*\",\
		\"type\": \"Identifier\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"DeviceUseStatement.indication\",\
		\"weight\": 1886,\
		\"max\": \"*\",\
		\"type\": \"CodeableConcept\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"DeviceUseStatement.notes\",\
		\"weight\": 1887,\
		\"max\": \"*\",\
		\"type\": \"string\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"DeviceUseStatement.recordedOn\",\
		\"weight\": 1888,\
		\"max\": \"1\",\
		\"type\": \"dateTime\"\
	},\
	{\
		\"min\": \"1\",\
		\"path\": \"DeviceUseStatement.subject\",\
		\"weight\": 1889,\
		\"max\": \"1\",\
		\"type\": \"Reference\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"DeviceUseStatement.timingTiming\",\
		\"weight\": 1890,\
		\"max\": \"1\",\
		\"type\": \"Timing\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"DeviceUseStatement.timingPeriod\",\
		\"weight\": 1890,\
		\"max\": \"1\",\
		\"type\": \"Period\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"DeviceUseStatement.timingDateTime\",\
		\"weight\": 1890,\
		\"max\": \"1\",\
		\"type\": \"dateTime\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"DiagnosticOrder\",\
		\"weight\": 1891,\
		\"max\": \"*\",\
		\"type\": \"DomainResource\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"DiagnosticOrder.id\",\
		\"weight\": 1892,\
		\"max\": \"1\",\
		\"type\": \"id\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"DiagnosticOrder.meta\",\
		\"weight\": 1893,\
		\"max\": \"1\",\
		\"type\": \"Meta\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"DiagnosticOrder.implicitRules\",\
		\"weight\": 1894,\
		\"max\": \"1\",\
		\"type\": \"uri\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"DiagnosticOrder.language\",\
		\"weight\": 1895,\
		\"max\": \"1\",\
		\"type\": \"code\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"DiagnosticOrder.text\",\
		\"weight\": 1896,\
		\"max\": \"1\",\
		\"type\": \"Narrative\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"DiagnosticOrder.contained\",\
		\"weight\": 1897,\
		\"max\": \"*\",\
		\"type\": \"Resource\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"DiagnosticOrder.extension\",\
		\"weight\": 1898,\
		\"max\": \"*\",\
		\"type\": \"Extension\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"DiagnosticOrder.modifierExtension\",\
		\"weight\": 1899,\
		\"max\": \"*\",\
		\"type\": \"Extension\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"DiagnosticOrder.identifier\",\
		\"weight\": 1900,\
		\"max\": \"*\",\
		\"type\": \"Identifier\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"DiagnosticOrder.status\",\
		\"weight\": 1901,\
		\"max\": \"1\",\
		\"type\": \"code\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"DiagnosticOrder.priority\",\
		\"weight\": 1902,\
		\"max\": \"1\",\
		\"type\": \"code\"\
	},\
	{\
		\"min\": \"1\",\
		\"path\": \"DiagnosticOrder.subject\",\
		\"weight\": 1903,\
		\"max\": \"1\",\
		\"type\": \"Reference\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"DiagnosticOrder.encounter\",\
		\"weight\": 1904,\
		\"max\": \"1\",\
		\"type\": \"Reference\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"DiagnosticOrder.orderer\",\
		\"weight\": 1905,\
		\"max\": \"1\",\
		\"type\": \"Reference\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"DiagnosticOrder.reason\",\
		\"weight\": 1906,\
		\"max\": \"*\",\
		\"type\": \"CodeableConcept\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"DiagnosticOrder.supportingInformation\",\
		\"weight\": 1907,\
		\"max\": \"*\",\
		\"type\": \"Reference\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"DiagnosticOrder.specimen\",\
		\"weight\": 1908,\
		\"max\": \"*\",\
		\"type\": \"Reference\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"DiagnosticOrder.event\",\
		\"weight\": 1909,\
		\"max\": \"*\",\
		\"type\": \"BackboneElement\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"DiagnosticOrder.event.id\",\
		\"weight\": 1910,\
		\"max\": \"1\",\
		\"type\": \"id\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"DiagnosticOrder.event.extension\",\
		\"weight\": 1911,\
		\"max\": \"*\",\
		\"type\": \"Extension\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"DiagnosticOrder.event.modifierExtension\",\
		\"weight\": 1912,\
		\"max\": \"*\",\
		\"type\": \"Extension\"\
	},\
	{\
		\"min\": \"1\",\
		\"path\": \"DiagnosticOrder.event.status\",\
		\"weight\": 1913,\
		\"max\": \"1\",\
		\"type\": \"code\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"DiagnosticOrder.event.description\",\
		\"weight\": 1914,\
		\"max\": \"1\",\
		\"type\": \"CodeableConcept\"\
	},\
	{\
		\"min\": \"1\",\
		\"path\": \"DiagnosticOrder.event.dateTime\",\
		\"weight\": 1915,\
		\"max\": \"1\",\
		\"type\": \"dateTime\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"DiagnosticOrder.event.actor\",\
		\"weight\": 1916,\
		\"max\": \"1\",\
		\"type\": \"Reference\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"DiagnosticOrder.item\",\
		\"weight\": 1917,\
		\"max\": \"*\",\
		\"type\": \"BackboneElement\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"DiagnosticOrder.item.id\",\
		\"weight\": 1918,\
		\"max\": \"1\",\
		\"type\": \"id\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"DiagnosticOrder.item.extension\",\
		\"weight\": 1919,\
		\"max\": \"*\",\
		\"type\": \"Extension\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"DiagnosticOrder.item.modifierExtension\",\
		\"weight\": 1920,\
		\"max\": \"*\",\
		\"type\": \"Extension\"\
	},\
	{\
		\"min\": \"1\",\
		\"path\": \"DiagnosticOrder.item.code\",\
		\"weight\": 1921,\
		\"max\": \"1\",\
		\"type\": \"CodeableConcept\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"DiagnosticOrder.item.specimen\",\
		\"weight\": 1922,\
		\"max\": \"*\",\
		\"type\": \"Reference\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"DiagnosticOrder.item.bodySite\",\
		\"weight\": 1923,\
		\"max\": \"1\",\
		\"type\": \"CodeableConcept\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"DiagnosticOrder.item.status\",\
		\"weight\": 1924,\
		\"max\": \"1\",\
		\"type\": \"code\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"DiagnosticOrder.item.event\",\
		\"weight\": 1925,\
		\"max\": \"*\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"DiagnosticOrder.note\",\
		\"weight\": 1926,\
		\"max\": \"*\",\
		\"type\": \"Annotation\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"DiagnosticReport\",\
		\"weight\": 1927,\
		\"max\": \"*\",\
		\"type\": \"DomainResource\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"DiagnosticReport.id\",\
		\"weight\": 1928,\
		\"max\": \"1\",\
		\"type\": \"id\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"DiagnosticReport.meta\",\
		\"weight\": 1929,\
		\"max\": \"1\",\
		\"type\": \"Meta\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"DiagnosticReport.implicitRules\",\
		\"weight\": 1930,\
		\"max\": \"1\",\
		\"type\": \"uri\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"DiagnosticReport.language\",\
		\"weight\": 1931,\
		\"max\": \"1\",\
		\"type\": \"code\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"DiagnosticReport.text\",\
		\"weight\": 1932,\
		\"max\": \"1\",\
		\"type\": \"Narrative\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"DiagnosticReport.contained\",\
		\"weight\": 1933,\
		\"max\": \"*\",\
		\"type\": \"Resource\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"DiagnosticReport.extension\",\
		\"weight\": 1934,\
		\"max\": \"*\",\
		\"type\": \"Extension\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"DiagnosticReport.modifierExtension\",\
		\"weight\": 1935,\
		\"max\": \"*\",\
		\"type\": \"Extension\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"DiagnosticReport.identifier\",\
		\"weight\": 1936,\
		\"max\": \"*\",\
		\"type\": \"Identifier\"\
	},\
	{\
		\"min\": \"1\",\
		\"path\": \"DiagnosticReport.status\",\
		\"weight\": 1937,\
		\"max\": \"1\",\
		\"type\": \"code\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"DiagnosticReport.category\",\
		\"weight\": 1938,\
		\"max\": \"1\",\
		\"type\": \"CodeableConcept\"\
	},\
	{\
		\"min\": \"1\",\
		\"path\": \"DiagnosticReport.code\",\
		\"weight\": 1939,\
		\"max\": \"1\",\
		\"type\": \"CodeableConcept\"\
	},\
	{\
		\"min\": \"1\",\
		\"path\": \"DiagnosticReport.subject\",\
		\"weight\": 1940,\
		\"max\": \"1\",\
		\"type\": \"Reference\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"DiagnosticReport.encounter\",\
		\"weight\": 1941,\
		\"max\": \"1\",\
		\"type\": \"Reference\"\
	},\
	{\
		\"min\": \"1\",\
		\"path\": \"DiagnosticReport.effectiveDateTime\",\
		\"weight\": 1942,\
		\"max\": \"1\",\
		\"type\": \"dateTime\"\
	},\
	{\
		\"min\": \"1\",\
		\"path\": \"DiagnosticReport.effectivePeriod\",\
		\"weight\": 1942,\
		\"max\": \"1\",\
		\"type\": \"Period\"\
	},\
	{\
		\"min\": \"1\",\
		\"path\": \"DiagnosticReport.issued\",\
		\"weight\": 1943,\
		\"max\": \"1\",\
		\"type\": \"instant\"\
	},\
	{\
		\"min\": \"1\",\
		\"path\": \"DiagnosticReport.performer\",\
		\"weight\": 1944,\
		\"max\": \"1\",\
		\"type\": \"Reference\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"DiagnosticReport.request\",\
		\"weight\": 1945,\
		\"max\": \"*\",\
		\"type\": \"Reference\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"DiagnosticReport.specimen\",\
		\"weight\": 1946,\
		\"max\": \"*\",\
		\"type\": \"Reference\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"DiagnosticReport.result\",\
		\"weight\": 1947,\
		\"max\": \"*\",\
		\"type\": \"Reference\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"DiagnosticReport.imagingStudy\",\
		\"weight\": 1948,\
		\"max\": \"*\",\
		\"type\": \"Reference\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"DiagnosticReport.image\",\
		\"weight\": 1949,\
		\"max\": \"*\",\
		\"type\": \"BackboneElement\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"DiagnosticReport.image.id\",\
		\"weight\": 1950,\
		\"max\": \"1\",\
		\"type\": \"id\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"DiagnosticReport.image.extension\",\
		\"weight\": 1951,\
		\"max\": \"*\",\
		\"type\": \"Extension\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"DiagnosticReport.image.modifierExtension\",\
		\"weight\": 1952,\
		\"max\": \"*\",\
		\"type\": \"Extension\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"DiagnosticReport.image.comment\",\
		\"weight\": 1953,\
		\"max\": \"1\",\
		\"type\": \"string\"\
	},\
	{\
		\"min\": \"1\",\
		\"path\": \"DiagnosticReport.image.link\",\
		\"weight\": 1954,\
		\"max\": \"1\",\
		\"type\": \"Reference\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"DiagnosticReport.conclusion\",\
		\"weight\": 1955,\
		\"max\": \"1\",\
		\"type\": \"string\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"DiagnosticReport.codedDiagnosis\",\
		\"weight\": 1956,\
		\"max\": \"*\",\
		\"type\": \"CodeableConcept\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"DiagnosticReport.presentedForm\",\
		\"weight\": 1957,\
		\"max\": \"*\",\
		\"type\": \"Attachment\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"DocumentManifest\",\
		\"weight\": 1958,\
		\"max\": \"*\",\
		\"type\": \"DomainResource\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"DocumentManifest.id\",\
		\"weight\": 1959,\
		\"max\": \"1\",\
		\"type\": \"id\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"DocumentManifest.meta\",\
		\"weight\": 1960,\
		\"max\": \"1\",\
		\"type\": \"Meta\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"DocumentManifest.implicitRules\",\
		\"weight\": 1961,\
		\"max\": \"1\",\
		\"type\": \"uri\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"DocumentManifest.language\",\
		\"weight\": 1962,\
		\"max\": \"1\",\
		\"type\": \"code\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"DocumentManifest.text\",\
		\"weight\": 1963,\
		\"max\": \"1\",\
		\"type\": \"Narrative\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"DocumentManifest.contained\",\
		\"weight\": 1964,\
		\"max\": \"*\",\
		\"type\": \"Resource\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"DocumentManifest.extension\",\
		\"weight\": 1965,\
		\"max\": \"*\",\
		\"type\": \"Extension\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"DocumentManifest.modifierExtension\",\
		\"weight\": 1966,\
		\"max\": \"*\",\
		\"type\": \"Extension\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"DocumentManifest.masterIdentifier\",\
		\"weight\": 1967,\
		\"max\": \"1\",\
		\"type\": \"Identifier\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"DocumentManifest.identifier\",\
		\"weight\": 1968,\
		\"max\": \"*\",\
		\"type\": \"Identifier\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"DocumentManifest.subject\",\
		\"weight\": 1969,\
		\"max\": \"1\",\
		\"type\": \"Reference\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"DocumentManifest.recipient\",\
		\"weight\": 1970,\
		\"max\": \"*\",\
		\"type\": \"Reference\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"DocumentManifest.type\",\
		\"weight\": 1971,\
		\"max\": \"1\",\
		\"type\": \"CodeableConcept\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"DocumentManifest.author\",\
		\"weight\": 1972,\
		\"max\": \"*\",\
		\"type\": \"Reference\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"DocumentManifest.created\",\
		\"weight\": 1973,\
		\"max\": \"1\",\
		\"type\": \"dateTime\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"DocumentManifest.source\",\
		\"weight\": 1974,\
		\"max\": \"1\",\
		\"type\": \"uri\"\
	},\
	{\
		\"min\": \"1\",\
		\"path\": \"DocumentManifest.status\",\
		\"weight\": 1975,\
		\"max\": \"1\",\
		\"type\": \"code\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"DocumentManifest.description\",\
		\"weight\": 1976,\
		\"max\": \"1\",\
		\"type\": \"string\"\
	},\
	{\
		\"min\": \"1\",\
		\"path\": \"DocumentManifest.content\",\
		\"weight\": 1977,\
		\"max\": \"*\",\
		\"type\": \"BackboneElement\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"DocumentManifest.content.id\",\
		\"weight\": 1978,\
		\"max\": \"1\",\
		\"type\": \"id\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"DocumentManifest.content.extension\",\
		\"weight\": 1979,\
		\"max\": \"*\",\
		\"type\": \"Extension\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"DocumentManifest.content.modifierExtension\",\
		\"weight\": 1980,\
		\"max\": \"*\",\
		\"type\": \"Extension\"\
	},\
	{\
		\"min\": \"1\",\
		\"path\": \"DocumentManifest.content.pAttachment\",\
		\"weight\": 1981,\
		\"max\": \"1\",\
		\"type\": \"Attachment\"\
	},\
	{\
		\"min\": \"1\",\
		\"path\": \"DocumentManifest.content.pReference\",\
		\"weight\": 1981,\
		\"max\": \"1\",\
		\"type\": \"Reference\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"DocumentManifest.related\",\
		\"weight\": 1982,\
		\"max\": \"*\",\
		\"type\": \"BackboneElement\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"DocumentManifest.related.id\",\
		\"weight\": 1983,\
		\"max\": \"1\",\
		\"type\": \"id\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"DocumentManifest.related.extension\",\
		\"weight\": 1984,\
		\"max\": \"*\",\
		\"type\": \"Extension\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"DocumentManifest.related.modifierExtension\",\
		\"weight\": 1985,\
		\"max\": \"*\",\
		\"type\": \"Extension\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"DocumentManifest.related.identifier\",\
		\"weight\": 1986,\
		\"max\": \"1\",\
		\"type\": \"Identifier\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"DocumentManifest.related.ref\",\
		\"weight\": 1987,\
		\"max\": \"1\",\
		\"type\": \"Reference\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"DocumentReference\",\
		\"weight\": 1988,\
		\"max\": \"*\",\
		\"type\": \"DomainResource\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"DocumentReference.id\",\
		\"weight\": 1989,\
		\"max\": \"1\",\
		\"type\": \"id\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"DocumentReference.meta\",\
		\"weight\": 1990,\
		\"max\": \"1\",\
		\"type\": \"Meta\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"DocumentReference.implicitRules\",\
		\"weight\": 1991,\
		\"max\": \"1\",\
		\"type\": \"uri\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"DocumentReference.language\",\
		\"weight\": 1992,\
		\"max\": \"1\",\
		\"type\": \"code\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"DocumentReference.text\",\
		\"weight\": 1993,\
		\"max\": \"1\",\
		\"type\": \"Narrative\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"DocumentReference.contained\",\
		\"weight\": 1994,\
		\"max\": \"*\",\
		\"type\": \"Resource\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"DocumentReference.extension\",\
		\"weight\": 1995,\
		\"max\": \"*\",\
		\"type\": \"Extension\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"DocumentReference.modifierExtension\",\
		\"weight\": 1996,\
		\"max\": \"*\",\
		\"type\": \"Extension\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"DocumentReference.masterIdentifier\",\
		\"weight\": 1997,\
		\"max\": \"1\",\
		\"type\": \"Identifier\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"DocumentReference.identifier\",\
		\"weight\": 1998,\
		\"max\": \"*\",\
		\"type\": \"Identifier\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"DocumentReference.subject\",\
		\"weight\": 1999,\
		\"max\": \"1\",\
		\"type\": \"Reference\"\
	},\
	{\
		\"min\": \"1\",\
		\"path\": \"DocumentReference.type\",\
		\"weight\": 2000,\
		\"max\": \"1\",\
		\"type\": \"CodeableConcept\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"DocumentReference.class\",\
		\"weight\": 2001,\
		\"max\": \"1\",\
		\"type\": \"CodeableConcept\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"DocumentReference.author\",\
		\"weight\": 2002,\
		\"max\": \"*\",\
		\"type\": \"Reference\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"DocumentReference.custodian\",\
		\"weight\": 2003,\
		\"max\": \"1\",\
		\"type\": \"Reference\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"DocumentReference.authenticator\",\
		\"weight\": 2004,\
		\"max\": \"1\",\
		\"type\": \"Reference\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"DocumentReference.created\",\
		\"weight\": 2005,\
		\"max\": \"1\",\
		\"type\": \"dateTime\"\
	},\
	{\
		\"min\": \"1\",\
		\"path\": \"DocumentReference.indexed\",\
		\"weight\": 2006,\
		\"max\": \"1\",\
		\"type\": \"instant\"\
	},\
	{\
		\"min\": \"1\",\
		\"path\": \"DocumentReference.status\",\
		\"weight\": 2007,\
		\"max\": \"1\",\
		\"type\": \"code\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"DocumentReference.docStatus\",\
		\"weight\": 2008,\
		\"max\": \"1\",\
		\"type\": \"CodeableConcept\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"DocumentReference.relatesTo\",\
		\"weight\": 2009,\
		\"max\": \"*\",\
		\"type\": \"BackboneElement\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"DocumentReference.relatesTo.id\",\
		\"weight\": 2010,\
		\"max\": \"1\",\
		\"type\": \"id\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"DocumentReference.relatesTo.extension\",\
		\"weight\": 2011,\
		\"max\": \"*\",\
		\"type\": \"Extension\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"DocumentReference.relatesTo.modifierExtension\",\
		\"weight\": 2012,\
		\"max\": \"*\",\
		\"type\": \"Extension\"\
	},\
	{\
		\"min\": \"1\",\
		\"path\": \"DocumentReference.relatesTo.code\",\
		\"weight\": 2013,\
		\"max\": \"1\",\
		\"type\": \"code\"\
	},\
	{\
		\"min\": \"1\",\
		\"path\": \"DocumentReference.relatesTo.target\",\
		\"weight\": 2014,\
		\"max\": \"1\",\
		\"type\": \"Reference\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"DocumentReference.description\",\
		\"weight\": 2015,\
		\"max\": \"1\",\
		\"type\": \"string\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"DocumentReference.securityLabel\",\
		\"weight\": 2016,\
		\"max\": \"*\",\
		\"type\": \"CodeableConcept\"\
	},\
	{\
		\"min\": \"1\",\
		\"path\": \"DocumentReference.content\",\
		\"weight\": 2017,\
		\"max\": \"*\",\
		\"type\": \"BackboneElement\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"DocumentReference.content.id\",\
		\"weight\": 2018,\
		\"max\": \"1\",\
		\"type\": \"id\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"DocumentReference.content.extension\",\
		\"weight\": 2019,\
		\"max\": \"*\",\
		\"type\": \"Extension\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"DocumentReference.content.modifierExtension\",\
		\"weight\": 2020,\
		\"max\": \"*\",\
		\"type\": \"Extension\"\
	},\
	{\
		\"min\": \"1\",\
		\"path\": \"DocumentReference.content.attachment\",\
		\"weight\": 2021,\
		\"max\": \"1\",\
		\"type\": \"Attachment\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"DocumentReference.content.format\",\
		\"weight\": 2022,\
		\"max\": \"*\",\
		\"type\": \"Coding\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"DocumentReference.context\",\
		\"weight\": 2023,\
		\"max\": \"1\",\
		\"type\": \"BackboneElement\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"DocumentReference.context.id\",\
		\"weight\": 2024,\
		\"max\": \"1\",\
		\"type\": \"id\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"DocumentReference.context.extension\",\
		\"weight\": 2025,\
		\"max\": \"*\",\
		\"type\": \"Extension\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"DocumentReference.context.modifierExtension\",\
		\"weight\": 2026,\
		\"max\": \"*\",\
		\"type\": \"Extension\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"DocumentReference.context.encounter\",\
		\"weight\": 2027,\
		\"max\": \"1\",\
		\"type\": \"Reference\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"DocumentReference.context.event\",\
		\"weight\": 2028,\
		\"max\": \"*\",\
		\"type\": \"CodeableConcept\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"DocumentReference.context.period\",\
		\"weight\": 2029,\
		\"max\": \"1\",\
		\"type\": \"Period\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"DocumentReference.context.facilityType\",\
		\"weight\": 2030,\
		\"max\": \"1\",\
		\"type\": \"CodeableConcept\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"DocumentReference.context.practiceSetting\",\
		\"weight\": 2031,\
		\"max\": \"1\",\
		\"type\": \"CodeableConcept\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"DocumentReference.context.sourcePatientInfo\",\
		\"weight\": 2032,\
		\"max\": \"1\",\
		\"type\": \"Reference\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"DocumentReference.context.related\",\
		\"weight\": 2033,\
		\"max\": \"*\",\
		\"type\": \"BackboneElement\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"DocumentReference.context.related.id\",\
		\"weight\": 2034,\
		\"max\": \"1\",\
		\"type\": \"id\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"DocumentReference.context.related.extension\",\
		\"weight\": 2035,\
		\"max\": \"*\",\
		\"type\": \"Extension\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"DocumentReference.context.related.modifierExtension\",\
		\"weight\": 2036,\
		\"max\": \"*\",\
		\"type\": \"Extension\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"DocumentReference.context.related.identifier\",\
		\"weight\": 2037,\
		\"max\": \"1\",\
		\"type\": \"Identifier\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"DocumentReference.context.related.ref\",\
		\"weight\": 2038,\
		\"max\": \"1\",\
		\"type\": \"Reference\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"EligibilityRequest\",\
		\"weight\": 2039,\
		\"max\": \"*\",\
		\"type\": \"DomainResource\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"EligibilityRequest.id\",\
		\"weight\": 2040,\
		\"max\": \"1\",\
		\"type\": \"id\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"EligibilityRequest.meta\",\
		\"weight\": 2041,\
		\"max\": \"1\",\
		\"type\": \"Meta\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"EligibilityRequest.implicitRules\",\
		\"weight\": 2042,\
		\"max\": \"1\",\
		\"type\": \"uri\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"EligibilityRequest.language\",\
		\"weight\": 2043,\
		\"max\": \"1\",\
		\"type\": \"code\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"EligibilityRequest.text\",\
		\"weight\": 2044,\
		\"max\": \"1\",\
		\"type\": \"Narrative\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"EligibilityRequest.contained\",\
		\"weight\": 2045,\
		\"max\": \"*\",\
		\"type\": \"Resource\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"EligibilityRequest.extension\",\
		\"weight\": 2046,\
		\"max\": \"*\",\
		\"type\": \"Extension\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"EligibilityRequest.modifierExtension\",\
		\"weight\": 2047,\
		\"max\": \"*\",\
		\"type\": \"Extension\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"EligibilityRequest.identifier\",\
		\"weight\": 2048,\
		\"max\": \"*\",\
		\"type\": \"Identifier\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"EligibilityRequest.ruleset\",\
		\"weight\": 2049,\
		\"max\": \"1\",\
		\"type\": \"Coding\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"EligibilityRequest.originalRuleset\",\
		\"weight\": 2050,\
		\"max\": \"1\",\
		\"type\": \"Coding\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"EligibilityRequest.created\",\
		\"weight\": 2051,\
		\"max\": \"1\",\
		\"type\": \"dateTime\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"EligibilityRequest.targetIdentifier\",\
		\"weight\": 2052,\
		\"max\": \"1\",\
		\"type\": \"Identifier\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"EligibilityRequest.targetReference\",\
		\"weight\": 2052,\
		\"max\": \"1\",\
		\"type\": \"Reference\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"EligibilityRequest.providerIdentifier\",\
		\"weight\": 2053,\
		\"max\": \"1\",\
		\"type\": \"Identifier\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"EligibilityRequest.providerReference\",\
		\"weight\": 2053,\
		\"max\": \"1\",\
		\"type\": \"Reference\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"EligibilityRequest.organizationIdentifier\",\
		\"weight\": 2054,\
		\"max\": \"1\",\
		\"type\": \"Identifier\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"EligibilityRequest.organizationReference\",\
		\"weight\": 2054,\
		\"max\": \"1\",\
		\"type\": \"Reference\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"EligibilityRequest.priority\",\
		\"weight\": 2055,\
		\"max\": \"1\",\
		\"type\": \"Coding\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"EligibilityRequest.entererIdentifier\",\
		\"weight\": 2056,\
		\"max\": \"1\",\
		\"type\": \"Identifier\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"EligibilityRequest.entererReference\",\
		\"weight\": 2056,\
		\"max\": \"1\",\
		\"type\": \"Reference\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"EligibilityRequest.facilityIdentifier\",\
		\"weight\": 2057,\
		\"max\": \"1\",\
		\"type\": \"Identifier\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"EligibilityRequest.facilityReference\",\
		\"weight\": 2057,\
		\"max\": \"1\",\
		\"type\": \"Reference\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"EligibilityRequest.patientIdentifier\",\
		\"weight\": 2058,\
		\"max\": \"1\",\
		\"type\": \"Identifier\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"EligibilityRequest.patientReference\",\
		\"weight\": 2058,\
		\"max\": \"1\",\
		\"type\": \"Reference\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"EligibilityRequest.coverageIdentifier\",\
		\"weight\": 2059,\
		\"max\": \"1\",\
		\"type\": \"Identifier\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"EligibilityRequest.coverageReference\",\
		\"weight\": 2059,\
		\"max\": \"1\",\
		\"type\": \"Reference\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"EligibilityRequest.businessArrangement\",\
		\"weight\": 2060,\
		\"max\": \"1\",\
		\"type\": \"string\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"EligibilityRequest.servicedDate\",\
		\"weight\": 2061,\
		\"max\": \"1\",\
		\"type\": \"date\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"EligibilityRequest.servicedPeriod\",\
		\"weight\": 2061,\
		\"max\": \"1\",\
		\"type\": \"Period\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"EligibilityRequest.benefitCategory\",\
		\"weight\": 2062,\
		\"max\": \"1\",\
		\"type\": \"Coding\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"EligibilityRequest.benefitSubCategory\",\
		\"weight\": 2063,\
		\"max\": \"1\",\
		\"type\": \"Coding\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"EligibilityResponse\",\
		\"weight\": 2064,\
		\"max\": \"*\",\
		\"type\": \"DomainResource\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"EligibilityResponse.id\",\
		\"weight\": 2065,\
		\"max\": \"1\",\
		\"type\": \"id\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"EligibilityResponse.meta\",\
		\"weight\": 2066,\
		\"max\": \"1\",\
		\"type\": \"Meta\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"EligibilityResponse.implicitRules\",\
		\"weight\": 2067,\
		\"max\": \"1\",\
		\"type\": \"uri\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"EligibilityResponse.language\",\
		\"weight\": 2068,\
		\"max\": \"1\",\
		\"type\": \"code\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"EligibilityResponse.text\",\
		\"weight\": 2069,\
		\"max\": \"1\",\
		\"type\": \"Narrative\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"EligibilityResponse.contained\",\
		\"weight\": 2070,\
		\"max\": \"*\",\
		\"type\": \"Resource\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"EligibilityResponse.extension\",\
		\"weight\": 2071,\
		\"max\": \"*\",\
		\"type\": \"Extension\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"EligibilityResponse.modifierExtension\",\
		\"weight\": 2072,\
		\"max\": \"*\",\
		\"type\": \"Extension\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"EligibilityResponse.identifier\",\
		\"weight\": 2073,\
		\"max\": \"*\",\
		\"type\": \"Identifier\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"EligibilityResponse.requestIdentifier\",\
		\"weight\": 2074,\
		\"max\": \"1\",\
		\"type\": \"Identifier\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"EligibilityResponse.requestReference\",\
		\"weight\": 2074,\
		\"max\": \"1\",\
		\"type\": \"Reference\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"EligibilityResponse.outcome\",\
		\"weight\": 2075,\
		\"max\": \"1\",\
		\"type\": \"code\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"EligibilityResponse.disposition\",\
		\"weight\": 2076,\
		\"max\": \"1\",\
		\"type\": \"string\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"EligibilityResponse.ruleset\",\
		\"weight\": 2077,\
		\"max\": \"1\",\
		\"type\": \"Coding\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"EligibilityResponse.originalRuleset\",\
		\"weight\": 2078,\
		\"max\": \"1\",\
		\"type\": \"Coding\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"EligibilityResponse.created\",\
		\"weight\": 2079,\
		\"max\": \"1\",\
		\"type\": \"dateTime\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"EligibilityResponse.organizationIdentifier\",\
		\"weight\": 2080,\
		\"max\": \"1\",\
		\"type\": \"Identifier\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"EligibilityResponse.organizationReference\",\
		\"weight\": 2080,\
		\"max\": \"1\",\
		\"type\": \"Reference\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"EligibilityResponse.requestProviderIdentifier\",\
		\"weight\": 2081,\
		\"max\": \"1\",\
		\"type\": \"Identifier\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"EligibilityResponse.requestProviderReference\",\
		\"weight\": 2081,\
		\"max\": \"1\",\
		\"type\": \"Reference\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"EligibilityResponse.requestOrganizationIdentifier\",\
		\"weight\": 2082,\
		\"max\": \"1\",\
		\"type\": \"Identifier\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"EligibilityResponse.requestOrganizationReference\",\
		\"weight\": 2082,\
		\"max\": \"1\",\
		\"type\": \"Reference\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"EligibilityResponse.inforce\",\
		\"weight\": 2083,\
		\"max\": \"1\",\
		\"type\": \"boolean\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"EligibilityResponse.contract\",\
		\"weight\": 2084,\
		\"max\": \"1\",\
		\"type\": \"Reference\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"EligibilityResponse.form\",\
		\"weight\": 2085,\
		\"max\": \"1\",\
		\"type\": \"Coding\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"EligibilityResponse.benefitBalance\",\
		\"weight\": 2086,\
		\"max\": \"*\",\
		\"type\": \"BackboneElement\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"EligibilityResponse.benefitBalance.id\",\
		\"weight\": 2087,\
		\"max\": \"1\",\
		\"type\": \"id\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"EligibilityResponse.benefitBalance.extension\",\
		\"weight\": 2088,\
		\"max\": \"*\",\
		\"type\": \"Extension\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"EligibilityResponse.benefitBalance.modifierExtension\",\
		\"weight\": 2089,\
		\"max\": \"*\",\
		\"type\": \"Extension\"\
	},\
	{\
		\"min\": \"1\",\
		\"path\": \"EligibilityResponse.benefitBalance.category\",\
		\"weight\": 2090,\
		\"max\": \"1\",\
		\"type\": \"Coding\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"EligibilityResponse.benefitBalance.subCategory\",\
		\"weight\": 2091,\
		\"max\": \"1\",\
		\"type\": \"Coding\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"EligibilityResponse.benefitBalance.network\",\
		\"weight\": 2092,\
		\"max\": \"1\",\
		\"type\": \"Coding\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"EligibilityResponse.benefitBalance.unit\",\
		\"weight\": 2093,\
		\"max\": \"1\",\
		\"type\": \"Coding\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"EligibilityResponse.benefitBalance.term\",\
		\"weight\": 2094,\
		\"max\": \"1\",\
		\"type\": \"Coding\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"EligibilityResponse.benefitBalance.financial\",\
		\"weight\": 2095,\
		\"max\": \"*\",\
		\"type\": \"BackboneElement\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"EligibilityResponse.benefitBalance.financial.id\",\
		\"weight\": 2096,\
		\"max\": \"1\",\
		\"type\": \"id\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"EligibilityResponse.benefitBalance.financial.extension\",\
		\"weight\": 2097,\
		\"max\": \"*\",\
		\"type\": \"Extension\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"EligibilityResponse.benefitBalance.financial.modifierExtension\",\
		\"weight\": 2098,\
		\"max\": \"*\",\
		\"type\": \"Extension\"\
	},\
	{\
		\"min\": \"1\",\
		\"path\": \"EligibilityResponse.benefitBalance.financial.type\",\
		\"weight\": 2099,\
		\"max\": \"1\",\
		\"type\": \"Coding\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"EligibilityResponse.benefitBalance.financial.benefitUnsignedInt\",\
		\"weight\": 2100,\
		\"max\": \"1\",\
		\"type\": \"unsignedInt\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"EligibilityResponse.benefitBalance.financial.benefitQuantity\",\
		\"weight\": 2100,\
		\"max\": \"1\",\
		\"type\": \"Quantity\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"EligibilityResponse.benefitBalance.financial.benefitUsedUnsignedInt\",\
		\"weight\": 2101,\
		\"max\": \"1\",\
		\"type\": \"unsignedInt\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"EligibilityResponse.benefitBalance.financial.benefitUsedQuantity\",\
		\"weight\": 2101,\
		\"max\": \"1\",\
		\"type\": \"Quantity\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"EligibilityResponse.error\",\
		\"weight\": 2102,\
		\"max\": \"*\",\
		\"type\": \"BackboneElement\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"EligibilityResponse.error.id\",\
		\"weight\": 2103,\
		\"max\": \"1\",\
		\"type\": \"id\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"EligibilityResponse.error.extension\",\
		\"weight\": 2104,\
		\"max\": \"*\",\
		\"type\": \"Extension\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"EligibilityResponse.error.modifierExtension\",\
		\"weight\": 2105,\
		\"max\": \"*\",\
		\"type\": \"Extension\"\
	},\
	{\
		\"min\": \"1\",\
		\"path\": \"EligibilityResponse.error.code\",\
		\"weight\": 2106,\
		\"max\": \"1\",\
		\"type\": \"Coding\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Encounter\",\
		\"weight\": 2107,\
		\"max\": \"*\",\
		\"type\": \"DomainResource\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Encounter.id\",\
		\"weight\": 2108,\
		\"max\": \"1\",\
		\"type\": \"id\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Encounter.meta\",\
		\"weight\": 2109,\
		\"max\": \"1\",\
		\"type\": \"Meta\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Encounter.implicitRules\",\
		\"weight\": 2110,\
		\"max\": \"1\",\
		\"type\": \"uri\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Encounter.language\",\
		\"weight\": 2111,\
		\"max\": \"1\",\
		\"type\": \"code\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Encounter.text\",\
		\"weight\": 2112,\
		\"max\": \"1\",\
		\"type\": \"Narrative\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Encounter.contained\",\
		\"weight\": 2113,\
		\"max\": \"*\",\
		\"type\": \"Resource\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Encounter.extension\",\
		\"weight\": 2114,\
		\"max\": \"*\",\
		\"type\": \"Extension\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Encounter.modifierExtension\",\
		\"weight\": 2115,\
		\"max\": \"*\",\
		\"type\": \"Extension\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Encounter.identifier\",\
		\"weight\": 2116,\
		\"max\": \"*\",\
		\"type\": \"Identifier\"\
	},\
	{\
		\"min\": \"1\",\
		\"path\": \"Encounter.status\",\
		\"weight\": 2117,\
		\"max\": \"1\",\
		\"type\": \"code\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Encounter.statusHistory\",\
		\"weight\": 2118,\
		\"max\": \"*\",\
		\"type\": \"BackboneElement\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Encounter.statusHistory.id\",\
		\"weight\": 2119,\
		\"max\": \"1\",\
		\"type\": \"id\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Encounter.statusHistory.extension\",\
		\"weight\": 2120,\
		\"max\": \"*\",\
		\"type\": \"Extension\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Encounter.statusHistory.modifierExtension\",\
		\"weight\": 2121,\
		\"max\": \"*\",\
		\"type\": \"Extension\"\
	},\
	{\
		\"min\": \"1\",\
		\"path\": \"Encounter.statusHistory.status\",\
		\"weight\": 2122,\
		\"max\": \"1\",\
		\"type\": \"code\"\
	},\
	{\
		\"min\": \"1\",\
		\"path\": \"Encounter.statusHistory.period\",\
		\"weight\": 2123,\
		\"max\": \"1\",\
		\"type\": \"Period\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Encounter.class\",\
		\"weight\": 2124,\
		\"max\": \"1\",\
		\"type\": \"code\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Encounter.type\",\
		\"weight\": 2125,\
		\"max\": \"*\",\
		\"type\": \"CodeableConcept\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Encounter.priority\",\
		\"weight\": 2126,\
		\"max\": \"1\",\
		\"type\": \"CodeableConcept\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Encounter.patient\",\
		\"weight\": 2127,\
		\"max\": \"1\",\
		\"type\": \"Reference\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Encounter.episodeOfCare\",\
		\"weight\": 2128,\
		\"max\": \"*\",\
		\"type\": \"Reference\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Encounter.incomingReferral\",\
		\"weight\": 2129,\
		\"max\": \"*\",\
		\"type\": \"Reference\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Encounter.participant\",\
		\"weight\": 2130,\
		\"max\": \"*\",\
		\"type\": \"BackboneElement\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Encounter.participant.id\",\
		\"weight\": 2131,\
		\"max\": \"1\",\
		\"type\": \"id\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Encounter.participant.extension\",\
		\"weight\": 2132,\
		\"max\": \"*\",\
		\"type\": \"Extension\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Encounter.participant.modifierExtension\",\
		\"weight\": 2133,\
		\"max\": \"*\",\
		\"type\": \"Extension\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Encounter.participant.type\",\
		\"weight\": 2134,\
		\"max\": \"*\",\
		\"type\": \"CodeableConcept\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Encounter.participant.period\",\
		\"weight\": 2135,\
		\"max\": \"1\",\
		\"type\": \"Period\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Encounter.participant.individual\",\
		\"weight\": 2136,\
		\"max\": \"1\",\
		\"type\": \"Reference\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Encounter.appointment\",\
		\"weight\": 2137,\
		\"max\": \"1\",\
		\"type\": \"Reference\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Encounter.period\",\
		\"weight\": 2138,\
		\"max\": \"1\",\
		\"type\": \"Period\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Encounter.length\",\
		\"weight\": 2139,\
		\"max\": \"1\",\
		\"type\": \"Quantity\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Encounter.reason\",\
		\"weight\": 2140,\
		\"max\": \"*\",\
		\"type\": \"CodeableConcept\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Encounter.indication\",\
		\"weight\": 2141,\
		\"max\": \"*\",\
		\"type\": \"Reference\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Encounter.hospitalization\",\
		\"weight\": 2142,\
		\"max\": \"1\",\
		\"type\": \"BackboneElement\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Encounter.hospitalization.id\",\
		\"weight\": 2143,\
		\"max\": \"1\",\
		\"type\": \"id\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Encounter.hospitalization.extension\",\
		\"weight\": 2144,\
		\"max\": \"*\",\
		\"type\": \"Extension\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Encounter.hospitalization.modifierExtension\",\
		\"weight\": 2145,\
		\"max\": \"*\",\
		\"type\": \"Extension\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Encounter.hospitalization.preAdmissionIdentifier\",\
		\"weight\": 2146,\
		\"max\": \"1\",\
		\"type\": \"Identifier\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Encounter.hospitalization.origin\",\
		\"weight\": 2147,\
		\"max\": \"1\",\
		\"type\": \"Reference\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Encounter.hospitalization.admitSource\",\
		\"weight\": 2148,\
		\"max\": \"1\",\
		\"type\": \"CodeableConcept\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Encounter.hospitalization.admittingDiagnosis\",\
		\"weight\": 2149,\
		\"max\": \"*\",\
		\"type\": \"Reference\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Encounter.hospitalization.reAdmission\",\
		\"weight\": 2150,\
		\"max\": \"1\",\
		\"type\": \"CodeableConcept\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Encounter.hospitalization.dietPreference\",\
		\"weight\": 2151,\
		\"max\": \"*\",\
		\"type\": \"CodeableConcept\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Encounter.hospitalization.specialCourtesy\",\
		\"weight\": 2152,\
		\"max\": \"*\",\
		\"type\": \"CodeableConcept\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Encounter.hospitalization.specialArrangement\",\
		\"weight\": 2153,\
		\"max\": \"*\",\
		\"type\": \"CodeableConcept\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Encounter.hospitalization.destination\",\
		\"weight\": 2154,\
		\"max\": \"1\",\
		\"type\": \"Reference\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Encounter.hospitalization.dischargeDisposition\",\
		\"weight\": 2155,\
		\"max\": \"1\",\
		\"type\": \"CodeableConcept\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Encounter.hospitalization.dischargeDiagnosis\",\
		\"weight\": 2156,\
		\"max\": \"*\",\
		\"type\": \"Reference\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Encounter.location\",\
		\"weight\": 2157,\
		\"max\": \"*\",\
		\"type\": \"BackboneElement\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Encounter.location.id\",\
		\"weight\": 2158,\
		\"max\": \"1\",\
		\"type\": \"id\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Encounter.location.extension\",\
		\"weight\": 2159,\
		\"max\": \"*\",\
		\"type\": \"Extension\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Encounter.location.modifierExtension\",\
		\"weight\": 2160,\
		\"max\": \"*\",\
		\"type\": \"Extension\"\
	},\
	{\
		\"min\": \"1\",\
		\"path\": \"Encounter.location.location\",\
		\"weight\": 2161,\
		\"max\": \"1\",\
		\"type\": \"Reference\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Encounter.location.status\",\
		\"weight\": 2162,\
		\"max\": \"1\",\
		\"type\": \"code\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Encounter.location.period\",\
		\"weight\": 2163,\
		\"max\": \"1\",\
		\"type\": \"Period\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Encounter.serviceProvider\",\
		\"weight\": 2164,\
		\"max\": \"1\",\
		\"type\": \"Reference\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Encounter.partOf\",\
		\"weight\": 2165,\
		\"max\": \"1\",\
		\"type\": \"Reference\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"EnrollmentRequest\",\
		\"weight\": 2166,\
		\"max\": \"*\",\
		\"type\": \"DomainResource\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"EnrollmentRequest.id\",\
		\"weight\": 2167,\
		\"max\": \"1\",\
		\"type\": \"id\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"EnrollmentRequest.meta\",\
		\"weight\": 2168,\
		\"max\": \"1\",\
		\"type\": \"Meta\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"EnrollmentRequest.implicitRules\",\
		\"weight\": 2169,\
		\"max\": \"1\",\
		\"type\": \"uri\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"EnrollmentRequest.language\",\
		\"weight\": 2170,\
		\"max\": \"1\",\
		\"type\": \"code\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"EnrollmentRequest.text\",\
		\"weight\": 2171,\
		\"max\": \"1\",\
		\"type\": \"Narrative\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"EnrollmentRequest.contained\",\
		\"weight\": 2172,\
		\"max\": \"*\",\
		\"type\": \"Resource\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"EnrollmentRequest.extension\",\
		\"weight\": 2173,\
		\"max\": \"*\",\
		\"type\": \"Extension\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"EnrollmentRequest.modifierExtension\",\
		\"weight\": 2174,\
		\"max\": \"*\",\
		\"type\": \"Extension\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"EnrollmentRequest.identifier\",\
		\"weight\": 2175,\
		\"max\": \"*\",\
		\"type\": \"Identifier\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"EnrollmentRequest.ruleset\",\
		\"weight\": 2176,\
		\"max\": \"1\",\
		\"type\": \"Coding\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"EnrollmentRequest.originalRuleset\",\
		\"weight\": 2177,\
		\"max\": \"1\",\
		\"type\": \"Coding\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"EnrollmentRequest.created\",\
		\"weight\": 2178,\
		\"max\": \"1\",\
		\"type\": \"dateTime\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"EnrollmentRequest.target\",\
		\"weight\": 2179,\
		\"max\": \"1\",\
		\"type\": \"Reference\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"EnrollmentRequest.provider\",\
		\"weight\": 2180,\
		\"max\": \"1\",\
		\"type\": \"Reference\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"EnrollmentRequest.organization\",\
		\"weight\": 2181,\
		\"max\": \"1\",\
		\"type\": \"Reference\"\
	},\
	{\
		\"min\": \"1\",\
		\"path\": \"EnrollmentRequest.subject\",\
		\"weight\": 2182,\
		\"max\": \"1\",\
		\"type\": \"Reference\"\
	},\
	{\
		\"min\": \"1\",\
		\"path\": \"EnrollmentRequest.coverage\",\
		\"weight\": 2183,\
		\"max\": \"1\",\
		\"type\": \"Reference\"\
	},\
	{\
		\"min\": \"1\",\
		\"path\": \"EnrollmentRequest.relationship\",\
		\"weight\": 2184,\
		\"max\": \"1\",\
		\"type\": \"Coding\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"EnrollmentResponse\",\
		\"weight\": 2185,\
		\"max\": \"*\",\
		\"type\": \"DomainResource\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"EnrollmentResponse.id\",\
		\"weight\": 2186,\
		\"max\": \"1\",\
		\"type\": \"id\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"EnrollmentResponse.meta\",\
		\"weight\": 2187,\
		\"max\": \"1\",\
		\"type\": \"Meta\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"EnrollmentResponse.implicitRules\",\
		\"weight\": 2188,\
		\"max\": \"1\",\
		\"type\": \"uri\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"EnrollmentResponse.language\",\
		\"weight\": 2189,\
		\"max\": \"1\",\
		\"type\": \"code\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"EnrollmentResponse.text\",\
		\"weight\": 2190,\
		\"max\": \"1\",\
		\"type\": \"Narrative\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"EnrollmentResponse.contained\",\
		\"weight\": 2191,\
		\"max\": \"*\",\
		\"type\": \"Resource\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"EnrollmentResponse.extension\",\
		\"weight\": 2192,\
		\"max\": \"*\",\
		\"type\": \"Extension\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"EnrollmentResponse.modifierExtension\",\
		\"weight\": 2193,\
		\"max\": \"*\",\
		\"type\": \"Extension\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"EnrollmentResponse.identifier\",\
		\"weight\": 2194,\
		\"max\": \"*\",\
		\"type\": \"Identifier\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"EnrollmentResponse.request\",\
		\"weight\": 2195,\
		\"max\": \"1\",\
		\"type\": \"Reference\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"EnrollmentResponse.outcome\",\
		\"weight\": 2196,\
		\"max\": \"1\",\
		\"type\": \"code\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"EnrollmentResponse.disposition\",\
		\"weight\": 2197,\
		\"max\": \"1\",\
		\"type\": \"string\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"EnrollmentResponse.ruleset\",\
		\"weight\": 2198,\
		\"max\": \"1\",\
		\"type\": \"Coding\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"EnrollmentResponse.originalRuleset\",\
		\"weight\": 2199,\
		\"max\": \"1\",\
		\"type\": \"Coding\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"EnrollmentResponse.created\",\
		\"weight\": 2200,\
		\"max\": \"1\",\
		\"type\": \"dateTime\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"EnrollmentResponse.organization\",\
		\"weight\": 2201,\
		\"max\": \"1\",\
		\"type\": \"Reference\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"EnrollmentResponse.requestProvider\",\
		\"weight\": 2202,\
		\"max\": \"1\",\
		\"type\": \"Reference\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"EnrollmentResponse.requestOrganization\",\
		\"weight\": 2203,\
		\"max\": \"1\",\
		\"type\": \"Reference\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"EpisodeOfCare\",\
		\"weight\": 2204,\
		\"max\": \"*\",\
		\"type\": \"DomainResource\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"EpisodeOfCare.id\",\
		\"weight\": 2205,\
		\"max\": \"1\",\
		\"type\": \"id\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"EpisodeOfCare.meta\",\
		\"weight\": 2206,\
		\"max\": \"1\",\
		\"type\": \"Meta\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"EpisodeOfCare.implicitRules\",\
		\"weight\": 2207,\
		\"max\": \"1\",\
		\"type\": \"uri\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"EpisodeOfCare.language\",\
		\"weight\": 2208,\
		\"max\": \"1\",\
		\"type\": \"code\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"EpisodeOfCare.text\",\
		\"weight\": 2209,\
		\"max\": \"1\",\
		\"type\": \"Narrative\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"EpisodeOfCare.contained\",\
		\"weight\": 2210,\
		\"max\": \"*\",\
		\"type\": \"Resource\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"EpisodeOfCare.extension\",\
		\"weight\": 2211,\
		\"max\": \"*\",\
		\"type\": \"Extension\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"EpisodeOfCare.modifierExtension\",\
		\"weight\": 2212,\
		\"max\": \"*\",\
		\"type\": \"Extension\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"EpisodeOfCare.identifier\",\
		\"weight\": 2213,\
		\"max\": \"*\",\
		\"type\": \"Identifier\"\
	},\
	{\
		\"min\": \"1\",\
		\"path\": \"EpisodeOfCare.status\",\
		\"weight\": 2214,\
		\"max\": \"1\",\
		\"type\": \"code\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"EpisodeOfCare.statusHistory\",\
		\"weight\": 2215,\
		\"max\": \"*\",\
		\"type\": \"BackboneElement\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"EpisodeOfCare.statusHistory.id\",\
		\"weight\": 2216,\
		\"max\": \"1\",\
		\"type\": \"id\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"EpisodeOfCare.statusHistory.extension\",\
		\"weight\": 2217,\
		\"max\": \"*\",\
		\"type\": \"Extension\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"EpisodeOfCare.statusHistory.modifierExtension\",\
		\"weight\": 2218,\
		\"max\": \"*\",\
		\"type\": \"Extension\"\
	},\
	{\
		\"min\": \"1\",\
		\"path\": \"EpisodeOfCare.statusHistory.status\",\
		\"weight\": 2219,\
		\"max\": \"1\",\
		\"type\": \"code\"\
	},\
	{\
		\"min\": \"1\",\
		\"path\": \"EpisodeOfCare.statusHistory.period\",\
		\"weight\": 2220,\
		\"max\": \"1\",\
		\"type\": \"Period\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"EpisodeOfCare.type\",\
		\"weight\": 2221,\
		\"max\": \"*\",\
		\"type\": \"CodeableConcept\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"EpisodeOfCare.condition\",\
		\"weight\": 2222,\
		\"max\": \"*\",\
		\"type\": \"Reference\"\
	},\
	{\
		\"min\": \"1\",\
		\"path\": \"EpisodeOfCare.patient\",\
		\"weight\": 2223,\
		\"max\": \"1\",\
		\"type\": \"Reference\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"EpisodeOfCare.managingOrganization\",\
		\"weight\": 2224,\
		\"max\": \"1\",\
		\"type\": \"Reference\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"EpisodeOfCare.period\",\
		\"weight\": 2225,\
		\"max\": \"1\",\
		\"type\": \"Period\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"EpisodeOfCare.referralRequest\",\
		\"weight\": 2226,\
		\"max\": \"*\",\
		\"type\": \"Reference\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"EpisodeOfCare.careManager\",\
		\"weight\": 2227,\
		\"max\": \"1\",\
		\"type\": \"Reference\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"EpisodeOfCare.team\",\
		\"weight\": 2228,\
		\"max\": \"*\",\
		\"type\": \"Reference\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"ExpansionProfile\",\
		\"weight\": 2229,\
		\"max\": \"*\",\
		\"type\": \"DomainResource\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"ExpansionProfile.id\",\
		\"weight\": 2230,\
		\"max\": \"1\",\
		\"type\": \"id\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"ExpansionProfile.meta\",\
		\"weight\": 2231,\
		\"max\": \"1\",\
		\"type\": \"Meta\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"ExpansionProfile.implicitRules\",\
		\"weight\": 2232,\
		\"max\": \"1\",\
		\"type\": \"uri\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"ExpansionProfile.language\",\
		\"weight\": 2233,\
		\"max\": \"1\",\
		\"type\": \"code\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"ExpansionProfile.text\",\
		\"weight\": 2234,\
		\"max\": \"1\",\
		\"type\": \"Narrative\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"ExpansionProfile.contained\",\
		\"weight\": 2235,\
		\"max\": \"*\",\
		\"type\": \"Resource\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"ExpansionProfile.extension\",\
		\"weight\": 2236,\
		\"max\": \"*\",\
		\"type\": \"Extension\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"ExpansionProfile.modifierExtension\",\
		\"weight\": 2237,\
		\"max\": \"*\",\
		\"type\": \"Extension\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"ExpansionProfile.url\",\
		\"weight\": 2238,\
		\"max\": \"1\",\
		\"type\": \"uri\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"ExpansionProfile.identifier\",\
		\"weight\": 2239,\
		\"max\": \"1\",\
		\"type\": \"Identifier\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"ExpansionProfile.version\",\
		\"weight\": 2240,\
		\"max\": \"1\",\
		\"type\": \"string\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"ExpansionProfile.name\",\
		\"weight\": 2241,\
		\"max\": \"1\",\
		\"type\": \"string\"\
	},\
	{\
		\"min\": \"1\",\
		\"path\": \"ExpansionProfile.status\",\
		\"weight\": 2242,\
		\"max\": \"1\",\
		\"type\": \"code\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"ExpansionProfile.experimental\",\
		\"weight\": 2243,\
		\"max\": \"1\",\
		\"type\": \"boolean\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"ExpansionProfile.publisher\",\
		\"weight\": 2244,\
		\"max\": \"1\",\
		\"type\": \"string\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"ExpansionProfile.contact\",\
		\"weight\": 2245,\
		\"max\": \"*\",\
		\"type\": \"BackboneElement\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"ExpansionProfile.contact.id\",\
		\"weight\": 2246,\
		\"max\": \"1\",\
		\"type\": \"id\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"ExpansionProfile.contact.extension\",\
		\"weight\": 2247,\
		\"max\": \"*\",\
		\"type\": \"Extension\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"ExpansionProfile.contact.modifierExtension\",\
		\"weight\": 2248,\
		\"max\": \"*\",\
		\"type\": \"Extension\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"ExpansionProfile.contact.name\",\
		\"weight\": 2249,\
		\"max\": \"1\",\
		\"type\": \"string\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"ExpansionProfile.contact.telecom\",\
		\"weight\": 2250,\
		\"max\": \"*\",\
		\"type\": \"ContactPoint\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"ExpansionProfile.date\",\
		\"weight\": 2251,\
		\"max\": \"1\",\
		\"type\": \"dateTime\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"ExpansionProfile.description\",\
		\"weight\": 2252,\
		\"max\": \"1\",\
		\"type\": \"string\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"ExpansionProfile.codeSystem\",\
		\"weight\": 2253,\
		\"max\": \"1\",\
		\"type\": \"BackboneElement\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"ExpansionProfile.codeSystem.id\",\
		\"weight\": 2254,\
		\"max\": \"1\",\
		\"type\": \"id\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"ExpansionProfile.codeSystem.extension\",\
		\"weight\": 2255,\
		\"max\": \"*\",\
		\"type\": \"Extension\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"ExpansionProfile.codeSystem.modifierExtension\",\
		\"weight\": 2256,\
		\"max\": \"*\",\
		\"type\": \"Extension\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"ExpansionProfile.codeSystem.include\",\
		\"weight\": 2257,\
		\"max\": \"1\",\
		\"type\": \"BackboneElement\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"ExpansionProfile.codeSystem.include.id\",\
		\"weight\": 2258,\
		\"max\": \"1\",\
		\"type\": \"id\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"ExpansionProfile.codeSystem.include.extension\",\
		\"weight\": 2259,\
		\"max\": \"*\",\
		\"type\": \"Extension\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"ExpansionProfile.codeSystem.include.modifierExtension\",\
		\"weight\": 2260,\
		\"max\": \"*\",\
		\"type\": \"Extension\"\
	},\
	{\
		\"min\": \"1\",\
		\"path\": \"ExpansionProfile.codeSystem.include.codeSystem\",\
		\"weight\": 2261,\
		\"max\": \"*\",\
		\"type\": \"BackboneElement\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"ExpansionProfile.codeSystem.include.codeSystem.id\",\
		\"weight\": 2262,\
		\"max\": \"1\",\
		\"type\": \"id\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"ExpansionProfile.codeSystem.include.codeSystem.extension\",\
		\"weight\": 2263,\
		\"max\": \"*\",\
		\"type\": \"Extension\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"ExpansionProfile.codeSystem.include.codeSystem.modifierExtension\",\
		\"weight\": 2264,\
		\"max\": \"*\",\
		\"type\": \"Extension\"\
	},\
	{\
		\"min\": \"1\",\
		\"path\": \"ExpansionProfile.codeSystem.include.codeSystem.system\",\
		\"weight\": 2265,\
		\"max\": \"1\",\
		\"type\": \"uri\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"ExpansionProfile.codeSystem.include.codeSystem.version\",\
		\"weight\": 2266,\
		\"max\": \"1\",\
		\"type\": \"string\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"ExpansionProfile.codeSystem.exclude\",\
		\"weight\": 2267,\
		\"max\": \"1\",\
		\"type\": \"BackboneElement\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"ExpansionProfile.codeSystem.exclude.id\",\
		\"weight\": 2268,\
		\"max\": \"1\",\
		\"type\": \"id\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"ExpansionProfile.codeSystem.exclude.extension\",\
		\"weight\": 2269,\
		\"max\": \"*\",\
		\"type\": \"Extension\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"ExpansionProfile.codeSystem.exclude.modifierExtension\",\
		\"weight\": 2270,\
		\"max\": \"*\",\
		\"type\": \"Extension\"\
	},\
	{\
		\"min\": \"1\",\
		\"path\": \"ExpansionProfile.codeSystem.exclude.codeSystem\",\
		\"weight\": 2271,\
		\"max\": \"*\",\
		\"type\": \"BackboneElement\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"ExpansionProfile.codeSystem.exclude.codeSystem.id\",\
		\"weight\": 2272,\
		\"max\": \"1\",\
		\"type\": \"id\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"ExpansionProfile.codeSystem.exclude.codeSystem.extension\",\
		\"weight\": 2273,\
		\"max\": \"*\",\
		\"type\": \"Extension\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"ExpansionProfile.codeSystem.exclude.codeSystem.modifierExtension\",\
		\"weight\": 2274,\
		\"max\": \"*\",\
		\"type\": \"Extension\"\
	},\
	{\
		\"min\": \"1\",\
		\"path\": \"ExpansionProfile.codeSystem.exclude.codeSystem.system\",\
		\"weight\": 2275,\
		\"max\": \"1\",\
		\"type\": \"uri\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"ExpansionProfile.codeSystem.exclude.codeSystem.version\",\
		\"weight\": 2276,\
		\"max\": \"1\",\
		\"type\": \"string\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"ExpansionProfile.includeDesignations\",\
		\"weight\": 2277,\
		\"max\": \"1\",\
		\"type\": \"boolean\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"ExpansionProfile.designation\",\
		\"weight\": 2278,\
		\"max\": \"1\",\
		\"type\": \"BackboneElement\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"ExpansionProfile.designation.id\",\
		\"weight\": 2279,\
		\"max\": \"1\",\
		\"type\": \"id\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"ExpansionProfile.designation.extension\",\
		\"weight\": 2280,\
		\"max\": \"*\",\
		\"type\": \"Extension\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"ExpansionProfile.designation.modifierExtension\",\
		\"weight\": 2281,\
		\"max\": \"*\",\
		\"type\": \"Extension\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"ExpansionProfile.designation.include\",\
		\"weight\": 2282,\
		\"max\": \"1\",\
		\"type\": \"BackboneElement\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"ExpansionProfile.designation.include.id\",\
		\"weight\": 2283,\
		\"max\": \"1\",\
		\"type\": \"id\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"ExpansionProfile.designation.include.extension\",\
		\"weight\": 2284,\
		\"max\": \"*\",\
		\"type\": \"Extension\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"ExpansionProfile.designation.include.modifierExtension\",\
		\"weight\": 2285,\
		\"max\": \"*\",\
		\"type\": \"Extension\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"ExpansionProfile.designation.include.designation\",\
		\"weight\": 2286,\
		\"max\": \"*\",\
		\"type\": \"BackboneElement\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"ExpansionProfile.designation.include.designation.id\",\
		\"weight\": 2287,\
		\"max\": \"1\",\
		\"type\": \"id\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"ExpansionProfile.designation.include.designation.extension\",\
		\"weight\": 2288,\
		\"max\": \"*\",\
		\"type\": \"Extension\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"ExpansionProfile.designation.include.designation.modifierExtension\",\
		\"weight\": 2289,\
		\"max\": \"*\",\
		\"type\": \"Extension\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"ExpansionProfile.designation.include.designation.language\",\
		\"weight\": 2290,\
		\"max\": \"1\",\
		\"type\": \"code\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"ExpansionProfile.designation.include.designation.use\",\
		\"weight\": 2291,\
		\"max\": \"1\",\
		\"type\": \"Coding\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"ExpansionProfile.designation.exclude\",\
		\"weight\": 2292,\
		\"max\": \"1\",\
		\"type\": \"BackboneElement\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"ExpansionProfile.designation.exclude.id\",\
		\"weight\": 2293,\
		\"max\": \"1\",\
		\"type\": \"id\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"ExpansionProfile.designation.exclude.extension\",\
		\"weight\": 2294,\
		\"max\": \"*\",\
		\"type\": \"Extension\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"ExpansionProfile.designation.exclude.modifierExtension\",\
		\"weight\": 2295,\
		\"max\": \"*\",\
		\"type\": \"Extension\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"ExpansionProfile.designation.exclude.designation\",\
		\"weight\": 2296,\
		\"max\": \"*\",\
		\"type\": \"BackboneElement\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"ExpansionProfile.designation.exclude.designation.id\",\
		\"weight\": 2297,\
		\"max\": \"1\",\
		\"type\": \"id\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"ExpansionProfile.designation.exclude.designation.extension\",\
		\"weight\": 2298,\
		\"max\": \"*\",\
		\"type\": \"Extension\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"ExpansionProfile.designation.exclude.designation.modifierExtension\",\
		\"weight\": 2299,\
		\"max\": \"*\",\
		\"type\": \"Extension\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"ExpansionProfile.designation.exclude.designation.language\",\
		\"weight\": 2300,\
		\"max\": \"1\",\
		\"type\": \"code\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"ExpansionProfile.designation.exclude.designation.use\",\
		\"weight\": 2301,\
		\"max\": \"1\",\
		\"type\": \"Coding\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"ExpansionProfile.includeDefinition\",\
		\"weight\": 2302,\
		\"max\": \"1\",\
		\"type\": \"boolean\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"ExpansionProfile.includeInactive\",\
		\"weight\": 2303,\
		\"max\": \"1\",\
		\"type\": \"boolean\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"ExpansionProfile.excludeNested\",\
		\"weight\": 2304,\
		\"max\": \"1\",\
		\"type\": \"boolean\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"ExpansionProfile.excludeNotForUI\",\
		\"weight\": 2305,\
		\"max\": \"1\",\
		\"type\": \"boolean\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"ExpansionProfile.excludePostCoordinated\",\
		\"weight\": 2306,\
		\"max\": \"1\",\
		\"type\": \"boolean\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"ExpansionProfile.displayLanguage\",\
		\"weight\": 2307,\
		\"max\": \"1\",\
		\"type\": \"code\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"ExpansionProfile.limitedExpansion\",\
		\"weight\": 2308,\
		\"max\": \"1\",\
		\"type\": \"boolean\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"ExplanationOfBenefit\",\
		\"weight\": 2309,\
		\"max\": \"*\",\
		\"type\": \"DomainResource\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"ExplanationOfBenefit.id\",\
		\"weight\": 2310,\
		\"max\": \"1\",\
		\"type\": \"id\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"ExplanationOfBenefit.meta\",\
		\"weight\": 2311,\
		\"max\": \"1\",\
		\"type\": \"Meta\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"ExplanationOfBenefit.implicitRules\",\
		\"weight\": 2312,\
		\"max\": \"1\",\
		\"type\": \"uri\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"ExplanationOfBenefit.language\",\
		\"weight\": 2313,\
		\"max\": \"1\",\
		\"type\": \"code\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"ExplanationOfBenefit.text\",\
		\"weight\": 2314,\
		\"max\": \"1\",\
		\"type\": \"Narrative\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"ExplanationOfBenefit.contained\",\
		\"weight\": 2315,\
		\"max\": \"*\",\
		\"type\": \"Resource\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"ExplanationOfBenefit.extension\",\
		\"weight\": 2316,\
		\"max\": \"*\",\
		\"type\": \"Extension\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"ExplanationOfBenefit.modifierExtension\",\
		\"weight\": 2317,\
		\"max\": \"*\",\
		\"type\": \"Extension\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"ExplanationOfBenefit.identifier\",\
		\"weight\": 2318,\
		\"max\": \"*\",\
		\"type\": \"Identifier\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"ExplanationOfBenefit.claimIdentifier\",\
		\"weight\": 2319,\
		\"max\": \"1\",\
		\"type\": \"Identifier\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"ExplanationOfBenefit.claimReference\",\
		\"weight\": 2319,\
		\"max\": \"1\",\
		\"type\": \"Reference\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"ExplanationOfBenefit.claimResponseIdentifier\",\
		\"weight\": 2320,\
		\"max\": \"1\",\
		\"type\": \"Identifier\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"ExplanationOfBenefit.claimResponseReference\",\
		\"weight\": 2320,\
		\"max\": \"1\",\
		\"type\": \"Reference\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"ExplanationOfBenefit.subType\",\
		\"weight\": 2321,\
		\"max\": \"*\",\
		\"type\": \"Coding\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"ExplanationOfBenefit.ruleset\",\
		\"weight\": 2322,\
		\"max\": \"1\",\
		\"type\": \"Coding\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"ExplanationOfBenefit.originalRuleset\",\
		\"weight\": 2323,\
		\"max\": \"1\",\
		\"type\": \"Coding\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"ExplanationOfBenefit.created\",\
		\"weight\": 2324,\
		\"max\": \"1\",\
		\"type\": \"dateTime\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"ExplanationOfBenefit.billablePeriod\",\
		\"weight\": 2325,\
		\"max\": \"1\",\
		\"type\": \"Period\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"ExplanationOfBenefit.disposition\",\
		\"weight\": 2326,\
		\"max\": \"1\",\
		\"type\": \"string\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"ExplanationOfBenefit.providerIdentifier\",\
		\"weight\": 2327,\
		\"max\": \"1\",\
		\"type\": \"Identifier\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"ExplanationOfBenefit.providerReference\",\
		\"weight\": 2327,\
		\"max\": \"1\",\
		\"type\": \"Reference\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"ExplanationOfBenefit.organizationIdentifier\",\
		\"weight\": 2328,\
		\"max\": \"1\",\
		\"type\": \"Identifier\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"ExplanationOfBenefit.organizationReference\",\
		\"weight\": 2328,\
		\"max\": \"1\",\
		\"type\": \"Reference\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"ExplanationOfBenefit.facilityIdentifier\",\
		\"weight\": 2329,\
		\"max\": \"1\",\
		\"type\": \"Identifier\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"ExplanationOfBenefit.facilityReference\",\
		\"weight\": 2329,\
		\"max\": \"1\",\
		\"type\": \"Reference\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"ExplanationOfBenefit.related\",\
		\"weight\": 2330,\
		\"max\": \"*\",\
		\"type\": \"BackboneElement\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"ExplanationOfBenefit.related.id\",\
		\"weight\": 2331,\
		\"max\": \"1\",\
		\"type\": \"id\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"ExplanationOfBenefit.related.extension\",\
		\"weight\": 2332,\
		\"max\": \"*\",\
		\"type\": \"Extension\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"ExplanationOfBenefit.related.modifierExtension\",\
		\"weight\": 2333,\
		\"max\": \"*\",\
		\"type\": \"Extension\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"ExplanationOfBenefit.related.claimIdentifier\",\
		\"weight\": 2334,\
		\"max\": \"1\",\
		\"type\": \"Identifier\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"ExplanationOfBenefit.related.claimReference\",\
		\"weight\": 2334,\
		\"max\": \"1\",\
		\"type\": \"Reference\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"ExplanationOfBenefit.related.relationship\",\
		\"weight\": 2335,\
		\"max\": \"1\",\
		\"type\": \"Coding\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"ExplanationOfBenefit.related.reference\",\
		\"weight\": 2336,\
		\"max\": \"1\",\
		\"type\": \"Identifier\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"ExplanationOfBenefit.prescriptionIdentifier\",\
		\"weight\": 2337,\
		\"max\": \"1\",\
		\"type\": \"Identifier\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"ExplanationOfBenefit.prescriptionReference\",\
		\"weight\": 2337,\
		\"max\": \"1\",\
		\"type\": \"Reference\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"ExplanationOfBenefit.prescriptionReference\",\
		\"weight\": 2337,\
		\"max\": \"1\",\
		\"type\": \"Reference\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"ExplanationOfBenefit.originalPrescriptionIdentifier\",\
		\"weight\": 2338,\
		\"max\": \"1\",\
		\"type\": \"Identifier\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"ExplanationOfBenefit.originalPrescriptionReference\",\
		\"weight\": 2338,\
		\"max\": \"1\",\
		\"type\": \"Reference\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"ExplanationOfBenefit.payee\",\
		\"weight\": 2339,\
		\"max\": \"1\",\
		\"type\": \"BackboneElement\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"ExplanationOfBenefit.payee.id\",\
		\"weight\": 2340,\
		\"max\": \"1\",\
		\"type\": \"id\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"ExplanationOfBenefit.payee.extension\",\
		\"weight\": 2341,\
		\"max\": \"*\",\
		\"type\": \"Extension\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"ExplanationOfBenefit.payee.modifierExtension\",\
		\"weight\": 2342,\
		\"max\": \"*\",\
		\"type\": \"Extension\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"ExplanationOfBenefit.payee.type\",\
		\"weight\": 2343,\
		\"max\": \"1\",\
		\"type\": \"Coding\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"ExplanationOfBenefit.payee.partyIdentifier\",\
		\"weight\": 2344,\
		\"max\": \"1\",\
		\"type\": \"Identifier\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"ExplanationOfBenefit.payee.partyReference\",\
		\"weight\": 2344,\
		\"max\": \"1\",\
		\"type\": \"Reference\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"ExplanationOfBenefit.payee.partyReference\",\
		\"weight\": 2344,\
		\"max\": \"1\",\
		\"type\": \"Reference\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"ExplanationOfBenefit.payee.partyReference\",\
		\"weight\": 2344,\
		\"max\": \"1\",\
		\"type\": \"Reference\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"ExplanationOfBenefit.payee.partyReference\",\
		\"weight\": 2344,\
		\"max\": \"1\",\
		\"type\": \"Reference\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"ExplanationOfBenefit.referralIdentifier\",\
		\"weight\": 2345,\
		\"max\": \"1\",\
		\"type\": \"Identifier\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"ExplanationOfBenefit.referralReference\",\
		\"weight\": 2345,\
		\"max\": \"1\",\
		\"type\": \"Reference\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"ExplanationOfBenefit.occurrenceCode\",\
		\"weight\": 2346,\
		\"max\": \"*\",\
		\"type\": \"Coding\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"ExplanationOfBenefit.occurenceSpanCode\",\
		\"weight\": 2347,\
		\"max\": \"*\",\
		\"type\": \"Coding\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"ExplanationOfBenefit.valueCode\",\
		\"weight\": 2348,\
		\"max\": \"*\",\
		\"type\": \"Coding\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"ExplanationOfBenefit.diagnosis\",\
		\"weight\": 2349,\
		\"max\": \"*\",\
		\"type\": \"BackboneElement\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"ExplanationOfBenefit.diagnosis.id\",\
		\"weight\": 2350,\
		\"max\": \"1\",\
		\"type\": \"id\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"ExplanationOfBenefit.diagnosis.extension\",\
		\"weight\": 2351,\
		\"max\": \"*\",\
		\"type\": \"Extension\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"ExplanationOfBenefit.diagnosis.modifierExtension\",\
		\"weight\": 2352,\
		\"max\": \"*\",\
		\"type\": \"Extension\"\
	},\
	{\
		\"min\": \"1\",\
		\"path\": \"ExplanationOfBenefit.diagnosis.sequence\",\
		\"weight\": 2353,\
		\"max\": \"1\",\
		\"type\": \"positiveInt\"\
	},\
	{\
		\"min\": \"1\",\
		\"path\": \"ExplanationOfBenefit.diagnosis.diagnosis\",\
		\"weight\": 2354,\
		\"max\": \"1\",\
		\"type\": \"Coding\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"ExplanationOfBenefit.procedure\",\
		\"weight\": 2355,\
		\"max\": \"*\",\
		\"type\": \"BackboneElement\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"ExplanationOfBenefit.procedure.id\",\
		\"weight\": 2356,\
		\"max\": \"1\",\
		\"type\": \"id\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"ExplanationOfBenefit.procedure.extension\",\
		\"weight\": 2357,\
		\"max\": \"*\",\
		\"type\": \"Extension\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"ExplanationOfBenefit.procedure.modifierExtension\",\
		\"weight\": 2358,\
		\"max\": \"*\",\
		\"type\": \"Extension\"\
	},\
	{\
		\"min\": \"1\",\
		\"path\": \"ExplanationOfBenefit.procedure.sequence\",\
		\"weight\": 2359,\
		\"max\": \"1\",\
		\"type\": \"positiveInt\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"ExplanationOfBenefit.procedure.date\",\
		\"weight\": 2360,\
		\"max\": \"1\",\
		\"type\": \"dateTime\"\
	},\
	{\
		\"min\": \"1\",\
		\"path\": \"ExplanationOfBenefit.procedure.procedureCoding\",\
		\"weight\": 2361,\
		\"max\": \"1\",\
		\"type\": \"Coding\"\
	},\
	{\
		\"min\": \"1\",\
		\"path\": \"ExplanationOfBenefit.procedure.procedureReference\",\
		\"weight\": 2361,\
		\"max\": \"1\",\
		\"type\": \"Reference\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"ExplanationOfBenefit.specialCondition\",\
		\"weight\": 2362,\
		\"max\": \"*\",\
		\"type\": \"Coding\"\
	},\
	{\
		\"min\": \"1\",\
		\"path\": \"ExplanationOfBenefit.patientIdentifier\",\
		\"weight\": 2363,\
		\"max\": \"1\",\
		\"type\": \"Identifier\"\
	},\
	{\
		\"min\": \"1\",\
		\"path\": \"ExplanationOfBenefit.patientReference\",\
		\"weight\": 2363,\
		\"max\": \"1\",\
		\"type\": \"Reference\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"ExplanationOfBenefit.precedence\",\
		\"weight\": 2364,\
		\"max\": \"1\",\
		\"type\": \"positiveInt\"\
	},\
	{\
		\"min\": \"1\",\
		\"path\": \"ExplanationOfBenefit.coverage\",\
		\"weight\": 2365,\
		\"max\": \"1\",\
		\"type\": \"BackboneElement\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"ExplanationOfBenefit.coverage.id\",\
		\"weight\": 2366,\
		\"max\": \"1\",\
		\"type\": \"id\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"ExplanationOfBenefit.coverage.extension\",\
		\"weight\": 2367,\
		\"max\": \"*\",\
		\"type\": \"Extension\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"ExplanationOfBenefit.coverage.modifierExtension\",\
		\"weight\": 2368,\
		\"max\": \"*\",\
		\"type\": \"Extension\"\
	},\
	{\
		\"min\": \"1\",\
		\"path\": \"ExplanationOfBenefit.coverage.coverageIdentifier\",\
		\"weight\": 2369,\
		\"max\": \"1\",\
		\"type\": \"Identifier\"\
	},\
	{\
		\"min\": \"1\",\
		\"path\": \"ExplanationOfBenefit.coverage.coverageReference\",\
		\"weight\": 2369,\
		\"max\": \"1\",\
		\"type\": \"Reference\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"ExplanationOfBenefit.coverage.preAuthRef\",\
		\"weight\": 2370,\
		\"max\": \"*\",\
		\"type\": \"string\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"ExplanationOfBenefit.accidentDate\",\
		\"weight\": 2371,\
		\"max\": \"1\",\
		\"type\": \"date\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"ExplanationOfBenefit.accidentType\",\
		\"weight\": 2372,\
		\"max\": \"1\",\
		\"type\": \"Coding\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"ExplanationOfBenefit.accidentLocationAddress\",\
		\"weight\": 2373,\
		\"max\": \"1\",\
		\"type\": \"Address\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"ExplanationOfBenefit.accidentLocationReference\",\
		\"weight\": 2373,\
		\"max\": \"1\",\
		\"type\": \"Reference\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"ExplanationOfBenefit.interventionException\",\
		\"weight\": 2374,\
		\"max\": \"*\",\
		\"type\": \"Coding\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"ExplanationOfBenefit.onset\",\
		\"weight\": 2375,\
		\"max\": \"*\",\
		\"type\": \"BackboneElement\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"ExplanationOfBenefit.onset.id\",\
		\"weight\": 2376,\
		\"max\": \"1\",\
		\"type\": \"id\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"ExplanationOfBenefit.onset.extension\",\
		\"weight\": 2377,\
		\"max\": \"*\",\
		\"type\": \"Extension\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"ExplanationOfBenefit.onset.modifierExtension\",\
		\"weight\": 2378,\
		\"max\": \"*\",\
		\"type\": \"Extension\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"ExplanationOfBenefit.onset.timeDate\",\
		\"weight\": 2379,\
		\"max\": \"1\",\
		\"type\": \"date\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"ExplanationOfBenefit.onset.timePeriod\",\
		\"weight\": 2379,\
		\"max\": \"1\",\
		\"type\": \"Period\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"ExplanationOfBenefit.onset.type\",\
		\"weight\": 2380,\
		\"max\": \"1\",\
		\"type\": \"Coding\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"ExplanationOfBenefit.employmentImpacted\",\
		\"weight\": 2381,\
		\"max\": \"1\",\
		\"type\": \"Period\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"ExplanationOfBenefit.hospitalization\",\
		\"weight\": 2382,\
		\"max\": \"1\",\
		\"type\": \"Period\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"ExplanationOfBenefit.item\",\
		\"weight\": 2383,\
		\"max\": \"*\",\
		\"type\": \"BackboneElement\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"ExplanationOfBenefit.item.id\",\
		\"weight\": 2384,\
		\"max\": \"1\",\
		\"type\": \"id\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"ExplanationOfBenefit.item.extension\",\
		\"weight\": 2385,\
		\"max\": \"*\",\
		\"type\": \"Extension\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"ExplanationOfBenefit.item.modifierExtension\",\
		\"weight\": 2386,\
		\"max\": \"*\",\
		\"type\": \"Extension\"\
	},\
	{\
		\"min\": \"1\",\
		\"path\": \"ExplanationOfBenefit.item.sequence\",\
		\"weight\": 2387,\
		\"max\": \"1\",\
		\"type\": \"positiveInt\"\
	},\
	{\
		\"min\": \"1\",\
		\"path\": \"ExplanationOfBenefit.item.type\",\
		\"weight\": 2388,\
		\"max\": \"1\",\
		\"type\": \"Coding\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"ExplanationOfBenefit.item.providerIdentifier\",\
		\"weight\": 2389,\
		\"max\": \"1\",\
		\"type\": \"Identifier\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"ExplanationOfBenefit.item.providerReference\",\
		\"weight\": 2389,\
		\"max\": \"1\",\
		\"type\": \"Reference\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"ExplanationOfBenefit.item.supervisorIdentifier\",\
		\"weight\": 2390,\
		\"max\": \"1\",\
		\"type\": \"Identifier\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"ExplanationOfBenefit.item.supervisorReference\",\
		\"weight\": 2390,\
		\"max\": \"1\",\
		\"type\": \"Reference\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"ExplanationOfBenefit.item.providerQualification\",\
		\"weight\": 2391,\
		\"max\": \"1\",\
		\"type\": \"Coding\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"ExplanationOfBenefit.item.diagnosisLinkId\",\
		\"weight\": 2392,\
		\"max\": \"*\",\
		\"type\": \"positiveInt\"\
	},\
	{\
		\"min\": \"1\",\
		\"path\": \"ExplanationOfBenefit.item.service\",\
		\"weight\": 2393,\
		\"max\": \"1\",\
		\"type\": \"Coding\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"ExplanationOfBenefit.item.serviceModifier\",\
		\"weight\": 2394,\
		\"max\": \"*\",\
		\"type\": \"Coding\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"ExplanationOfBenefit.item.modifier\",\
		\"weight\": 2395,\
		\"max\": \"*\",\
		\"type\": \"Coding\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"ExplanationOfBenefit.item.programCode\",\
		\"weight\": 2396,\
		\"max\": \"*\",\
		\"type\": \"Coding\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"ExplanationOfBenefit.item.servicedDate\",\
		\"weight\": 2397,\
		\"max\": \"1\",\
		\"type\": \"date\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"ExplanationOfBenefit.item.servicedPeriod\",\
		\"weight\": 2397,\
		\"max\": \"1\",\
		\"type\": \"Period\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"ExplanationOfBenefit.item.place\",\
		\"weight\": 2398,\
		\"max\": \"1\",\
		\"type\": \"Coding\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"ExplanationOfBenefit.item.quantity\",\
		\"weight\": 2399,\
		\"max\": \"1\",\
		\"type\": \"Quantity\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"ExplanationOfBenefit.item.unitPrice\",\
		\"weight\": 2400,\
		\"max\": \"1\",\
		\"type\": \"Quantity\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"ExplanationOfBenefit.item.factor\",\
		\"weight\": 2401,\
		\"max\": \"1\",\
		\"type\": \"decimal\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"ExplanationOfBenefit.item.points\",\
		\"weight\": 2402,\
		\"max\": \"1\",\
		\"type\": \"decimal\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"ExplanationOfBenefit.item.net\",\
		\"weight\": 2403,\
		\"max\": \"1\",\
		\"type\": \"Quantity\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"ExplanationOfBenefit.item.udi\",\
		\"weight\": 2404,\
		\"max\": \"*\",\
		\"type\": \"Reference\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"ExplanationOfBenefit.item.bodySite\",\
		\"weight\": 2405,\
		\"max\": \"1\",\
		\"type\": \"Coding\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"ExplanationOfBenefit.item.subSite\",\
		\"weight\": 2406,\
		\"max\": \"*\",\
		\"type\": \"Coding\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"ExplanationOfBenefit.item.noteNumber\",\
		\"weight\": 2407,\
		\"max\": \"*\",\
		\"type\": \"positiveInt\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"ExplanationOfBenefit.item.adjudication\",\
		\"weight\": 2408,\
		\"max\": \"*\",\
		\"type\": \"BackboneElement\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"ExplanationOfBenefit.item.adjudication.id\",\
		\"weight\": 2409,\
		\"max\": \"1\",\
		\"type\": \"id\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"ExplanationOfBenefit.item.adjudication.extension\",\
		\"weight\": 2410,\
		\"max\": \"*\",\
		\"type\": \"Extension\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"ExplanationOfBenefit.item.adjudication.modifierExtension\",\
		\"weight\": 2411,\
		\"max\": \"*\",\
		\"type\": \"Extension\"\
	},\
	{\
		\"min\": \"1\",\
		\"path\": \"ExplanationOfBenefit.item.adjudication.category\",\
		\"weight\": 2412,\
		\"max\": \"1\",\
		\"type\": \"Coding\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"ExplanationOfBenefit.item.adjudication.reason\",\
		\"weight\": 2413,\
		\"max\": \"1\",\
		\"type\": \"Coding\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"ExplanationOfBenefit.item.adjudication.amount\",\
		\"weight\": 2414,\
		\"max\": \"1\",\
		\"type\": \"Quantity\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"ExplanationOfBenefit.item.adjudication.value\",\
		\"weight\": 2415,\
		\"max\": \"1\",\
		\"type\": \"decimal\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"ExplanationOfBenefit.item.detail\",\
		\"weight\": 2416,\
		\"max\": \"*\",\
		\"type\": \"BackboneElement\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"ExplanationOfBenefit.item.detail.id\",\
		\"weight\": 2417,\
		\"max\": \"1\",\
		\"type\": \"id\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"ExplanationOfBenefit.item.detail.extension\",\
		\"weight\": 2418,\
		\"max\": \"*\",\
		\"type\": \"Extension\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"ExplanationOfBenefit.item.detail.modifierExtension\",\
		\"weight\": 2419,\
		\"max\": \"*\",\
		\"type\": \"Extension\"\
	},\
	{\
		\"min\": \"1\",\
		\"path\": \"ExplanationOfBenefit.item.detail.sequence\",\
		\"weight\": 2420,\
		\"max\": \"1\",\
		\"type\": \"positiveInt\"\
	},\
	{\
		\"min\": \"1\",\
		\"path\": \"ExplanationOfBenefit.item.detail.type\",\
		\"weight\": 2421,\
		\"max\": \"1\",\
		\"type\": \"Coding\"\
	},\
	{\
		\"min\": \"1\",\
		\"path\": \"ExplanationOfBenefit.item.detail.service\",\
		\"weight\": 2422,\
		\"max\": \"1\",\
		\"type\": \"Coding\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"ExplanationOfBenefit.item.detail.programCode\",\
		\"weight\": 2423,\
		\"max\": \"*\",\
		\"type\": \"Coding\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"ExplanationOfBenefit.item.detail.quantity\",\
		\"weight\": 2424,\
		\"max\": \"1\",\
		\"type\": \"Quantity\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"ExplanationOfBenefit.item.detail.unitPrice\",\
		\"weight\": 2425,\
		\"max\": \"1\",\
		\"type\": \"Quantity\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"ExplanationOfBenefit.item.detail.factor\",\
		\"weight\": 2426,\
		\"max\": \"1\",\
		\"type\": \"decimal\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"ExplanationOfBenefit.item.detail.points\",\
		\"weight\": 2427,\
		\"max\": \"1\",\
		\"type\": \"decimal\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"ExplanationOfBenefit.item.detail.net\",\
		\"weight\": 2428,\
		\"max\": \"1\",\
		\"type\": \"Quantity\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"ExplanationOfBenefit.item.detail.udi\",\
		\"weight\": 2429,\
		\"max\": \"*\",\
		\"type\": \"Reference\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"ExplanationOfBenefit.item.detail.adjudication\",\
		\"weight\": 2430,\
		\"max\": \"*\",\
		\"type\": \"BackboneElement\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"ExplanationOfBenefit.item.detail.adjudication.id\",\
		\"weight\": 2431,\
		\"max\": \"1\",\
		\"type\": \"id\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"ExplanationOfBenefit.item.detail.adjudication.extension\",\
		\"weight\": 2432,\
		\"max\": \"*\",\
		\"type\": \"Extension\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"ExplanationOfBenefit.item.detail.adjudication.modifierExtension\",\
		\"weight\": 2433,\
		\"max\": \"*\",\
		\"type\": \"Extension\"\
	},\
	{\
		\"min\": \"1\",\
		\"path\": \"ExplanationOfBenefit.item.detail.adjudication.category\",\
		\"weight\": 2434,\
		\"max\": \"1\",\
		\"type\": \"Coding\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"ExplanationOfBenefit.item.detail.adjudication.reason\",\
		\"weight\": 2435,\
		\"max\": \"1\",\
		\"type\": \"Coding\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"ExplanationOfBenefit.item.detail.adjudication.amount\",\
		\"weight\": 2436,\
		\"max\": \"1\",\
		\"type\": \"Quantity\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"ExplanationOfBenefit.item.detail.adjudication.value\",\
		\"weight\": 2437,\
		\"max\": \"1\",\
		\"type\": \"decimal\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"ExplanationOfBenefit.item.detail.subDetail\",\
		\"weight\": 2438,\
		\"max\": \"*\",\
		\"type\": \"BackboneElement\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"ExplanationOfBenefit.item.detail.subDetail.id\",\
		\"weight\": 2439,\
		\"max\": \"1\",\
		\"type\": \"id\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"ExplanationOfBenefit.item.detail.subDetail.extension\",\
		\"weight\": 2440,\
		\"max\": \"*\",\
		\"type\": \"Extension\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"ExplanationOfBenefit.item.detail.subDetail.modifierExtension\",\
		\"weight\": 2441,\
		\"max\": \"*\",\
		\"type\": \"Extension\"\
	},\
	{\
		\"min\": \"1\",\
		\"path\": \"ExplanationOfBenefit.item.detail.subDetail.sequence\",\
		\"weight\": 2442,\
		\"max\": \"1\",\
		\"type\": \"positiveInt\"\
	},\
	{\
		\"min\": \"1\",\
		\"path\": \"ExplanationOfBenefit.item.detail.subDetail.type\",\
		\"weight\": 2443,\
		\"max\": \"1\",\
		\"type\": \"Coding\"\
	},\
	{\
		\"min\": \"1\",\
		\"path\": \"ExplanationOfBenefit.item.detail.subDetail.service\",\
		\"weight\": 2444,\
		\"max\": \"1\",\
		\"type\": \"Coding\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"ExplanationOfBenefit.item.detail.subDetail.programCode\",\
		\"weight\": 2445,\
		\"max\": \"*\",\
		\"type\": \"Coding\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"ExplanationOfBenefit.item.detail.subDetail.quantity\",\
		\"weight\": 2446,\
		\"max\": \"1\",\
		\"type\": \"Quantity\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"ExplanationOfBenefit.item.detail.subDetail.unitPrice\",\
		\"weight\": 2447,\
		\"max\": \"1\",\
		\"type\": \"Quantity\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"ExplanationOfBenefit.item.detail.subDetail.factor\",\
		\"weight\": 2448,\
		\"max\": \"1\",\
		\"type\": \"decimal\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"ExplanationOfBenefit.item.detail.subDetail.points\",\
		\"weight\": 2449,\
		\"max\": \"1\",\
		\"type\": \"decimal\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"ExplanationOfBenefit.item.detail.subDetail.net\",\
		\"weight\": 2450,\
		\"max\": \"1\",\
		\"type\": \"Quantity\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"ExplanationOfBenefit.item.detail.subDetail.udi\",\
		\"weight\": 2451,\
		\"max\": \"*\",\
		\"type\": \"Reference\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"ExplanationOfBenefit.item.detail.subDetail.adjudication\",\
		\"weight\": 2452,\
		\"max\": \"*\",\
		\"type\": \"BackboneElement\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"ExplanationOfBenefit.item.detail.subDetail.adjudication.id\",\
		\"weight\": 2453,\
		\"max\": \"1\",\
		\"type\": \"id\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"ExplanationOfBenefit.item.detail.subDetail.adjudication.extension\",\
		\"weight\": 2454,\
		\"max\": \"*\",\
		\"type\": \"Extension\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"ExplanationOfBenefit.item.detail.subDetail.adjudication.modifierExtension\",\
		\"weight\": 2455,\
		\"max\": \"*\",\
		\"type\": \"Extension\"\
	},\
	{\
		\"min\": \"1\",\
		\"path\": \"ExplanationOfBenefit.item.detail.subDetail.adjudication.category\",\
		\"weight\": 2456,\
		\"max\": \"1\",\
		\"type\": \"Coding\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"ExplanationOfBenefit.item.detail.subDetail.adjudication.reason\",\
		\"weight\": 2457,\
		\"max\": \"1\",\
		\"type\": \"Coding\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"ExplanationOfBenefit.item.detail.subDetail.adjudication.amount\",\
		\"weight\": 2458,\
		\"max\": \"1\",\
		\"type\": \"Quantity\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"ExplanationOfBenefit.item.detail.subDetail.adjudication.value\",\
		\"weight\": 2459,\
		\"max\": \"1\",\
		\"type\": \"decimal\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"ExplanationOfBenefit.item.prosthesis\",\
		\"weight\": 2460,\
		\"max\": \"1\",\
		\"type\": \"BackboneElement\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"ExplanationOfBenefit.item.prosthesis.id\",\
		\"weight\": 2461,\
		\"max\": \"1\",\
		\"type\": \"id\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"ExplanationOfBenefit.item.prosthesis.extension\",\
		\"weight\": 2462,\
		\"max\": \"*\",\
		\"type\": \"Extension\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"ExplanationOfBenefit.item.prosthesis.modifierExtension\",\
		\"weight\": 2463,\
		\"max\": \"*\",\
		\"type\": \"Extension\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"ExplanationOfBenefit.item.prosthesis.initial\",\
		\"weight\": 2464,\
		\"max\": \"1\",\
		\"type\": \"boolean\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"ExplanationOfBenefit.item.prosthesis.priorDate\",\
		\"weight\": 2465,\
		\"max\": \"1\",\
		\"type\": \"date\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"ExplanationOfBenefit.item.prosthesis.priorMaterial\",\
		\"weight\": 2466,\
		\"max\": \"1\",\
		\"type\": \"Coding\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"ExplanationOfBenefit.addItem\",\
		\"weight\": 2467,\
		\"max\": \"*\",\
		\"type\": \"BackboneElement\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"ExplanationOfBenefit.addItem.id\",\
		\"weight\": 2468,\
		\"max\": \"1\",\
		\"type\": \"id\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"ExplanationOfBenefit.addItem.extension\",\
		\"weight\": 2469,\
		\"max\": \"*\",\
		\"type\": \"Extension\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"ExplanationOfBenefit.addItem.modifierExtension\",\
		\"weight\": 2470,\
		\"max\": \"*\",\
		\"type\": \"Extension\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"ExplanationOfBenefit.addItem.sequenceLinkId\",\
		\"weight\": 2471,\
		\"max\": \"*\",\
		\"type\": \"positiveInt\"\
	},\
	{\
		\"min\": \"1\",\
		\"path\": \"ExplanationOfBenefit.addItem.service\",\
		\"weight\": 2472,\
		\"max\": \"1\",\
		\"type\": \"Coding\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"ExplanationOfBenefit.addItem.fee\",\
		\"weight\": 2473,\
		\"max\": \"1\",\
		\"type\": \"Quantity\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"ExplanationOfBenefit.addItem.noteNumberLinkId\",\
		\"weight\": 2474,\
		\"max\": \"*\",\
		\"type\": \"positiveInt\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"ExplanationOfBenefit.addItem.adjudication\",\
		\"weight\": 2475,\
		\"max\": \"*\",\
		\"type\": \"BackboneElement\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"ExplanationOfBenefit.addItem.adjudication.id\",\
		\"weight\": 2476,\
		\"max\": \"1\",\
		\"type\": \"id\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"ExplanationOfBenefit.addItem.adjudication.extension\",\
		\"weight\": 2477,\
		\"max\": \"*\",\
		\"type\": \"Extension\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"ExplanationOfBenefit.addItem.adjudication.modifierExtension\",\
		\"weight\": 2478,\
		\"max\": \"*\",\
		\"type\": \"Extension\"\
	},\
	{\
		\"min\": \"1\",\
		\"path\": \"ExplanationOfBenefit.addItem.adjudication.category\",\
		\"weight\": 2479,\
		\"max\": \"1\",\
		\"type\": \"Coding\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"ExplanationOfBenefit.addItem.adjudication.reason\",\
		\"weight\": 2480,\
		\"max\": \"1\",\
		\"type\": \"Coding\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"ExplanationOfBenefit.addItem.adjudication.amount\",\
		\"weight\": 2481,\
		\"max\": \"1\",\
		\"type\": \"Quantity\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"ExplanationOfBenefit.addItem.adjudication.value\",\
		\"weight\": 2482,\
		\"max\": \"1\",\
		\"type\": \"decimal\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"ExplanationOfBenefit.addItem.detail\",\
		\"weight\": 2483,\
		\"max\": \"*\",\
		\"type\": \"BackboneElement\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"ExplanationOfBenefit.addItem.detail.id\",\
		\"weight\": 2484,\
		\"max\": \"1\",\
		\"type\": \"id\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"ExplanationOfBenefit.addItem.detail.extension\",\
		\"weight\": 2485,\
		\"max\": \"*\",\
		\"type\": \"Extension\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"ExplanationOfBenefit.addItem.detail.modifierExtension\",\
		\"weight\": 2486,\
		\"max\": \"*\",\
		\"type\": \"Extension\"\
	},\
	{\
		\"min\": \"1\",\
		\"path\": \"ExplanationOfBenefit.addItem.detail.service\",\
		\"weight\": 2487,\
		\"max\": \"1\",\
		\"type\": \"Coding\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"ExplanationOfBenefit.addItem.detail.fee\",\
		\"weight\": 2488,\
		\"max\": \"1\",\
		\"type\": \"Quantity\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"ExplanationOfBenefit.addItem.detail.adjudication\",\
		\"weight\": 2489,\
		\"max\": \"*\",\
		\"type\": \"BackboneElement\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"ExplanationOfBenefit.addItem.detail.adjudication.id\",\
		\"weight\": 2490,\
		\"max\": \"1\",\
		\"type\": \"id\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"ExplanationOfBenefit.addItem.detail.adjudication.extension\",\
		\"weight\": 2491,\
		\"max\": \"*\",\
		\"type\": \"Extension\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"ExplanationOfBenefit.addItem.detail.adjudication.modifierExtension\",\
		\"weight\": 2492,\
		\"max\": \"*\",\
		\"type\": \"Extension\"\
	},\
	{\
		\"min\": \"1\",\
		\"path\": \"ExplanationOfBenefit.addItem.detail.adjudication.category\",\
		\"weight\": 2493,\
		\"max\": \"1\",\
		\"type\": \"Coding\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"ExplanationOfBenefit.addItem.detail.adjudication.reason\",\
		\"weight\": 2494,\
		\"max\": \"1\",\
		\"type\": \"Coding\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"ExplanationOfBenefit.addItem.detail.adjudication.amount\",\
		\"weight\": 2495,\
		\"max\": \"1\",\
		\"type\": \"Quantity\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"ExplanationOfBenefit.addItem.detail.adjudication.value\",\
		\"weight\": 2496,\
		\"max\": \"1\",\
		\"type\": \"decimal\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"ExplanationOfBenefit.missingTeeth\",\
		\"weight\": 2497,\
		\"max\": \"*\",\
		\"type\": \"BackboneElement\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"ExplanationOfBenefit.missingTeeth.id\",\
		\"weight\": 2498,\
		\"max\": \"1\",\
		\"type\": \"id\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"ExplanationOfBenefit.missingTeeth.extension\",\
		\"weight\": 2499,\
		\"max\": \"*\",\
		\"type\": \"Extension\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"ExplanationOfBenefit.missingTeeth.modifierExtension\",\
		\"weight\": 2500,\
		\"max\": \"*\",\
		\"type\": \"Extension\"\
	},\
	{\
		\"min\": \"1\",\
		\"path\": \"ExplanationOfBenefit.missingTeeth.tooth\",\
		\"weight\": 2501,\
		\"max\": \"1\",\
		\"type\": \"Coding\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"ExplanationOfBenefit.missingTeeth.reason\",\
		\"weight\": 2502,\
		\"max\": \"1\",\
		\"type\": \"Coding\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"ExplanationOfBenefit.missingTeeth.extractionDate\",\
		\"weight\": 2503,\
		\"max\": \"1\",\
		\"type\": \"date\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"ExplanationOfBenefit.totalCost\",\
		\"weight\": 2504,\
		\"max\": \"1\",\
		\"type\": \"Quantity\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"ExplanationOfBenefit.unallocDeductable\",\
		\"weight\": 2505,\
		\"max\": \"1\",\
		\"type\": \"Quantity\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"ExplanationOfBenefit.totalBenefit\",\
		\"weight\": 2506,\
		\"max\": \"1\",\
		\"type\": \"Quantity\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"ExplanationOfBenefit.paymentAdjustment\",\
		\"weight\": 2507,\
		\"max\": \"1\",\
		\"type\": \"Quantity\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"ExplanationOfBenefit.paymentAdjustmentReason\",\
		\"weight\": 2508,\
		\"max\": \"1\",\
		\"type\": \"Coding\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"ExplanationOfBenefit.paymentDate\",\
		\"weight\": 2509,\
		\"max\": \"1\",\
		\"type\": \"date\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"ExplanationOfBenefit.paymentAmount\",\
		\"weight\": 2510,\
		\"max\": \"1\",\
		\"type\": \"Quantity\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"ExplanationOfBenefit.paymentRef\",\
		\"weight\": 2511,\
		\"max\": \"1\",\
		\"type\": \"Identifier\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"ExplanationOfBenefit.reserved\",\
		\"weight\": 2512,\
		\"max\": \"1\",\
		\"type\": \"Coding\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"ExplanationOfBenefit.form\",\
		\"weight\": 2513,\
		\"max\": \"1\",\
		\"type\": \"Coding\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"ExplanationOfBenefit.note\",\
		\"weight\": 2514,\
		\"max\": \"*\",\
		\"type\": \"BackboneElement\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"ExplanationOfBenefit.note.id\",\
		\"weight\": 2515,\
		\"max\": \"1\",\
		\"type\": \"id\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"ExplanationOfBenefit.note.extension\",\
		\"weight\": 2516,\
		\"max\": \"*\",\
		\"type\": \"Extension\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"ExplanationOfBenefit.note.modifierExtension\",\
		\"weight\": 2517,\
		\"max\": \"*\",\
		\"type\": \"Extension\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"ExplanationOfBenefit.note.number\",\
		\"weight\": 2518,\
		\"max\": \"1\",\
		\"type\": \"positiveInt\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"ExplanationOfBenefit.note.type\",\
		\"weight\": 2519,\
		\"max\": \"1\",\
		\"type\": \"Coding\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"ExplanationOfBenefit.note.text\",\
		\"weight\": 2520,\
		\"max\": \"1\",\
		\"type\": \"string\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"ExplanationOfBenefit.benefitBalance\",\
		\"weight\": 2521,\
		\"max\": \"*\",\
		\"type\": \"BackboneElement\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"ExplanationOfBenefit.benefitBalance.id\",\
		\"weight\": 2522,\
		\"max\": \"1\",\
		\"type\": \"id\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"ExplanationOfBenefit.benefitBalance.extension\",\
		\"weight\": 2523,\
		\"max\": \"*\",\
		\"type\": \"Extension\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"ExplanationOfBenefit.benefitBalance.modifierExtension\",\
		\"weight\": 2524,\
		\"max\": \"*\",\
		\"type\": \"Extension\"\
	},\
	{\
		\"min\": \"1\",\
		\"path\": \"ExplanationOfBenefit.benefitBalance.category\",\
		\"weight\": 2525,\
		\"max\": \"1\",\
		\"type\": \"Coding\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"ExplanationOfBenefit.benefitBalance.subCategory\",\
		\"weight\": 2526,\
		\"max\": \"1\",\
		\"type\": \"Coding\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"ExplanationOfBenefit.benefitBalance.network\",\
		\"weight\": 2527,\
		\"max\": \"1\",\
		\"type\": \"Coding\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"ExplanationOfBenefit.benefitBalance.unit\",\
		\"weight\": 2528,\
		\"max\": \"1\",\
		\"type\": \"Coding\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"ExplanationOfBenefit.benefitBalance.term\",\
		\"weight\": 2529,\
		\"max\": \"1\",\
		\"type\": \"Coding\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"ExplanationOfBenefit.benefitBalance.financial\",\
		\"weight\": 2530,\
		\"max\": \"*\",\
		\"type\": \"BackboneElement\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"ExplanationOfBenefit.benefitBalance.financial.id\",\
		\"weight\": 2531,\
		\"max\": \"1\",\
		\"type\": \"id\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"ExplanationOfBenefit.benefitBalance.financial.extension\",\
		\"weight\": 2532,\
		\"max\": \"*\",\
		\"type\": \"Extension\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"ExplanationOfBenefit.benefitBalance.financial.modifierExtension\",\
		\"weight\": 2533,\
		\"max\": \"*\",\
		\"type\": \"Extension\"\
	},\
	{\
		\"min\": \"1\",\
		\"path\": \"ExplanationOfBenefit.benefitBalance.financial.type\",\
		\"weight\": 2534,\
		\"max\": \"1\",\
		\"type\": \"Coding\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"ExplanationOfBenefit.benefitBalance.financial.benefitUnsignedInt\",\
		\"weight\": 2535,\
		\"max\": \"1\",\
		\"type\": \"unsignedInt\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"ExplanationOfBenefit.benefitBalance.financial.benefitQuantity\",\
		\"weight\": 2535,\
		\"max\": \"1\",\
		\"type\": \"Quantity\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"ExplanationOfBenefit.benefitBalance.financial.benefitUsedUnsignedInt\",\
		\"weight\": 2536,\
		\"max\": \"1\",\
		\"type\": \"unsignedInt\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"ExplanationOfBenefit.benefitBalance.financial.benefitUsedQuantity\",\
		\"weight\": 2536,\
		\"max\": \"1\",\
		\"type\": \"Quantity\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"FamilyMemberHistory\",\
		\"weight\": 2537,\
		\"max\": \"*\",\
		\"type\": \"DomainResource\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"FamilyMemberHistory.id\",\
		\"weight\": 2538,\
		\"max\": \"1\",\
		\"type\": \"id\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"FamilyMemberHistory.meta\",\
		\"weight\": 2539,\
		\"max\": \"1\",\
		\"type\": \"Meta\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"FamilyMemberHistory.implicitRules\",\
		\"weight\": 2540,\
		\"max\": \"1\",\
		\"type\": \"uri\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"FamilyMemberHistory.language\",\
		\"weight\": 2541,\
		\"max\": \"1\",\
		\"type\": \"code\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"FamilyMemberHistory.text\",\
		\"weight\": 2542,\
		\"max\": \"1\",\
		\"type\": \"Narrative\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"FamilyMemberHistory.contained\",\
		\"weight\": 2543,\
		\"max\": \"*\",\
		\"type\": \"Resource\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"FamilyMemberHistory.extension\",\
		\"weight\": 2544,\
		\"max\": \"*\",\
		\"type\": \"Extension\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"FamilyMemberHistory.modifierExtension\",\
		\"weight\": 2545,\
		\"max\": \"*\",\
		\"type\": \"Extension\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"FamilyMemberHistory.identifier\",\
		\"weight\": 2546,\
		\"max\": \"*\",\
		\"type\": \"Identifier\"\
	},\
	{\
		\"min\": \"1\",\
		\"path\": \"FamilyMemberHistory.patient\",\
		\"weight\": 2547,\
		\"max\": \"1\",\
		\"type\": \"Reference\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"FamilyMemberHistory.date\",\
		\"weight\": 2548,\
		\"max\": \"1\",\
		\"type\": \"dateTime\"\
	},\
	{\
		\"min\": \"1\",\
		\"path\": \"FamilyMemberHistory.status\",\
		\"weight\": 2549,\
		\"max\": \"1\",\
		\"type\": \"code\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"FamilyMemberHistory.name\",\
		\"weight\": 2550,\
		\"max\": \"1\",\
		\"type\": \"string\"\
	},\
	{\
		\"min\": \"1\",\
		\"path\": \"FamilyMemberHistory.relationship\",\
		\"weight\": 2551,\
		\"max\": \"1\",\
		\"type\": \"CodeableConcept\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"FamilyMemberHistory.gender\",\
		\"weight\": 2552,\
		\"max\": \"1\",\
		\"type\": \"code\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"FamilyMemberHistory.bornPeriod\",\
		\"weight\": 2553,\
		\"max\": \"1\",\
		\"type\": \"Period\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"FamilyMemberHistory.bornDate\",\
		\"weight\": 2553,\
		\"max\": \"1\",\
		\"type\": \"date\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"FamilyMemberHistory.bornString\",\
		\"weight\": 2553,\
		\"max\": \"1\",\
		\"type\": \"string\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"FamilyMemberHistory.ageQuantity\",\
		\"weight\": 2554,\
		\"max\": \"1\",\
		\"type\": \"Quantity\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"FamilyMemberHistory.ageRange\",\
		\"weight\": 2554,\
		\"max\": \"1\",\
		\"type\": \"Range\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"FamilyMemberHistory.ageString\",\
		\"weight\": 2554,\
		\"max\": \"1\",\
		\"type\": \"string\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"FamilyMemberHistory.deceasedBoolean\",\
		\"weight\": 2555,\
		\"max\": \"1\",\
		\"type\": \"boolean\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"FamilyMemberHistory.deceasedQuantity\",\
		\"weight\": 2555,\
		\"max\": \"1\",\
		\"type\": \"Quantity\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"FamilyMemberHistory.deceasedRange\",\
		\"weight\": 2555,\
		\"max\": \"1\",\
		\"type\": \"Range\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"FamilyMemberHistory.deceasedDate\",\
		\"weight\": 2555,\
		\"max\": \"1\",\
		\"type\": \"date\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"FamilyMemberHistory.deceasedString\",\
		\"weight\": 2555,\
		\"max\": \"1\",\
		\"type\": \"string\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"FamilyMemberHistory.note\",\
		\"weight\": 2556,\
		\"max\": \"1\",\
		\"type\": \"Annotation\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"FamilyMemberHistory.condition\",\
		\"weight\": 2557,\
		\"max\": \"*\",\
		\"type\": \"BackboneElement\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"FamilyMemberHistory.condition.id\",\
		\"weight\": 2558,\
		\"max\": \"1\",\
		\"type\": \"id\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"FamilyMemberHistory.condition.extension\",\
		\"weight\": 2559,\
		\"max\": \"*\",\
		\"type\": \"Extension\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"FamilyMemberHistory.condition.modifierExtension\",\
		\"weight\": 2560,\
		\"max\": \"*\",\
		\"type\": \"Extension\"\
	},\
	{\
		\"min\": \"1\",\
		\"path\": \"FamilyMemberHistory.condition.code\",\
		\"weight\": 2561,\
		\"max\": \"1\",\
		\"type\": \"CodeableConcept\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"FamilyMemberHistory.condition.outcome\",\
		\"weight\": 2562,\
		\"max\": \"1\",\
		\"type\": \"CodeableConcept\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"FamilyMemberHistory.condition.onsetQuantity\",\
		\"weight\": 2563,\
		\"max\": \"1\",\
		\"type\": \"Quantity\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"FamilyMemberHistory.condition.onsetRange\",\
		\"weight\": 2563,\
		\"max\": \"1\",\
		\"type\": \"Range\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"FamilyMemberHistory.condition.onsetPeriod\",\
		\"weight\": 2563,\
		\"max\": \"1\",\
		\"type\": \"Period\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"FamilyMemberHistory.condition.onsetString\",\
		\"weight\": 2563,\
		\"max\": \"1\",\
		\"type\": \"string\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"FamilyMemberHistory.condition.note\",\
		\"weight\": 2564,\
		\"max\": \"1\",\
		\"type\": \"Annotation\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Flag\",\
		\"weight\": 2565,\
		\"max\": \"*\",\
		\"type\": \"DomainResource\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Flag.id\",\
		\"weight\": 2566,\
		\"max\": \"1\",\
		\"type\": \"id\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Flag.meta\",\
		\"weight\": 2567,\
		\"max\": \"1\",\
		\"type\": \"Meta\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Flag.implicitRules\",\
		\"weight\": 2568,\
		\"max\": \"1\",\
		\"type\": \"uri\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Flag.language\",\
		\"weight\": 2569,\
		\"max\": \"1\",\
		\"type\": \"code\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Flag.text\",\
		\"weight\": 2570,\
		\"max\": \"1\",\
		\"type\": \"Narrative\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Flag.contained\",\
		\"weight\": 2571,\
		\"max\": \"*\",\
		\"type\": \"Resource\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Flag.extension\",\
		\"weight\": 2572,\
		\"max\": \"*\",\
		\"type\": \"Extension\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Flag.modifierExtension\",\
		\"weight\": 2573,\
		\"max\": \"*\",\
		\"type\": \"Extension\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Flag.identifier\",\
		\"weight\": 2574,\
		\"max\": \"*\",\
		\"type\": \"Identifier\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Flag.category\",\
		\"weight\": 2575,\
		\"max\": \"1\",\
		\"type\": \"CodeableConcept\"\
	},\
	{\
		\"min\": \"1\",\
		\"path\": \"Flag.status\",\
		\"weight\": 2576,\
		\"max\": \"1\",\
		\"type\": \"code\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Flag.period\",\
		\"weight\": 2577,\
		\"max\": \"1\",\
		\"type\": \"Period\"\
	},\
	{\
		\"min\": \"1\",\
		\"path\": \"Flag.subject\",\
		\"weight\": 2578,\
		\"max\": \"1\",\
		\"type\": \"Reference\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Flag.encounter\",\
		\"weight\": 2579,\
		\"max\": \"1\",\
		\"type\": \"Reference\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Flag.author\",\
		\"weight\": 2580,\
		\"max\": \"1\",\
		\"type\": \"Reference\"\
	},\
	{\
		\"min\": \"1\",\
		\"path\": \"Flag.code\",\
		\"weight\": 2581,\
		\"max\": \"1\",\
		\"type\": \"CodeableConcept\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Goal\",\
		\"weight\": 2582,\
		\"max\": \"*\",\
		\"type\": \"DomainResource\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Goal.id\",\
		\"weight\": 2583,\
		\"max\": \"1\",\
		\"type\": \"id\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Goal.meta\",\
		\"weight\": 2584,\
		\"max\": \"1\",\
		\"type\": \"Meta\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Goal.implicitRules\",\
		\"weight\": 2585,\
		\"max\": \"1\",\
		\"type\": \"uri\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Goal.language\",\
		\"weight\": 2586,\
		\"max\": \"1\",\
		\"type\": \"code\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Goal.text\",\
		\"weight\": 2587,\
		\"max\": \"1\",\
		\"type\": \"Narrative\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Goal.contained\",\
		\"weight\": 2588,\
		\"max\": \"*\",\
		\"type\": \"Resource\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Goal.extension\",\
		\"weight\": 2589,\
		\"max\": \"*\",\
		\"type\": \"Extension\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Goal.modifierExtension\",\
		\"weight\": 2590,\
		\"max\": \"*\",\
		\"type\": \"Extension\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Goal.identifier\",\
		\"weight\": 2591,\
		\"max\": \"*\",\
		\"type\": \"Identifier\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Goal.subject\",\
		\"weight\": 2592,\
		\"max\": \"1\",\
		\"type\": \"Reference\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Goal.startDate\",\
		\"weight\": 2593,\
		\"max\": \"1\",\
		\"type\": \"date\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Goal.startCodeableConcept\",\
		\"weight\": 2593,\
		\"max\": \"1\",\
		\"type\": \"CodeableConcept\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Goal.targetDate\",\
		\"weight\": 2594,\
		\"max\": \"1\",\
		\"type\": \"date\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Goal.targetQuantity\",\
		\"weight\": 2594,\
		\"max\": \"1\",\
		\"type\": \"Quantity\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Goal.category\",\
		\"weight\": 2595,\
		\"max\": \"*\",\
		\"type\": \"CodeableConcept\"\
	},\
	{\
		\"min\": \"1\",\
		\"path\": \"Goal.description\",\
		\"weight\": 2596,\
		\"max\": \"1\",\
		\"type\": \"string\"\
	},\
	{\
		\"min\": \"1\",\
		\"path\": \"Goal.status\",\
		\"weight\": 2597,\
		\"max\": \"1\",\
		\"type\": \"code\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Goal.statusDate\",\
		\"weight\": 2598,\
		\"max\": \"1\",\
		\"type\": \"date\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Goal.statusReason\",\
		\"weight\": 2599,\
		\"max\": \"1\",\
		\"type\": \"CodeableConcept\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Goal.author\",\
		\"weight\": 2600,\
		\"max\": \"1\",\
		\"type\": \"Reference\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Goal.priority\",\
		\"weight\": 2601,\
		\"max\": \"1\",\
		\"type\": \"CodeableConcept\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Goal.addresses\",\
		\"weight\": 2602,\
		\"max\": \"*\",\
		\"type\": \"Reference\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Goal.note\",\
		\"weight\": 2603,\
		\"max\": \"*\",\
		\"type\": \"Annotation\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Goal.outcome\",\
		\"weight\": 2604,\
		\"max\": \"*\",\
		\"type\": \"BackboneElement\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Goal.outcome.id\",\
		\"weight\": 2605,\
		\"max\": \"1\",\
		\"type\": \"id\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Goal.outcome.extension\",\
		\"weight\": 2606,\
		\"max\": \"*\",\
		\"type\": \"Extension\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Goal.outcome.modifierExtension\",\
		\"weight\": 2607,\
		\"max\": \"*\",\
		\"type\": \"Extension\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Goal.outcome.resultCodeableConcept\",\
		\"weight\": 2608,\
		\"max\": \"1\",\
		\"type\": \"CodeableConcept\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Goal.outcome.resultReference\",\
		\"weight\": 2608,\
		\"max\": \"1\",\
		\"type\": \"Reference\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Group\",\
		\"weight\": 2609,\
		\"max\": \"*\",\
		\"type\": \"DomainResource\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Group.id\",\
		\"weight\": 2610,\
		\"max\": \"1\",\
		\"type\": \"id\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Group.meta\",\
		\"weight\": 2611,\
		\"max\": \"1\",\
		\"type\": \"Meta\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Group.implicitRules\",\
		\"weight\": 2612,\
		\"max\": \"1\",\
		\"type\": \"uri\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Group.language\",\
		\"weight\": 2613,\
		\"max\": \"1\",\
		\"type\": \"code\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Group.text\",\
		\"weight\": 2614,\
		\"max\": \"1\",\
		\"type\": \"Narrative\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Group.contained\",\
		\"weight\": 2615,\
		\"max\": \"*\",\
		\"type\": \"Resource\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Group.extension\",\
		\"weight\": 2616,\
		\"max\": \"*\",\
		\"type\": \"Extension\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Group.modifierExtension\",\
		\"weight\": 2617,\
		\"max\": \"*\",\
		\"type\": \"Extension\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Group.identifier\",\
		\"weight\": 2618,\
		\"max\": \"*\",\
		\"type\": \"Identifier\"\
	},\
	{\
		\"min\": \"1\",\
		\"path\": \"Group.type\",\
		\"weight\": 2619,\
		\"max\": \"1\",\
		\"type\": \"code\"\
	},\
	{\
		\"min\": \"1\",\
		\"path\": \"Group.actual\",\
		\"weight\": 2620,\
		\"max\": \"1\",\
		\"type\": \"boolean\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Group.active\",\
		\"weight\": 2621,\
		\"max\": \"1\",\
		\"type\": \"boolean\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Group.code\",\
		\"weight\": 2622,\
		\"max\": \"1\",\
		\"type\": \"CodeableConcept\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Group.name\",\
		\"weight\": 2623,\
		\"max\": \"1\",\
		\"type\": \"string\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Group.quantity\",\
		\"weight\": 2624,\
		\"max\": \"1\",\
		\"type\": \"unsignedInt\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Group.characteristic\",\
		\"weight\": 2625,\
		\"max\": \"*\",\
		\"type\": \"BackboneElement\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Group.characteristic.id\",\
		\"weight\": 2626,\
		\"max\": \"1\",\
		\"type\": \"id\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Group.characteristic.extension\",\
		\"weight\": 2627,\
		\"max\": \"*\",\
		\"type\": \"Extension\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Group.characteristic.modifierExtension\",\
		\"weight\": 2628,\
		\"max\": \"*\",\
		\"type\": \"Extension\"\
	},\
	{\
		\"min\": \"1\",\
		\"path\": \"Group.characteristic.code\",\
		\"weight\": 2629,\
		\"max\": \"1\",\
		\"type\": \"CodeableConcept\"\
	},\
	{\
		\"min\": \"1\",\
		\"path\": \"Group.characteristic.valueCodeableConcept\",\
		\"weight\": 2630,\
		\"max\": \"1\",\
		\"type\": \"CodeableConcept\"\
	},\
	{\
		\"min\": \"1\",\
		\"path\": \"Group.characteristic.valueBoolean\",\
		\"weight\": 2630,\
		\"max\": \"1\",\
		\"type\": \"boolean\"\
	},\
	{\
		\"min\": \"1\",\
		\"path\": \"Group.characteristic.valueQuantity\",\
		\"weight\": 2630,\
		\"max\": \"1\",\
		\"type\": \"Quantity\"\
	},\
	{\
		\"min\": \"1\",\
		\"path\": \"Group.characteristic.valueRange\",\
		\"weight\": 2630,\
		\"max\": \"1\",\
		\"type\": \"Range\"\
	},\
	{\
		\"min\": \"1\",\
		\"path\": \"Group.characteristic.exclude\",\
		\"weight\": 2631,\
		\"max\": \"1\",\
		\"type\": \"boolean\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Group.characteristic.period\",\
		\"weight\": 2632,\
		\"max\": \"1\",\
		\"type\": \"Period\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Group.member\",\
		\"weight\": 2633,\
		\"max\": \"*\",\
		\"type\": \"BackboneElement\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Group.member.id\",\
		\"weight\": 2634,\
		\"max\": \"1\",\
		\"type\": \"id\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Group.member.extension\",\
		\"weight\": 2635,\
		\"max\": \"*\",\
		\"type\": \"Extension\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Group.member.modifierExtension\",\
		\"weight\": 2636,\
		\"max\": \"*\",\
		\"type\": \"Extension\"\
	},\
	{\
		\"min\": \"1\",\
		\"path\": \"Group.member.entity\",\
		\"weight\": 2637,\
		\"max\": \"1\",\
		\"type\": \"Reference\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Group.member.period\",\
		\"weight\": 2638,\
		\"max\": \"1\",\
		\"type\": \"Period\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Group.member.inactive\",\
		\"weight\": 2639,\
		\"max\": \"1\",\
		\"type\": \"boolean\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"GuidanceResponse\",\
		\"weight\": 2640,\
		\"max\": \"*\",\
		\"type\": \"DomainResource\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"GuidanceResponse.id\",\
		\"weight\": 2641,\
		\"max\": \"1\",\
		\"type\": \"id\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"GuidanceResponse.meta\",\
		\"weight\": 2642,\
		\"max\": \"1\",\
		\"type\": \"Meta\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"GuidanceResponse.implicitRules\",\
		\"weight\": 2643,\
		\"max\": \"1\",\
		\"type\": \"uri\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"GuidanceResponse.language\",\
		\"weight\": 2644,\
		\"max\": \"1\",\
		\"type\": \"code\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"GuidanceResponse.text\",\
		\"weight\": 2645,\
		\"max\": \"1\",\
		\"type\": \"Narrative\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"GuidanceResponse.contained\",\
		\"weight\": 2646,\
		\"max\": \"*\",\
		\"type\": \"Resource\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"GuidanceResponse.extension\",\
		\"weight\": 2647,\
		\"max\": \"*\",\
		\"type\": \"Extension\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"GuidanceResponse.modifierExtension\",\
		\"weight\": 2648,\
		\"max\": \"*\",\
		\"type\": \"Extension\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"GuidanceResponse.requestId\",\
		\"weight\": 2649,\
		\"max\": \"1\",\
		\"type\": \"string\"\
	},\
	{\
		\"min\": \"1\",\
		\"path\": \"GuidanceResponse.module\",\
		\"weight\": 2650,\
		\"max\": \"1\",\
		\"type\": \"Reference\"\
	},\
	{\
		\"min\": \"1\",\
		\"path\": \"GuidanceResponse.status\",\
		\"weight\": 2651,\
		\"max\": \"1\",\
		\"type\": \"code\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"GuidanceResponse.evaluationMessage\",\
		\"weight\": 2652,\
		\"max\": \"*\",\
		\"type\": \"Reference\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"GuidanceResponse.outputParameters\",\
		\"weight\": 2653,\
		\"max\": \"1\",\
		\"type\": \"Reference\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"GuidanceResponse.action\",\
		\"weight\": 2654,\
		\"max\": \"*\",\
		\"type\": \"BackboneElement\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"GuidanceResponse.action.id\",\
		\"weight\": 2655,\
		\"max\": \"1\",\
		\"type\": \"id\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"GuidanceResponse.action.extension\",\
		\"weight\": 2656,\
		\"max\": \"*\",\
		\"type\": \"Extension\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"GuidanceResponse.action.modifierExtension\",\
		\"weight\": 2657,\
		\"max\": \"*\",\
		\"type\": \"Extension\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"GuidanceResponse.action.actionIdentifier\",\
		\"weight\": 2658,\
		\"max\": \"1\",\
		\"type\": \"Identifier\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"GuidanceResponse.action.label\",\
		\"weight\": 2659,\
		\"max\": \"1\",\
		\"type\": \"string\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"GuidanceResponse.action.title\",\
		\"weight\": 2660,\
		\"max\": \"1\",\
		\"type\": \"string\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"GuidanceResponse.action.description\",\
		\"weight\": 2661,\
		\"max\": \"1\",\
		\"type\": \"string\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"GuidanceResponse.action.textEquivalent\",\
		\"weight\": 2662,\
		\"max\": \"1\",\
		\"type\": \"string\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"GuidanceResponse.action.concept\",\
		\"weight\": 2663,\
		\"max\": \"*\",\
		\"type\": \"CodeableConcept\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"GuidanceResponse.action.supportingEvidence\",\
		\"weight\": 2664,\
		\"max\": \"*\",\
		\"type\": \"Attachment\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"GuidanceResponse.action.relatedAction\",\
		\"weight\": 2665,\
		\"max\": \"1\",\
		\"type\": \"BackboneElement\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"GuidanceResponse.action.relatedAction.id\",\
		\"weight\": 2666,\
		\"max\": \"1\",\
		\"type\": \"id\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"GuidanceResponse.action.relatedAction.extension\",\
		\"weight\": 2667,\
		\"max\": \"*\",\
		\"type\": \"Extension\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"GuidanceResponse.action.relatedAction.modifierExtension\",\
		\"weight\": 2668,\
		\"max\": \"*\",\
		\"type\": \"Extension\"\
	},\
	{\
		\"min\": \"1\",\
		\"path\": \"GuidanceResponse.action.relatedAction.actionIdentifier\",\
		\"weight\": 2669,\
		\"max\": \"1\",\
		\"type\": \"Identifier\"\
	},\
	{\
		\"min\": \"1\",\
		\"path\": \"GuidanceResponse.action.relatedAction.relationship\",\
		\"weight\": 2670,\
		\"max\": \"1\",\
		\"type\": \"code\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"GuidanceResponse.action.relatedAction.offsetQuantity\",\
		\"weight\": 2671,\
		\"max\": \"1\",\
		\"type\": \"Quantity\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"GuidanceResponse.action.relatedAction.offsetRange\",\
		\"weight\": 2671,\
		\"max\": \"1\",\
		\"type\": \"Range\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"GuidanceResponse.action.relatedAction.anchor\",\
		\"weight\": 2672,\
		\"max\": \"1\",\
		\"type\": \"code\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"GuidanceResponse.action.documentation\",\
		\"weight\": 2673,\
		\"max\": \"*\",\
		\"type\": \"Attachment\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"GuidanceResponse.action.participant\",\
		\"weight\": 2674,\
		\"max\": \"*\",\
		\"type\": \"Reference\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"GuidanceResponse.action.type\",\
		\"weight\": 2675,\
		\"max\": \"1\",\
		\"type\": \"code\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"GuidanceResponse.action.behavior\",\
		\"weight\": 2676,\
		\"max\": \"*\",\
		\"type\": \"BackboneElement\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"GuidanceResponse.action.behavior.id\",\
		\"weight\": 2677,\
		\"max\": \"1\",\
		\"type\": \"id\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"GuidanceResponse.action.behavior.extension\",\
		\"weight\": 2678,\
		\"max\": \"*\",\
		\"type\": \"Extension\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"GuidanceResponse.action.behavior.modifierExtension\",\
		\"weight\": 2679,\
		\"max\": \"*\",\
		\"type\": \"Extension\"\
	},\
	{\
		\"min\": \"1\",\
		\"path\": \"GuidanceResponse.action.behavior.type\",\
		\"weight\": 2680,\
		\"max\": \"1\",\
		\"type\": \"Coding\"\
	},\
	{\
		\"min\": \"1\",\
		\"path\": \"GuidanceResponse.action.behavior.value\",\
		\"weight\": 2681,\
		\"max\": \"1\",\
		\"type\": \"Coding\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"GuidanceResponse.action.resource\",\
		\"weight\": 2682,\
		\"max\": \"1\",\
		\"type\": \"Reference\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"GuidanceResponse.action.action\",\
		\"weight\": 2683,\
		\"max\": \"*\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"GuidanceResponse.dataRequirement\",\
		\"weight\": 2684,\
		\"max\": \"*\",\
		\"type\": \"DataRequirement\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"HealthcareService\",\
		\"weight\": 2685,\
		\"max\": \"*\",\
		\"type\": \"DomainResource\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"HealthcareService.id\",\
		\"weight\": 2686,\
		\"max\": \"1\",\
		\"type\": \"id\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"HealthcareService.meta\",\
		\"weight\": 2687,\
		\"max\": \"1\",\
		\"type\": \"Meta\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"HealthcareService.implicitRules\",\
		\"weight\": 2688,\
		\"max\": \"1\",\
		\"type\": \"uri\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"HealthcareService.language\",\
		\"weight\": 2689,\
		\"max\": \"1\",\
		\"type\": \"code\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"HealthcareService.text\",\
		\"weight\": 2690,\
		\"max\": \"1\",\
		\"type\": \"Narrative\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"HealthcareService.contained\",\
		\"weight\": 2691,\
		\"max\": \"*\",\
		\"type\": \"Resource\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"HealthcareService.extension\",\
		\"weight\": 2692,\
		\"max\": \"*\",\
		\"type\": \"Extension\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"HealthcareService.modifierExtension\",\
		\"weight\": 2693,\
		\"max\": \"*\",\
		\"type\": \"Extension\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"HealthcareService.identifier\",\
		\"weight\": 2694,\
		\"max\": \"*\",\
		\"type\": \"Identifier\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"HealthcareService.providedBy\",\
		\"weight\": 2695,\
		\"max\": \"1\",\
		\"type\": \"Reference\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"HealthcareService.serviceCategory\",\
		\"weight\": 2696,\
		\"max\": \"1\",\
		\"type\": \"CodeableConcept\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"HealthcareService.serviceType\",\
		\"weight\": 2697,\
		\"max\": \"*\",\
		\"type\": \"CodeableConcept\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"HealthcareService.specialty\",\
		\"weight\": 2698,\
		\"max\": \"*\",\
		\"type\": \"CodeableConcept\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"HealthcareService.location\",\
		\"weight\": 2699,\
		\"max\": \"*\",\
		\"type\": \"Reference\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"HealthcareService.serviceName\",\
		\"weight\": 2700,\
		\"max\": \"1\",\
		\"type\": \"string\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"HealthcareService.comment\",\
		\"weight\": 2701,\
		\"max\": \"1\",\
		\"type\": \"string\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"HealthcareService.extraDetails\",\
		\"weight\": 2702,\
		\"max\": \"1\",\
		\"type\": \"string\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"HealthcareService.photo\",\
		\"weight\": 2703,\
		\"max\": \"1\",\
		\"type\": \"Attachment\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"HealthcareService.telecom\",\
		\"weight\": 2704,\
		\"max\": \"*\",\
		\"type\": \"ContactPoint\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"HealthcareService.coverageArea\",\
		\"weight\": 2705,\
		\"max\": \"*\",\
		\"type\": \"Reference\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"HealthcareService.serviceProvisionCode\",\
		\"weight\": 2706,\
		\"max\": \"*\",\
		\"type\": \"CodeableConcept\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"HealthcareService.eligibility\",\
		\"weight\": 2707,\
		\"max\": \"1\",\
		\"type\": \"CodeableConcept\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"HealthcareService.eligibilityNote\",\
		\"weight\": 2708,\
		\"max\": \"1\",\
		\"type\": \"string\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"HealthcareService.programName\",\
		\"weight\": 2709,\
		\"max\": \"*\",\
		\"type\": \"string\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"HealthcareService.characteristic\",\
		\"weight\": 2710,\
		\"max\": \"*\",\
		\"type\": \"CodeableConcept\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"HealthcareService.referralMethod\",\
		\"weight\": 2711,\
		\"max\": \"*\",\
		\"type\": \"CodeableConcept\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"HealthcareService.publicKey\",\
		\"weight\": 2712,\
		\"max\": \"1\",\
		\"type\": \"string\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"HealthcareService.appointmentRequired\",\
		\"weight\": 2713,\
		\"max\": \"1\",\
		\"type\": \"boolean\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"HealthcareService.availableTime\",\
		\"weight\": 2714,\
		\"max\": \"*\",\
		\"type\": \"BackboneElement\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"HealthcareService.availableTime.id\",\
		\"weight\": 2715,\
		\"max\": \"1\",\
		\"type\": \"id\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"HealthcareService.availableTime.extension\",\
		\"weight\": 2716,\
		\"max\": \"*\",\
		\"type\": \"Extension\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"HealthcareService.availableTime.modifierExtension\",\
		\"weight\": 2717,\
		\"max\": \"*\",\
		\"type\": \"Extension\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"HealthcareService.availableTime.daysOfWeek\",\
		\"weight\": 2718,\
		\"max\": \"*\",\
		\"type\": \"code\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"HealthcareService.availableTime.allDay\",\
		\"weight\": 2719,\
		\"max\": \"1\",\
		\"type\": \"boolean\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"HealthcareService.availableTime.availableStartTime\",\
		\"weight\": 2720,\
		\"max\": \"1\",\
		\"type\": \"time\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"HealthcareService.availableTime.availableEndTime\",\
		\"weight\": 2721,\
		\"max\": \"1\",\
		\"type\": \"time\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"HealthcareService.notAvailable\",\
		\"weight\": 2722,\
		\"max\": \"*\",\
		\"type\": \"BackboneElement\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"HealthcareService.notAvailable.id\",\
		\"weight\": 2723,\
		\"max\": \"1\",\
		\"type\": \"id\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"HealthcareService.notAvailable.extension\",\
		\"weight\": 2724,\
		\"max\": \"*\",\
		\"type\": \"Extension\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"HealthcareService.notAvailable.modifierExtension\",\
		\"weight\": 2725,\
		\"max\": \"*\",\
		\"type\": \"Extension\"\
	},\
	{\
		\"min\": \"1\",\
		\"path\": \"HealthcareService.notAvailable.description\",\
		\"weight\": 2726,\
		\"max\": \"1\",\
		\"type\": \"string\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"HealthcareService.notAvailable.during\",\
		\"weight\": 2727,\
		\"max\": \"1\",\
		\"type\": \"Period\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"HealthcareService.availabilityExceptions\",\
		\"weight\": 2728,\
		\"max\": \"1\",\
		\"type\": \"string\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"ImagingExcerpt\",\
		\"weight\": 2729,\
		\"max\": \"*\",\
		\"type\": \"DomainResource\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"ImagingExcerpt.id\",\
		\"weight\": 2730,\
		\"max\": \"1\",\
		\"type\": \"id\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"ImagingExcerpt.meta\",\
		\"weight\": 2731,\
		\"max\": \"1\",\
		\"type\": \"Meta\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"ImagingExcerpt.implicitRules\",\
		\"weight\": 2732,\
		\"max\": \"1\",\
		\"type\": \"uri\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"ImagingExcerpt.language\",\
		\"weight\": 2733,\
		\"max\": \"1\",\
		\"type\": \"code\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"ImagingExcerpt.text\",\
		\"weight\": 2734,\
		\"max\": \"1\",\
		\"type\": \"Narrative\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"ImagingExcerpt.contained\",\
		\"weight\": 2735,\
		\"max\": \"*\",\
		\"type\": \"Resource\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"ImagingExcerpt.extension\",\
		\"weight\": 2736,\
		\"max\": \"*\",\
		\"type\": \"Extension\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"ImagingExcerpt.modifierExtension\",\
		\"weight\": 2737,\
		\"max\": \"*\",\
		\"type\": \"Extension\"\
	},\
	{\
		\"min\": \"1\",\
		\"path\": \"ImagingExcerpt.uid\",\
		\"weight\": 2738,\
		\"max\": \"1\",\
		\"type\": \"oid\"\
	},\
	{\
		\"min\": \"1\",\
		\"path\": \"ImagingExcerpt.patient\",\
		\"weight\": 2739,\
		\"max\": \"1\",\
		\"type\": \"Reference\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"ImagingExcerpt.authoringTime\",\
		\"weight\": 2740,\
		\"max\": \"1\",\
		\"type\": \"dateTime\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"ImagingExcerpt.author\",\
		\"weight\": 2741,\
		\"max\": \"1\",\
		\"type\": \"Reference\"\
	},\
	{\
		\"min\": \"1\",\
		\"path\": \"ImagingExcerpt.title\",\
		\"weight\": 2742,\
		\"max\": \"1\",\
		\"type\": \"CodeableConcept\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"ImagingExcerpt.description\",\
		\"weight\": 2743,\
		\"max\": \"1\",\
		\"type\": \"string\"\
	},\
	{\
		\"min\": \"1\",\
		\"path\": \"ImagingExcerpt.study\",\
		\"weight\": 2744,\
		\"max\": \"*\",\
		\"type\": \"BackboneElement\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"ImagingExcerpt.study.id\",\
		\"weight\": 2745,\
		\"max\": \"1\",\
		\"type\": \"id\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"ImagingExcerpt.study.extension\",\
		\"weight\": 2746,\
		\"max\": \"*\",\
		\"type\": \"Extension\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"ImagingExcerpt.study.modifierExtension\",\
		\"weight\": 2747,\
		\"max\": \"*\",\
		\"type\": \"Extension\"\
	},\
	{\
		\"min\": \"1\",\
		\"path\": \"ImagingExcerpt.study.uid\",\
		\"weight\": 2748,\
		\"max\": \"1\",\
		\"type\": \"oid\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"ImagingExcerpt.study.imagingStudy\",\
		\"weight\": 2749,\
		\"max\": \"1\",\
		\"type\": \"Reference\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"ImagingExcerpt.study.dicom\",\
		\"weight\": 2750,\
		\"max\": \"*\",\
		\"type\": \"BackboneElement\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"ImagingExcerpt.study.dicom.id\",\
		\"weight\": 2751,\
		\"max\": \"1\",\
		\"type\": \"id\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"ImagingExcerpt.study.dicom.extension\",\
		\"weight\": 2752,\
		\"max\": \"*\",\
		\"type\": \"Extension\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"ImagingExcerpt.study.dicom.modifierExtension\",\
		\"weight\": 2753,\
		\"max\": \"*\",\
		\"type\": \"Extension\"\
	},\
	{\
		\"min\": \"1\",\
		\"path\": \"ImagingExcerpt.study.dicom.type\",\
		\"weight\": 2754,\
		\"max\": \"1\",\
		\"type\": \"code\"\
	},\
	{\
		\"min\": \"1\",\
		\"path\": \"ImagingExcerpt.study.dicom.url\",\
		\"weight\": 2755,\
		\"max\": \"1\",\
		\"type\": \"uri\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"ImagingExcerpt.study.viewable\",\
		\"weight\": 2756,\
		\"max\": \"*\",\
		\"type\": \"BackboneElement\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"ImagingExcerpt.study.viewable.id\",\
		\"weight\": 2757,\
		\"max\": \"1\",\
		\"type\": \"id\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"ImagingExcerpt.study.viewable.extension\",\
		\"weight\": 2758,\
		\"max\": \"*\",\
		\"type\": \"Extension\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"ImagingExcerpt.study.viewable.modifierExtension\",\
		\"weight\": 2759,\
		\"max\": \"*\",\
		\"type\": \"Extension\"\
	},\
	{\
		\"min\": \"1\",\
		\"path\": \"ImagingExcerpt.study.viewable.contentType\",\
		\"weight\": 2760,\
		\"max\": \"1\",\
		\"type\": \"code\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"ImagingExcerpt.study.viewable.height\",\
		\"weight\": 2761,\
		\"max\": \"1\",\
		\"type\": \"positiveInt\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"ImagingExcerpt.study.viewable.width\",\
		\"weight\": 2762,\
		\"max\": \"1\",\
		\"type\": \"positiveInt\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"ImagingExcerpt.study.viewable.frames\",\
		\"weight\": 2763,\
		\"max\": \"1\",\
		\"type\": \"positiveInt\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"ImagingExcerpt.study.viewable.duration\",\
		\"weight\": 2764,\
		\"max\": \"1\",\
		\"type\": \"unsignedInt\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"ImagingExcerpt.study.viewable.size\",\
		\"weight\": 2765,\
		\"max\": \"1\",\
		\"type\": \"unsignedInt\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"ImagingExcerpt.study.viewable.title\",\
		\"weight\": 2766,\
		\"max\": \"1\",\
		\"type\": \"string\"\
	},\
	{\
		\"min\": \"1\",\
		\"path\": \"ImagingExcerpt.study.viewable.url\",\
		\"weight\": 2767,\
		\"max\": \"1\",\
		\"type\": \"uri\"\
	},\
	{\
		\"min\": \"1\",\
		\"path\": \"ImagingExcerpt.study.series\",\
		\"weight\": 2768,\
		\"max\": \"*\",\
		\"type\": \"BackboneElement\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"ImagingExcerpt.study.series.id\",\
		\"weight\": 2769,\
		\"max\": \"1\",\
		\"type\": \"id\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"ImagingExcerpt.study.series.extension\",\
		\"weight\": 2770,\
		\"max\": \"*\",\
		\"type\": \"Extension\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"ImagingExcerpt.study.series.modifierExtension\",\
		\"weight\": 2771,\
		\"max\": \"*\",\
		\"type\": \"Extension\"\
	},\
	{\
		\"min\": \"1\",\
		\"path\": \"ImagingExcerpt.study.series.uid\",\
		\"weight\": 2772,\
		\"max\": \"1\",\
		\"type\": \"oid\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"ImagingExcerpt.study.series.dicom\",\
		\"weight\": 2773,\
		\"max\": \"*\",\
		\"type\": \"BackboneElement\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"ImagingExcerpt.study.series.dicom.id\",\
		\"weight\": 2774,\
		\"max\": \"1\",\
		\"type\": \"id\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"ImagingExcerpt.study.series.dicom.extension\",\
		\"weight\": 2775,\
		\"max\": \"*\",\
		\"type\": \"Extension\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"ImagingExcerpt.study.series.dicom.modifierExtension\",\
		\"weight\": 2776,\
		\"max\": \"*\",\
		\"type\": \"Extension\"\
	},\
	{\
		\"min\": \"1\",\
		\"path\": \"ImagingExcerpt.study.series.dicom.type\",\
		\"weight\": 2777,\
		\"max\": \"1\",\
		\"type\": \"code\"\
	},\
	{\
		\"min\": \"1\",\
		\"path\": \"ImagingExcerpt.study.series.dicom.url\",\
		\"weight\": 2778,\
		\"max\": \"1\",\
		\"type\": \"uri\"\
	},\
	{\
		\"min\": \"1\",\
		\"path\": \"ImagingExcerpt.study.series.instance\",\
		\"weight\": 2779,\
		\"max\": \"*\",\
		\"type\": \"BackboneElement\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"ImagingExcerpt.study.series.instance.id\",\
		\"weight\": 2780,\
		\"max\": \"1\",\
		\"type\": \"id\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"ImagingExcerpt.study.series.instance.extension\",\
		\"weight\": 2781,\
		\"max\": \"*\",\
		\"type\": \"Extension\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"ImagingExcerpt.study.series.instance.modifierExtension\",\
		\"weight\": 2782,\
		\"max\": \"*\",\
		\"type\": \"Extension\"\
	},\
	{\
		\"min\": \"1\",\
		\"path\": \"ImagingExcerpt.study.series.instance.sopClass\",\
		\"weight\": 2783,\
		\"max\": \"1\",\
		\"type\": \"oid\"\
	},\
	{\
		\"min\": \"1\",\
		\"path\": \"ImagingExcerpt.study.series.instance.uid\",\
		\"weight\": 2784,\
		\"max\": \"1\",\
		\"type\": \"oid\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"ImagingExcerpt.study.series.instance.dicom\",\
		\"weight\": 2785,\
		\"max\": \"*\",\
		\"type\": \"BackboneElement\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"ImagingExcerpt.study.series.instance.dicom.id\",\
		\"weight\": 2786,\
		\"max\": \"1\",\
		\"type\": \"id\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"ImagingExcerpt.study.series.instance.dicom.extension\",\
		\"weight\": 2787,\
		\"max\": \"*\",\
		\"type\": \"Extension\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"ImagingExcerpt.study.series.instance.dicom.modifierExtension\",\
		\"weight\": 2788,\
		\"max\": \"*\",\
		\"type\": \"Extension\"\
	},\
	{\
		\"min\": \"1\",\
		\"path\": \"ImagingExcerpt.study.series.instance.dicom.type\",\
		\"weight\": 2789,\
		\"max\": \"1\",\
		\"type\": \"code\"\
	},\
	{\
		\"min\": \"1\",\
		\"path\": \"ImagingExcerpt.study.series.instance.dicom.url\",\
		\"weight\": 2790,\
		\"max\": \"1\",\
		\"type\": \"uri\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"ImagingExcerpt.study.series.instance.frameNumbers\",\
		\"weight\": 2791,\
		\"max\": \"*\",\
		\"type\": \"unsignedInt\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"ImagingObjectSelection\",\
		\"weight\": 2792,\
		\"max\": \"*\",\
		\"type\": \"DomainResource\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"ImagingObjectSelection.id\",\
		\"weight\": 2793,\
		\"max\": \"1\",\
		\"type\": \"id\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"ImagingObjectSelection.meta\",\
		\"weight\": 2794,\
		\"max\": \"1\",\
		\"type\": \"Meta\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"ImagingObjectSelection.implicitRules\",\
		\"weight\": 2795,\
		\"max\": \"1\",\
		\"type\": \"uri\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"ImagingObjectSelection.language\",\
		\"weight\": 2796,\
		\"max\": \"1\",\
		\"type\": \"code\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"ImagingObjectSelection.text\",\
		\"weight\": 2797,\
		\"max\": \"1\",\
		\"type\": \"Narrative\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"ImagingObjectSelection.contained\",\
		\"weight\": 2798,\
		\"max\": \"*\",\
		\"type\": \"Resource\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"ImagingObjectSelection.extension\",\
		\"weight\": 2799,\
		\"max\": \"*\",\
		\"type\": \"Extension\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"ImagingObjectSelection.modifierExtension\",\
		\"weight\": 2800,\
		\"max\": \"*\",\
		\"type\": \"Extension\"\
	},\
	{\
		\"min\": \"1\",\
		\"path\": \"ImagingObjectSelection.uid\",\
		\"weight\": 2801,\
		\"max\": \"1\",\
		\"type\": \"oid\"\
	},\
	{\
		\"min\": \"1\",\
		\"path\": \"ImagingObjectSelection.patient\",\
		\"weight\": 2802,\
		\"max\": \"1\",\
		\"type\": \"Reference\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"ImagingObjectSelection.authoringTime\",\
		\"weight\": 2803,\
		\"max\": \"1\",\
		\"type\": \"dateTime\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"ImagingObjectSelection.author\",\
		\"weight\": 2804,\
		\"max\": \"1\",\
		\"type\": \"Reference\"\
	},\
	{\
		\"min\": \"1\",\
		\"path\": \"ImagingObjectSelection.title\",\
		\"weight\": 2805,\
		\"max\": \"1\",\
		\"type\": \"CodeableConcept\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"ImagingObjectSelection.description\",\
		\"weight\": 2806,\
		\"max\": \"1\",\
		\"type\": \"string\"\
	},\
	{\
		\"min\": \"1\",\
		\"path\": \"ImagingObjectSelection.study\",\
		\"weight\": 2807,\
		\"max\": \"*\",\
		\"type\": \"BackboneElement\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"ImagingObjectSelection.study.id\",\
		\"weight\": 2808,\
		\"max\": \"1\",\
		\"type\": \"id\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"ImagingObjectSelection.study.extension\",\
		\"weight\": 2809,\
		\"max\": \"*\",\
		\"type\": \"Extension\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"ImagingObjectSelection.study.modifierExtension\",\
		\"weight\": 2810,\
		\"max\": \"*\",\
		\"type\": \"Extension\"\
	},\
	{\
		\"min\": \"1\",\
		\"path\": \"ImagingObjectSelection.study.uid\",\
		\"weight\": 2811,\
		\"max\": \"1\",\
		\"type\": \"oid\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"ImagingObjectSelection.study.url\",\
		\"weight\": 2812,\
		\"max\": \"1\",\
		\"type\": \"uri\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"ImagingObjectSelection.study.imagingStudy\",\
		\"weight\": 2813,\
		\"max\": \"1\",\
		\"type\": \"Reference\"\
	},\
	{\
		\"min\": \"1\",\
		\"path\": \"ImagingObjectSelection.study.series\",\
		\"weight\": 2814,\
		\"max\": \"*\",\
		\"type\": \"BackboneElement\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"ImagingObjectSelection.study.series.id\",\
		\"weight\": 2815,\
		\"max\": \"1\",\
		\"type\": \"id\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"ImagingObjectSelection.study.series.extension\",\
		\"weight\": 2816,\
		\"max\": \"*\",\
		\"type\": \"Extension\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"ImagingObjectSelection.study.series.modifierExtension\",\
		\"weight\": 2817,\
		\"max\": \"*\",\
		\"type\": \"Extension\"\
	},\
	{\
		\"min\": \"1\",\
		\"path\": \"ImagingObjectSelection.study.series.uid\",\
		\"weight\": 2818,\
		\"max\": \"1\",\
		\"type\": \"oid\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"ImagingObjectSelection.study.series.url\",\
		\"weight\": 2819,\
		\"max\": \"1\",\
		\"type\": \"uri\"\
	},\
	{\
		\"min\": \"1\",\
		\"path\": \"ImagingObjectSelection.study.series.instance\",\
		\"weight\": 2820,\
		\"max\": \"*\",\
		\"type\": \"BackboneElement\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"ImagingObjectSelection.study.series.instance.id\",\
		\"weight\": 2821,\
		\"max\": \"1\",\
		\"type\": \"id\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"ImagingObjectSelection.study.series.instance.extension\",\
		\"weight\": 2822,\
		\"max\": \"*\",\
		\"type\": \"Extension\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"ImagingObjectSelection.study.series.instance.modifierExtension\",\
		\"weight\": 2823,\
		\"max\": \"*\",\
		\"type\": \"Extension\"\
	},\
	{\
		\"min\": \"1\",\
		\"path\": \"ImagingObjectSelection.study.series.instance.sopClass\",\
		\"weight\": 2824,\
		\"max\": \"1\",\
		\"type\": \"oid\"\
	},\
	{\
		\"min\": \"1\",\
		\"path\": \"ImagingObjectSelection.study.series.instance.uid\",\
		\"weight\": 2825,\
		\"max\": \"1\",\
		\"type\": \"oid\"\
	},\
	{\
		\"min\": \"1\",\
		\"path\": \"ImagingObjectSelection.study.series.instance.url\",\
		\"weight\": 2826,\
		\"max\": \"1\",\
		\"type\": \"uri\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"ImagingObjectSelection.study.series.instance.frame\",\
		\"weight\": 2827,\
		\"max\": \"*\",\
		\"type\": \"BackboneElement\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"ImagingObjectSelection.study.series.instance.frame.id\",\
		\"weight\": 2828,\
		\"max\": \"1\",\
		\"type\": \"id\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"ImagingObjectSelection.study.series.instance.frame.extension\",\
		\"weight\": 2829,\
		\"max\": \"*\",\
		\"type\": \"Extension\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"ImagingObjectSelection.study.series.instance.frame.modifierExtension\",\
		\"weight\": 2830,\
		\"max\": \"*\",\
		\"type\": \"Extension\"\
	},\
	{\
		\"min\": \"1\",\
		\"path\": \"ImagingObjectSelection.study.series.instance.frame.number\",\
		\"weight\": 2831,\
		\"max\": \"*\",\
		\"type\": \"unsignedInt\"\
	},\
	{\
		\"min\": \"1\",\
		\"path\": \"ImagingObjectSelection.study.series.instance.frame.url\",\
		\"weight\": 2832,\
		\"max\": \"1\",\
		\"type\": \"uri\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"ImagingStudy\",\
		\"weight\": 2833,\
		\"max\": \"*\",\
		\"type\": \"DomainResource\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"ImagingStudy.id\",\
		\"weight\": 2834,\
		\"max\": \"1\",\
		\"type\": \"id\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"ImagingStudy.meta\",\
		\"weight\": 2835,\
		\"max\": \"1\",\
		\"type\": \"Meta\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"ImagingStudy.implicitRules\",\
		\"weight\": 2836,\
		\"max\": \"1\",\
		\"type\": \"uri\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"ImagingStudy.language\",\
		\"weight\": 2837,\
		\"max\": \"1\",\
		\"type\": \"code\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"ImagingStudy.text\",\
		\"weight\": 2838,\
		\"max\": \"1\",\
		\"type\": \"Narrative\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"ImagingStudy.contained\",\
		\"weight\": 2839,\
		\"max\": \"*\",\
		\"type\": \"Resource\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"ImagingStudy.extension\",\
		\"weight\": 2840,\
		\"max\": \"*\",\
		\"type\": \"Extension\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"ImagingStudy.modifierExtension\",\
		\"weight\": 2841,\
		\"max\": \"*\",\
		\"type\": \"Extension\"\
	},\
	{\
		\"min\": \"1\",\
		\"path\": \"ImagingStudy.uid\",\
		\"weight\": 2842,\
		\"max\": \"1\",\
		\"type\": \"oid\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"ImagingStudy.accession\",\
		\"weight\": 2843,\
		\"max\": \"1\",\
		\"type\": \"Identifier\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"ImagingStudy.identifier\",\
		\"weight\": 2844,\
		\"max\": \"*\",\
		\"type\": \"Identifier\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"ImagingStudy.availability\",\
		\"weight\": 2845,\
		\"max\": \"1\",\
		\"type\": \"code\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"ImagingStudy.modalityList\",\
		\"weight\": 2846,\
		\"max\": \"*\",\
		\"type\": \"Coding\"\
	},\
	{\
		\"min\": \"1\",\
		\"path\": \"ImagingStudy.patient\",\
		\"weight\": 2847,\
		\"max\": \"1\",\
		\"type\": \"Reference\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"ImagingStudy.started\",\
		\"weight\": 2848,\
		\"max\": \"1\",\
		\"type\": \"dateTime\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"ImagingStudy.order\",\
		\"weight\": 2849,\
		\"max\": \"*\",\
		\"type\": \"Reference\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"ImagingStudy.referrer\",\
		\"weight\": 2850,\
		\"max\": \"1\",\
		\"type\": \"Reference\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"ImagingStudy.interpreter\",\
		\"weight\": 2851,\
		\"max\": \"1\",\
		\"type\": \"Reference\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"ImagingStudy.url\",\
		\"weight\": 2852,\
		\"max\": \"1\",\
		\"type\": \"uri\"\
	},\
	{\
		\"min\": \"1\",\
		\"path\": \"ImagingStudy.numberOfSeries\",\
		\"weight\": 2853,\
		\"max\": \"1\",\
		\"type\": \"unsignedInt\"\
	},\
	{\
		\"min\": \"1\",\
		\"path\": \"ImagingStudy.numberOfInstances\",\
		\"weight\": 2854,\
		\"max\": \"1\",\
		\"type\": \"unsignedInt\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"ImagingStudy.procedure\",\
		\"weight\": 2855,\
		\"max\": \"*\",\
		\"type\": \"Reference\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"ImagingStudy.description\",\
		\"weight\": 2856,\
		\"max\": \"1\",\
		\"type\": \"string\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"ImagingStudy.series\",\
		\"weight\": 2857,\
		\"max\": \"*\",\
		\"type\": \"BackboneElement\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"ImagingStudy.series.id\",\
		\"weight\": 2858,\
		\"max\": \"1\",\
		\"type\": \"id\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"ImagingStudy.series.extension\",\
		\"weight\": 2859,\
		\"max\": \"*\",\
		\"type\": \"Extension\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"ImagingStudy.series.modifierExtension\",\
		\"weight\": 2860,\
		\"max\": \"*\",\
		\"type\": \"Extension\"\
	},\
	{\
		\"min\": \"1\",\
		\"path\": \"ImagingStudy.series.uid\",\
		\"weight\": 2861,\
		\"max\": \"1\",\
		\"type\": \"oid\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"ImagingStudy.series.number\",\
		\"weight\": 2862,\
		\"max\": \"1\",\
		\"type\": \"unsignedInt\"\
	},\
	{\
		\"min\": \"1\",\
		\"path\": \"ImagingStudy.series.modality\",\
		\"weight\": 2863,\
		\"max\": \"1\",\
		\"type\": \"Coding\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"ImagingStudy.series.description\",\
		\"weight\": 2864,\
		\"max\": \"1\",\
		\"type\": \"string\"\
	},\
	{\
		\"min\": \"1\",\
		\"path\": \"ImagingStudy.series.numberOfInstances\",\
		\"weight\": 2865,\
		\"max\": \"1\",\
		\"type\": \"unsignedInt\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"ImagingStudy.series.availability\",\
		\"weight\": 2866,\
		\"max\": \"1\",\
		\"type\": \"code\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"ImagingStudy.series.url\",\
		\"weight\": 2867,\
		\"max\": \"1\",\
		\"type\": \"uri\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"ImagingStudy.series.bodySite\",\
		\"weight\": 2868,\
		\"max\": \"1\",\
		\"type\": \"Coding\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"ImagingStudy.series.laterality\",\
		\"weight\": 2869,\
		\"max\": \"1\",\
		\"type\": \"Coding\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"ImagingStudy.series.started\",\
		\"weight\": 2870,\
		\"max\": \"1\",\
		\"type\": \"dateTime\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"ImagingStudy.series.instance\",\
		\"weight\": 2871,\
		\"max\": \"*\",\
		\"type\": \"BackboneElement\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"ImagingStudy.series.instance.id\",\
		\"weight\": 2872,\
		\"max\": \"1\",\
		\"type\": \"id\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"ImagingStudy.series.instance.extension\",\
		\"weight\": 2873,\
		\"max\": \"*\",\
		\"type\": \"Extension\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"ImagingStudy.series.instance.modifierExtension\",\
		\"weight\": 2874,\
		\"max\": \"*\",\
		\"type\": \"Extension\"\
	},\
	{\
		\"min\": \"1\",\
		\"path\": \"ImagingStudy.series.instance.uid\",\
		\"weight\": 2875,\
		\"max\": \"1\",\
		\"type\": \"oid\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"ImagingStudy.series.instance.number\",\
		\"weight\": 2876,\
		\"max\": \"1\",\
		\"type\": \"unsignedInt\"\
	},\
	{\
		\"min\": \"1\",\
		\"path\": \"ImagingStudy.series.instance.sopClass\",\
		\"weight\": 2877,\
		\"max\": \"1\",\
		\"type\": \"oid\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"ImagingStudy.series.instance.type\",\
		\"weight\": 2878,\
		\"max\": \"1\",\
		\"type\": \"string\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"ImagingStudy.series.instance.title\",\
		\"weight\": 2879,\
		\"max\": \"1\",\
		\"type\": \"string\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"ImagingStudy.series.instance.content\",\
		\"weight\": 2880,\
		\"max\": \"*\",\
		\"type\": \"Attachment\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Immunization\",\
		\"weight\": 2881,\
		\"max\": \"*\",\
		\"type\": \"DomainResource\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Immunization.id\",\
		\"weight\": 2882,\
		\"max\": \"1\",\
		\"type\": \"id\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Immunization.meta\",\
		\"weight\": 2883,\
		\"max\": \"1\",\
		\"type\": \"Meta\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Immunization.implicitRules\",\
		\"weight\": 2884,\
		\"max\": \"1\",\
		\"type\": \"uri\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Immunization.language\",\
		\"weight\": 2885,\
		\"max\": \"1\",\
		\"type\": \"code\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Immunization.text\",\
		\"weight\": 2886,\
		\"max\": \"1\",\
		\"type\": \"Narrative\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Immunization.contained\",\
		\"weight\": 2887,\
		\"max\": \"*\",\
		\"type\": \"Resource\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Immunization.extension\",\
		\"weight\": 2888,\
		\"max\": \"*\",\
		\"type\": \"Extension\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Immunization.modifierExtension\",\
		\"weight\": 2889,\
		\"max\": \"*\",\
		\"type\": \"Extension\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Immunization.identifier\",\
		\"weight\": 2890,\
		\"max\": \"*\",\
		\"type\": \"Identifier\"\
	},\
	{\
		\"min\": \"1\",\
		\"path\": \"Immunization.status\",\
		\"weight\": 2891,\
		\"max\": \"1\",\
		\"type\": \"code\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Immunization.date\",\
		\"weight\": 2892,\
		\"max\": \"1\",\
		\"type\": \"dateTime\"\
	},\
	{\
		\"min\": \"1\",\
		\"path\": \"Immunization.vaccineCode\",\
		\"weight\": 2893,\
		\"max\": \"1\",\
		\"type\": \"CodeableConcept\"\
	},\
	{\
		\"min\": \"1\",\
		\"path\": \"Immunization.patient\",\
		\"weight\": 2894,\
		\"max\": \"1\",\
		\"type\": \"Reference\"\
	},\
	{\
		\"min\": \"1\",\
		\"path\": \"Immunization.wasNotGiven\",\
		\"weight\": 2895,\
		\"max\": \"1\",\
		\"type\": \"boolean\"\
	},\
	{\
		\"min\": \"1\",\
		\"path\": \"Immunization.reported\",\
		\"weight\": 2896,\
		\"max\": \"1\",\
		\"type\": \"boolean\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Immunization.performer\",\
		\"weight\": 2897,\
		\"max\": \"1\",\
		\"type\": \"Reference\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Immunization.requester\",\
		\"weight\": 2898,\
		\"max\": \"1\",\
		\"type\": \"Reference\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Immunization.encounter\",\
		\"weight\": 2899,\
		\"max\": \"1\",\
		\"type\": \"Reference\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Immunization.manufacturer\",\
		\"weight\": 2900,\
		\"max\": \"1\",\
		\"type\": \"Reference\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Immunization.location\",\
		\"weight\": 2901,\
		\"max\": \"1\",\
		\"type\": \"Reference\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Immunization.lotNumber\",\
		\"weight\": 2902,\
		\"max\": \"1\",\
		\"type\": \"string\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Immunization.expirationDate\",\
		\"weight\": 2903,\
		\"max\": \"1\",\
		\"type\": \"date\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Immunization.site\",\
		\"weight\": 2904,\
		\"max\": \"1\",\
		\"type\": \"CodeableConcept\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Immunization.route\",\
		\"weight\": 2905,\
		\"max\": \"1\",\
		\"type\": \"CodeableConcept\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Immunization.doseQuantity\",\
		\"weight\": 2906,\
		\"max\": \"1\",\
		\"type\": \"Quantity\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Immunization.note\",\
		\"weight\": 2907,\
		\"max\": \"*\",\
		\"type\": \"Annotation\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Immunization.explanation\",\
		\"weight\": 2908,\
		\"max\": \"1\",\
		\"type\": \"BackboneElement\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Immunization.explanation.id\",\
		\"weight\": 2909,\
		\"max\": \"1\",\
		\"type\": \"id\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Immunization.explanation.extension\",\
		\"weight\": 2910,\
		\"max\": \"*\",\
		\"type\": \"Extension\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Immunization.explanation.modifierExtension\",\
		\"weight\": 2911,\
		\"max\": \"*\",\
		\"type\": \"Extension\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Immunization.explanation.reason\",\
		\"weight\": 2912,\
		\"max\": \"*\",\
		\"type\": \"CodeableConcept\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Immunization.explanation.reasonNotGiven\",\
		\"weight\": 2913,\
		\"max\": \"*\",\
		\"type\": \"CodeableConcept\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Immunization.reaction\",\
		\"weight\": 2914,\
		\"max\": \"*\",\
		\"type\": \"BackboneElement\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Immunization.reaction.id\",\
		\"weight\": 2915,\
		\"max\": \"1\",\
		\"type\": \"id\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Immunization.reaction.extension\",\
		\"weight\": 2916,\
		\"max\": \"*\",\
		\"type\": \"Extension\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Immunization.reaction.modifierExtension\",\
		\"weight\": 2917,\
		\"max\": \"*\",\
		\"type\": \"Extension\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Immunization.reaction.date\",\
		\"weight\": 2918,\
		\"max\": \"1\",\
		\"type\": \"dateTime\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Immunization.reaction.detail\",\
		\"weight\": 2919,\
		\"max\": \"1\",\
		\"type\": \"Reference\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Immunization.reaction.reported\",\
		\"weight\": 2920,\
		\"max\": \"1\",\
		\"type\": \"boolean\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Immunization.vaccinationProtocol\",\
		\"weight\": 2921,\
		\"max\": \"*\",\
		\"type\": \"BackboneElement\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Immunization.vaccinationProtocol.id\",\
		\"weight\": 2922,\
		\"max\": \"1\",\
		\"type\": \"id\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Immunization.vaccinationProtocol.extension\",\
		\"weight\": 2923,\
		\"max\": \"*\",\
		\"type\": \"Extension\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Immunization.vaccinationProtocol.modifierExtension\",\
		\"weight\": 2924,\
		\"max\": \"*\",\
		\"type\": \"Extension\"\
	},\
	{\
		\"min\": \"1\",\
		\"path\": \"Immunization.vaccinationProtocol.doseSequence\",\
		\"weight\": 2925,\
		\"max\": \"1\",\
		\"type\": \"positiveInt\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Immunization.vaccinationProtocol.description\",\
		\"weight\": 2926,\
		\"max\": \"1\",\
		\"type\": \"string\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Immunization.vaccinationProtocol.authority\",\
		\"weight\": 2927,\
		\"max\": \"1\",\
		\"type\": \"Reference\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Immunization.vaccinationProtocol.series\",\
		\"weight\": 2928,\
		\"max\": \"1\",\
		\"type\": \"string\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Immunization.vaccinationProtocol.seriesDoses\",\
		\"weight\": 2929,\
		\"max\": \"1\",\
		\"type\": \"positiveInt\"\
	},\
	{\
		\"min\": \"1\",\
		\"path\": \"Immunization.vaccinationProtocol.targetDisease\",\
		\"weight\": 2930,\
		\"max\": \"*\",\
		\"type\": \"CodeableConcept\"\
	},\
	{\
		\"min\": \"1\",\
		\"path\": \"Immunization.vaccinationProtocol.doseStatus\",\
		\"weight\": 2931,\
		\"max\": \"1\",\
		\"type\": \"CodeableConcept\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Immunization.vaccinationProtocol.doseStatusReason\",\
		\"weight\": 2932,\
		\"max\": \"1\",\
		\"type\": \"CodeableConcept\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"ImmunizationRecommendation\",\
		\"weight\": 2933,\
		\"max\": \"*\",\
		\"type\": \"DomainResource\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"ImmunizationRecommendation.id\",\
		\"weight\": 2934,\
		\"max\": \"1\",\
		\"type\": \"id\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"ImmunizationRecommendation.meta\",\
		\"weight\": 2935,\
		\"max\": \"1\",\
		\"type\": \"Meta\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"ImmunizationRecommendation.implicitRules\",\
		\"weight\": 2936,\
		\"max\": \"1\",\
		\"type\": \"uri\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"ImmunizationRecommendation.language\",\
		\"weight\": 2937,\
		\"max\": \"1\",\
		\"type\": \"code\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"ImmunizationRecommendation.text\",\
		\"weight\": 2938,\
		\"max\": \"1\",\
		\"type\": \"Narrative\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"ImmunizationRecommendation.contained\",\
		\"weight\": 2939,\
		\"max\": \"*\",\
		\"type\": \"Resource\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"ImmunizationRecommendation.extension\",\
		\"weight\": 2940,\
		\"max\": \"*\",\
		\"type\": \"Extension\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"ImmunizationRecommendation.modifierExtension\",\
		\"weight\": 2941,\
		\"max\": \"*\",\
		\"type\": \"Extension\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"ImmunizationRecommendation.identifier\",\
		\"weight\": 2942,\
		\"max\": \"*\",\
		\"type\": \"Identifier\"\
	},\
	{\
		\"min\": \"1\",\
		\"path\": \"ImmunizationRecommendation.patient\",\
		\"weight\": 2943,\
		\"max\": \"1\",\
		\"type\": \"Reference\"\
	},\
	{\
		\"min\": \"1\",\
		\"path\": \"ImmunizationRecommendation.recommendation\",\
		\"weight\": 2944,\
		\"max\": \"*\",\
		\"type\": \"BackboneElement\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"ImmunizationRecommendation.recommendation.id\",\
		\"weight\": 2945,\
		\"max\": \"1\",\
		\"type\": \"id\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"ImmunizationRecommendation.recommendation.extension\",\
		\"weight\": 2946,\
		\"max\": \"*\",\
		\"type\": \"Extension\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"ImmunizationRecommendation.recommendation.modifierExtension\",\
		\"weight\": 2947,\
		\"max\": \"*\",\
		\"type\": \"Extension\"\
	},\
	{\
		\"min\": \"1\",\
		\"path\": \"ImmunizationRecommendation.recommendation.date\",\
		\"weight\": 2948,\
		\"max\": \"1\",\
		\"type\": \"dateTime\"\
	},\
	{\
		\"min\": \"1\",\
		\"path\": \"ImmunizationRecommendation.recommendation.vaccineCode\",\
		\"weight\": 2949,\
		\"max\": \"1\",\
		\"type\": \"CodeableConcept\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"ImmunizationRecommendation.recommendation.doseNumber\",\
		\"weight\": 2950,\
		\"max\": \"1\",\
		\"type\": \"positiveInt\"\
	},\
	{\
		\"min\": \"1\",\
		\"path\": \"ImmunizationRecommendation.recommendation.forecastStatus\",\
		\"weight\": 2951,\
		\"max\": \"1\",\
		\"type\": \"CodeableConcept\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"ImmunizationRecommendation.recommendation.dateCriterion\",\
		\"weight\": 2952,\
		\"max\": \"*\",\
		\"type\": \"BackboneElement\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"ImmunizationRecommendation.recommendation.dateCriterion.id\",\
		\"weight\": 2953,\
		\"max\": \"1\",\
		\"type\": \"id\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"ImmunizationRecommendation.recommendation.dateCriterion.extension\",\
		\"weight\": 2954,\
		\"max\": \"*\",\
		\"type\": \"Extension\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"ImmunizationRecommendation.recommendation.dateCriterion.modifierExtension\",\
		\"weight\": 2955,\
		\"max\": \"*\",\
		\"type\": \"Extension\"\
	},\
	{\
		\"min\": \"1\",\
		\"path\": \"ImmunizationRecommendation.recommendation.dateCriterion.code\",\
		\"weight\": 2956,\
		\"max\": \"1\",\
		\"type\": \"CodeableConcept\"\
	},\
	{\
		\"min\": \"1\",\
		\"path\": \"ImmunizationRecommendation.recommendation.dateCriterion.value\",\
		\"weight\": 2957,\
		\"max\": \"1\",\
		\"type\": \"dateTime\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"ImmunizationRecommendation.recommendation.protocol\",\
		\"weight\": 2958,\
		\"max\": \"1\",\
		\"type\": \"BackboneElement\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"ImmunizationRecommendation.recommendation.protocol.id\",\
		\"weight\": 2959,\
		\"max\": \"1\",\
		\"type\": \"id\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"ImmunizationRecommendation.recommendation.protocol.extension\",\
		\"weight\": 2960,\
		\"max\": \"*\",\
		\"type\": \"Extension\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"ImmunizationRecommendation.recommendation.protocol.modifierExtension\",\
		\"weight\": 2961,\
		\"max\": \"*\",\
		\"type\": \"Extension\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"ImmunizationRecommendation.recommendation.protocol.doseSequence\",\
		\"weight\": 2962,\
		\"max\": \"1\",\
		\"type\": \"integer\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"ImmunizationRecommendation.recommendation.protocol.description\",\
		\"weight\": 2963,\
		\"max\": \"1\",\
		\"type\": \"string\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"ImmunizationRecommendation.recommendation.protocol.authority\",\
		\"weight\": 2964,\
		\"max\": \"1\",\
		\"type\": \"Reference\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"ImmunizationRecommendation.recommendation.protocol.series\",\
		\"weight\": 2965,\
		\"max\": \"1\",\
		\"type\": \"string\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"ImmunizationRecommendation.recommendation.supportingImmunization\",\
		\"weight\": 2966,\
		\"max\": \"*\",\
		\"type\": \"Reference\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"ImmunizationRecommendation.recommendation.supportingPatientInformation\",\
		\"weight\": 2967,\
		\"max\": \"*\",\
		\"type\": \"Reference\"\
	},\
	{\
		\"min\": \"1\",\
		\"path\": \"ImplementationGuide\",\
		\"weight\": 2968,\
		\"max\": \"1\",\
		\"type\": \"DomainResource\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"ImplementationGuide.id\",\
		\"weight\": 2969,\
		\"max\": \"1\",\
		\"type\": \"id\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"ImplementationGuide.meta\",\
		\"weight\": 2970,\
		\"max\": \"1\",\
		\"type\": \"Meta\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"ImplementationGuide.implicitRules\",\
		\"weight\": 2971,\
		\"max\": \"1\",\
		\"type\": \"uri\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"ImplementationGuide.language\",\
		\"weight\": 2972,\
		\"max\": \"1\",\
		\"type\": \"code\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"ImplementationGuide.text\",\
		\"weight\": 2973,\
		\"max\": \"1\",\
		\"type\": \"Narrative\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"ImplementationGuide.contained\",\
		\"weight\": 2974,\
		\"max\": \"*\",\
		\"type\": \"Resource\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"ImplementationGuide.extension\",\
		\"weight\": 2975,\
		\"max\": \"*\",\
		\"type\": \"Extension\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"ImplementationGuide.modifierExtension\",\
		\"weight\": 2976,\
		\"max\": \"*\",\
		\"type\": \"Extension\"\
	},\
	{\
		\"min\": \"1\",\
		\"path\": \"ImplementationGuide.url\",\
		\"weight\": 2977,\
		\"max\": \"1\",\
		\"type\": \"uri\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"ImplementationGuide.version\",\
		\"weight\": 2978,\
		\"max\": \"1\",\
		\"type\": \"string\"\
	},\
	{\
		\"min\": \"1\",\
		\"path\": \"ImplementationGuide.name\",\
		\"weight\": 2979,\
		\"max\": \"1\",\
		\"type\": \"string\"\
	},\
	{\
		\"min\": \"1\",\
		\"path\": \"ImplementationGuide.status\",\
		\"weight\": 2980,\
		\"max\": \"1\",\
		\"type\": \"code\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"ImplementationGuide.experimental\",\
		\"weight\": 2981,\
		\"max\": \"1\",\
		\"type\": \"boolean\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"ImplementationGuide.publisher\",\
		\"weight\": 2982,\
		\"max\": \"1\",\
		\"type\": \"string\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"ImplementationGuide.contact\",\
		\"weight\": 2983,\
		\"max\": \"*\",\
		\"type\": \"BackboneElement\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"ImplementationGuide.contact.id\",\
		\"weight\": 2984,\
		\"max\": \"1\",\
		\"type\": \"id\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"ImplementationGuide.contact.extension\",\
		\"weight\": 2985,\
		\"max\": \"*\",\
		\"type\": \"Extension\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"ImplementationGuide.contact.modifierExtension\",\
		\"weight\": 2986,\
		\"max\": \"*\",\
		\"type\": \"Extension\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"ImplementationGuide.contact.name\",\
		\"weight\": 2987,\
		\"max\": \"1\",\
		\"type\": \"string\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"ImplementationGuide.contact.telecom\",\
		\"weight\": 2988,\
		\"max\": \"*\",\
		\"type\": \"ContactPoint\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"ImplementationGuide.date\",\
		\"weight\": 2989,\
		\"max\": \"1\",\
		\"type\": \"dateTime\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"ImplementationGuide.description\",\
		\"weight\": 2990,\
		\"max\": \"1\",\
		\"type\": \"string\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"ImplementationGuide.useContext\",\
		\"weight\": 2991,\
		\"max\": \"*\",\
		\"type\": \"CodeableConcept\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"ImplementationGuide.copyright\",\
		\"weight\": 2992,\
		\"max\": \"1\",\
		\"type\": \"string\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"ImplementationGuide.fhirVersion\",\
		\"weight\": 2993,\
		\"max\": \"1\",\
		\"type\": \"id\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"ImplementationGuide.dependency\",\
		\"weight\": 2994,\
		\"max\": \"*\",\
		\"type\": \"BackboneElement\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"ImplementationGuide.dependency.id\",\
		\"weight\": 2995,\
		\"max\": \"1\",\
		\"type\": \"id\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"ImplementationGuide.dependency.extension\",\
		\"weight\": 2996,\
		\"max\": \"*\",\
		\"type\": \"Extension\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"ImplementationGuide.dependency.modifierExtension\",\
		\"weight\": 2997,\
		\"max\": \"*\",\
		\"type\": \"Extension\"\
	},\
	{\
		\"min\": \"1\",\
		\"path\": \"ImplementationGuide.dependency.type\",\
		\"weight\": 2998,\
		\"max\": \"1\",\
		\"type\": \"code\"\
	},\
	{\
		\"min\": \"1\",\
		\"path\": \"ImplementationGuide.dependency.uri\",\
		\"weight\": 2999,\
		\"max\": \"1\",\
		\"type\": \"uri\"\
	},\
	{\
		\"min\": \"1\",\
		\"path\": \"ImplementationGuide.package\",\
		\"weight\": 3000,\
		\"max\": \"*\",\
		\"type\": \"BackboneElement\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"ImplementationGuide.package.id\",\
		\"weight\": 3001,\
		\"max\": \"1\",\
		\"type\": \"id\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"ImplementationGuide.package.extension\",\
		\"weight\": 3002,\
		\"max\": \"*\",\
		\"type\": \"Extension\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"ImplementationGuide.package.modifierExtension\",\
		\"weight\": 3003,\
		\"max\": \"*\",\
		\"type\": \"Extension\"\
	},\
	{\
		\"min\": \"1\",\
		\"path\": \"ImplementationGuide.package.name\",\
		\"weight\": 3004,\
		\"max\": \"1\",\
		\"type\": \"string\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"ImplementationGuide.package.description\",\
		\"weight\": 3005,\
		\"max\": \"1\",\
		\"type\": \"string\"\
	},\
	{\
		\"min\": \"1\",\
		\"path\": \"ImplementationGuide.package.resource\",\
		\"weight\": 3006,\
		\"max\": \"*\",\
		\"type\": \"BackboneElement\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"ImplementationGuide.package.resource.id\",\
		\"weight\": 3007,\
		\"max\": \"1\",\
		\"type\": \"id\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"ImplementationGuide.package.resource.extension\",\
		\"weight\": 3008,\
		\"max\": \"*\",\
		\"type\": \"Extension\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"ImplementationGuide.package.resource.modifierExtension\",\
		\"weight\": 3009,\
		\"max\": \"*\",\
		\"type\": \"Extension\"\
	},\
	{\
		\"min\": \"1\",\
		\"path\": \"ImplementationGuide.package.resource.example\",\
		\"weight\": 3010,\
		\"max\": \"1\",\
		\"type\": \"boolean\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"ImplementationGuide.package.resource.name\",\
		\"weight\": 3011,\
		\"max\": \"1\",\
		\"type\": \"string\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"ImplementationGuide.package.resource.description\",\
		\"weight\": 3012,\
		\"max\": \"1\",\
		\"type\": \"string\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"ImplementationGuide.package.resource.acronym\",\
		\"weight\": 3013,\
		\"max\": \"1\",\
		\"type\": \"string\"\
	},\
	{\
		\"min\": \"1\",\
		\"path\": \"ImplementationGuide.package.resource.sourceUri\",\
		\"weight\": 3014,\
		\"max\": \"1\",\
		\"type\": \"uri\"\
	},\
	{\
		\"min\": \"1\",\
		\"path\": \"ImplementationGuide.package.resource.sourceReference\",\
		\"weight\": 3014,\
		\"max\": \"1\",\
		\"type\": \"Reference\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"ImplementationGuide.package.resource.exampleFor\",\
		\"weight\": 3015,\
		\"max\": \"1\",\
		\"type\": \"Reference\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"ImplementationGuide.global\",\
		\"weight\": 3016,\
		\"max\": \"*\",\
		\"type\": \"BackboneElement\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"ImplementationGuide.global.id\",\
		\"weight\": 3017,\
		\"max\": \"1\",\
		\"type\": \"id\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"ImplementationGuide.global.extension\",\
		\"weight\": 3018,\
		\"max\": \"*\",\
		\"type\": \"Extension\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"ImplementationGuide.global.modifierExtension\",\
		\"weight\": 3019,\
		\"max\": \"*\",\
		\"type\": \"Extension\"\
	},\
	{\
		\"min\": \"1\",\
		\"path\": \"ImplementationGuide.global.type\",\
		\"weight\": 3020,\
		\"max\": \"1\",\
		\"type\": \"code\"\
	},\
	{\
		\"min\": \"1\",\
		\"path\": \"ImplementationGuide.global.profile\",\
		\"weight\": 3021,\
		\"max\": \"1\",\
		\"type\": \"Reference\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"ImplementationGuide.binary\",\
		\"weight\": 3022,\
		\"max\": \"*\",\
		\"type\": \"uri\"\
	},\
	{\
		\"min\": \"1\",\
		\"path\": \"ImplementationGuide.page\",\
		\"weight\": 3023,\
		\"max\": \"1\",\
		\"type\": \"BackboneElement\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"ImplementationGuide.page.id\",\
		\"weight\": 3024,\
		\"max\": \"1\",\
		\"type\": \"id\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"ImplementationGuide.page.extension\",\
		\"weight\": 3025,\
		\"max\": \"*\",\
		\"type\": \"Extension\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"ImplementationGuide.page.modifierExtension\",\
		\"weight\": 3026,\
		\"max\": \"*\",\
		\"type\": \"Extension\"\
	},\
	{\
		\"min\": \"1\",\
		\"path\": \"ImplementationGuide.page.source\",\
		\"weight\": 3027,\
		\"max\": \"1\",\
		\"type\": \"uri\"\
	},\
	{\
		\"min\": \"1\",\
		\"path\": \"ImplementationGuide.page.name\",\
		\"weight\": 3028,\
		\"max\": \"1\",\
		\"type\": \"string\"\
	},\
	{\
		\"min\": \"1\",\
		\"path\": \"ImplementationGuide.page.kind\",\
		\"weight\": 3029,\
		\"max\": \"1\",\
		\"type\": \"code\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"ImplementationGuide.page.type\",\
		\"weight\": 3030,\
		\"max\": \"*\",\
		\"type\": \"code\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"ImplementationGuide.page.package\",\
		\"weight\": 3031,\
		\"max\": \"*\",\
		\"type\": \"string\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"ImplementationGuide.page.format\",\
		\"weight\": 3032,\
		\"max\": \"1\",\
		\"type\": \"code\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"ImplementationGuide.page.page\",\
		\"weight\": 3033,\
		\"max\": \"*\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Library\",\
		\"weight\": 3034,\
		\"max\": \"*\",\
		\"type\": \"DomainResource\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Library.id\",\
		\"weight\": 3035,\
		\"max\": \"1\",\
		\"type\": \"id\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Library.meta\",\
		\"weight\": 3036,\
		\"max\": \"1\",\
		\"type\": \"Meta\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Library.implicitRules\",\
		\"weight\": 3037,\
		\"max\": \"1\",\
		\"type\": \"uri\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Library.language\",\
		\"weight\": 3038,\
		\"max\": \"1\",\
		\"type\": \"code\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Library.text\",\
		\"weight\": 3039,\
		\"max\": \"1\",\
		\"type\": \"Narrative\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Library.contained\",\
		\"weight\": 3040,\
		\"max\": \"*\",\
		\"type\": \"Resource\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Library.extension\",\
		\"weight\": 3041,\
		\"max\": \"*\",\
		\"type\": \"Extension\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Library.modifierExtension\",\
		\"weight\": 3042,\
		\"max\": \"*\",\
		\"type\": \"Extension\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Library.moduleMetadata\",\
		\"weight\": 3043,\
		\"max\": \"1\",\
		\"type\": \"ModuleMetadata\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Library.model\",\
		\"weight\": 3044,\
		\"max\": \"*\",\
		\"type\": \"BackboneElement\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Library.model.id\",\
		\"weight\": 3045,\
		\"max\": \"1\",\
		\"type\": \"id\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Library.model.extension\",\
		\"weight\": 3046,\
		\"max\": \"*\",\
		\"type\": \"Extension\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Library.model.modifierExtension\",\
		\"weight\": 3047,\
		\"max\": \"*\",\
		\"type\": \"Extension\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Library.model.name\",\
		\"weight\": 3048,\
		\"max\": \"1\",\
		\"type\": \"string\"\
	},\
	{\
		\"min\": \"1\",\
		\"path\": \"Library.model.identifier\",\
		\"weight\": 3049,\
		\"max\": \"1\",\
		\"type\": \"string\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Library.model.version\",\
		\"weight\": 3050,\
		\"max\": \"1\",\
		\"type\": \"string\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Library.library\",\
		\"weight\": 3051,\
		\"max\": \"*\",\
		\"type\": \"BackboneElement\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Library.library.id\",\
		\"weight\": 3052,\
		\"max\": \"1\",\
		\"type\": \"id\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Library.library.extension\",\
		\"weight\": 3053,\
		\"max\": \"*\",\
		\"type\": \"Extension\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Library.library.modifierExtension\",\
		\"weight\": 3054,\
		\"max\": \"*\",\
		\"type\": \"Extension\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Library.library.name\",\
		\"weight\": 3055,\
		\"max\": \"1\",\
		\"type\": \"string\"\
	},\
	{\
		\"min\": \"1\",\
		\"path\": \"Library.library.identifier\",\
		\"weight\": 3056,\
		\"max\": \"1\",\
		\"type\": \"string\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Library.library.version\",\
		\"weight\": 3057,\
		\"max\": \"1\",\
		\"type\": \"string\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Library.library.documentAttachment\",\
		\"weight\": 3058,\
		\"max\": \"1\",\
		\"type\": \"Attachment\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Library.library.documentReference\",\
		\"weight\": 3058,\
		\"max\": \"1\",\
		\"type\": \"Reference\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Library.codeSystem\",\
		\"weight\": 3059,\
		\"max\": \"*\",\
		\"type\": \"BackboneElement\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Library.codeSystem.id\",\
		\"weight\": 3060,\
		\"max\": \"1\",\
		\"type\": \"id\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Library.codeSystem.extension\",\
		\"weight\": 3061,\
		\"max\": \"*\",\
		\"type\": \"Extension\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Library.codeSystem.modifierExtension\",\
		\"weight\": 3062,\
		\"max\": \"*\",\
		\"type\": \"Extension\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Library.codeSystem.name\",\
		\"weight\": 3063,\
		\"max\": \"1\",\
		\"type\": \"string\"\
	},\
	{\
		\"min\": \"1\",\
		\"path\": \"Library.codeSystem.identifier\",\
		\"weight\": 3064,\
		\"max\": \"1\",\
		\"type\": \"string\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Library.codeSystem.version\",\
		\"weight\": 3065,\
		\"max\": \"1\",\
		\"type\": \"string\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Library.valueSet\",\
		\"weight\": 3066,\
		\"max\": \"*\",\
		\"type\": \"BackboneElement\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Library.valueSet.id\",\
		\"weight\": 3067,\
		\"max\": \"1\",\
		\"type\": \"id\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Library.valueSet.extension\",\
		\"weight\": 3068,\
		\"max\": \"*\",\
		\"type\": \"Extension\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Library.valueSet.modifierExtension\",\
		\"weight\": 3069,\
		\"max\": \"*\",\
		\"type\": \"Extension\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Library.valueSet.name\",\
		\"weight\": 3070,\
		\"max\": \"1\",\
		\"type\": \"string\"\
	},\
	{\
		\"min\": \"1\",\
		\"path\": \"Library.valueSet.identifier\",\
		\"weight\": 3071,\
		\"max\": \"1\",\
		\"type\": \"string\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Library.valueSet.version\",\
		\"weight\": 3072,\
		\"max\": \"1\",\
		\"type\": \"string\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Library.valueSet.codeSystem\",\
		\"weight\": 3073,\
		\"max\": \"*\",\
		\"type\": \"string\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Library.parameter\",\
		\"weight\": 3074,\
		\"max\": \"*\",\
		\"type\": \"ParameterDefinition\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Library.dataRequirement\",\
		\"weight\": 3075,\
		\"max\": \"*\",\
		\"type\": \"DataRequirement\"\
	},\
	{\
		\"min\": \"1\",\
		\"path\": \"Library.document\",\
		\"weight\": 3076,\
		\"max\": \"1\",\
		\"type\": \"Attachment\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Linkage\",\
		\"weight\": 3077,\
		\"max\": \"*\",\
		\"type\": \"DomainResource\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Linkage.id\",\
		\"weight\": 3078,\
		\"max\": \"1\",\
		\"type\": \"id\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Linkage.meta\",\
		\"weight\": 3079,\
		\"max\": \"1\",\
		\"type\": \"Meta\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Linkage.implicitRules\",\
		\"weight\": 3080,\
		\"max\": \"1\",\
		\"type\": \"uri\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Linkage.language\",\
		\"weight\": 3081,\
		\"max\": \"1\",\
		\"type\": \"code\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Linkage.text\",\
		\"weight\": 3082,\
		\"max\": \"1\",\
		\"type\": \"Narrative\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Linkage.contained\",\
		\"weight\": 3083,\
		\"max\": \"*\",\
		\"type\": \"Resource\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Linkage.extension\",\
		\"weight\": 3084,\
		\"max\": \"*\",\
		\"type\": \"Extension\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Linkage.modifierExtension\",\
		\"weight\": 3085,\
		\"max\": \"*\",\
		\"type\": \"Extension\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Linkage.author\",\
		\"weight\": 3086,\
		\"max\": \"1\",\
		\"type\": \"Reference\"\
	},\
	{\
		\"min\": \"1\",\
		\"path\": \"Linkage.item\",\
		\"weight\": 3087,\
		\"max\": \"*\",\
		\"type\": \"BackboneElement\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Linkage.item.id\",\
		\"weight\": 3088,\
		\"max\": \"1\",\
		\"type\": \"id\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Linkage.item.extension\",\
		\"weight\": 3089,\
		\"max\": \"*\",\
		\"type\": \"Extension\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Linkage.item.modifierExtension\",\
		\"weight\": 3090,\
		\"max\": \"*\",\
		\"type\": \"Extension\"\
	},\
	{\
		\"min\": \"1\",\
		\"path\": \"Linkage.item.type\",\
		\"weight\": 3091,\
		\"max\": \"1\",\
		\"type\": \"code\"\
	},\
	{\
		\"min\": \"1\",\
		\"path\": \"Linkage.item.resource\",\
		\"weight\": 3092,\
		\"max\": \"1\",\
		\"type\": \"Reference\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"List\",\
		\"weight\": 3093,\
		\"max\": \"*\",\
		\"type\": \"DomainResource\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"List.id\",\
		\"weight\": 3094,\
		\"max\": \"1\",\
		\"type\": \"id\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"List.meta\",\
		\"weight\": 3095,\
		\"max\": \"1\",\
		\"type\": \"Meta\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"List.implicitRules\",\
		\"weight\": 3096,\
		\"max\": \"1\",\
		\"type\": \"uri\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"List.language\",\
		\"weight\": 3097,\
		\"max\": \"1\",\
		\"type\": \"code\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"List.text\",\
		\"weight\": 3098,\
		\"max\": \"1\",\
		\"type\": \"Narrative\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"List.contained\",\
		\"weight\": 3099,\
		\"max\": \"*\",\
		\"type\": \"Resource\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"List.extension\",\
		\"weight\": 3100,\
		\"max\": \"*\",\
		\"type\": \"Extension\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"List.modifierExtension\",\
		\"weight\": 3101,\
		\"max\": \"*\",\
		\"type\": \"Extension\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"List.identifier\",\
		\"weight\": 3102,\
		\"max\": \"*\",\
		\"type\": \"Identifier\"\
	},\
	{\
		\"min\": \"1\",\
		\"path\": \"List.status\",\
		\"weight\": 3103,\
		\"max\": \"1\",\
		\"type\": \"code\"\
	},\
	{\
		\"min\": \"1\",\
		\"path\": \"List.mode\",\
		\"weight\": 3104,\
		\"max\": \"1\",\
		\"type\": \"code\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"List.title\",\
		\"weight\": 3105,\
		\"max\": \"1\",\
		\"type\": \"string\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"List.code\",\
		\"weight\": 3106,\
		\"max\": \"1\",\
		\"type\": \"CodeableConcept\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"List.subject\",\
		\"weight\": 3107,\
		\"max\": \"1\",\
		\"type\": \"Reference\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"List.encounter\",\
		\"weight\": 3108,\
		\"max\": \"1\",\
		\"type\": \"Reference\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"List.date\",\
		\"weight\": 3109,\
		\"max\": \"1\",\
		\"type\": \"dateTime\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"List.source\",\
		\"weight\": 3110,\
		\"max\": \"1\",\
		\"type\": \"Reference\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"List.orderedBy\",\
		\"weight\": 3111,\
		\"max\": \"1\",\
		\"type\": \"CodeableConcept\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"List.note\",\
		\"weight\": 3112,\
		\"max\": \"*\",\
		\"type\": \"Annotation\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"List.entry\",\
		\"weight\": 3113,\
		\"max\": \"*\",\
		\"type\": \"BackboneElement\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"List.entry.id\",\
		\"weight\": 3114,\
		\"max\": \"1\",\
		\"type\": \"id\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"List.entry.extension\",\
		\"weight\": 3115,\
		\"max\": \"*\",\
		\"type\": \"Extension\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"List.entry.modifierExtension\",\
		\"weight\": 3116,\
		\"max\": \"*\",\
		\"type\": \"Extension\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"List.entry.flag\",\
		\"weight\": 3117,\
		\"max\": \"1\",\
		\"type\": \"CodeableConcept\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"List.entry.deleted\",\
		\"weight\": 3118,\
		\"max\": \"1\",\
		\"type\": \"boolean\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"List.entry.date\",\
		\"weight\": 3119,\
		\"max\": \"1\",\
		\"type\": \"dateTime\"\
	},\
	{\
		\"min\": \"1\",\
		\"path\": \"List.entry.item\",\
		\"weight\": 3120,\
		\"max\": \"1\",\
		\"type\": \"Reference\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"List.emptyReason\",\
		\"weight\": 3121,\
		\"max\": \"1\",\
		\"type\": \"CodeableConcept\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Location\",\
		\"weight\": 3122,\
		\"max\": \"*\",\
		\"type\": \"DomainResource\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Location.id\",\
		\"weight\": 3123,\
		\"max\": \"1\",\
		\"type\": \"id\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Location.meta\",\
		\"weight\": 3124,\
		\"max\": \"1\",\
		\"type\": \"Meta\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Location.implicitRules\",\
		\"weight\": 3125,\
		\"max\": \"1\",\
		\"type\": \"uri\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Location.language\",\
		\"weight\": 3126,\
		\"max\": \"1\",\
		\"type\": \"code\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Location.text\",\
		\"weight\": 3127,\
		\"max\": \"1\",\
		\"type\": \"Narrative\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Location.contained\",\
		\"weight\": 3128,\
		\"max\": \"*\",\
		\"type\": \"Resource\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Location.extension\",\
		\"weight\": 3129,\
		\"max\": \"*\",\
		\"type\": \"Extension\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Location.modifierExtension\",\
		\"weight\": 3130,\
		\"max\": \"*\",\
		\"type\": \"Extension\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Location.identifier\",\
		\"weight\": 3131,\
		\"max\": \"*\",\
		\"type\": \"Identifier\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Location.status\",\
		\"weight\": 3132,\
		\"max\": \"1\",\
		\"type\": \"code\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Location.name\",\
		\"weight\": 3133,\
		\"max\": \"1\",\
		\"type\": \"string\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Location.description\",\
		\"weight\": 3134,\
		\"max\": \"1\",\
		\"type\": \"string\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Location.mode\",\
		\"weight\": 3135,\
		\"max\": \"1\",\
		\"type\": \"code\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Location.type\",\
		\"weight\": 3136,\
		\"max\": \"1\",\
		\"type\": \"CodeableConcept\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Location.telecom\",\
		\"weight\": 3137,\
		\"max\": \"*\",\
		\"type\": \"ContactPoint\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Location.address\",\
		\"weight\": 3138,\
		\"max\": \"1\",\
		\"type\": \"Address\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Location.physicalType\",\
		\"weight\": 3139,\
		\"max\": \"1\",\
		\"type\": \"CodeableConcept\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Location.position\",\
		\"weight\": 3140,\
		\"max\": \"1\",\
		\"type\": \"BackboneElement\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Location.position.id\",\
		\"weight\": 3141,\
		\"max\": \"1\",\
		\"type\": \"id\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Location.position.extension\",\
		\"weight\": 3142,\
		\"max\": \"*\",\
		\"type\": \"Extension\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Location.position.modifierExtension\",\
		\"weight\": 3143,\
		\"max\": \"*\",\
		\"type\": \"Extension\"\
	},\
	{\
		\"min\": \"1\",\
		\"path\": \"Location.position.longitude\",\
		\"weight\": 3144,\
		\"max\": \"1\",\
		\"type\": \"decimal\"\
	},\
	{\
		\"min\": \"1\",\
		\"path\": \"Location.position.latitude\",\
		\"weight\": 3145,\
		\"max\": \"1\",\
		\"type\": \"decimal\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Location.position.altitude\",\
		\"weight\": 3146,\
		\"max\": \"1\",\
		\"type\": \"decimal\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Location.managingOrganization\",\
		\"weight\": 3147,\
		\"max\": \"1\",\
		\"type\": \"Reference\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Location.partOf\",\
		\"weight\": 3148,\
		\"max\": \"1\",\
		\"type\": \"Reference\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Measure\",\
		\"weight\": 3149,\
		\"max\": \"*\",\
		\"type\": \"DomainResource\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Measure.id\",\
		\"weight\": 3150,\
		\"max\": \"1\",\
		\"type\": \"id\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Measure.meta\",\
		\"weight\": 3151,\
		\"max\": \"1\",\
		\"type\": \"Meta\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Measure.implicitRules\",\
		\"weight\": 3152,\
		\"max\": \"1\",\
		\"type\": \"uri\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Measure.language\",\
		\"weight\": 3153,\
		\"max\": \"1\",\
		\"type\": \"code\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Measure.text\",\
		\"weight\": 3154,\
		\"max\": \"1\",\
		\"type\": \"Narrative\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Measure.contained\",\
		\"weight\": 3155,\
		\"max\": \"*\",\
		\"type\": \"Resource\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Measure.extension\",\
		\"weight\": 3156,\
		\"max\": \"*\",\
		\"type\": \"Extension\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Measure.modifierExtension\",\
		\"weight\": 3157,\
		\"max\": \"*\",\
		\"type\": \"Extension\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Measure.moduleMetadata\",\
		\"weight\": 3158,\
		\"max\": \"1\",\
		\"type\": \"ModuleMetadata\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Measure.library\",\
		\"weight\": 3159,\
		\"max\": \"*\",\
		\"type\": \"Reference\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Measure.disclaimer\",\
		\"weight\": 3160,\
		\"max\": \"1\",\
		\"type\": \"markdown\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Measure.scoring\",\
		\"weight\": 3161,\
		\"max\": \"1\",\
		\"type\": \"code\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Measure.type\",\
		\"weight\": 3162,\
		\"max\": \"*\",\
		\"type\": \"code\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Measure.riskAdjustment\",\
		\"weight\": 3163,\
		\"max\": \"1\",\
		\"type\": \"string\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Measure.rateAggregation\",\
		\"weight\": 3164,\
		\"max\": \"1\",\
		\"type\": \"string\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Measure.rationale\",\
		\"weight\": 3165,\
		\"max\": \"1\",\
		\"type\": \"markdown\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Measure.clinicalRecommendationStatement\",\
		\"weight\": 3166,\
		\"max\": \"1\",\
		\"type\": \"markdown\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Measure.improvementNotation\",\
		\"weight\": 3167,\
		\"max\": \"1\",\
		\"type\": \"string\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Measure.definition\",\
		\"weight\": 3168,\
		\"max\": \"1\",\
		\"type\": \"markdown\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Measure.guidance\",\
		\"weight\": 3169,\
		\"max\": \"1\",\
		\"type\": \"markdown\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Measure.set\",\
		\"weight\": 3170,\
		\"max\": \"1\",\
		\"type\": \"string\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Measure.group\",\
		\"weight\": 3171,\
		\"max\": \"*\",\
		\"type\": \"BackboneElement\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Measure.group.id\",\
		\"weight\": 3172,\
		\"max\": \"1\",\
		\"type\": \"id\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Measure.group.extension\",\
		\"weight\": 3173,\
		\"max\": \"*\",\
		\"type\": \"Extension\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Measure.group.modifierExtension\",\
		\"weight\": 3174,\
		\"max\": \"*\",\
		\"type\": \"Extension\"\
	},\
	{\
		\"min\": \"1\",\
		\"path\": \"Measure.group.identifier\",\
		\"weight\": 3175,\
		\"max\": \"1\",\
		\"type\": \"Identifier\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Measure.group.name\",\
		\"weight\": 3176,\
		\"max\": \"1\",\
		\"type\": \"string\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Measure.group.description\",\
		\"weight\": 3177,\
		\"max\": \"1\",\
		\"type\": \"string\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Measure.group.population\",\
		\"weight\": 3178,\
		\"max\": \"*\",\
		\"type\": \"BackboneElement\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Measure.group.population.id\",\
		\"weight\": 3179,\
		\"max\": \"1\",\
		\"type\": \"id\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Measure.group.population.extension\",\
		\"weight\": 3180,\
		\"max\": \"*\",\
		\"type\": \"Extension\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Measure.group.population.modifierExtension\",\
		\"weight\": 3181,\
		\"max\": \"*\",\
		\"type\": \"Extension\"\
	},\
	{\
		\"min\": \"1\",\
		\"path\": \"Measure.group.population.type\",\
		\"weight\": 3182,\
		\"max\": \"1\",\
		\"type\": \"code\"\
	},\
	{\
		\"min\": \"1\",\
		\"path\": \"Measure.group.population.identifier\",\
		\"weight\": 3183,\
		\"max\": \"1\",\
		\"type\": \"Identifier\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Measure.group.population.name\",\
		\"weight\": 3184,\
		\"max\": \"1\",\
		\"type\": \"string\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Measure.group.population.description\",\
		\"weight\": 3185,\
		\"max\": \"1\",\
		\"type\": \"string\"\
	},\
	{\
		\"min\": \"1\",\
		\"path\": \"Measure.group.population.criteria\",\
		\"weight\": 3186,\
		\"max\": \"1\",\
		\"type\": \"string\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Measure.group.stratifier\",\
		\"weight\": 3187,\
		\"max\": \"*\",\
		\"type\": \"BackboneElement\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Measure.group.stratifier.id\",\
		\"weight\": 3188,\
		\"max\": \"1\",\
		\"type\": \"id\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Measure.group.stratifier.extension\",\
		\"weight\": 3189,\
		\"max\": \"*\",\
		\"type\": \"Extension\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Measure.group.stratifier.modifierExtension\",\
		\"weight\": 3190,\
		\"max\": \"*\",\
		\"type\": \"Extension\"\
	},\
	{\
		\"min\": \"1\",\
		\"path\": \"Measure.group.stratifier.identifier\",\
		\"weight\": 3191,\
		\"max\": \"1\",\
		\"type\": \"Identifier\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Measure.group.stratifier.criteria\",\
		\"weight\": 3192,\
		\"max\": \"1\",\
		\"type\": \"string\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Measure.group.stratifier.path\",\
		\"weight\": 3193,\
		\"max\": \"1\",\
		\"type\": \"string\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Measure.supplementalData\",\
		\"weight\": 3194,\
		\"max\": \"*\",\
		\"type\": \"BackboneElement\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Measure.supplementalData.id\",\
		\"weight\": 3195,\
		\"max\": \"1\",\
		\"type\": \"id\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Measure.supplementalData.extension\",\
		\"weight\": 3196,\
		\"max\": \"*\",\
		\"type\": \"Extension\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Measure.supplementalData.modifierExtension\",\
		\"weight\": 3197,\
		\"max\": \"*\",\
		\"type\": \"Extension\"\
	},\
	{\
		\"min\": \"1\",\
		\"path\": \"Measure.supplementalData.identifier\",\
		\"weight\": 3198,\
		\"max\": \"1\",\
		\"type\": \"Identifier\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Measure.supplementalData.usage\",\
		\"weight\": 3199,\
		\"max\": \"*\",\
		\"type\": \"code\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Measure.supplementalData.criteria\",\
		\"weight\": 3200,\
		\"max\": \"1\",\
		\"type\": \"string\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Measure.supplementalData.path\",\
		\"weight\": 3201,\
		\"max\": \"1\",\
		\"type\": \"string\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"MeasureReport\",\
		\"weight\": 3202,\
		\"max\": \"*\",\
		\"type\": \"DomainResource\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"MeasureReport.id\",\
		\"weight\": 3203,\
		\"max\": \"1\",\
		\"type\": \"id\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"MeasureReport.meta\",\
		\"weight\": 3204,\
		\"max\": \"1\",\
		\"type\": \"Meta\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"MeasureReport.implicitRules\",\
		\"weight\": 3205,\
		\"max\": \"1\",\
		\"type\": \"uri\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"MeasureReport.language\",\
		\"weight\": 3206,\
		\"max\": \"1\",\
		\"type\": \"code\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"MeasureReport.text\",\
		\"weight\": 3207,\
		\"max\": \"1\",\
		\"type\": \"Narrative\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"MeasureReport.contained\",\
		\"weight\": 3208,\
		\"max\": \"*\",\
		\"type\": \"Resource\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"MeasureReport.extension\",\
		\"weight\": 3209,\
		\"max\": \"*\",\
		\"type\": \"Extension\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"MeasureReport.modifierExtension\",\
		\"weight\": 3210,\
		\"max\": \"*\",\
		\"type\": \"Extension\"\
	},\
	{\
		\"min\": \"1\",\
		\"path\": \"MeasureReport.measure\",\
		\"weight\": 3211,\
		\"max\": \"1\",\
		\"type\": \"Reference\"\
	},\
	{\
		\"min\": \"1\",\
		\"path\": \"MeasureReport.type\",\
		\"weight\": 3212,\
		\"max\": \"1\",\
		\"type\": \"code\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"MeasureReport.patient\",\
		\"weight\": 3213,\
		\"max\": \"1\",\
		\"type\": \"Reference\"\
	},\
	{\
		\"min\": \"1\",\
		\"path\": \"MeasureReport.period\",\
		\"weight\": 3214,\
		\"max\": \"1\",\
		\"type\": \"Period\"\
	},\
	{\
		\"min\": \"1\",\
		\"path\": \"MeasureReport.status\",\
		\"weight\": 3215,\
		\"max\": \"1\",\
		\"type\": \"code\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"MeasureReport.date\",\
		\"weight\": 3216,\
		\"max\": \"1\",\
		\"type\": \"dateTime\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"MeasureReport.reportingOrganization\",\
		\"weight\": 3217,\
		\"max\": \"1\",\
		\"type\": \"Reference\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"MeasureReport.group\",\
		\"weight\": 3218,\
		\"max\": \"*\",\
		\"type\": \"BackboneElement\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"MeasureReport.group.id\",\
		\"weight\": 3219,\
		\"max\": \"1\",\
		\"type\": \"id\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"MeasureReport.group.extension\",\
		\"weight\": 3220,\
		\"max\": \"*\",\
		\"type\": \"Extension\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"MeasureReport.group.modifierExtension\",\
		\"weight\": 3221,\
		\"max\": \"*\",\
		\"type\": \"Extension\"\
	},\
	{\
		\"min\": \"1\",\
		\"path\": \"MeasureReport.group.identifier\",\
		\"weight\": 3222,\
		\"max\": \"1\",\
		\"type\": \"Identifier\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"MeasureReport.group.population\",\
		\"weight\": 3223,\
		\"max\": \"*\",\
		\"type\": \"BackboneElement\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"MeasureReport.group.population.id\",\
		\"weight\": 3224,\
		\"max\": \"1\",\
		\"type\": \"id\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"MeasureReport.group.population.extension\",\
		\"weight\": 3225,\
		\"max\": \"*\",\
		\"type\": \"Extension\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"MeasureReport.group.population.modifierExtension\",\
		\"weight\": 3226,\
		\"max\": \"*\",\
		\"type\": \"Extension\"\
	},\
	{\
		\"min\": \"1\",\
		\"path\": \"MeasureReport.group.population.type\",\
		\"weight\": 3227,\
		\"max\": \"1\",\
		\"type\": \"code\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"MeasureReport.group.population.count\",\
		\"weight\": 3228,\
		\"max\": \"1\",\
		\"type\": \"integer\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"MeasureReport.group.population.patients\",\
		\"weight\": 3229,\
		\"max\": \"1\",\
		\"type\": \"Reference\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"MeasureReport.group.measureScore\",\
		\"weight\": 3230,\
		\"max\": \"1\",\
		\"type\": \"decimal\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"MeasureReport.group.stratifier\",\
		\"weight\": 3231,\
		\"max\": \"*\",\
		\"type\": \"BackboneElement\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"MeasureReport.group.stratifier.id\",\
		\"weight\": 3232,\
		\"max\": \"1\",\
		\"type\": \"id\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"MeasureReport.group.stratifier.extension\",\
		\"weight\": 3233,\
		\"max\": \"*\",\
		\"type\": \"Extension\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"MeasureReport.group.stratifier.modifierExtension\",\
		\"weight\": 3234,\
		\"max\": \"*\",\
		\"type\": \"Extension\"\
	},\
	{\
		\"min\": \"1\",\
		\"path\": \"MeasureReport.group.stratifier.identifier\",\
		\"weight\": 3235,\
		\"max\": \"1\",\
		\"type\": \"Identifier\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"MeasureReport.group.stratifier.group\",\
		\"weight\": 3236,\
		\"max\": \"*\",\
		\"type\": \"BackboneElement\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"MeasureReport.group.stratifier.group.id\",\
		\"weight\": 3237,\
		\"max\": \"1\",\
		\"type\": \"id\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"MeasureReport.group.stratifier.group.extension\",\
		\"weight\": 3238,\
		\"max\": \"*\",\
		\"type\": \"Extension\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"MeasureReport.group.stratifier.group.modifierExtension\",\
		\"weight\": 3239,\
		\"max\": \"*\",\
		\"type\": \"Extension\"\
	},\
	{\
		\"min\": \"1\",\
		\"path\": \"MeasureReport.group.stratifier.group.value\",\
		\"weight\": 3240,\
		\"max\": \"1\",\
		\"type\": \"string\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"MeasureReport.group.stratifier.group.population\",\
		\"weight\": 3241,\
		\"max\": \"*\",\
		\"type\": \"BackboneElement\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"MeasureReport.group.stratifier.group.population.id\",\
		\"weight\": 3242,\
		\"max\": \"1\",\
		\"type\": \"id\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"MeasureReport.group.stratifier.group.population.extension\",\
		\"weight\": 3243,\
		\"max\": \"*\",\
		\"type\": \"Extension\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"MeasureReport.group.stratifier.group.population.modifierExtension\",\
		\"weight\": 3244,\
		\"max\": \"*\",\
		\"type\": \"Extension\"\
	},\
	{\
		\"min\": \"1\",\
		\"path\": \"MeasureReport.group.stratifier.group.population.type\",\
		\"weight\": 3245,\
		\"max\": \"1\",\
		\"type\": \"code\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"MeasureReport.group.stratifier.group.population.count\",\
		\"weight\": 3246,\
		\"max\": \"1\",\
		\"type\": \"integer\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"MeasureReport.group.stratifier.group.population.patients\",\
		\"weight\": 3247,\
		\"max\": \"1\",\
		\"type\": \"Reference\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"MeasureReport.group.stratifier.group.measureScore\",\
		\"weight\": 3248,\
		\"max\": \"1\",\
		\"type\": \"decimal\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"MeasureReport.group.supplementalData\",\
		\"weight\": 3249,\
		\"max\": \"*\",\
		\"type\": \"BackboneElement\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"MeasureReport.group.supplementalData.id\",\
		\"weight\": 3250,\
		\"max\": \"1\",\
		\"type\": \"id\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"MeasureReport.group.supplementalData.extension\",\
		\"weight\": 3251,\
		\"max\": \"*\",\
		\"type\": \"Extension\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"MeasureReport.group.supplementalData.modifierExtension\",\
		\"weight\": 3252,\
		\"max\": \"*\",\
		\"type\": \"Extension\"\
	},\
	{\
		\"min\": \"1\",\
		\"path\": \"MeasureReport.group.supplementalData.identifier\",\
		\"weight\": 3253,\
		\"max\": \"1\",\
		\"type\": \"Identifier\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"MeasureReport.group.supplementalData.group\",\
		\"weight\": 3254,\
		\"max\": \"*\",\
		\"type\": \"BackboneElement\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"MeasureReport.group.supplementalData.group.id\",\
		\"weight\": 3255,\
		\"max\": \"1\",\
		\"type\": \"id\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"MeasureReport.group.supplementalData.group.extension\",\
		\"weight\": 3256,\
		\"max\": \"*\",\
		\"type\": \"Extension\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"MeasureReport.group.supplementalData.group.modifierExtension\",\
		\"weight\": 3257,\
		\"max\": \"*\",\
		\"type\": \"Extension\"\
	},\
	{\
		\"min\": \"1\",\
		\"path\": \"MeasureReport.group.supplementalData.group.value\",\
		\"weight\": 3258,\
		\"max\": \"1\",\
		\"type\": \"string\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"MeasureReport.group.supplementalData.group.count\",\
		\"weight\": 3259,\
		\"max\": \"1\",\
		\"type\": \"integer\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"MeasureReport.group.supplementalData.group.patients\",\
		\"weight\": 3260,\
		\"max\": \"1\",\
		\"type\": \"Reference\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"MeasureReport.evaluatedResources\",\
		\"weight\": 3261,\
		\"max\": \"1\",\
		\"type\": \"Reference\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Media\",\
		\"weight\": 3262,\
		\"max\": \"*\",\
		\"type\": \"DomainResource\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Media.id\",\
		\"weight\": 3263,\
		\"max\": \"1\",\
		\"type\": \"id\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Media.meta\",\
		\"weight\": 3264,\
		\"max\": \"1\",\
		\"type\": \"Meta\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Media.implicitRules\",\
		\"weight\": 3265,\
		\"max\": \"1\",\
		\"type\": \"uri\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Media.language\",\
		\"weight\": 3266,\
		\"max\": \"1\",\
		\"type\": \"code\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Media.text\",\
		\"weight\": 3267,\
		\"max\": \"1\",\
		\"type\": \"Narrative\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Media.contained\",\
		\"weight\": 3268,\
		\"max\": \"*\",\
		\"type\": \"Resource\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Media.extension\",\
		\"weight\": 3269,\
		\"max\": \"*\",\
		\"type\": \"Extension\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Media.modifierExtension\",\
		\"weight\": 3270,\
		\"max\": \"*\",\
		\"type\": \"Extension\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Media.identifier\",\
		\"weight\": 3271,\
		\"max\": \"*\",\
		\"type\": \"Identifier\"\
	},\
	{\
		\"min\": \"1\",\
		\"path\": \"Media.type\",\
		\"weight\": 3272,\
		\"max\": \"1\",\
		\"type\": \"code\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Media.subtype\",\
		\"weight\": 3273,\
		\"max\": \"1\",\
		\"type\": \"CodeableConcept\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Media.view\",\
		\"weight\": 3274,\
		\"max\": \"1\",\
		\"type\": \"CodeableConcept\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Media.subject\",\
		\"weight\": 3275,\
		\"max\": \"1\",\
		\"type\": \"Reference\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Media.operator\",\
		\"weight\": 3276,\
		\"max\": \"1\",\
		\"type\": \"Reference\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Media.deviceName\",\
		\"weight\": 3277,\
		\"max\": \"1\",\
		\"type\": \"string\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Media.height\",\
		\"weight\": 3278,\
		\"max\": \"1\",\
		\"type\": \"positiveInt\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Media.width\",\
		\"weight\": 3279,\
		\"max\": \"1\",\
		\"type\": \"positiveInt\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Media.frames\",\
		\"weight\": 3280,\
		\"max\": \"1\",\
		\"type\": \"positiveInt\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Media.duration\",\
		\"weight\": 3281,\
		\"max\": \"1\",\
		\"type\": \"unsignedInt\"\
	},\
	{\
		\"min\": \"1\",\
		\"path\": \"Media.content\",\
		\"weight\": 3282,\
		\"max\": \"1\",\
		\"type\": \"Attachment\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Medication\",\
		\"weight\": 3283,\
		\"max\": \"*\",\
		\"type\": \"DomainResource\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Medication.id\",\
		\"weight\": 3284,\
		\"max\": \"1\",\
		\"type\": \"id\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Medication.meta\",\
		\"weight\": 3285,\
		\"max\": \"1\",\
		\"type\": \"Meta\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Medication.implicitRules\",\
		\"weight\": 3286,\
		\"max\": \"1\",\
		\"type\": \"uri\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Medication.language\",\
		\"weight\": 3287,\
		\"max\": \"1\",\
		\"type\": \"code\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Medication.text\",\
		\"weight\": 3288,\
		\"max\": \"1\",\
		\"type\": \"Narrative\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Medication.contained\",\
		\"weight\": 3289,\
		\"max\": \"*\",\
		\"type\": \"Resource\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Medication.extension\",\
		\"weight\": 3290,\
		\"max\": \"*\",\
		\"type\": \"Extension\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Medication.modifierExtension\",\
		\"weight\": 3291,\
		\"max\": \"*\",\
		\"type\": \"Extension\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Medication.code\",\
		\"weight\": 3292,\
		\"max\": \"1\",\
		\"type\": \"CodeableConcept\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Medication.isBrand\",\
		\"weight\": 3293,\
		\"max\": \"1\",\
		\"type\": \"boolean\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Medication.manufacturer\",\
		\"weight\": 3294,\
		\"max\": \"1\",\
		\"type\": \"Reference\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Medication.product\",\
		\"weight\": 3295,\
		\"max\": \"1\",\
		\"type\": \"BackboneElement\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Medication.product.id\",\
		\"weight\": 3296,\
		\"max\": \"1\",\
		\"type\": \"id\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Medication.product.extension\",\
		\"weight\": 3297,\
		\"max\": \"*\",\
		\"type\": \"Extension\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Medication.product.modifierExtension\",\
		\"weight\": 3298,\
		\"max\": \"*\",\
		\"type\": \"Extension\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Medication.product.form\",\
		\"weight\": 3299,\
		\"max\": \"1\",\
		\"type\": \"CodeableConcept\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Medication.product.ingredient\",\
		\"weight\": 3300,\
		\"max\": \"*\",\
		\"type\": \"BackboneElement\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Medication.product.ingredient.id\",\
		\"weight\": 3301,\
		\"max\": \"1\",\
		\"type\": \"id\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Medication.product.ingredient.extension\",\
		\"weight\": 3302,\
		\"max\": \"*\",\
		\"type\": \"Extension\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Medication.product.ingredient.modifierExtension\",\
		\"weight\": 3303,\
		\"max\": \"*\",\
		\"type\": \"Extension\"\
	},\
	{\
		\"min\": \"1\",\
		\"path\": \"Medication.product.ingredient.itemCodeableConcept\",\
		\"weight\": 3304,\
		\"max\": \"1\",\
		\"type\": \"CodeableConcept\"\
	},\
	{\
		\"min\": \"1\",\
		\"path\": \"Medication.product.ingredient.itemReference\",\
		\"weight\": 3304,\
		\"max\": \"1\",\
		\"type\": \"Reference\"\
	},\
	{\
		\"min\": \"1\",\
		\"path\": \"Medication.product.ingredient.itemReference\",\
		\"weight\": 3304,\
		\"max\": \"1\",\
		\"type\": \"Reference\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Medication.product.ingredient.amount\",\
		\"weight\": 3305,\
		\"max\": \"1\",\
		\"type\": \"Ratio\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Medication.product.batch\",\
		\"weight\": 3306,\
		\"max\": \"*\",\
		\"type\": \"BackboneElement\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Medication.product.batch.id\",\
		\"weight\": 3307,\
		\"max\": \"1\",\
		\"type\": \"id\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Medication.product.batch.extension\",\
		\"weight\": 3308,\
		\"max\": \"*\",\
		\"type\": \"Extension\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Medication.product.batch.modifierExtension\",\
		\"weight\": 3309,\
		\"max\": \"*\",\
		\"type\": \"Extension\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Medication.product.batch.lotNumber\",\
		\"weight\": 3310,\
		\"max\": \"1\",\
		\"type\": \"string\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Medication.product.batch.expirationDate\",\
		\"weight\": 3311,\
		\"max\": \"1\",\
		\"type\": \"dateTime\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Medication.package\",\
		\"weight\": 3312,\
		\"max\": \"1\",\
		\"type\": \"BackboneElement\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Medication.package.id\",\
		\"weight\": 3313,\
		\"max\": \"1\",\
		\"type\": \"id\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Medication.package.extension\",\
		\"weight\": 3314,\
		\"max\": \"*\",\
		\"type\": \"Extension\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Medication.package.modifierExtension\",\
		\"weight\": 3315,\
		\"max\": \"*\",\
		\"type\": \"Extension\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Medication.package.container\",\
		\"weight\": 3316,\
		\"max\": \"1\",\
		\"type\": \"CodeableConcept\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Medication.package.content\",\
		\"weight\": 3317,\
		\"max\": \"*\",\
		\"type\": \"BackboneElement\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Medication.package.content.id\",\
		\"weight\": 3318,\
		\"max\": \"1\",\
		\"type\": \"id\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Medication.package.content.extension\",\
		\"weight\": 3319,\
		\"max\": \"*\",\
		\"type\": \"Extension\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Medication.package.content.modifierExtension\",\
		\"weight\": 3320,\
		\"max\": \"*\",\
		\"type\": \"Extension\"\
	},\
	{\
		\"min\": \"1\",\
		\"path\": \"Medication.package.content.itemCodeableConcept\",\
		\"weight\": 3321,\
		\"max\": \"1\",\
		\"type\": \"CodeableConcept\"\
	},\
	{\
		\"min\": \"1\",\
		\"path\": \"Medication.package.content.itemReference\",\
		\"weight\": 3321,\
		\"max\": \"1\",\
		\"type\": \"Reference\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Medication.package.content.amount\",\
		\"weight\": 3322,\
		\"max\": \"1\",\
		\"type\": \"Quantity\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"MedicationAdministration\",\
		\"weight\": 3323,\
		\"max\": \"*\",\
		\"type\": \"DomainResource\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"MedicationAdministration.id\",\
		\"weight\": 3324,\
		\"max\": \"1\",\
		\"type\": \"id\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"MedicationAdministration.meta\",\
		\"weight\": 3325,\
		\"max\": \"1\",\
		\"type\": \"Meta\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"MedicationAdministration.implicitRules\",\
		\"weight\": 3326,\
		\"max\": \"1\",\
		\"type\": \"uri\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"MedicationAdministration.language\",\
		\"weight\": 3327,\
		\"max\": \"1\",\
		\"type\": \"code\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"MedicationAdministration.text\",\
		\"weight\": 3328,\
		\"max\": \"1\",\
		\"type\": \"Narrative\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"MedicationAdministration.contained\",\
		\"weight\": 3329,\
		\"max\": \"*\",\
		\"type\": \"Resource\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"MedicationAdministration.extension\",\
		\"weight\": 3330,\
		\"max\": \"*\",\
		\"type\": \"Extension\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"MedicationAdministration.modifierExtension\",\
		\"weight\": 3331,\
		\"max\": \"*\",\
		\"type\": \"Extension\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"MedicationAdministration.identifier\",\
		\"weight\": 3332,\
		\"max\": \"*\",\
		\"type\": \"Identifier\"\
	},\
	{\
		\"min\": \"1\",\
		\"path\": \"MedicationAdministration.status\",\
		\"weight\": 3333,\
		\"max\": \"1\",\
		\"type\": \"code\"\
	},\
	{\
		\"min\": \"1\",\
		\"path\": \"MedicationAdministration.medicationCodeableConcept\",\
		\"weight\": 3334,\
		\"max\": \"1\",\
		\"type\": \"CodeableConcept\"\
	},\
	{\
		\"min\": \"1\",\
		\"path\": \"MedicationAdministration.medicationReference\",\
		\"weight\": 3334,\
		\"max\": \"1\",\
		\"type\": \"Reference\"\
	},\
	{\
		\"min\": \"1\",\
		\"path\": \"MedicationAdministration.patient\",\
		\"weight\": 3335,\
		\"max\": \"1\",\
		\"type\": \"Reference\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"MedicationAdministration.encounter\",\
		\"weight\": 3336,\
		\"max\": \"1\",\
		\"type\": \"Reference\"\
	},\
	{\
		\"min\": \"1\",\
		\"path\": \"MedicationAdministration.effectiveTimeDateTime\",\
		\"weight\": 3337,\
		\"max\": \"1\",\
		\"type\": \"dateTime\"\
	},\
	{\
		\"min\": \"1\",\
		\"path\": \"MedicationAdministration.effectiveTimePeriod\",\
		\"weight\": 3337,\
		\"max\": \"1\",\
		\"type\": \"Period\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"MedicationAdministration.practitioner\",\
		\"weight\": 3338,\
		\"max\": \"1\",\
		\"type\": \"Reference\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"MedicationAdministration.prescription\",\
		\"weight\": 3339,\
		\"max\": \"1\",\
		\"type\": \"Reference\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"MedicationAdministration.wasNotGiven\",\
		\"weight\": 3340,\
		\"max\": \"1\",\
		\"type\": \"boolean\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"MedicationAdministration.reasonNotGiven\",\
		\"weight\": 3341,\
		\"max\": \"*\",\
		\"type\": \"CodeableConcept\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"MedicationAdministration.reasonGiven\",\
		\"weight\": 3342,\
		\"max\": \"*\",\
		\"type\": \"CodeableConcept\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"MedicationAdministration.device\",\
		\"weight\": 3343,\
		\"max\": \"*\",\
		\"type\": \"Reference\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"MedicationAdministration.note\",\
		\"weight\": 3344,\
		\"max\": \"*\",\
		\"type\": \"Annotation\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"MedicationAdministration.dosage\",\
		\"weight\": 3345,\
		\"max\": \"1\",\
		\"type\": \"BackboneElement\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"MedicationAdministration.dosage.id\",\
		\"weight\": 3346,\
		\"max\": \"1\",\
		\"type\": \"id\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"MedicationAdministration.dosage.extension\",\
		\"weight\": 3347,\
		\"max\": \"*\",\
		\"type\": \"Extension\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"MedicationAdministration.dosage.modifierExtension\",\
		\"weight\": 3348,\
		\"max\": \"*\",\
		\"type\": \"Extension\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"MedicationAdministration.dosage.text\",\
		\"weight\": 3349,\
		\"max\": \"1\",\
		\"type\": \"string\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"MedicationAdministration.dosage.siteCodeableConcept\",\
		\"weight\": 3350,\
		\"max\": \"1\",\
		\"type\": \"CodeableConcept\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"MedicationAdministration.dosage.siteReference\",\
		\"weight\": 3350,\
		\"max\": \"1\",\
		\"type\": \"Reference\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"MedicationAdministration.dosage.route\",\
		\"weight\": 3351,\
		\"max\": \"1\",\
		\"type\": \"CodeableConcept\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"MedicationAdministration.dosage.method\",\
		\"weight\": 3352,\
		\"max\": \"1\",\
		\"type\": \"CodeableConcept\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"MedicationAdministration.dosage.quantity\",\
		\"weight\": 3353,\
		\"max\": \"1\",\
		\"type\": \"Quantity\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"MedicationAdministration.dosage.rateRatio\",\
		\"weight\": 3354,\
		\"max\": \"1\",\
		\"type\": \"Ratio\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"MedicationAdministration.dosage.rateRange\",\
		\"weight\": 3354,\
		\"max\": \"1\",\
		\"type\": \"Range\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"MedicationDispense\",\
		\"weight\": 3355,\
		\"max\": \"*\",\
		\"type\": \"DomainResource\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"MedicationDispense.id\",\
		\"weight\": 3356,\
		\"max\": \"1\",\
		\"type\": \"id\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"MedicationDispense.meta\",\
		\"weight\": 3357,\
		\"max\": \"1\",\
		\"type\": \"Meta\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"MedicationDispense.implicitRules\",\
		\"weight\": 3358,\
		\"max\": \"1\",\
		\"type\": \"uri\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"MedicationDispense.language\",\
		\"weight\": 3359,\
		\"max\": \"1\",\
		\"type\": \"code\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"MedicationDispense.text\",\
		\"weight\": 3360,\
		\"max\": \"1\",\
		\"type\": \"Narrative\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"MedicationDispense.contained\",\
		\"weight\": 3361,\
		\"max\": \"*\",\
		\"type\": \"Resource\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"MedicationDispense.extension\",\
		\"weight\": 3362,\
		\"max\": \"*\",\
		\"type\": \"Extension\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"MedicationDispense.modifierExtension\",\
		\"weight\": 3363,\
		\"max\": \"*\",\
		\"type\": \"Extension\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"MedicationDispense.identifier\",\
		\"weight\": 3364,\
		\"max\": \"1\",\
		\"type\": \"Identifier\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"MedicationDispense.status\",\
		\"weight\": 3365,\
		\"max\": \"1\",\
		\"type\": \"code\"\
	},\
	{\
		\"min\": \"1\",\
		\"path\": \"MedicationDispense.medicationCodeableConcept\",\
		\"weight\": 3366,\
		\"max\": \"1\",\
		\"type\": \"CodeableConcept\"\
	},\
	{\
		\"min\": \"1\",\
		\"path\": \"MedicationDispense.medicationReference\",\
		\"weight\": 3366,\
		\"max\": \"1\",\
		\"type\": \"Reference\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"MedicationDispense.patient\",\
		\"weight\": 3367,\
		\"max\": \"1\",\
		\"type\": \"Reference\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"MedicationDispense.dispenser\",\
		\"weight\": 3368,\
		\"max\": \"1\",\
		\"type\": \"Reference\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"MedicationDispense.authorizingPrescription\",\
		\"weight\": 3369,\
		\"max\": \"*\",\
		\"type\": \"Reference\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"MedicationDispense.type\",\
		\"weight\": 3370,\
		\"max\": \"1\",\
		\"type\": \"CodeableConcept\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"MedicationDispense.quantity\",\
		\"weight\": 3371,\
		\"max\": \"1\",\
		\"type\": \"Quantity\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"MedicationDispense.daysSupply\",\
		\"weight\": 3372,\
		\"max\": \"1\",\
		\"type\": \"Quantity\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"MedicationDispense.whenPrepared\",\
		\"weight\": 3373,\
		\"max\": \"1\",\
		\"type\": \"dateTime\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"MedicationDispense.whenHandedOver\",\
		\"weight\": 3374,\
		\"max\": \"1\",\
		\"type\": \"dateTime\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"MedicationDispense.destination\",\
		\"weight\": 3375,\
		\"max\": \"1\",\
		\"type\": \"Reference\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"MedicationDispense.receiver\",\
		\"weight\": 3376,\
		\"max\": \"*\",\
		\"type\": \"Reference\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"MedicationDispense.note\",\
		\"weight\": 3377,\
		\"max\": \"*\",\
		\"type\": \"Annotation\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"MedicationDispense.dosageInstruction\",\
		\"weight\": 3378,\
		\"max\": \"*\",\
		\"type\": \"BackboneElement\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"MedicationDispense.dosageInstruction.id\",\
		\"weight\": 3379,\
		\"max\": \"1\",\
		\"type\": \"id\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"MedicationDispense.dosageInstruction.extension\",\
		\"weight\": 3380,\
		\"max\": \"*\",\
		\"type\": \"Extension\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"MedicationDispense.dosageInstruction.modifierExtension\",\
		\"weight\": 3381,\
		\"max\": \"*\",\
		\"type\": \"Extension\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"MedicationDispense.dosageInstruction.text\",\
		\"weight\": 3382,\
		\"max\": \"1\",\
		\"type\": \"string\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"MedicationDispense.dosageInstruction.additionalInstructions\",\
		\"weight\": 3383,\
		\"max\": \"1\",\
		\"type\": \"CodeableConcept\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"MedicationDispense.dosageInstruction.timing\",\
		\"weight\": 3384,\
		\"max\": \"1\",\
		\"type\": \"Timing\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"MedicationDispense.dosageInstruction.asNeededBoolean\",\
		\"weight\": 3385,\
		\"max\": \"1\",\
		\"type\": \"boolean\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"MedicationDispense.dosageInstruction.asNeededCodeableConcept\",\
		\"weight\": 3385,\
		\"max\": \"1\",\
		\"type\": \"CodeableConcept\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"MedicationDispense.dosageInstruction.siteCodeableConcept\",\
		\"weight\": 3386,\
		\"max\": \"1\",\
		\"type\": \"CodeableConcept\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"MedicationDispense.dosageInstruction.siteReference\",\
		\"weight\": 3386,\
		\"max\": \"1\",\
		\"type\": \"Reference\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"MedicationDispense.dosageInstruction.route\",\
		\"weight\": 3387,\
		\"max\": \"1\",\
		\"type\": \"CodeableConcept\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"MedicationDispense.dosageInstruction.method\",\
		\"weight\": 3388,\
		\"max\": \"1\",\
		\"type\": \"CodeableConcept\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"MedicationDispense.dosageInstruction.doseRange\",\
		\"weight\": 3389,\
		\"max\": \"1\",\
		\"type\": \"Range\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"MedicationDispense.dosageInstruction.doseQuantity\",\
		\"weight\": 3389,\
		\"max\": \"1\",\
		\"type\": \"Quantity\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"MedicationDispense.dosageInstruction.rateRatio\",\
		\"weight\": 3390,\
		\"max\": \"1\",\
		\"type\": \"Ratio\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"MedicationDispense.dosageInstruction.rateRange\",\
		\"weight\": 3390,\
		\"max\": \"1\",\
		\"type\": \"Range\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"MedicationDispense.dosageInstruction.maxDosePerPeriod\",\
		\"weight\": 3391,\
		\"max\": \"1\",\
		\"type\": \"Ratio\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"MedicationDispense.substitution\",\
		\"weight\": 3392,\
		\"max\": \"1\",\
		\"type\": \"BackboneElement\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"MedicationDispense.substitution.id\",\
		\"weight\": 3393,\
		\"max\": \"1\",\
		\"type\": \"id\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"MedicationDispense.substitution.extension\",\
		\"weight\": 3394,\
		\"max\": \"*\",\
		\"type\": \"Extension\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"MedicationDispense.substitution.modifierExtension\",\
		\"weight\": 3395,\
		\"max\": \"*\",\
		\"type\": \"Extension\"\
	},\
	{\
		\"min\": \"1\",\
		\"path\": \"MedicationDispense.substitution.type\",\
		\"weight\": 3396,\
		\"max\": \"1\",\
		\"type\": \"CodeableConcept\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"MedicationDispense.substitution.reason\",\
		\"weight\": 3397,\
		\"max\": \"*\",\
		\"type\": \"CodeableConcept\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"MedicationDispense.substitution.responsibleParty\",\
		\"weight\": 3398,\
		\"max\": \"*\",\
		\"type\": \"Reference\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"MedicationOrder\",\
		\"weight\": 3399,\
		\"max\": \"*\",\
		\"type\": \"DomainResource\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"MedicationOrder.id\",\
		\"weight\": 3400,\
		\"max\": \"1\",\
		\"type\": \"id\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"MedicationOrder.meta\",\
		\"weight\": 3401,\
		\"max\": \"1\",\
		\"type\": \"Meta\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"MedicationOrder.implicitRules\",\
		\"weight\": 3402,\
		\"max\": \"1\",\
		\"type\": \"uri\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"MedicationOrder.language\",\
		\"weight\": 3403,\
		\"max\": \"1\",\
		\"type\": \"code\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"MedicationOrder.text\",\
		\"weight\": 3404,\
		\"max\": \"1\",\
		\"type\": \"Narrative\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"MedicationOrder.contained\",\
		\"weight\": 3405,\
		\"max\": \"*\",\
		\"type\": \"Resource\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"MedicationOrder.extension\",\
		\"weight\": 3406,\
		\"max\": \"*\",\
		\"type\": \"Extension\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"MedicationOrder.modifierExtension\",\
		\"weight\": 3407,\
		\"max\": \"*\",\
		\"type\": \"Extension\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"MedicationOrder.identifier\",\
		\"weight\": 3408,\
		\"max\": \"*\",\
		\"type\": \"Identifier\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"MedicationOrder.status\",\
		\"weight\": 3409,\
		\"max\": \"1\",\
		\"type\": \"code\"\
	},\
	{\
		\"min\": \"1\",\
		\"path\": \"MedicationOrder.medicationCodeableConcept\",\
		\"weight\": 3410,\
		\"max\": \"1\",\
		\"type\": \"CodeableConcept\"\
	},\
	{\
		\"min\": \"1\",\
		\"path\": \"MedicationOrder.medicationReference\",\
		\"weight\": 3410,\
		\"max\": \"1\",\
		\"type\": \"Reference\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"MedicationOrder.patient\",\
		\"weight\": 3411,\
		\"max\": \"1\",\
		\"type\": \"Reference\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"MedicationOrder.encounter\",\
		\"weight\": 3412,\
		\"max\": \"1\",\
		\"type\": \"Reference\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"MedicationOrder.dateWritten\",\
		\"weight\": 3413,\
		\"max\": \"1\",\
		\"type\": \"dateTime\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"MedicationOrder.prescriber\",\
		\"weight\": 3414,\
		\"max\": \"1\",\
		\"type\": \"Reference\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"MedicationOrder.reasonCode\",\
		\"weight\": 3415,\
		\"max\": \"*\",\
		\"type\": \"CodeableConcept\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"MedicationOrder.reasonReference\",\
		\"weight\": 3416,\
		\"max\": \"*\",\
		\"type\": \"Reference\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"MedicationOrder.dateEnded\",\
		\"weight\": 3417,\
		\"max\": \"1\",\
		\"type\": \"dateTime\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"MedicationOrder.reasonEnded\",\
		\"weight\": 3418,\
		\"max\": \"1\",\
		\"type\": \"CodeableConcept\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"MedicationOrder.note\",\
		\"weight\": 3419,\
		\"max\": \"*\",\
		\"type\": \"Annotation\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"MedicationOrder.dosageInstruction\",\
		\"weight\": 3420,\
		\"max\": \"*\",\
		\"type\": \"BackboneElement\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"MedicationOrder.dosageInstruction.id\",\
		\"weight\": 3421,\
		\"max\": \"1\",\
		\"type\": \"id\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"MedicationOrder.dosageInstruction.extension\",\
		\"weight\": 3422,\
		\"max\": \"*\",\
		\"type\": \"Extension\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"MedicationOrder.dosageInstruction.modifierExtension\",\
		\"weight\": 3423,\
		\"max\": \"*\",\
		\"type\": \"Extension\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"MedicationOrder.dosageInstruction.text\",\
		\"weight\": 3424,\
		\"max\": \"1\",\
		\"type\": \"string\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"MedicationOrder.dosageInstruction.additionalInstructions\",\
		\"weight\": 3425,\
		\"max\": \"1\",\
		\"type\": \"CodeableConcept\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"MedicationOrder.dosageInstruction.timing\",\
		\"weight\": 3426,\
		\"max\": \"1\",\
		\"type\": \"Timing\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"MedicationOrder.dosageInstruction.asNeededBoolean\",\
		\"weight\": 3427,\
		\"max\": \"1\",\
		\"type\": \"boolean\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"MedicationOrder.dosageInstruction.asNeededCodeableConcept\",\
		\"weight\": 3427,\
		\"max\": \"1\",\
		\"type\": \"CodeableConcept\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"MedicationOrder.dosageInstruction.siteCodeableConcept\",\
		\"weight\": 3428,\
		\"max\": \"1\",\
		\"type\": \"CodeableConcept\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"MedicationOrder.dosageInstruction.siteReference\",\
		\"weight\": 3428,\
		\"max\": \"1\",\
		\"type\": \"Reference\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"MedicationOrder.dosageInstruction.route\",\
		\"weight\": 3429,\
		\"max\": \"1\",\
		\"type\": \"CodeableConcept\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"MedicationOrder.dosageInstruction.method\",\
		\"weight\": 3430,\
		\"max\": \"1\",\
		\"type\": \"CodeableConcept\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"MedicationOrder.dosageInstruction.doseRange\",\
		\"weight\": 3431,\
		\"max\": \"1\",\
		\"type\": \"Range\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"MedicationOrder.dosageInstruction.doseQuantity\",\
		\"weight\": 3431,\
		\"max\": \"1\",\
		\"type\": \"Quantity\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"MedicationOrder.dosageInstruction.rateRatio\",\
		\"weight\": 3432,\
		\"max\": \"1\",\
		\"type\": \"Ratio\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"MedicationOrder.dosageInstruction.rateRange\",\
		\"weight\": 3432,\
		\"max\": \"1\",\
		\"type\": \"Range\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"MedicationOrder.dosageInstruction.rateQuantity\",\
		\"weight\": 3432,\
		\"max\": \"1\",\
		\"type\": \"Quantity\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"MedicationOrder.dosageInstruction.maxDosePerPeriod\",\
		\"weight\": 3433,\
		\"max\": \"1\",\
		\"type\": \"Ratio\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"MedicationOrder.dispenseRequest\",\
		\"weight\": 3434,\
		\"max\": \"1\",\
		\"type\": \"BackboneElement\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"MedicationOrder.dispenseRequest.id\",\
		\"weight\": 3435,\
		\"max\": \"1\",\
		\"type\": \"id\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"MedicationOrder.dispenseRequest.extension\",\
		\"weight\": 3436,\
		\"max\": \"*\",\
		\"type\": \"Extension\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"MedicationOrder.dispenseRequest.modifierExtension\",\
		\"weight\": 3437,\
		\"max\": \"*\",\
		\"type\": \"Extension\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"MedicationOrder.dispenseRequest.medicationCodeableConcept\",\
		\"weight\": 3438,\
		\"max\": \"1\",\
		\"type\": \"CodeableConcept\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"MedicationOrder.dispenseRequest.medicationReference\",\
		\"weight\": 3438,\
		\"max\": \"1\",\
		\"type\": \"Reference\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"MedicationOrder.dispenseRequest.validityPeriod\",\
		\"weight\": 3439,\
		\"max\": \"1\",\
		\"type\": \"Period\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"MedicationOrder.dispenseRequest.numberOfRepeatsAllowed\",\
		\"weight\": 3440,\
		\"max\": \"1\",\
		\"type\": \"positiveInt\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"MedicationOrder.dispenseRequest.quantity\",\
		\"weight\": 3441,\
		\"max\": \"1\",\
		\"type\": \"Quantity\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"MedicationOrder.dispenseRequest.expectedSupplyDuration\",\
		\"weight\": 3442,\
		\"max\": \"1\",\
		\"type\": \"Quantity\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"MedicationOrder.substitution\",\
		\"weight\": 3443,\
		\"max\": \"1\",\
		\"type\": \"BackboneElement\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"MedicationOrder.substitution.id\",\
		\"weight\": 3444,\
		\"max\": \"1\",\
		\"type\": \"id\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"MedicationOrder.substitution.extension\",\
		\"weight\": 3445,\
		\"max\": \"*\",\
		\"type\": \"Extension\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"MedicationOrder.substitution.modifierExtension\",\
		\"weight\": 3446,\
		\"max\": \"*\",\
		\"type\": \"Extension\"\
	},\
	{\
		\"min\": \"1\",\
		\"path\": \"MedicationOrder.substitution.type\",\
		\"weight\": 3447,\
		\"max\": \"1\",\
		\"type\": \"CodeableConcept\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"MedicationOrder.substitution.reason\",\
		\"weight\": 3448,\
		\"max\": \"1\",\
		\"type\": \"CodeableConcept\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"MedicationOrder.priorPrescription\",\
		\"weight\": 3449,\
		\"max\": \"1\",\
		\"type\": \"Reference\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"MedicationStatement\",\
		\"weight\": 3450,\
		\"max\": \"*\",\
		\"type\": \"DomainResource\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"MedicationStatement.id\",\
		\"weight\": 3451,\
		\"max\": \"1\",\
		\"type\": \"id\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"MedicationStatement.meta\",\
		\"weight\": 3452,\
		\"max\": \"1\",\
		\"type\": \"Meta\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"MedicationStatement.implicitRules\",\
		\"weight\": 3453,\
		\"max\": \"1\",\
		\"type\": \"uri\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"MedicationStatement.language\",\
		\"weight\": 3454,\
		\"max\": \"1\",\
		\"type\": \"code\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"MedicationStatement.text\",\
		\"weight\": 3455,\
		\"max\": \"1\",\
		\"type\": \"Narrative\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"MedicationStatement.contained\",\
		\"weight\": 3456,\
		\"max\": \"*\",\
		\"type\": \"Resource\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"MedicationStatement.extension\",\
		\"weight\": 3457,\
		\"max\": \"*\",\
		\"type\": \"Extension\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"MedicationStatement.modifierExtension\",\
		\"weight\": 3458,\
		\"max\": \"*\",\
		\"type\": \"Extension\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"MedicationStatement.identifier\",\
		\"weight\": 3459,\
		\"max\": \"*\",\
		\"type\": \"Identifier\"\
	},\
	{\
		\"min\": \"1\",\
		\"path\": \"MedicationStatement.status\",\
		\"weight\": 3460,\
		\"max\": \"1\",\
		\"type\": \"code\"\
	},\
	{\
		\"min\": \"1\",\
		\"path\": \"MedicationStatement.medicationCodeableConcept\",\
		\"weight\": 3461,\
		\"max\": \"1\",\
		\"type\": \"CodeableConcept\"\
	},\
	{\
		\"min\": \"1\",\
		\"path\": \"MedicationStatement.medicationReference\",\
		\"weight\": 3461,\
		\"max\": \"1\",\
		\"type\": \"Reference\"\
	},\
	{\
		\"min\": \"1\",\
		\"path\": \"MedicationStatement.patient\",\
		\"weight\": 3462,\
		\"max\": \"1\",\
		\"type\": \"Reference\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"MedicationStatement.effectiveDateTime\",\
		\"weight\": 3463,\
		\"max\": \"1\",\
		\"type\": \"dateTime\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"MedicationStatement.effectivePeriod\",\
		\"weight\": 3463,\
		\"max\": \"1\",\
		\"type\": \"Period\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"MedicationStatement.informationSource\",\
		\"weight\": 3464,\
		\"max\": \"1\",\
		\"type\": \"Reference\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"MedicationStatement.supportingInformation\",\
		\"weight\": 3465,\
		\"max\": \"*\",\
		\"type\": \"Reference\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"MedicationStatement.dateAsserted\",\
		\"weight\": 3466,\
		\"max\": \"1\",\
		\"type\": \"dateTime\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"MedicationStatement.wasNotTaken\",\
		\"weight\": 3467,\
		\"max\": \"1\",\
		\"type\": \"boolean\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"MedicationStatement.reasonNotTaken\",\
		\"weight\": 3468,\
		\"max\": \"*\",\
		\"type\": \"CodeableConcept\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"MedicationStatement.reasonForUseCodeableConcept\",\
		\"weight\": 3469,\
		\"max\": \"1\",\
		\"type\": \"CodeableConcept\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"MedicationStatement.reasonForUseReference\",\
		\"weight\": 3469,\
		\"max\": \"1\",\
		\"type\": \"Reference\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"MedicationStatement.note\",\
		\"weight\": 3470,\
		\"max\": \"*\",\
		\"type\": \"Annotation\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"MedicationStatement.dosage\",\
		\"weight\": 3471,\
		\"max\": \"*\",\
		\"type\": \"BackboneElement\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"MedicationStatement.dosage.id\",\
		\"weight\": 3472,\
		\"max\": \"1\",\
		\"type\": \"id\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"MedicationStatement.dosage.extension\",\
		\"weight\": 3473,\
		\"max\": \"*\",\
		\"type\": \"Extension\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"MedicationStatement.dosage.modifierExtension\",\
		\"weight\": 3474,\
		\"max\": \"*\",\
		\"type\": \"Extension\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"MedicationStatement.dosage.text\",\
		\"weight\": 3475,\
		\"max\": \"1\",\
		\"type\": \"string\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"MedicationStatement.dosage.timing\",\
		\"weight\": 3476,\
		\"max\": \"1\",\
		\"type\": \"Timing\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"MedicationStatement.dosage.asNeededBoolean\",\
		\"weight\": 3477,\
		\"max\": \"1\",\
		\"type\": \"boolean\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"MedicationStatement.dosage.asNeededCodeableConcept\",\
		\"weight\": 3477,\
		\"max\": \"1\",\
		\"type\": \"CodeableConcept\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"MedicationStatement.dosage.siteCodeableConcept\",\
		\"weight\": 3478,\
		\"max\": \"1\",\
		\"type\": \"CodeableConcept\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"MedicationStatement.dosage.siteReference\",\
		\"weight\": 3478,\
		\"max\": \"1\",\
		\"type\": \"Reference\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"MedicationStatement.dosage.route\",\
		\"weight\": 3479,\
		\"max\": \"1\",\
		\"type\": \"CodeableConcept\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"MedicationStatement.dosage.method\",\
		\"weight\": 3480,\
		\"max\": \"1\",\
		\"type\": \"CodeableConcept\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"MedicationStatement.dosage.quantityQuantity\",\
		\"weight\": 3481,\
		\"max\": \"1\",\
		\"type\": \"Quantity\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"MedicationStatement.dosage.quantityRange\",\
		\"weight\": 3481,\
		\"max\": \"1\",\
		\"type\": \"Range\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"MedicationStatement.dosage.rateRatio\",\
		\"weight\": 3482,\
		\"max\": \"1\",\
		\"type\": \"Ratio\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"MedicationStatement.dosage.rateRange\",\
		\"weight\": 3482,\
		\"max\": \"1\",\
		\"type\": \"Range\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"MedicationStatement.dosage.maxDosePerPeriod\",\
		\"weight\": 3483,\
		\"max\": \"1\",\
		\"type\": \"Ratio\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"MessageHeader\",\
		\"weight\": 3484,\
		\"max\": \"*\",\
		\"type\": \"DomainResource\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"MessageHeader.id\",\
		\"weight\": 3485,\
		\"max\": \"1\",\
		\"type\": \"id\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"MessageHeader.meta\",\
		\"weight\": 3486,\
		\"max\": \"1\",\
		\"type\": \"Meta\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"MessageHeader.implicitRules\",\
		\"weight\": 3487,\
		\"max\": \"1\",\
		\"type\": \"uri\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"MessageHeader.language\",\
		\"weight\": 3488,\
		\"max\": \"1\",\
		\"type\": \"code\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"MessageHeader.text\",\
		\"weight\": 3489,\
		\"max\": \"1\",\
		\"type\": \"Narrative\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"MessageHeader.contained\",\
		\"weight\": 3490,\
		\"max\": \"*\",\
		\"type\": \"Resource\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"MessageHeader.extension\",\
		\"weight\": 3491,\
		\"max\": \"*\",\
		\"type\": \"Extension\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"MessageHeader.modifierExtension\",\
		\"weight\": 3492,\
		\"max\": \"*\",\
		\"type\": \"Extension\"\
	},\
	{\
		\"min\": \"1\",\
		\"path\": \"MessageHeader.timestamp\",\
		\"weight\": 3493,\
		\"max\": \"1\",\
		\"type\": \"instant\"\
	},\
	{\
		\"min\": \"1\",\
		\"path\": \"MessageHeader.event\",\
		\"weight\": 3494,\
		\"max\": \"1\",\
		\"type\": \"Coding\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"MessageHeader.response\",\
		\"weight\": 3495,\
		\"max\": \"1\",\
		\"type\": \"BackboneElement\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"MessageHeader.response.id\",\
		\"weight\": 3496,\
		\"max\": \"1\",\
		\"type\": \"id\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"MessageHeader.response.extension\",\
		\"weight\": 3497,\
		\"max\": \"*\",\
		\"type\": \"Extension\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"MessageHeader.response.modifierExtension\",\
		\"weight\": 3498,\
		\"max\": \"*\",\
		\"type\": \"Extension\"\
	},\
	{\
		\"min\": \"1\",\
		\"path\": \"MessageHeader.response.identifier\",\
		\"weight\": 3499,\
		\"max\": \"1\",\
		\"type\": \"id\"\
	},\
	{\
		\"min\": \"1\",\
		\"path\": \"MessageHeader.response.code\",\
		\"weight\": 3500,\
		\"max\": \"1\",\
		\"type\": \"code\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"MessageHeader.response.details\",\
		\"weight\": 3501,\
		\"max\": \"1\",\
		\"type\": \"Reference\"\
	},\
	{\
		\"min\": \"1\",\
		\"path\": \"MessageHeader.source\",\
		\"weight\": 3502,\
		\"max\": \"1\",\
		\"type\": \"BackboneElement\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"MessageHeader.source.id\",\
		\"weight\": 3503,\
		\"max\": \"1\",\
		\"type\": \"id\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"MessageHeader.source.extension\",\
		\"weight\": 3504,\
		\"max\": \"*\",\
		\"type\": \"Extension\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"MessageHeader.source.modifierExtension\",\
		\"weight\": 3505,\
		\"max\": \"*\",\
		\"type\": \"Extension\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"MessageHeader.source.name\",\
		\"weight\": 3506,\
		\"max\": \"1\",\
		\"type\": \"string\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"MessageHeader.source.software\",\
		\"weight\": 3507,\
		\"max\": \"1\",\
		\"type\": \"string\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"MessageHeader.source.version\",\
		\"weight\": 3508,\
		\"max\": \"1\",\
		\"type\": \"string\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"MessageHeader.source.contact\",\
		\"weight\": 3509,\
		\"max\": \"1\",\
		\"type\": \"ContactPoint\"\
	},\
	{\
		\"min\": \"1\",\
		\"path\": \"MessageHeader.source.endpoint\",\
		\"weight\": 3510,\
		\"max\": \"1\",\
		\"type\": \"uri\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"MessageHeader.destination\",\
		\"weight\": 3511,\
		\"max\": \"*\",\
		\"type\": \"BackboneElement\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"MessageHeader.destination.id\",\
		\"weight\": 3512,\
		\"max\": \"1\",\
		\"type\": \"id\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"MessageHeader.destination.extension\",\
		\"weight\": 3513,\
		\"max\": \"*\",\
		\"type\": \"Extension\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"MessageHeader.destination.modifierExtension\",\
		\"weight\": 3514,\
		\"max\": \"*\",\
		\"type\": \"Extension\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"MessageHeader.destination.name\",\
		\"weight\": 3515,\
		\"max\": \"1\",\
		\"type\": \"string\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"MessageHeader.destination.target\",\
		\"weight\": 3516,\
		\"max\": \"1\",\
		\"type\": \"Reference\"\
	},\
	{\
		\"min\": \"1\",\
		\"path\": \"MessageHeader.destination.endpoint\",\
		\"weight\": 3517,\
		\"max\": \"1\",\
		\"type\": \"uri\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"MessageHeader.enterer\",\
		\"weight\": 3518,\
		\"max\": \"1\",\
		\"type\": \"Reference\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"MessageHeader.author\",\
		\"weight\": 3519,\
		\"max\": \"1\",\
		\"type\": \"Reference\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"MessageHeader.receiver\",\
		\"weight\": 3520,\
		\"max\": \"1\",\
		\"type\": \"Reference\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"MessageHeader.responsible\",\
		\"weight\": 3521,\
		\"max\": \"1\",\
		\"type\": \"Reference\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"MessageHeader.reason\",\
		\"weight\": 3522,\
		\"max\": \"1\",\
		\"type\": \"CodeableConcept\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"MessageHeader.data\",\
		\"weight\": 3523,\
		\"max\": \"*\",\
		\"type\": \"Reference\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"ModuleDefinition\",\
		\"weight\": 3524,\
		\"max\": \"*\",\
		\"type\": \"DomainResource\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"ModuleDefinition.id\",\
		\"weight\": 3525,\
		\"max\": \"1\",\
		\"type\": \"id\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"ModuleDefinition.meta\",\
		\"weight\": 3526,\
		\"max\": \"1\",\
		\"type\": \"Meta\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"ModuleDefinition.implicitRules\",\
		\"weight\": 3527,\
		\"max\": \"1\",\
		\"type\": \"uri\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"ModuleDefinition.language\",\
		\"weight\": 3528,\
		\"max\": \"1\",\
		\"type\": \"code\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"ModuleDefinition.text\",\
		\"weight\": 3529,\
		\"max\": \"1\",\
		\"type\": \"Narrative\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"ModuleDefinition.contained\",\
		\"weight\": 3530,\
		\"max\": \"*\",\
		\"type\": \"Resource\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"ModuleDefinition.extension\",\
		\"weight\": 3531,\
		\"max\": \"*\",\
		\"type\": \"Extension\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"ModuleDefinition.modifierExtension\",\
		\"weight\": 3532,\
		\"max\": \"*\",\
		\"type\": \"Extension\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"ModuleDefinition.identifier\",\
		\"weight\": 3533,\
		\"max\": \"*\",\
		\"type\": \"Identifier\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"ModuleDefinition.version\",\
		\"weight\": 3534,\
		\"max\": \"1\",\
		\"type\": \"string\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"ModuleDefinition.model\",\
		\"weight\": 3535,\
		\"max\": \"*\",\
		\"type\": \"BackboneElement\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"ModuleDefinition.model.id\",\
		\"weight\": 3536,\
		\"max\": \"1\",\
		\"type\": \"id\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"ModuleDefinition.model.extension\",\
		\"weight\": 3537,\
		\"max\": \"*\",\
		\"type\": \"Extension\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"ModuleDefinition.model.modifierExtension\",\
		\"weight\": 3538,\
		\"max\": \"*\",\
		\"type\": \"Extension\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"ModuleDefinition.model.name\",\
		\"weight\": 3539,\
		\"max\": \"1\",\
		\"type\": \"string\"\
	},\
	{\
		\"min\": \"1\",\
		\"path\": \"ModuleDefinition.model.identifier\",\
		\"weight\": 3540,\
		\"max\": \"1\",\
		\"type\": \"string\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"ModuleDefinition.model.version\",\
		\"weight\": 3541,\
		\"max\": \"1\",\
		\"type\": \"string\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"ModuleDefinition.library\",\
		\"weight\": 3542,\
		\"max\": \"*\",\
		\"type\": \"BackboneElement\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"ModuleDefinition.library.id\",\
		\"weight\": 3543,\
		\"max\": \"1\",\
		\"type\": \"id\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"ModuleDefinition.library.extension\",\
		\"weight\": 3544,\
		\"max\": \"*\",\
		\"type\": \"Extension\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"ModuleDefinition.library.modifierExtension\",\
		\"weight\": 3545,\
		\"max\": \"*\",\
		\"type\": \"Extension\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"ModuleDefinition.library.name\",\
		\"weight\": 3546,\
		\"max\": \"1\",\
		\"type\": \"string\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"ModuleDefinition.library.identifier\",\
		\"weight\": 3547,\
		\"max\": \"1\",\
		\"type\": \"string\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"ModuleDefinition.library.version\",\
		\"weight\": 3548,\
		\"max\": \"1\",\
		\"type\": \"string\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"ModuleDefinition.library.documentAttachment\",\
		\"weight\": 3549,\
		\"max\": \"1\",\
		\"type\": \"Attachment\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"ModuleDefinition.library.documentReference\",\
		\"weight\": 3549,\
		\"max\": \"1\",\
		\"type\": \"Reference\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"ModuleDefinition.codeSystem\",\
		\"weight\": 3550,\
		\"max\": \"*\",\
		\"type\": \"BackboneElement\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"ModuleDefinition.codeSystem.id\",\
		\"weight\": 3551,\
		\"max\": \"1\",\
		\"type\": \"id\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"ModuleDefinition.codeSystem.extension\",\
		\"weight\": 3552,\
		\"max\": \"*\",\
		\"type\": \"Extension\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"ModuleDefinition.codeSystem.modifierExtension\",\
		\"weight\": 3553,\
		\"max\": \"*\",\
		\"type\": \"Extension\"\
	},\
	{\
		\"min\": \"1\",\
		\"path\": \"ModuleDefinition.codeSystem.name\",\
		\"weight\": 3554,\
		\"max\": \"1\",\
		\"type\": \"string\"\
	},\
	{\
		\"min\": \"1\",\
		\"path\": \"ModuleDefinition.codeSystem.identifier\",\
		\"weight\": 3555,\
		\"max\": \"1\",\
		\"type\": \"string\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"ModuleDefinition.codeSystem.version\",\
		\"weight\": 3556,\
		\"max\": \"1\",\
		\"type\": \"string\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"ModuleDefinition.valueSet\",\
		\"weight\": 3557,\
		\"max\": \"*\",\
		\"type\": \"BackboneElement\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"ModuleDefinition.valueSet.id\",\
		\"weight\": 3558,\
		\"max\": \"1\",\
		\"type\": \"id\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"ModuleDefinition.valueSet.extension\",\
		\"weight\": 3559,\
		\"max\": \"*\",\
		\"type\": \"Extension\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"ModuleDefinition.valueSet.modifierExtension\",\
		\"weight\": 3560,\
		\"max\": \"*\",\
		\"type\": \"Extension\"\
	},\
	{\
		\"min\": \"1\",\
		\"path\": \"ModuleDefinition.valueSet.name\",\
		\"weight\": 3561,\
		\"max\": \"1\",\
		\"type\": \"string\"\
	},\
	{\
		\"min\": \"1\",\
		\"path\": \"ModuleDefinition.valueSet.identifier\",\
		\"weight\": 3562,\
		\"max\": \"1\",\
		\"type\": \"string\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"ModuleDefinition.valueSet.version\",\
		\"weight\": 3563,\
		\"max\": \"1\",\
		\"type\": \"string\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"ModuleDefinition.valueSet.codeSystem\",\
		\"weight\": 3564,\
		\"max\": \"*\",\
		\"type\": \"string\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"ModuleDefinition.parameter\",\
		\"weight\": 3565,\
		\"max\": \"*\",\
		\"type\": \"BackboneElement\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"ModuleDefinition.parameter.id\",\
		\"weight\": 3566,\
		\"max\": \"1\",\
		\"type\": \"id\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"ModuleDefinition.parameter.extension\",\
		\"weight\": 3567,\
		\"max\": \"*\",\
		\"type\": \"Extension\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"ModuleDefinition.parameter.modifierExtension\",\
		\"weight\": 3568,\
		\"max\": \"*\",\
		\"type\": \"Extension\"\
	},\
	{\
		\"min\": \"1\",\
		\"path\": \"ModuleDefinition.parameter.name\",\
		\"weight\": 3569,\
		\"max\": \"1\",\
		\"type\": \"code\"\
	},\
	{\
		\"min\": \"1\",\
		\"path\": \"ModuleDefinition.parameter.use\",\
		\"weight\": 3570,\
		\"max\": \"1\",\
		\"type\": \"code\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"ModuleDefinition.parameter.documentation\",\
		\"weight\": 3571,\
		\"max\": \"1\",\
		\"type\": \"string\"\
	},\
	{\
		\"min\": \"1\",\
		\"path\": \"ModuleDefinition.parameter.type\",\
		\"weight\": 3572,\
		\"max\": \"1\",\
		\"type\": \"code\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"ModuleDefinition.parameter.profile\",\
		\"weight\": 3573,\
		\"max\": \"1\",\
		\"type\": \"Reference\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"ModuleDefinition.data\",\
		\"weight\": 3574,\
		\"max\": \"*\",\
		\"type\": \"BackboneElement\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"ModuleDefinition.data.id\",\
		\"weight\": 3575,\
		\"max\": \"1\",\
		\"type\": \"id\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"ModuleDefinition.data.extension\",\
		\"weight\": 3576,\
		\"max\": \"*\",\
		\"type\": \"Extension\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"ModuleDefinition.data.modifierExtension\",\
		\"weight\": 3577,\
		\"max\": \"*\",\
		\"type\": \"Extension\"\
	},\
	{\
		\"min\": \"1\",\
		\"path\": \"ModuleDefinition.data.type\",\
		\"weight\": 3578,\
		\"max\": \"1\",\
		\"type\": \"code\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"ModuleDefinition.data.profile\",\
		\"weight\": 3579,\
		\"max\": \"1\",\
		\"type\": \"Reference\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"ModuleDefinition.data.mustSupport\",\
		\"weight\": 3580,\
		\"max\": \"*\",\
		\"type\": \"string\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"ModuleDefinition.data.codeFilter\",\
		\"weight\": 3581,\
		\"max\": \"*\",\
		\"type\": \"BackboneElement\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"ModuleDefinition.data.codeFilter.id\",\
		\"weight\": 3582,\
		\"max\": \"1\",\
		\"type\": \"id\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"ModuleDefinition.data.codeFilter.extension\",\
		\"weight\": 3583,\
		\"max\": \"*\",\
		\"type\": \"Extension\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"ModuleDefinition.data.codeFilter.modifierExtension\",\
		\"weight\": 3584,\
		\"max\": \"*\",\
		\"type\": \"Extension\"\
	},\
	{\
		\"min\": \"1\",\
		\"path\": \"ModuleDefinition.data.codeFilter.path\",\
		\"weight\": 3585,\
		\"max\": \"1\",\
		\"type\": \"string\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"ModuleDefinition.data.codeFilter.valueSetString\",\
		\"weight\": 3586,\
		\"max\": \"1\",\
		\"type\": \"string\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"ModuleDefinition.data.codeFilter.valueSetReference\",\
		\"weight\": 3586,\
		\"max\": \"1\",\
		\"type\": \"Reference\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"ModuleDefinition.data.codeFilter.codeableConcept\",\
		\"weight\": 3587,\
		\"max\": \"*\",\
		\"type\": \"CodeableConcept\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"ModuleDefinition.data.dateFilter\",\
		\"weight\": 3588,\
		\"max\": \"*\",\
		\"type\": \"BackboneElement\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"ModuleDefinition.data.dateFilter.id\",\
		\"weight\": 3589,\
		\"max\": \"1\",\
		\"type\": \"id\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"ModuleDefinition.data.dateFilter.extension\",\
		\"weight\": 3590,\
		\"max\": \"*\",\
		\"type\": \"Extension\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"ModuleDefinition.data.dateFilter.modifierExtension\",\
		\"weight\": 3591,\
		\"max\": \"*\",\
		\"type\": \"Extension\"\
	},\
	{\
		\"min\": \"1\",\
		\"path\": \"ModuleDefinition.data.dateFilter.path\",\
		\"weight\": 3592,\
		\"max\": \"1\",\
		\"type\": \"string\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"ModuleDefinition.data.dateFilter.valueDateTime\",\
		\"weight\": 3593,\
		\"max\": \"1\",\
		\"type\": \"dateTime\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"ModuleDefinition.data.dateFilter.valuePeriod\",\
		\"weight\": 3593,\
		\"max\": \"1\",\
		\"type\": \"Period\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"NamingSystem\",\
		\"weight\": 3594,\
		\"max\": \"*\",\
		\"type\": \"DomainResource\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"NamingSystem.id\",\
		\"weight\": 3595,\
		\"max\": \"1\",\
		\"type\": \"id\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"NamingSystem.meta\",\
		\"weight\": 3596,\
		\"max\": \"1\",\
		\"type\": \"Meta\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"NamingSystem.implicitRules\",\
		\"weight\": 3597,\
		\"max\": \"1\",\
		\"type\": \"uri\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"NamingSystem.language\",\
		\"weight\": 3598,\
		\"max\": \"1\",\
		\"type\": \"code\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"NamingSystem.text\",\
		\"weight\": 3599,\
		\"max\": \"1\",\
		\"type\": \"Narrative\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"NamingSystem.contained\",\
		\"weight\": 3600,\
		\"max\": \"*\",\
		\"type\": \"Resource\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"NamingSystem.extension\",\
		\"weight\": 3601,\
		\"max\": \"*\",\
		\"type\": \"Extension\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"NamingSystem.modifierExtension\",\
		\"weight\": 3602,\
		\"max\": \"*\",\
		\"type\": \"Extension\"\
	},\
	{\
		\"min\": \"1\",\
		\"path\": \"NamingSystem.name\",\
		\"weight\": 3603,\
		\"max\": \"1\",\
		\"type\": \"string\"\
	},\
	{\
		\"min\": \"1\",\
		\"path\": \"NamingSystem.status\",\
		\"weight\": 3604,\
		\"max\": \"1\",\
		\"type\": \"code\"\
	},\
	{\
		\"min\": \"1\",\
		\"path\": \"NamingSystem.kind\",\
		\"weight\": 3605,\
		\"max\": \"1\",\
		\"type\": \"code\"\
	},\
	{\
		\"min\": \"1\",\
		\"path\": \"NamingSystem.date\",\
		\"weight\": 3606,\
		\"max\": \"1\",\
		\"type\": \"dateTime\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"NamingSystem.publisher\",\
		\"weight\": 3607,\
		\"max\": \"1\",\
		\"type\": \"string\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"NamingSystem.contact\",\
		\"weight\": 3608,\
		\"max\": \"*\",\
		\"type\": \"BackboneElement\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"NamingSystem.contact.id\",\
		\"weight\": 3609,\
		\"max\": \"1\",\
		\"type\": \"id\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"NamingSystem.contact.extension\",\
		\"weight\": 3610,\
		\"max\": \"*\",\
		\"type\": \"Extension\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"NamingSystem.contact.modifierExtension\",\
		\"weight\": 3611,\
		\"max\": \"*\",\
		\"type\": \"Extension\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"NamingSystem.contact.name\",\
		\"weight\": 3612,\
		\"max\": \"1\",\
		\"type\": \"string\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"NamingSystem.contact.telecom\",\
		\"weight\": 3613,\
		\"max\": \"*\",\
		\"type\": \"ContactPoint\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"NamingSystem.responsible\",\
		\"weight\": 3614,\
		\"max\": \"1\",\
		\"type\": \"string\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"NamingSystem.type\",\
		\"weight\": 3615,\
		\"max\": \"1\",\
		\"type\": \"CodeableConcept\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"NamingSystem.description\",\
		\"weight\": 3616,\
		\"max\": \"1\",\
		\"type\": \"string\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"NamingSystem.useContext\",\
		\"weight\": 3617,\
		\"max\": \"*\",\
		\"type\": \"CodeableConcept\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"NamingSystem.usage\",\
		\"weight\": 3618,\
		\"max\": \"1\",\
		\"type\": \"string\"\
	},\
	{\
		\"min\": \"1\",\
		\"path\": \"NamingSystem.uniqueId\",\
		\"weight\": 3619,\
		\"max\": \"*\",\
		\"type\": \"BackboneElement\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"NamingSystem.uniqueId.id\",\
		\"weight\": 3620,\
		\"max\": \"1\",\
		\"type\": \"id\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"NamingSystem.uniqueId.extension\",\
		\"weight\": 3621,\
		\"max\": \"*\",\
		\"type\": \"Extension\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"NamingSystem.uniqueId.modifierExtension\",\
		\"weight\": 3622,\
		\"max\": \"*\",\
		\"type\": \"Extension\"\
	},\
	{\
		\"min\": \"1\",\
		\"path\": \"NamingSystem.uniqueId.type\",\
		\"weight\": 3623,\
		\"max\": \"1\",\
		\"type\": \"code\"\
	},\
	{\
		\"min\": \"1\",\
		\"path\": \"NamingSystem.uniqueId.value\",\
		\"weight\": 3624,\
		\"max\": \"1\",\
		\"type\": \"string\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"NamingSystem.uniqueId.preferred\",\
		\"weight\": 3625,\
		\"max\": \"1\",\
		\"type\": \"boolean\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"NamingSystem.uniqueId.period\",\
		\"weight\": 3626,\
		\"max\": \"1\",\
		\"type\": \"Period\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"NamingSystem.replacedBy\",\
		\"weight\": 3627,\
		\"max\": \"1\",\
		\"type\": \"Reference\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"NutritionOrder\",\
		\"weight\": 3628,\
		\"max\": \"*\",\
		\"type\": \"DomainResource\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"NutritionOrder.id\",\
		\"weight\": 3629,\
		\"max\": \"1\",\
		\"type\": \"id\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"NutritionOrder.meta\",\
		\"weight\": 3630,\
		\"max\": \"1\",\
		\"type\": \"Meta\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"NutritionOrder.implicitRules\",\
		\"weight\": 3631,\
		\"max\": \"1\",\
		\"type\": \"uri\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"NutritionOrder.language\",\
		\"weight\": 3632,\
		\"max\": \"1\",\
		\"type\": \"code\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"NutritionOrder.text\",\
		\"weight\": 3633,\
		\"max\": \"1\",\
		\"type\": \"Narrative\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"NutritionOrder.contained\",\
		\"weight\": 3634,\
		\"max\": \"*\",\
		\"type\": \"Resource\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"NutritionOrder.extension\",\
		\"weight\": 3635,\
		\"max\": \"*\",\
		\"type\": \"Extension\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"NutritionOrder.modifierExtension\",\
		\"weight\": 3636,\
		\"max\": \"*\",\
		\"type\": \"Extension\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"NutritionOrder.identifier\",\
		\"weight\": 3637,\
		\"max\": \"*\",\
		\"type\": \"Identifier\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"NutritionOrder.status\",\
		\"weight\": 3638,\
		\"max\": \"1\",\
		\"type\": \"code\"\
	},\
	{\
		\"min\": \"1\",\
		\"path\": \"NutritionOrder.patient\",\
		\"weight\": 3639,\
		\"max\": \"1\",\
		\"type\": \"Reference\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"NutritionOrder.encounter\",\
		\"weight\": 3640,\
		\"max\": \"1\",\
		\"type\": \"Reference\"\
	},\
	{\
		\"min\": \"1\",\
		\"path\": \"NutritionOrder.dateTime\",\
		\"weight\": 3641,\
		\"max\": \"1\",\
		\"type\": \"dateTime\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"NutritionOrder.orderer\",\
		\"weight\": 3642,\
		\"max\": \"1\",\
		\"type\": \"Reference\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"NutritionOrder.allergyIntolerance\",\
		\"weight\": 3643,\
		\"max\": \"*\",\
		\"type\": \"Reference\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"NutritionOrder.foodPreferenceModifier\",\
		\"weight\": 3644,\
		\"max\": \"*\",\
		\"type\": \"CodeableConcept\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"NutritionOrder.excludeFoodModifier\",\
		\"weight\": 3645,\
		\"max\": \"*\",\
		\"type\": \"CodeableConcept\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"NutritionOrder.oralDiet\",\
		\"weight\": 3646,\
		\"max\": \"1\",\
		\"type\": \"BackboneElement\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"NutritionOrder.oralDiet.id\",\
		\"weight\": 3647,\
		\"max\": \"1\",\
		\"type\": \"id\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"NutritionOrder.oralDiet.extension\",\
		\"weight\": 3648,\
		\"max\": \"*\",\
		\"type\": \"Extension\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"NutritionOrder.oralDiet.modifierExtension\",\
		\"weight\": 3649,\
		\"max\": \"*\",\
		\"type\": \"Extension\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"NutritionOrder.oralDiet.type\",\
		\"weight\": 3650,\
		\"max\": \"*\",\
		\"type\": \"CodeableConcept\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"NutritionOrder.oralDiet.schedule\",\
		\"weight\": 3651,\
		\"max\": \"*\",\
		\"type\": \"Timing\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"NutritionOrder.oralDiet.nutrient\",\
		\"weight\": 3652,\
		\"max\": \"*\",\
		\"type\": \"BackboneElement\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"NutritionOrder.oralDiet.nutrient.id\",\
		\"weight\": 3653,\
		\"max\": \"1\",\
		\"type\": \"id\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"NutritionOrder.oralDiet.nutrient.extension\",\
		\"weight\": 3654,\
		\"max\": \"*\",\
		\"type\": \"Extension\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"NutritionOrder.oralDiet.nutrient.modifierExtension\",\
		\"weight\": 3655,\
		\"max\": \"*\",\
		\"type\": \"Extension\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"NutritionOrder.oralDiet.nutrient.modifier\",\
		\"weight\": 3656,\
		\"max\": \"1\",\
		\"type\": \"CodeableConcept\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"NutritionOrder.oralDiet.nutrient.amount\",\
		\"weight\": 3657,\
		\"max\": \"1\",\
		\"type\": \"Quantity\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"NutritionOrder.oralDiet.texture\",\
		\"weight\": 3658,\
		\"max\": \"*\",\
		\"type\": \"BackboneElement\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"NutritionOrder.oralDiet.texture.id\",\
		\"weight\": 3659,\
		\"max\": \"1\",\
		\"type\": \"id\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"NutritionOrder.oralDiet.texture.extension\",\
		\"weight\": 3660,\
		\"max\": \"*\",\
		\"type\": \"Extension\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"NutritionOrder.oralDiet.texture.modifierExtension\",\
		\"weight\": 3661,\
		\"max\": \"*\",\
		\"type\": \"Extension\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"NutritionOrder.oralDiet.texture.modifier\",\
		\"weight\": 3662,\
		\"max\": \"1\",\
		\"type\": \"CodeableConcept\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"NutritionOrder.oralDiet.texture.foodType\",\
		\"weight\": 3663,\
		\"max\": \"1\",\
		\"type\": \"CodeableConcept\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"NutritionOrder.oralDiet.fluidConsistencyType\",\
		\"weight\": 3664,\
		\"max\": \"*\",\
		\"type\": \"CodeableConcept\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"NutritionOrder.oralDiet.instruction\",\
		\"weight\": 3665,\
		\"max\": \"1\",\
		\"type\": \"string\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"NutritionOrder.supplement\",\
		\"weight\": 3666,\
		\"max\": \"*\",\
		\"type\": \"BackboneElement\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"NutritionOrder.supplement.id\",\
		\"weight\": 3667,\
		\"max\": \"1\",\
		\"type\": \"id\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"NutritionOrder.supplement.extension\",\
		\"weight\": 3668,\
		\"max\": \"*\",\
		\"type\": \"Extension\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"NutritionOrder.supplement.modifierExtension\",\
		\"weight\": 3669,\
		\"max\": \"*\",\
		\"type\": \"Extension\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"NutritionOrder.supplement.type\",\
		\"weight\": 3670,\
		\"max\": \"1\",\
		\"type\": \"CodeableConcept\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"NutritionOrder.supplement.productName\",\
		\"weight\": 3671,\
		\"max\": \"1\",\
		\"type\": \"string\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"NutritionOrder.supplement.schedule\",\
		\"weight\": 3672,\
		\"max\": \"*\",\
		\"type\": \"Timing\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"NutritionOrder.supplement.quantity\",\
		\"weight\": 3673,\
		\"max\": \"1\",\
		\"type\": \"Quantity\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"NutritionOrder.supplement.instruction\",\
		\"weight\": 3674,\
		\"max\": \"1\",\
		\"type\": \"string\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"NutritionOrder.enteralFormula\",\
		\"weight\": 3675,\
		\"max\": \"1\",\
		\"type\": \"BackboneElement\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"NutritionOrder.enteralFormula.id\",\
		\"weight\": 3676,\
		\"max\": \"1\",\
		\"type\": \"id\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"NutritionOrder.enteralFormula.extension\",\
		\"weight\": 3677,\
		\"max\": \"*\",\
		\"type\": \"Extension\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"NutritionOrder.enteralFormula.modifierExtension\",\
		\"weight\": 3678,\
		\"max\": \"*\",\
		\"type\": \"Extension\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"NutritionOrder.enteralFormula.baseFormulaType\",\
		\"weight\": 3679,\
		\"max\": \"1\",\
		\"type\": \"CodeableConcept\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"NutritionOrder.enteralFormula.baseFormulaProductName\",\
		\"weight\": 3680,\
		\"max\": \"1\",\
		\"type\": \"string\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"NutritionOrder.enteralFormula.additiveType\",\
		\"weight\": 3681,\
		\"max\": \"1\",\
		\"type\": \"CodeableConcept\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"NutritionOrder.enteralFormula.additiveProductName\",\
		\"weight\": 3682,\
		\"max\": \"1\",\
		\"type\": \"string\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"NutritionOrder.enteralFormula.caloricDensity\",\
		\"weight\": 3683,\
		\"max\": \"1\",\
		\"type\": \"Quantity\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"NutritionOrder.enteralFormula.routeofAdministration\",\
		\"weight\": 3684,\
		\"max\": \"1\",\
		\"type\": \"CodeableConcept\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"NutritionOrder.enteralFormula.administration\",\
		\"weight\": 3685,\
		\"max\": \"*\",\
		\"type\": \"BackboneElement\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"NutritionOrder.enteralFormula.administration.id\",\
		\"weight\": 3686,\
		\"max\": \"1\",\
		\"type\": \"id\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"NutritionOrder.enteralFormula.administration.extension\",\
		\"weight\": 3687,\
		\"max\": \"*\",\
		\"type\": \"Extension\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"NutritionOrder.enteralFormula.administration.modifierExtension\",\
		\"weight\": 3688,\
		\"max\": \"*\",\
		\"type\": \"Extension\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"NutritionOrder.enteralFormula.administration.schedule\",\
		\"weight\": 3689,\
		\"max\": \"1\",\
		\"type\": \"Timing\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"NutritionOrder.enteralFormula.administration.quantity\",\
		\"weight\": 3690,\
		\"max\": \"1\",\
		\"type\": \"Quantity\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"NutritionOrder.enteralFormula.administration.rateQuantity\",\
		\"weight\": 3691,\
		\"max\": \"1\",\
		\"type\": \"Quantity\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"NutritionOrder.enteralFormula.administration.rateRatio\",\
		\"weight\": 3691,\
		\"max\": \"1\",\
		\"type\": \"Ratio\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"NutritionOrder.enteralFormula.maxVolumeToDeliver\",\
		\"weight\": 3692,\
		\"max\": \"1\",\
		\"type\": \"Quantity\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"NutritionOrder.enteralFormula.administrationInstruction\",\
		\"weight\": 3693,\
		\"max\": \"1\",\
		\"type\": \"string\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Observation\",\
		\"weight\": 3694,\
		\"max\": \"*\",\
		\"type\": \"DomainResource\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Observation.id\",\
		\"weight\": 3695,\
		\"max\": \"1\",\
		\"type\": \"id\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Observation.meta\",\
		\"weight\": 3696,\
		\"max\": \"1\",\
		\"type\": \"Meta\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Observation.implicitRules\",\
		\"weight\": 3697,\
		\"max\": \"1\",\
		\"type\": \"uri\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Observation.language\",\
		\"weight\": 3698,\
		\"max\": \"1\",\
		\"type\": \"code\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Observation.text\",\
		\"weight\": 3699,\
		\"max\": \"1\",\
		\"type\": \"Narrative\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Observation.contained\",\
		\"weight\": 3700,\
		\"max\": \"*\",\
		\"type\": \"Resource\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Observation.extension\",\
		\"weight\": 3701,\
		\"max\": \"*\",\
		\"type\": \"Extension\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Observation.modifierExtension\",\
		\"weight\": 3702,\
		\"max\": \"*\",\
		\"type\": \"Extension\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Observation.identifier\",\
		\"weight\": 3703,\
		\"max\": \"*\",\
		\"type\": \"Identifier\"\
	},\
	{\
		\"min\": \"1\",\
		\"path\": \"Observation.status\",\
		\"weight\": 3704,\
		\"max\": \"1\",\
		\"type\": \"code\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Observation.category\",\
		\"weight\": 3705,\
		\"max\": \"1\",\
		\"type\": \"CodeableConcept\"\
	},\
	{\
		\"min\": \"1\",\
		\"path\": \"Observation.code\",\
		\"weight\": 3706,\
		\"max\": \"1\",\
		\"type\": \"CodeableConcept\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Observation.subject\",\
		\"weight\": 3707,\
		\"max\": \"1\",\
		\"type\": \"Reference\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Observation.encounter\",\
		\"weight\": 3708,\
		\"max\": \"1\",\
		\"type\": \"Reference\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Observation.effectiveDateTime\",\
		\"weight\": 3709,\
		\"max\": \"1\",\
		\"type\": \"dateTime\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Observation.effectivePeriod\",\
		\"weight\": 3709,\
		\"max\": \"1\",\
		\"type\": \"Period\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Observation.issued\",\
		\"weight\": 3710,\
		\"max\": \"1\",\
		\"type\": \"instant\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Observation.performer\",\
		\"weight\": 3711,\
		\"max\": \"*\",\
		\"type\": \"Reference\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Observation.valueQuantity\",\
		\"weight\": 3712,\
		\"max\": \"1\",\
		\"type\": \"Quantity\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Observation.valueCodeableConcept\",\
		\"weight\": 3712,\
		\"max\": \"1\",\
		\"type\": \"CodeableConcept\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Observation.valueString\",\
		\"weight\": 3712,\
		\"max\": \"1\",\
		\"type\": \"string\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Observation.valueRange\",\
		\"weight\": 3712,\
		\"max\": \"1\",\
		\"type\": \"Range\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Observation.valueRatio\",\
		\"weight\": 3712,\
		\"max\": \"1\",\
		\"type\": \"Ratio\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Observation.valueSampledData\",\
		\"weight\": 3712,\
		\"max\": \"1\",\
		\"type\": \"SampledData\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Observation.valueAttachment\",\
		\"weight\": 3712,\
		\"max\": \"1\",\
		\"type\": \"Attachment\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Observation.valueTime\",\
		\"weight\": 3712,\
		\"max\": \"1\",\
		\"type\": \"time\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Observation.valueDateTime\",\
		\"weight\": 3712,\
		\"max\": \"1\",\
		\"type\": \"dateTime\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Observation.valuePeriod\",\
		\"weight\": 3712,\
		\"max\": \"1\",\
		\"type\": \"Period\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Observation.dataAbsentReason\",\
		\"weight\": 3713,\
		\"max\": \"1\",\
		\"type\": \"CodeableConcept\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Observation.interpretation\",\
		\"weight\": 3714,\
		\"max\": \"1\",\
		\"type\": \"CodeableConcept\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Observation.comment\",\
		\"weight\": 3715,\
		\"max\": \"1\",\
		\"type\": \"string\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Observation.bodySite\",\
		\"weight\": 3716,\
		\"max\": \"1\",\
		\"type\": \"CodeableConcept\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Observation.method\",\
		\"weight\": 3717,\
		\"max\": \"1\",\
		\"type\": \"CodeableConcept\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Observation.specimen\",\
		\"weight\": 3718,\
		\"max\": \"1\",\
		\"type\": \"Reference\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Observation.device\",\
		\"weight\": 3719,\
		\"max\": \"1\",\
		\"type\": \"Reference\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Observation.referenceRange\",\
		\"weight\": 3720,\
		\"max\": \"*\",\
		\"type\": \"BackboneElement\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Observation.referenceRange.id\",\
		\"weight\": 3721,\
		\"max\": \"1\",\
		\"type\": \"id\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Observation.referenceRange.extension\",\
		\"weight\": 3722,\
		\"max\": \"*\",\
		\"type\": \"Extension\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Observation.referenceRange.modifierExtension\",\
		\"weight\": 3723,\
		\"max\": \"*\",\
		\"type\": \"Extension\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Observation.referenceRange.low\",\
		\"weight\": 3724,\
		\"max\": \"1\",\
		\"type\": \"Quantity\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Observation.referenceRange.high\",\
		\"weight\": 3725,\
		\"max\": \"1\",\
		\"type\": \"Quantity\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Observation.referenceRange.meaning\",\
		\"weight\": 3726,\
		\"max\": \"1\",\
		\"type\": \"CodeableConcept\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Observation.referenceRange.age\",\
		\"weight\": 3727,\
		\"max\": \"1\",\
		\"type\": \"Range\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Observation.referenceRange.text\",\
		\"weight\": 3728,\
		\"max\": \"1\",\
		\"type\": \"string\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Observation.related\",\
		\"weight\": 3729,\
		\"max\": \"*\",\
		\"type\": \"BackboneElement\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Observation.related.id\",\
		\"weight\": 3730,\
		\"max\": \"1\",\
		\"type\": \"id\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Observation.related.extension\",\
		\"weight\": 3731,\
		\"max\": \"*\",\
		\"type\": \"Extension\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Observation.related.modifierExtension\",\
		\"weight\": 3732,\
		\"max\": \"*\",\
		\"type\": \"Extension\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Observation.related.type\",\
		\"weight\": 3733,\
		\"max\": \"1\",\
		\"type\": \"code\"\
	},\
	{\
		\"min\": \"1\",\
		\"path\": \"Observation.related.target\",\
		\"weight\": 3734,\
		\"max\": \"1\",\
		\"type\": \"Reference\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Observation.component\",\
		\"weight\": 3735,\
		\"max\": \"*\",\
		\"type\": \"BackboneElement\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Observation.component.id\",\
		\"weight\": 3736,\
		\"max\": \"1\",\
		\"type\": \"id\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Observation.component.extension\",\
		\"weight\": 3737,\
		\"max\": \"*\",\
		\"type\": \"Extension\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Observation.component.modifierExtension\",\
		\"weight\": 3738,\
		\"max\": \"*\",\
		\"type\": \"Extension\"\
	},\
	{\
		\"min\": \"1\",\
		\"path\": \"Observation.component.code\",\
		\"weight\": 3739,\
		\"max\": \"1\",\
		\"type\": \"CodeableConcept\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Observation.component.valueQuantity\",\
		\"weight\": 3740,\
		\"max\": \"1\",\
		\"type\": \"Quantity\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Observation.component.valueCodeableConcept\",\
		\"weight\": 3740,\
		\"max\": \"1\",\
		\"type\": \"CodeableConcept\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Observation.component.valueString\",\
		\"weight\": 3740,\
		\"max\": \"1\",\
		\"type\": \"string\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Observation.component.valueRange\",\
		\"weight\": 3740,\
		\"max\": \"1\",\
		\"type\": \"Range\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Observation.component.valueRatio\",\
		\"weight\": 3740,\
		\"max\": \"1\",\
		\"type\": \"Ratio\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Observation.component.valueSampledData\",\
		\"weight\": 3740,\
		\"max\": \"1\",\
		\"type\": \"SampledData\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Observation.component.valueAttachment\",\
		\"weight\": 3740,\
		\"max\": \"1\",\
		\"type\": \"Attachment\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Observation.component.valueTime\",\
		\"weight\": 3740,\
		\"max\": \"1\",\
		\"type\": \"time\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Observation.component.valueDateTime\",\
		\"weight\": 3740,\
		\"max\": \"1\",\
		\"type\": \"dateTime\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Observation.component.valuePeriod\",\
		\"weight\": 3740,\
		\"max\": \"1\",\
		\"type\": \"Period\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Observation.component.dataAbsentReason\",\
		\"weight\": 3741,\
		\"max\": \"1\",\
		\"type\": \"CodeableConcept\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Observation.component.referenceRange\",\
		\"weight\": 3742,\
		\"max\": \"*\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"OperationDefinition\",\
		\"weight\": 3743,\
		\"max\": \"*\",\
		\"type\": \"DomainResource\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"OperationDefinition.id\",\
		\"weight\": 3744,\
		\"max\": \"1\",\
		\"type\": \"id\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"OperationDefinition.meta\",\
		\"weight\": 3745,\
		\"max\": \"1\",\
		\"type\": \"Meta\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"OperationDefinition.implicitRules\",\
		\"weight\": 3746,\
		\"max\": \"1\",\
		\"type\": \"uri\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"OperationDefinition.language\",\
		\"weight\": 3747,\
		\"max\": \"1\",\
		\"type\": \"code\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"OperationDefinition.text\",\
		\"weight\": 3748,\
		\"max\": \"1\",\
		\"type\": \"Narrative\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"OperationDefinition.contained\",\
		\"weight\": 3749,\
		\"max\": \"*\",\
		\"type\": \"Resource\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"OperationDefinition.extension\",\
		\"weight\": 3750,\
		\"max\": \"*\",\
		\"type\": \"Extension\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"OperationDefinition.modifierExtension\",\
		\"weight\": 3751,\
		\"max\": \"*\",\
		\"type\": \"Extension\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"OperationDefinition.url\",\
		\"weight\": 3752,\
		\"max\": \"1\",\
		\"type\": \"uri\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"OperationDefinition.version\",\
		\"weight\": 3753,\
		\"max\": \"1\",\
		\"type\": \"string\"\
	},\
	{\
		\"min\": \"1\",\
		\"path\": \"OperationDefinition.name\",\
		\"weight\": 3754,\
		\"max\": \"1\",\
		\"type\": \"string\"\
	},\
	{\
		\"min\": \"1\",\
		\"path\": \"OperationDefinition.status\",\
		\"weight\": 3755,\
		\"max\": \"1\",\
		\"type\": \"code\"\
	},\
	{\
		\"min\": \"1\",\
		\"path\": \"OperationDefinition.kind\",\
		\"weight\": 3756,\
		\"max\": \"1\",\
		\"type\": \"code\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"OperationDefinition.experimental\",\
		\"weight\": 3757,\
		\"max\": \"1\",\
		\"type\": \"boolean\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"OperationDefinition.date\",\
		\"weight\": 3758,\
		\"max\": \"1\",\
		\"type\": \"dateTime\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"OperationDefinition.publisher\",\
		\"weight\": 3759,\
		\"max\": \"1\",\
		\"type\": \"string\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"OperationDefinition.contact\",\
		\"weight\": 3760,\
		\"max\": \"*\",\
		\"type\": \"BackboneElement\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"OperationDefinition.contact.id\",\
		\"weight\": 3761,\
		\"max\": \"1\",\
		\"type\": \"id\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"OperationDefinition.contact.extension\",\
		\"weight\": 3762,\
		\"max\": \"*\",\
		\"type\": \"Extension\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"OperationDefinition.contact.modifierExtension\",\
		\"weight\": 3763,\
		\"max\": \"*\",\
		\"type\": \"Extension\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"OperationDefinition.contact.name\",\
		\"weight\": 3764,\
		\"max\": \"1\",\
		\"type\": \"string\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"OperationDefinition.contact.telecom\",\
		\"weight\": 3765,\
		\"max\": \"*\",\
		\"type\": \"ContactPoint\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"OperationDefinition.description\",\
		\"weight\": 3766,\
		\"max\": \"1\",\
		\"type\": \"string\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"OperationDefinition.useContext\",\
		\"weight\": 3767,\
		\"max\": \"*\",\
		\"type\": \"CodeableConcept\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"OperationDefinition.requirements\",\
		\"weight\": 3768,\
		\"max\": \"1\",\
		\"type\": \"string\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"OperationDefinition.idempotent\",\
		\"weight\": 3769,\
		\"max\": \"1\",\
		\"type\": \"boolean\"\
	},\
	{\
		\"min\": \"1\",\
		\"path\": \"OperationDefinition.code\",\
		\"weight\": 3770,\
		\"max\": \"1\",\
		\"type\": \"code\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"OperationDefinition.comment\",\
		\"weight\": 3771,\
		\"max\": \"1\",\
		\"type\": \"string\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"OperationDefinition.base\",\
		\"weight\": 3772,\
		\"max\": \"1\",\
		\"type\": \"Reference\"\
	},\
	{\
		\"min\": \"1\",\
		\"path\": \"OperationDefinition.system\",\
		\"weight\": 3773,\
		\"max\": \"1\",\
		\"type\": \"boolean\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"OperationDefinition.type\",\
		\"weight\": 3774,\
		\"max\": \"*\",\
		\"type\": \"code\"\
	},\
	{\
		\"min\": \"1\",\
		\"path\": \"OperationDefinition.instance\",\
		\"weight\": 3775,\
		\"max\": \"1\",\
		\"type\": \"boolean\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"OperationDefinition.parameter\",\
		\"weight\": 3776,\
		\"max\": \"*\",\
		\"type\": \"BackboneElement\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"OperationDefinition.parameter.id\",\
		\"weight\": 3777,\
		\"max\": \"1\",\
		\"type\": \"id\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"OperationDefinition.parameter.extension\",\
		\"weight\": 3778,\
		\"max\": \"*\",\
		\"type\": \"Extension\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"OperationDefinition.parameter.modifierExtension\",\
		\"weight\": 3779,\
		\"max\": \"*\",\
		\"type\": \"Extension\"\
	},\
	{\
		\"min\": \"1\",\
		\"path\": \"OperationDefinition.parameter.name\",\
		\"weight\": 3780,\
		\"max\": \"1\",\
		\"type\": \"code\"\
	},\
	{\
		\"min\": \"1\",\
		\"path\": \"OperationDefinition.parameter.use\",\
		\"weight\": 3781,\
		\"max\": \"1\",\
		\"type\": \"code\"\
	},\
	{\
		\"min\": \"1\",\
		\"path\": \"OperationDefinition.parameter.min\",\
		\"weight\": 3782,\
		\"max\": \"1\",\
		\"type\": \"integer\"\
	},\
	{\
		\"min\": \"1\",\
		\"path\": \"OperationDefinition.parameter.max\",\
		\"weight\": 3783,\
		\"max\": \"1\",\
		\"type\": \"string\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"OperationDefinition.parameter.documentation\",\
		\"weight\": 3784,\
		\"max\": \"1\",\
		\"type\": \"string\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"OperationDefinition.parameter.type\",\
		\"weight\": 3785,\
		\"max\": \"1\",\
		\"type\": \"code\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"OperationDefinition.parameter.searchType\",\
		\"weight\": 3786,\
		\"max\": \"1\",\
		\"type\": \"code\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"OperationDefinition.parameter.profile\",\
		\"weight\": 3787,\
		\"max\": \"1\",\
		\"type\": \"Reference\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"OperationDefinition.parameter.binding\",\
		\"weight\": 3788,\
		\"max\": \"1\",\
		\"type\": \"BackboneElement\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"OperationDefinition.parameter.binding.id\",\
		\"weight\": 3789,\
		\"max\": \"1\",\
		\"type\": \"id\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"OperationDefinition.parameter.binding.extension\",\
		\"weight\": 3790,\
		\"max\": \"*\",\
		\"type\": \"Extension\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"OperationDefinition.parameter.binding.modifierExtension\",\
		\"weight\": 3791,\
		\"max\": \"*\",\
		\"type\": \"Extension\"\
	},\
	{\
		\"min\": \"1\",\
		\"path\": \"OperationDefinition.parameter.binding.strength\",\
		\"weight\": 3792,\
		\"max\": \"1\",\
		\"type\": \"code\"\
	},\
	{\
		\"min\": \"1\",\
		\"path\": \"OperationDefinition.parameter.binding.valueSetUri\",\
		\"weight\": 3793,\
		\"max\": \"1\",\
		\"type\": \"uri\"\
	},\
	{\
		\"min\": \"1\",\
		\"path\": \"OperationDefinition.parameter.binding.valueSetReference\",\
		\"weight\": 3793,\
		\"max\": \"1\",\
		\"type\": \"Reference\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"OperationDefinition.parameter.part\",\
		\"weight\": 3794,\
		\"max\": \"*\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"OperationOutcome\",\
		\"weight\": 3795,\
		\"max\": \"*\",\
		\"type\": \"DomainResource\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"OperationOutcome.id\",\
		\"weight\": 3796,\
		\"max\": \"1\",\
		\"type\": \"id\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"OperationOutcome.meta\",\
		\"weight\": 3797,\
		\"max\": \"1\",\
		\"type\": \"Meta\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"OperationOutcome.implicitRules\",\
		\"weight\": 3798,\
		\"max\": \"1\",\
		\"type\": \"uri\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"OperationOutcome.language\",\
		\"weight\": 3799,\
		\"max\": \"1\",\
		\"type\": \"code\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"OperationOutcome.text\",\
		\"weight\": 3800,\
		\"max\": \"1\",\
		\"type\": \"Narrative\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"OperationOutcome.contained\",\
		\"weight\": 3801,\
		\"max\": \"*\",\
		\"type\": \"Resource\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"OperationOutcome.extension\",\
		\"weight\": 3802,\
		\"max\": \"*\",\
		\"type\": \"Extension\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"OperationOutcome.modifierExtension\",\
		\"weight\": 3803,\
		\"max\": \"*\",\
		\"type\": \"Extension\"\
	},\
	{\
		\"min\": \"1\",\
		\"path\": \"OperationOutcome.issue\",\
		\"weight\": 3804,\
		\"max\": \"*\",\
		\"type\": \"BackboneElement\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"OperationOutcome.issue.id\",\
		\"weight\": 3805,\
		\"max\": \"1\",\
		\"type\": \"id\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"OperationOutcome.issue.extension\",\
		\"weight\": 3806,\
		\"max\": \"*\",\
		\"type\": \"Extension\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"OperationOutcome.issue.modifierExtension\",\
		\"weight\": 3807,\
		\"max\": \"*\",\
		\"type\": \"Extension\"\
	},\
	{\
		\"min\": \"1\",\
		\"path\": \"OperationOutcome.issue.severity\",\
		\"weight\": 3808,\
		\"max\": \"1\",\
		\"type\": \"code\"\
	},\
	{\
		\"min\": \"1\",\
		\"path\": \"OperationOutcome.issue.code\",\
		\"weight\": 3809,\
		\"max\": \"1\",\
		\"type\": \"code\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"OperationOutcome.issue.details\",\
		\"weight\": 3810,\
		\"max\": \"1\",\
		\"type\": \"CodeableConcept\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"OperationOutcome.issue.diagnostics\",\
		\"weight\": 3811,\
		\"max\": \"1\",\
		\"type\": \"string\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"OperationOutcome.issue.location\",\
		\"weight\": 3812,\
		\"max\": \"*\",\
		\"type\": \"string\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"OperationOutcome.issue.expression\",\
		\"weight\": 3813,\
		\"max\": \"*\",\
		\"type\": \"string\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Order\",\
		\"weight\": 3814,\
		\"max\": \"*\",\
		\"type\": \"DomainResource\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Order.id\",\
		\"weight\": 3815,\
		\"max\": \"1\",\
		\"type\": \"id\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Order.meta\",\
		\"weight\": 3816,\
		\"max\": \"1\",\
		\"type\": \"Meta\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Order.implicitRules\",\
		\"weight\": 3817,\
		\"max\": \"1\",\
		\"type\": \"uri\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Order.language\",\
		\"weight\": 3818,\
		\"max\": \"1\",\
		\"type\": \"code\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Order.text\",\
		\"weight\": 3819,\
		\"max\": \"1\",\
		\"type\": \"Narrative\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Order.contained\",\
		\"weight\": 3820,\
		\"max\": \"*\",\
		\"type\": \"Resource\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Order.extension\",\
		\"weight\": 3821,\
		\"max\": \"*\",\
		\"type\": \"Extension\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Order.modifierExtension\",\
		\"weight\": 3822,\
		\"max\": \"*\",\
		\"type\": \"Extension\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Order.identifier\",\
		\"weight\": 3823,\
		\"max\": \"*\",\
		\"type\": \"Identifier\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Order.date\",\
		\"weight\": 3824,\
		\"max\": \"1\",\
		\"type\": \"dateTime\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Order.subject\",\
		\"weight\": 3825,\
		\"max\": \"1\",\
		\"type\": \"Reference\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Order.source\",\
		\"weight\": 3826,\
		\"max\": \"1\",\
		\"type\": \"Reference\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Order.target\",\
		\"weight\": 3827,\
		\"max\": \"1\",\
		\"type\": \"Reference\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Order.reasonCodeableConcept\",\
		\"weight\": 3828,\
		\"max\": \"1\",\
		\"type\": \"CodeableConcept\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Order.reasonReference\",\
		\"weight\": 3828,\
		\"max\": \"1\",\
		\"type\": \"Reference\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Order.when\",\
		\"weight\": 3829,\
		\"max\": \"1\",\
		\"type\": \"BackboneElement\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Order.when.id\",\
		\"weight\": 3830,\
		\"max\": \"1\",\
		\"type\": \"id\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Order.when.extension\",\
		\"weight\": 3831,\
		\"max\": \"*\",\
		\"type\": \"Extension\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Order.when.modifierExtension\",\
		\"weight\": 3832,\
		\"max\": \"*\",\
		\"type\": \"Extension\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Order.when.code\",\
		\"weight\": 3833,\
		\"max\": \"1\",\
		\"type\": \"CodeableConcept\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Order.when.schedule\",\
		\"weight\": 3834,\
		\"max\": \"1\",\
		\"type\": \"Timing\"\
	},\
	{\
		\"min\": \"1\",\
		\"path\": \"Order.detail\",\
		\"weight\": 3835,\
		\"max\": \"*\",\
		\"type\": \"Reference\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"OrderResponse\",\
		\"weight\": 3836,\
		\"max\": \"*\",\
		\"type\": \"DomainResource\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"OrderResponse.id\",\
		\"weight\": 3837,\
		\"max\": \"1\",\
		\"type\": \"id\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"OrderResponse.meta\",\
		\"weight\": 3838,\
		\"max\": \"1\",\
		\"type\": \"Meta\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"OrderResponse.implicitRules\",\
		\"weight\": 3839,\
		\"max\": \"1\",\
		\"type\": \"uri\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"OrderResponse.language\",\
		\"weight\": 3840,\
		\"max\": \"1\",\
		\"type\": \"code\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"OrderResponse.text\",\
		\"weight\": 3841,\
		\"max\": \"1\",\
		\"type\": \"Narrative\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"OrderResponse.contained\",\
		\"weight\": 3842,\
		\"max\": \"*\",\
		\"type\": \"Resource\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"OrderResponse.extension\",\
		\"weight\": 3843,\
		\"max\": \"*\",\
		\"type\": \"Extension\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"OrderResponse.modifierExtension\",\
		\"weight\": 3844,\
		\"max\": \"*\",\
		\"type\": \"Extension\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"OrderResponse.identifier\",\
		\"weight\": 3845,\
		\"max\": \"*\",\
		\"type\": \"Identifier\"\
	},\
	{\
		\"min\": \"1\",\
		\"path\": \"OrderResponse.request\",\
		\"weight\": 3846,\
		\"max\": \"1\",\
		\"type\": \"Reference\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"OrderResponse.date\",\
		\"weight\": 3847,\
		\"max\": \"1\",\
		\"type\": \"dateTime\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"OrderResponse.who\",\
		\"weight\": 3848,\
		\"max\": \"1\",\
		\"type\": \"Reference\"\
	},\
	{\
		\"min\": \"1\",\
		\"path\": \"OrderResponse.orderStatus\",\
		\"weight\": 3849,\
		\"max\": \"1\",\
		\"type\": \"code\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"OrderResponse.description\",\
		\"weight\": 3850,\
		\"max\": \"1\",\
		\"type\": \"string\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"OrderResponse.fulfillment\",\
		\"weight\": 3851,\
		\"max\": \"*\",\
		\"type\": \"Reference\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"OrderSet\",\
		\"weight\": 3852,\
		\"max\": \"*\",\
		\"type\": \"DomainResource\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"OrderSet.id\",\
		\"weight\": 3853,\
		\"max\": \"1\",\
		\"type\": \"id\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"OrderSet.meta\",\
		\"weight\": 3854,\
		\"max\": \"1\",\
		\"type\": \"Meta\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"OrderSet.implicitRules\",\
		\"weight\": 3855,\
		\"max\": \"1\",\
		\"type\": \"uri\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"OrderSet.language\",\
		\"weight\": 3856,\
		\"max\": \"1\",\
		\"type\": \"code\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"OrderSet.text\",\
		\"weight\": 3857,\
		\"max\": \"1\",\
		\"type\": \"Narrative\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"OrderSet.contained\",\
		\"weight\": 3858,\
		\"max\": \"*\",\
		\"type\": \"Resource\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"OrderSet.extension\",\
		\"weight\": 3859,\
		\"max\": \"*\",\
		\"type\": \"Extension\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"OrderSet.modifierExtension\",\
		\"weight\": 3860,\
		\"max\": \"*\",\
		\"type\": \"Extension\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"OrderSet.moduleMetadata\",\
		\"weight\": 3861,\
		\"max\": \"1\",\
		\"type\": \"ModuleMetadata\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"OrderSet.library\",\
		\"weight\": 3862,\
		\"max\": \"*\",\
		\"type\": \"Reference\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"OrderSet.action\",\
		\"weight\": 3863,\
		\"max\": \"*\",\
		\"type\": \"ActionDefinition\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Organization\",\
		\"weight\": 3864,\
		\"max\": \"*\",\
		\"type\": \"DomainResource\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Organization.id\",\
		\"weight\": 3865,\
		\"max\": \"1\",\
		\"type\": \"id\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Organization.meta\",\
		\"weight\": 3866,\
		\"max\": \"1\",\
		\"type\": \"Meta\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Organization.implicitRules\",\
		\"weight\": 3867,\
		\"max\": \"1\",\
		\"type\": \"uri\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Organization.language\",\
		\"weight\": 3868,\
		\"max\": \"1\",\
		\"type\": \"code\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Organization.text\",\
		\"weight\": 3869,\
		\"max\": \"1\",\
		\"type\": \"Narrative\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Organization.contained\",\
		\"weight\": 3870,\
		\"max\": \"*\",\
		\"type\": \"Resource\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Organization.extension\",\
		\"weight\": 3871,\
		\"max\": \"*\",\
		\"type\": \"Extension\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Organization.modifierExtension\",\
		\"weight\": 3872,\
		\"max\": \"*\",\
		\"type\": \"Extension\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Organization.identifier\",\
		\"weight\": 3873,\
		\"max\": \"*\",\
		\"type\": \"Identifier\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Organization.active\",\
		\"weight\": 3874,\
		\"max\": \"1\",\
		\"type\": \"boolean\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Organization.type\",\
		\"weight\": 3875,\
		\"max\": \"1\",\
		\"type\": \"CodeableConcept\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Organization.name\",\
		\"weight\": 3876,\
		\"max\": \"1\",\
		\"type\": \"string\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Organization.telecom\",\
		\"weight\": 3877,\
		\"max\": \"*\",\
		\"type\": \"ContactPoint\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Organization.address\",\
		\"weight\": 3878,\
		\"max\": \"*\",\
		\"type\": \"Address\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Organization.partOf\",\
		\"weight\": 3879,\
		\"max\": \"1\",\
		\"type\": \"Reference\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Organization.contact\",\
		\"weight\": 3880,\
		\"max\": \"*\",\
		\"type\": \"BackboneElement\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Organization.contact.id\",\
		\"weight\": 3881,\
		\"max\": \"1\",\
		\"type\": \"id\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Organization.contact.extension\",\
		\"weight\": 3882,\
		\"max\": \"*\",\
		\"type\": \"Extension\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Organization.contact.modifierExtension\",\
		\"weight\": 3883,\
		\"max\": \"*\",\
		\"type\": \"Extension\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Organization.contact.purpose\",\
		\"weight\": 3884,\
		\"max\": \"1\",\
		\"type\": \"CodeableConcept\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Organization.contact.name\",\
		\"weight\": 3885,\
		\"max\": \"1\",\
		\"type\": \"HumanName\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Organization.contact.telecom\",\
		\"weight\": 3886,\
		\"max\": \"*\",\
		\"type\": \"ContactPoint\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Organization.contact.address\",\
		\"weight\": 3887,\
		\"max\": \"1\",\
		\"type\": \"Address\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Patient\",\
		\"weight\": 3888,\
		\"max\": \"*\",\
		\"type\": \"DomainResource\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Patient.id\",\
		\"weight\": 3889,\
		\"max\": \"1\",\
		\"type\": \"id\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Patient.meta\",\
		\"weight\": 3890,\
		\"max\": \"1\",\
		\"type\": \"Meta\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Patient.implicitRules\",\
		\"weight\": 3891,\
		\"max\": \"1\",\
		\"type\": \"uri\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Patient.language\",\
		\"weight\": 3892,\
		\"max\": \"1\",\
		\"type\": \"code\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Patient.text\",\
		\"weight\": 3893,\
		\"max\": \"1\",\
		\"type\": \"Narrative\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Patient.contained\",\
		\"weight\": 3894,\
		\"max\": \"*\",\
		\"type\": \"Resource\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Patient.extension\",\
		\"weight\": 3895,\
		\"max\": \"*\",\
		\"type\": \"Extension\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Patient.modifierExtension\",\
		\"weight\": 3896,\
		\"max\": \"*\",\
		\"type\": \"Extension\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Patient.identifier\",\
		\"weight\": 3897,\
		\"max\": \"*\",\
		\"type\": \"Identifier\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Patient.active\",\
		\"weight\": 3898,\
		\"max\": \"1\",\
		\"type\": \"boolean\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Patient.name\",\
		\"weight\": 3899,\
		\"max\": \"*\",\
		\"type\": \"HumanName\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Patient.telecom\",\
		\"weight\": 3900,\
		\"max\": \"*\",\
		\"type\": \"ContactPoint\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Patient.gender\",\
		\"weight\": 3901,\
		\"max\": \"1\",\
		\"type\": \"code\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Patient.birthDate\",\
		\"weight\": 3902,\
		\"max\": \"1\",\
		\"type\": \"date\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Patient.deceasedBoolean\",\
		\"weight\": 3903,\
		\"max\": \"1\",\
		\"type\": \"boolean\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Patient.deceasedDateTime\",\
		\"weight\": 3903,\
		\"max\": \"1\",\
		\"type\": \"dateTime\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Patient.address\",\
		\"weight\": 3904,\
		\"max\": \"*\",\
		\"type\": \"Address\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Patient.maritalStatus\",\
		\"weight\": 3905,\
		\"max\": \"1\",\
		\"type\": \"CodeableConcept\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Patient.multipleBirthBoolean\",\
		\"weight\": 3906,\
		\"max\": \"1\",\
		\"type\": \"boolean\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Patient.multipleBirthInteger\",\
		\"weight\": 3906,\
		\"max\": \"1\",\
		\"type\": \"integer\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Patient.photo\",\
		\"weight\": 3907,\
		\"max\": \"*\",\
		\"type\": \"Attachment\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Patient.contact\",\
		\"weight\": 3908,\
		\"max\": \"*\",\
		\"type\": \"BackboneElement\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Patient.contact.id\",\
		\"weight\": 3909,\
		\"max\": \"1\",\
		\"type\": \"id\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Patient.contact.extension\",\
		\"weight\": 3910,\
		\"max\": \"*\",\
		\"type\": \"Extension\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Patient.contact.modifierExtension\",\
		\"weight\": 3911,\
		\"max\": \"*\",\
		\"type\": \"Extension\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Patient.contact.relationship\",\
		\"weight\": 3912,\
		\"max\": \"*\",\
		\"type\": \"CodeableConcept\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Patient.contact.name\",\
		\"weight\": 3913,\
		\"max\": \"1\",\
		\"type\": \"HumanName\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Patient.contact.telecom\",\
		\"weight\": 3914,\
		\"max\": \"*\",\
		\"type\": \"ContactPoint\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Patient.contact.address\",\
		\"weight\": 3915,\
		\"max\": \"1\",\
		\"type\": \"Address\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Patient.contact.gender\",\
		\"weight\": 3916,\
		\"max\": \"1\",\
		\"type\": \"code\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Patient.contact.organization\",\
		\"weight\": 3917,\
		\"max\": \"1\",\
		\"type\": \"Reference\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Patient.contact.period\",\
		\"weight\": 3918,\
		\"max\": \"1\",\
		\"type\": \"Period\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Patient.animal\",\
		\"weight\": 3919,\
		\"max\": \"1\",\
		\"type\": \"BackboneElement\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Patient.animal.id\",\
		\"weight\": 3920,\
		\"max\": \"1\",\
		\"type\": \"id\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Patient.animal.extension\",\
		\"weight\": 3921,\
		\"max\": \"*\",\
		\"type\": \"Extension\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Patient.animal.modifierExtension\",\
		\"weight\": 3922,\
		\"max\": \"*\",\
		\"type\": \"Extension\"\
	},\
	{\
		\"min\": \"1\",\
		\"path\": \"Patient.animal.species\",\
		\"weight\": 3923,\
		\"max\": \"1\",\
		\"type\": \"CodeableConcept\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Patient.animal.breed\",\
		\"weight\": 3924,\
		\"max\": \"1\",\
		\"type\": \"CodeableConcept\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Patient.animal.genderStatus\",\
		\"weight\": 3925,\
		\"max\": \"1\",\
		\"type\": \"CodeableConcept\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Patient.communication\",\
		\"weight\": 3926,\
		\"max\": \"*\",\
		\"type\": \"BackboneElement\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Patient.communication.id\",\
		\"weight\": 3927,\
		\"max\": \"1\",\
		\"type\": \"id\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Patient.communication.extension\",\
		\"weight\": 3928,\
		\"max\": \"*\",\
		\"type\": \"Extension\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Patient.communication.modifierExtension\",\
		\"weight\": 3929,\
		\"max\": \"*\",\
		\"type\": \"Extension\"\
	},\
	{\
		\"min\": \"1\",\
		\"path\": \"Patient.communication.language\",\
		\"weight\": 3930,\
		\"max\": \"1\",\
		\"type\": \"CodeableConcept\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Patient.communication.preferred\",\
		\"weight\": 3931,\
		\"max\": \"1\",\
		\"type\": \"boolean\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Patient.careProvider\",\
		\"weight\": 3932,\
		\"max\": \"*\",\
		\"type\": \"Reference\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Patient.managingOrganization\",\
		\"weight\": 3933,\
		\"max\": \"1\",\
		\"type\": \"Reference\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Patient.link\",\
		\"weight\": 3934,\
		\"max\": \"*\",\
		\"type\": \"BackboneElement\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Patient.link.id\",\
		\"weight\": 3935,\
		\"max\": \"1\",\
		\"type\": \"id\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Patient.link.extension\",\
		\"weight\": 3936,\
		\"max\": \"*\",\
		\"type\": \"Extension\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Patient.link.modifierExtension\",\
		\"weight\": 3937,\
		\"max\": \"*\",\
		\"type\": \"Extension\"\
	},\
	{\
		\"min\": \"1\",\
		\"path\": \"Patient.link.other\",\
		\"weight\": 3938,\
		\"max\": \"1\",\
		\"type\": \"Reference\"\
	},\
	{\
		\"min\": \"1\",\
		\"path\": \"Patient.link.type\",\
		\"weight\": 3939,\
		\"max\": \"1\",\
		\"type\": \"code\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"PaymentNotice\",\
		\"weight\": 3940,\
		\"max\": \"*\",\
		\"type\": \"DomainResource\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"PaymentNotice.id\",\
		\"weight\": 3941,\
		\"max\": \"1\",\
		\"type\": \"id\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"PaymentNotice.meta\",\
		\"weight\": 3942,\
		\"max\": \"1\",\
		\"type\": \"Meta\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"PaymentNotice.implicitRules\",\
		\"weight\": 3943,\
		\"max\": \"1\",\
		\"type\": \"uri\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"PaymentNotice.language\",\
		\"weight\": 3944,\
		\"max\": \"1\",\
		\"type\": \"code\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"PaymentNotice.text\",\
		\"weight\": 3945,\
		\"max\": \"1\",\
		\"type\": \"Narrative\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"PaymentNotice.contained\",\
		\"weight\": 3946,\
		\"max\": \"*\",\
		\"type\": \"Resource\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"PaymentNotice.extension\",\
		\"weight\": 3947,\
		\"max\": \"*\",\
		\"type\": \"Extension\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"PaymentNotice.modifierExtension\",\
		\"weight\": 3948,\
		\"max\": \"*\",\
		\"type\": \"Extension\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"PaymentNotice.identifier\",\
		\"weight\": 3949,\
		\"max\": \"*\",\
		\"type\": \"Identifier\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"PaymentNotice.ruleset\",\
		\"weight\": 3950,\
		\"max\": \"1\",\
		\"type\": \"Coding\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"PaymentNotice.originalRuleset\",\
		\"weight\": 3951,\
		\"max\": \"1\",\
		\"type\": \"Coding\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"PaymentNotice.created\",\
		\"weight\": 3952,\
		\"max\": \"1\",\
		\"type\": \"dateTime\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"PaymentNotice.targetIdentifier\",\
		\"weight\": 3953,\
		\"max\": \"1\",\
		\"type\": \"Identifier\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"PaymentNotice.targetReference\",\
		\"weight\": 3953,\
		\"max\": \"1\",\
		\"type\": \"Reference\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"PaymentNotice.providerIdentifier\",\
		\"weight\": 3954,\
		\"max\": \"1\",\
		\"type\": \"Identifier\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"PaymentNotice.providerReference\",\
		\"weight\": 3954,\
		\"max\": \"1\",\
		\"type\": \"Reference\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"PaymentNotice.organizationIdentifier\",\
		\"weight\": 3955,\
		\"max\": \"1\",\
		\"type\": \"Identifier\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"PaymentNotice.organizationReference\",\
		\"weight\": 3955,\
		\"max\": \"1\",\
		\"type\": \"Reference\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"PaymentNotice.requestIdentifier\",\
		\"weight\": 3956,\
		\"max\": \"1\",\
		\"type\": \"Identifier\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"PaymentNotice.requestReference\",\
		\"weight\": 3956,\
		\"max\": \"1\",\
		\"type\": \"Reference\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"PaymentNotice.responseIdentifier\",\
		\"weight\": 3957,\
		\"max\": \"1\",\
		\"type\": \"Identifier\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"PaymentNotice.responseReference\",\
		\"weight\": 3957,\
		\"max\": \"1\",\
		\"type\": \"Reference\"\
	},\
	{\
		\"min\": \"1\",\
		\"path\": \"PaymentNotice.paymentStatus\",\
		\"weight\": 3958,\
		\"max\": \"1\",\
		\"type\": \"Coding\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"PaymentNotice.statusDate\",\
		\"weight\": 3959,\
		\"max\": \"1\",\
		\"type\": \"date\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"PaymentReconciliation\",\
		\"weight\": 3960,\
		\"max\": \"*\",\
		\"type\": \"DomainResource\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"PaymentReconciliation.id\",\
		\"weight\": 3961,\
		\"max\": \"1\",\
		\"type\": \"id\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"PaymentReconciliation.meta\",\
		\"weight\": 3962,\
		\"max\": \"1\",\
		\"type\": \"Meta\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"PaymentReconciliation.implicitRules\",\
		\"weight\": 3963,\
		\"max\": \"1\",\
		\"type\": \"uri\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"PaymentReconciliation.language\",\
		\"weight\": 3964,\
		\"max\": \"1\",\
		\"type\": \"code\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"PaymentReconciliation.text\",\
		\"weight\": 3965,\
		\"max\": \"1\",\
		\"type\": \"Narrative\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"PaymentReconciliation.contained\",\
		\"weight\": 3966,\
		\"max\": \"*\",\
		\"type\": \"Resource\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"PaymentReconciliation.extension\",\
		\"weight\": 3967,\
		\"max\": \"*\",\
		\"type\": \"Extension\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"PaymentReconciliation.modifierExtension\",\
		\"weight\": 3968,\
		\"max\": \"*\",\
		\"type\": \"Extension\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"PaymentReconciliation.identifier\",\
		\"weight\": 3969,\
		\"max\": \"*\",\
		\"type\": \"Identifier\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"PaymentReconciliation.requestIdentifier\",\
		\"weight\": 3970,\
		\"max\": \"1\",\
		\"type\": \"Identifier\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"PaymentReconciliation.requestReference\",\
		\"weight\": 3970,\
		\"max\": \"1\",\
		\"type\": \"Reference\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"PaymentReconciliation.outcome\",\
		\"weight\": 3971,\
		\"max\": \"1\",\
		\"type\": \"code\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"PaymentReconciliation.disposition\",\
		\"weight\": 3972,\
		\"max\": \"1\",\
		\"type\": \"string\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"PaymentReconciliation.ruleset\",\
		\"weight\": 3973,\
		\"max\": \"1\",\
		\"type\": \"Coding\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"PaymentReconciliation.originalRuleset\",\
		\"weight\": 3974,\
		\"max\": \"1\",\
		\"type\": \"Coding\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"PaymentReconciliation.created\",\
		\"weight\": 3975,\
		\"max\": \"1\",\
		\"type\": \"dateTime\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"PaymentReconciliation.period\",\
		\"weight\": 3976,\
		\"max\": \"1\",\
		\"type\": \"Period\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"PaymentReconciliation.organizationIdentifier\",\
		\"weight\": 3977,\
		\"max\": \"1\",\
		\"type\": \"Identifier\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"PaymentReconciliation.organizationReference\",\
		\"weight\": 3977,\
		\"max\": \"1\",\
		\"type\": \"Reference\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"PaymentReconciliation.requestProviderIdentifier\",\
		\"weight\": 3978,\
		\"max\": \"1\",\
		\"type\": \"Identifier\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"PaymentReconciliation.requestProviderReference\",\
		\"weight\": 3978,\
		\"max\": \"1\",\
		\"type\": \"Reference\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"PaymentReconciliation.requestOrganizationIdentifier\",\
		\"weight\": 3979,\
		\"max\": \"1\",\
		\"type\": \"Identifier\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"PaymentReconciliation.requestOrganizationReference\",\
		\"weight\": 3979,\
		\"max\": \"1\",\
		\"type\": \"Reference\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"PaymentReconciliation.detail\",\
		\"weight\": 3980,\
		\"max\": \"*\",\
		\"type\": \"BackboneElement\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"PaymentReconciliation.detail.id\",\
		\"weight\": 3981,\
		\"max\": \"1\",\
		\"type\": \"id\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"PaymentReconciliation.detail.extension\",\
		\"weight\": 3982,\
		\"max\": \"*\",\
		\"type\": \"Extension\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"PaymentReconciliation.detail.modifierExtension\",\
		\"weight\": 3983,\
		\"max\": \"*\",\
		\"type\": \"Extension\"\
	},\
	{\
		\"min\": \"1\",\
		\"path\": \"PaymentReconciliation.detail.type\",\
		\"weight\": 3984,\
		\"max\": \"1\",\
		\"type\": \"Coding\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"PaymentReconciliation.detail.requestIdentifier\",\
		\"weight\": 3985,\
		\"max\": \"1\",\
		\"type\": \"Identifier\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"PaymentReconciliation.detail.requestReference\",\
		\"weight\": 3985,\
		\"max\": \"1\",\
		\"type\": \"Reference\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"PaymentReconciliation.detail.responceIdentifier\",\
		\"weight\": 3986,\
		\"max\": \"1\",\
		\"type\": \"Identifier\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"PaymentReconciliation.detail.responceReference\",\
		\"weight\": 3986,\
		\"max\": \"1\",\
		\"type\": \"Reference\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"PaymentReconciliation.detail.submitterIdentifier\",\
		\"weight\": 3987,\
		\"max\": \"1\",\
		\"type\": \"Identifier\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"PaymentReconciliation.detail.submitterReference\",\
		\"weight\": 3987,\
		\"max\": \"1\",\
		\"type\": \"Reference\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"PaymentReconciliation.detail.payeeIdentifier\",\
		\"weight\": 3988,\
		\"max\": \"1\",\
		\"type\": \"Identifier\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"PaymentReconciliation.detail.payeeReference\",\
		\"weight\": 3988,\
		\"max\": \"1\",\
		\"type\": \"Reference\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"PaymentReconciliation.detail.date\",\
		\"weight\": 3989,\
		\"max\": \"1\",\
		\"type\": \"date\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"PaymentReconciliation.detail.amount\",\
		\"weight\": 3990,\
		\"max\": \"1\",\
		\"type\": \"Quantity\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"PaymentReconciliation.form\",\
		\"weight\": 3991,\
		\"max\": \"1\",\
		\"type\": \"Coding\"\
	},\
	{\
		\"min\": \"1\",\
		\"path\": \"PaymentReconciliation.total\",\
		\"weight\": 3992,\
		\"max\": \"1\",\
		\"type\": \"Quantity\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"PaymentReconciliation.note\",\
		\"weight\": 3993,\
		\"max\": \"*\",\
		\"type\": \"BackboneElement\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"PaymentReconciliation.note.id\",\
		\"weight\": 3994,\
		\"max\": \"1\",\
		\"type\": \"id\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"PaymentReconciliation.note.extension\",\
		\"weight\": 3995,\
		\"max\": \"*\",\
		\"type\": \"Extension\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"PaymentReconciliation.note.modifierExtension\",\
		\"weight\": 3996,\
		\"max\": \"*\",\
		\"type\": \"Extension\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"PaymentReconciliation.note.type\",\
		\"weight\": 3997,\
		\"max\": \"1\",\
		\"type\": \"Coding\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"PaymentReconciliation.note.text\",\
		\"weight\": 3998,\
		\"max\": \"1\",\
		\"type\": \"string\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Person\",\
		\"weight\": 3999,\
		\"max\": \"*\",\
		\"type\": \"DomainResource\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Person.id\",\
		\"weight\": 4000,\
		\"max\": \"1\",\
		\"type\": \"id\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Person.meta\",\
		\"weight\": 4001,\
		\"max\": \"1\",\
		\"type\": \"Meta\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Person.implicitRules\",\
		\"weight\": 4002,\
		\"max\": \"1\",\
		\"type\": \"uri\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Person.language\",\
		\"weight\": 4003,\
		\"max\": \"1\",\
		\"type\": \"code\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Person.text\",\
		\"weight\": 4004,\
		\"max\": \"1\",\
		\"type\": \"Narrative\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Person.contained\",\
		\"weight\": 4005,\
		\"max\": \"*\",\
		\"type\": \"Resource\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Person.extension\",\
		\"weight\": 4006,\
		\"max\": \"*\",\
		\"type\": \"Extension\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Person.modifierExtension\",\
		\"weight\": 4007,\
		\"max\": \"*\",\
		\"type\": \"Extension\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Person.identifier\",\
		\"weight\": 4008,\
		\"max\": \"*\",\
		\"type\": \"Identifier\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Person.name\",\
		\"weight\": 4009,\
		\"max\": \"*\",\
		\"type\": \"HumanName\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Person.telecom\",\
		\"weight\": 4010,\
		\"max\": \"*\",\
		\"type\": \"ContactPoint\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Person.gender\",\
		\"weight\": 4011,\
		\"max\": \"1\",\
		\"type\": \"code\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Person.birthDate\",\
		\"weight\": 4012,\
		\"max\": \"1\",\
		\"type\": \"date\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Person.address\",\
		\"weight\": 4013,\
		\"max\": \"*\",\
		\"type\": \"Address\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Person.photo\",\
		\"weight\": 4014,\
		\"max\": \"1\",\
		\"type\": \"Attachment\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Person.managingOrganization\",\
		\"weight\": 4015,\
		\"max\": \"1\",\
		\"type\": \"Reference\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Person.active\",\
		\"weight\": 4016,\
		\"max\": \"1\",\
		\"type\": \"boolean\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Person.link\",\
		\"weight\": 4017,\
		\"max\": \"*\",\
		\"type\": \"BackboneElement\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Person.link.id\",\
		\"weight\": 4018,\
		\"max\": \"1\",\
		\"type\": \"id\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Person.link.extension\",\
		\"weight\": 4019,\
		\"max\": \"*\",\
		\"type\": \"Extension\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Person.link.modifierExtension\",\
		\"weight\": 4020,\
		\"max\": \"*\",\
		\"type\": \"Extension\"\
	},\
	{\
		\"min\": \"1\",\
		\"path\": \"Person.link.target\",\
		\"weight\": 4021,\
		\"max\": \"1\",\
		\"type\": \"Reference\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Person.link.assurance\",\
		\"weight\": 4022,\
		\"max\": \"1\",\
		\"type\": \"code\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Practitioner\",\
		\"weight\": 4023,\
		\"max\": \"*\",\
		\"type\": \"DomainResource\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Practitioner.id\",\
		\"weight\": 4024,\
		\"max\": \"1\",\
		\"type\": \"id\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Practitioner.meta\",\
		\"weight\": 4025,\
		\"max\": \"1\",\
		\"type\": \"Meta\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Practitioner.implicitRules\",\
		\"weight\": 4026,\
		\"max\": \"1\",\
		\"type\": \"uri\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Practitioner.language\",\
		\"weight\": 4027,\
		\"max\": \"1\",\
		\"type\": \"code\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Practitioner.text\",\
		\"weight\": 4028,\
		\"max\": \"1\",\
		\"type\": \"Narrative\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Practitioner.contained\",\
		\"weight\": 4029,\
		\"max\": \"*\",\
		\"type\": \"Resource\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Practitioner.extension\",\
		\"weight\": 4030,\
		\"max\": \"*\",\
		\"type\": \"Extension\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Practitioner.modifierExtension\",\
		\"weight\": 4031,\
		\"max\": \"*\",\
		\"type\": \"Extension\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Practitioner.identifier\",\
		\"weight\": 4032,\
		\"max\": \"*\",\
		\"type\": \"Identifier\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Practitioner.active\",\
		\"weight\": 4033,\
		\"max\": \"1\",\
		\"type\": \"boolean\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Practitioner.name\",\
		\"weight\": 4034,\
		\"max\": \"*\",\
		\"type\": \"HumanName\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Practitioner.telecom\",\
		\"weight\": 4035,\
		\"max\": \"*\",\
		\"type\": \"ContactPoint\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Practitioner.address\",\
		\"weight\": 4036,\
		\"max\": \"*\",\
		\"type\": \"Address\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Practitioner.gender\",\
		\"weight\": 4037,\
		\"max\": \"1\",\
		\"type\": \"code\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Practitioner.birthDate\",\
		\"weight\": 4038,\
		\"max\": \"1\",\
		\"type\": \"date\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Practitioner.photo\",\
		\"weight\": 4039,\
		\"max\": \"*\",\
		\"type\": \"Attachment\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Practitioner.practitionerRole\",\
		\"weight\": 4040,\
		\"max\": \"*\",\
		\"type\": \"BackboneElement\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Practitioner.practitionerRole.id\",\
		\"weight\": 4041,\
		\"max\": \"1\",\
		\"type\": \"id\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Practitioner.practitionerRole.extension\",\
		\"weight\": 4042,\
		\"max\": \"*\",\
		\"type\": \"Extension\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Practitioner.practitionerRole.modifierExtension\",\
		\"weight\": 4043,\
		\"max\": \"*\",\
		\"type\": \"Extension\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Practitioner.practitionerRole.organization\",\
		\"weight\": 4044,\
		\"max\": \"1\",\
		\"type\": \"Reference\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Practitioner.practitionerRole.role\",\
		\"weight\": 4045,\
		\"max\": \"1\",\
		\"type\": \"CodeableConcept\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Practitioner.practitionerRole.specialty\",\
		\"weight\": 4046,\
		\"max\": \"*\",\
		\"type\": \"CodeableConcept\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Practitioner.practitionerRole.identifier\",\
		\"weight\": 4047,\
		\"max\": \"*\",\
		\"type\": \"Identifier\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Practitioner.practitionerRole.telecom\",\
		\"weight\": 4048,\
		\"max\": \"*\",\
		\"type\": \"ContactPoint\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Practitioner.practitionerRole.period\",\
		\"weight\": 4049,\
		\"max\": \"1\",\
		\"type\": \"Period\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Practitioner.practitionerRole.location\",\
		\"weight\": 4050,\
		\"max\": \"*\",\
		\"type\": \"Reference\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Practitioner.practitionerRole.healthcareService\",\
		\"weight\": 4051,\
		\"max\": \"*\",\
		\"type\": \"Reference\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Practitioner.qualification\",\
		\"weight\": 4052,\
		\"max\": \"*\",\
		\"type\": \"BackboneElement\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Practitioner.qualification.id\",\
		\"weight\": 4053,\
		\"max\": \"1\",\
		\"type\": \"id\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Practitioner.qualification.extension\",\
		\"weight\": 4054,\
		\"max\": \"*\",\
		\"type\": \"Extension\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Practitioner.qualification.modifierExtension\",\
		\"weight\": 4055,\
		\"max\": \"*\",\
		\"type\": \"Extension\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Practitioner.qualification.identifier\",\
		\"weight\": 4056,\
		\"max\": \"*\",\
		\"type\": \"Identifier\"\
	},\
	{\
		\"min\": \"1\",\
		\"path\": \"Practitioner.qualification.code\",\
		\"weight\": 4057,\
		\"max\": \"1\",\
		\"type\": \"CodeableConcept\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Practitioner.qualification.period\",\
		\"weight\": 4058,\
		\"max\": \"1\",\
		\"type\": \"Period\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Practitioner.qualification.issuer\",\
		\"weight\": 4059,\
		\"max\": \"1\",\
		\"type\": \"Reference\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Practitioner.communication\",\
		\"weight\": 4060,\
		\"max\": \"*\",\
		\"type\": \"CodeableConcept\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"PractitionerRole\",\
		\"weight\": 4061,\
		\"max\": \"*\",\
		\"type\": \"DomainResource\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"PractitionerRole.id\",\
		\"weight\": 4062,\
		\"max\": \"1\",\
		\"type\": \"id\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"PractitionerRole.meta\",\
		\"weight\": 4063,\
		\"max\": \"1\",\
		\"type\": \"Meta\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"PractitionerRole.implicitRules\",\
		\"weight\": 4064,\
		\"max\": \"1\",\
		\"type\": \"uri\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"PractitionerRole.language\",\
		\"weight\": 4065,\
		\"max\": \"1\",\
		\"type\": \"code\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"PractitionerRole.text\",\
		\"weight\": 4066,\
		\"max\": \"1\",\
		\"type\": \"Narrative\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"PractitionerRole.contained\",\
		\"weight\": 4067,\
		\"max\": \"*\",\
		\"type\": \"Resource\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"PractitionerRole.extension\",\
		\"weight\": 4068,\
		\"max\": \"*\",\
		\"type\": \"Extension\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"PractitionerRole.modifierExtension\",\
		\"weight\": 4069,\
		\"max\": \"*\",\
		\"type\": \"Extension\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"PractitionerRole.identifier\",\
		\"weight\": 4070,\
		\"max\": \"*\",\
		\"type\": \"Identifier\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"PractitionerRole.active\",\
		\"weight\": 4071,\
		\"max\": \"1\",\
		\"type\": \"boolean\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"PractitionerRole.practitioner\",\
		\"weight\": 4072,\
		\"max\": \"1\",\
		\"type\": \"Reference\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"PractitionerRole.organization\",\
		\"weight\": 4073,\
		\"max\": \"1\",\
		\"type\": \"Reference\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"PractitionerRole.role\",\
		\"weight\": 4074,\
		\"max\": \"*\",\
		\"type\": \"CodeableConcept\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"PractitionerRole.specialty\",\
		\"weight\": 4075,\
		\"max\": \"*\",\
		\"type\": \"CodeableConcept\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"PractitionerRole.location\",\
		\"weight\": 4076,\
		\"max\": \"*\",\
		\"type\": \"Reference\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"PractitionerRole.healthcareService\",\
		\"weight\": 4077,\
		\"max\": \"*\",\
		\"type\": \"Reference\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"PractitionerRole.telecom\",\
		\"weight\": 4078,\
		\"max\": \"*\",\
		\"type\": \"ContactPoint\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"PractitionerRole.period\",\
		\"weight\": 4079,\
		\"max\": \"1\",\
		\"type\": \"Period\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"PractitionerRole.availableTime\",\
		\"weight\": 4080,\
		\"max\": \"*\",\
		\"type\": \"BackboneElement\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"PractitionerRole.availableTime.id\",\
		\"weight\": 4081,\
		\"max\": \"1\",\
		\"type\": \"id\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"PractitionerRole.availableTime.extension\",\
		\"weight\": 4082,\
		\"max\": \"*\",\
		\"type\": \"Extension\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"PractitionerRole.availableTime.modifierExtension\",\
		\"weight\": 4083,\
		\"max\": \"*\",\
		\"type\": \"Extension\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"PractitionerRole.availableTime.daysOfWeek\",\
		\"weight\": 4084,\
		\"max\": \"*\",\
		\"type\": \"code\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"PractitionerRole.availableTime.allDay\",\
		\"weight\": 4085,\
		\"max\": \"1\",\
		\"type\": \"boolean\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"PractitionerRole.availableTime.availableStartTime\",\
		\"weight\": 4086,\
		\"max\": \"1\",\
		\"type\": \"time\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"PractitionerRole.availableTime.availableEndTime\",\
		\"weight\": 4087,\
		\"max\": \"1\",\
		\"type\": \"time\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"PractitionerRole.notAvailable\",\
		\"weight\": 4088,\
		\"max\": \"*\",\
		\"type\": \"BackboneElement\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"PractitionerRole.notAvailable.id\",\
		\"weight\": 4089,\
		\"max\": \"1\",\
		\"type\": \"id\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"PractitionerRole.notAvailable.extension\",\
		\"weight\": 4090,\
		\"max\": \"*\",\
		\"type\": \"Extension\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"PractitionerRole.notAvailable.modifierExtension\",\
		\"weight\": 4091,\
		\"max\": \"*\",\
		\"type\": \"Extension\"\
	},\
	{\
		\"min\": \"1\",\
		\"path\": \"PractitionerRole.notAvailable.description\",\
		\"weight\": 4092,\
		\"max\": \"1\",\
		\"type\": \"string\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"PractitionerRole.notAvailable.during\",\
		\"weight\": 4093,\
		\"max\": \"1\",\
		\"type\": \"Period\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"PractitionerRole.availabilityExceptions\",\
		\"weight\": 4094,\
		\"max\": \"1\",\
		\"type\": \"string\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Procedure\",\
		\"weight\": 4095,\
		\"max\": \"*\",\
		\"type\": \"DomainResource\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Procedure.id\",\
		\"weight\": 4096,\
		\"max\": \"1\",\
		\"type\": \"id\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Procedure.meta\",\
		\"weight\": 4097,\
		\"max\": \"1\",\
		\"type\": \"Meta\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Procedure.implicitRules\",\
		\"weight\": 4098,\
		\"max\": \"1\",\
		\"type\": \"uri\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Procedure.language\",\
		\"weight\": 4099,\
		\"max\": \"1\",\
		\"type\": \"code\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Procedure.text\",\
		\"weight\": 4100,\
		\"max\": \"1\",\
		\"type\": \"Narrative\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Procedure.contained\",\
		\"weight\": 4101,\
		\"max\": \"*\",\
		\"type\": \"Resource\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Procedure.extension\",\
		\"weight\": 4102,\
		\"max\": \"*\",\
		\"type\": \"Extension\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Procedure.modifierExtension\",\
		\"weight\": 4103,\
		\"max\": \"*\",\
		\"type\": \"Extension\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Procedure.identifier\",\
		\"weight\": 4104,\
		\"max\": \"*\",\
		\"type\": \"Identifier\"\
	},\
	{\
		\"min\": \"1\",\
		\"path\": \"Procedure.subject\",\
		\"weight\": 4105,\
		\"max\": \"1\",\
		\"type\": \"Reference\"\
	},\
	{\
		\"min\": \"1\",\
		\"path\": \"Procedure.status\",\
		\"weight\": 4106,\
		\"max\": \"1\",\
		\"type\": \"code\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Procedure.category\",\
		\"weight\": 4107,\
		\"max\": \"1\",\
		\"type\": \"CodeableConcept\"\
	},\
	{\
		\"min\": \"1\",\
		\"path\": \"Procedure.code\",\
		\"weight\": 4108,\
		\"max\": \"1\",\
		\"type\": \"CodeableConcept\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Procedure.notPerformed\",\
		\"weight\": 4109,\
		\"max\": \"1\",\
		\"type\": \"boolean\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Procedure.reasonNotPerformed\",\
		\"weight\": 4110,\
		\"max\": \"*\",\
		\"type\": \"CodeableConcept\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Procedure.bodySite\",\
		\"weight\": 4111,\
		\"max\": \"*\",\
		\"type\": \"CodeableConcept\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Procedure.reasonCodeableConcept\",\
		\"weight\": 4112,\
		\"max\": \"1\",\
		\"type\": \"CodeableConcept\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Procedure.reasonReference\",\
		\"weight\": 4112,\
		\"max\": \"1\",\
		\"type\": \"Reference\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Procedure.performer\",\
		\"weight\": 4113,\
		\"max\": \"*\",\
		\"type\": \"BackboneElement\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Procedure.performer.id\",\
		\"weight\": 4114,\
		\"max\": \"1\",\
		\"type\": \"id\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Procedure.performer.extension\",\
		\"weight\": 4115,\
		\"max\": \"*\",\
		\"type\": \"Extension\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Procedure.performer.modifierExtension\",\
		\"weight\": 4116,\
		\"max\": \"*\",\
		\"type\": \"Extension\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Procedure.performer.actor\",\
		\"weight\": 4117,\
		\"max\": \"1\",\
		\"type\": \"Reference\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Procedure.performer.role\",\
		\"weight\": 4118,\
		\"max\": \"1\",\
		\"type\": \"CodeableConcept\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Procedure.performedDateTime\",\
		\"weight\": 4119,\
		\"max\": \"1\",\
		\"type\": \"dateTime\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Procedure.performedPeriod\",\
		\"weight\": 4119,\
		\"max\": \"1\",\
		\"type\": \"Period\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Procedure.encounter\",\
		\"weight\": 4120,\
		\"max\": \"1\",\
		\"type\": \"Reference\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Procedure.location\",\
		\"weight\": 4121,\
		\"max\": \"1\",\
		\"type\": \"Reference\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Procedure.outcome\",\
		\"weight\": 4122,\
		\"max\": \"1\",\
		\"type\": \"CodeableConcept\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Procedure.report\",\
		\"weight\": 4123,\
		\"max\": \"*\",\
		\"type\": \"Reference\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Procedure.complication\",\
		\"weight\": 4124,\
		\"max\": \"*\",\
		\"type\": \"CodeableConcept\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Procedure.followUp\",\
		\"weight\": 4125,\
		\"max\": \"*\",\
		\"type\": \"CodeableConcept\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Procedure.request\",\
		\"weight\": 4126,\
		\"max\": \"1\",\
		\"type\": \"Reference\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Procedure.notes\",\
		\"weight\": 4127,\
		\"max\": \"*\",\
		\"type\": \"Annotation\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Procedure.focalDevice\",\
		\"weight\": 4128,\
		\"max\": \"*\",\
		\"type\": \"BackboneElement\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Procedure.focalDevice.id\",\
		\"weight\": 4129,\
		\"max\": \"1\",\
		\"type\": \"id\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Procedure.focalDevice.extension\",\
		\"weight\": 4130,\
		\"max\": \"*\",\
		\"type\": \"Extension\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Procedure.focalDevice.modifierExtension\",\
		\"weight\": 4131,\
		\"max\": \"*\",\
		\"type\": \"Extension\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Procedure.focalDevice.action\",\
		\"weight\": 4132,\
		\"max\": \"1\",\
		\"type\": \"CodeableConcept\"\
	},\
	{\
		\"min\": \"1\",\
		\"path\": \"Procedure.focalDevice.manipulated\",\
		\"weight\": 4133,\
		\"max\": \"1\",\
		\"type\": \"Reference\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Procedure.used\",\
		\"weight\": 4134,\
		\"max\": \"*\",\
		\"type\": \"Reference\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"ProcedureRequest\",\
		\"weight\": 4135,\
		\"max\": \"*\",\
		\"type\": \"DomainResource\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"ProcedureRequest.id\",\
		\"weight\": 4136,\
		\"max\": \"1\",\
		\"type\": \"id\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"ProcedureRequest.meta\",\
		\"weight\": 4137,\
		\"max\": \"1\",\
		\"type\": \"Meta\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"ProcedureRequest.implicitRules\",\
		\"weight\": 4138,\
		\"max\": \"1\",\
		\"type\": \"uri\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"ProcedureRequest.language\",\
		\"weight\": 4139,\
		\"max\": \"1\",\
		\"type\": \"code\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"ProcedureRequest.text\",\
		\"weight\": 4140,\
		\"max\": \"1\",\
		\"type\": \"Narrative\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"ProcedureRequest.contained\",\
		\"weight\": 4141,\
		\"max\": \"*\",\
		\"type\": \"Resource\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"ProcedureRequest.extension\",\
		\"weight\": 4142,\
		\"max\": \"*\",\
		\"type\": \"Extension\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"ProcedureRequest.modifierExtension\",\
		\"weight\": 4143,\
		\"max\": \"*\",\
		\"type\": \"Extension\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"ProcedureRequest.identifier\",\
		\"weight\": 4144,\
		\"max\": \"*\",\
		\"type\": \"Identifier\"\
	},\
	{\
		\"min\": \"1\",\
		\"path\": \"ProcedureRequest.subject\",\
		\"weight\": 4145,\
		\"max\": \"1\",\
		\"type\": \"Reference\"\
	},\
	{\
		\"min\": \"1\",\
		\"path\": \"ProcedureRequest.code\",\
		\"weight\": 4146,\
		\"max\": \"1\",\
		\"type\": \"CodeableConcept\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"ProcedureRequest.bodySite\",\
		\"weight\": 4147,\
		\"max\": \"*\",\
		\"type\": \"CodeableConcept\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"ProcedureRequest.reasonCodeableConcept\",\
		\"weight\": 4148,\
		\"max\": \"1\",\
		\"type\": \"CodeableConcept\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"ProcedureRequest.reasonReference\",\
		\"weight\": 4148,\
		\"max\": \"1\",\
		\"type\": \"Reference\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"ProcedureRequest.scheduledDateTime\",\
		\"weight\": 4149,\
		\"max\": \"1\",\
		\"type\": \"dateTime\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"ProcedureRequest.scheduledPeriod\",\
		\"weight\": 4149,\
		\"max\": \"1\",\
		\"type\": \"Period\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"ProcedureRequest.scheduledTiming\",\
		\"weight\": 4149,\
		\"max\": \"1\",\
		\"type\": \"Timing\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"ProcedureRequest.encounter\",\
		\"weight\": 4150,\
		\"max\": \"1\",\
		\"type\": \"Reference\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"ProcedureRequest.performer\",\
		\"weight\": 4151,\
		\"max\": \"1\",\
		\"type\": \"Reference\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"ProcedureRequest.status\",\
		\"weight\": 4152,\
		\"max\": \"1\",\
		\"type\": \"code\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"ProcedureRequest.notes\",\
		\"weight\": 4153,\
		\"max\": \"*\",\
		\"type\": \"Annotation\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"ProcedureRequest.asNeededBoolean\",\
		\"weight\": 4154,\
		\"max\": \"1\",\
		\"type\": \"boolean\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"ProcedureRequest.asNeededCodeableConcept\",\
		\"weight\": 4154,\
		\"max\": \"1\",\
		\"type\": \"CodeableConcept\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"ProcedureRequest.orderedOn\",\
		\"weight\": 4155,\
		\"max\": \"1\",\
		\"type\": \"dateTime\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"ProcedureRequest.orderer\",\
		\"weight\": 4156,\
		\"max\": \"1\",\
		\"type\": \"Reference\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"ProcedureRequest.priority\",\
		\"weight\": 4157,\
		\"max\": \"1\",\
		\"type\": \"code\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"ProcessRequest\",\
		\"weight\": 4158,\
		\"max\": \"*\",\
		\"type\": \"DomainResource\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"ProcessRequest.id\",\
		\"weight\": 4159,\
		\"max\": \"1\",\
		\"type\": \"id\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"ProcessRequest.meta\",\
		\"weight\": 4160,\
		\"max\": \"1\",\
		\"type\": \"Meta\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"ProcessRequest.implicitRules\",\
		\"weight\": 4161,\
		\"max\": \"1\",\
		\"type\": \"uri\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"ProcessRequest.language\",\
		\"weight\": 4162,\
		\"max\": \"1\",\
		\"type\": \"code\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"ProcessRequest.text\",\
		\"weight\": 4163,\
		\"max\": \"1\",\
		\"type\": \"Narrative\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"ProcessRequest.contained\",\
		\"weight\": 4164,\
		\"max\": \"*\",\
		\"type\": \"Resource\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"ProcessRequest.extension\",\
		\"weight\": 4165,\
		\"max\": \"*\",\
		\"type\": \"Extension\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"ProcessRequest.modifierExtension\",\
		\"weight\": 4166,\
		\"max\": \"*\",\
		\"type\": \"Extension\"\
	},\
	{\
		\"min\": \"1\",\
		\"path\": \"ProcessRequest.action\",\
		\"weight\": 4167,\
		\"max\": \"1\",\
		\"type\": \"code\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"ProcessRequest.identifier\",\
		\"weight\": 4168,\
		\"max\": \"*\",\
		\"type\": \"Identifier\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"ProcessRequest.ruleset\",\
		\"weight\": 4169,\
		\"max\": \"1\",\
		\"type\": \"Coding\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"ProcessRequest.originalRuleset\",\
		\"weight\": 4170,\
		\"max\": \"1\",\
		\"type\": \"Coding\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"ProcessRequest.created\",\
		\"weight\": 4171,\
		\"max\": \"1\",\
		\"type\": \"dateTime\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"ProcessRequest.targetIdentifier\",\
		\"weight\": 4172,\
		\"max\": \"1\",\
		\"type\": \"Identifier\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"ProcessRequest.targetReference\",\
		\"weight\": 4172,\
		\"max\": \"1\",\
		\"type\": \"Reference\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"ProcessRequest.providerIdentifier\",\
		\"weight\": 4173,\
		\"max\": \"1\",\
		\"type\": \"Identifier\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"ProcessRequest.providerReference\",\
		\"weight\": 4173,\
		\"max\": \"1\",\
		\"type\": \"Reference\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"ProcessRequest.organizationIdentifier\",\
		\"weight\": 4174,\
		\"max\": \"1\",\
		\"type\": \"Identifier\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"ProcessRequest.organizationReference\",\
		\"weight\": 4174,\
		\"max\": \"1\",\
		\"type\": \"Reference\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"ProcessRequest.requestIdentifier\",\
		\"weight\": 4175,\
		\"max\": \"1\",\
		\"type\": \"Identifier\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"ProcessRequest.requestReference\",\
		\"weight\": 4175,\
		\"max\": \"1\",\
		\"type\": \"Reference\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"ProcessRequest.responseIdentifier\",\
		\"weight\": 4176,\
		\"max\": \"1\",\
		\"type\": \"Identifier\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"ProcessRequest.responseReference\",\
		\"weight\": 4176,\
		\"max\": \"1\",\
		\"type\": \"Reference\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"ProcessRequest.nullify\",\
		\"weight\": 4177,\
		\"max\": \"1\",\
		\"type\": \"boolean\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"ProcessRequest.reference\",\
		\"weight\": 4178,\
		\"max\": \"1\",\
		\"type\": \"string\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"ProcessRequest.item\",\
		\"weight\": 4179,\
		\"max\": \"*\",\
		\"type\": \"BackboneElement\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"ProcessRequest.item.id\",\
		\"weight\": 4180,\
		\"max\": \"1\",\
		\"type\": \"id\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"ProcessRequest.item.extension\",\
		\"weight\": 4181,\
		\"max\": \"*\",\
		\"type\": \"Extension\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"ProcessRequest.item.modifierExtension\",\
		\"weight\": 4182,\
		\"max\": \"*\",\
		\"type\": \"Extension\"\
	},\
	{\
		\"min\": \"1\",\
		\"path\": \"ProcessRequest.item.sequenceLinkId\",\
		\"weight\": 4183,\
		\"max\": \"1\",\
		\"type\": \"integer\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"ProcessRequest.include\",\
		\"weight\": 4184,\
		\"max\": \"*\",\
		\"type\": \"string\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"ProcessRequest.exclude\",\
		\"weight\": 4185,\
		\"max\": \"*\",\
		\"type\": \"string\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"ProcessRequest.period\",\
		\"weight\": 4186,\
		\"max\": \"1\",\
		\"type\": \"Period\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"ProcessResponse\",\
		\"weight\": 4187,\
		\"max\": \"*\",\
		\"type\": \"DomainResource\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"ProcessResponse.id\",\
		\"weight\": 4188,\
		\"max\": \"1\",\
		\"type\": \"id\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"ProcessResponse.meta\",\
		\"weight\": 4189,\
		\"max\": \"1\",\
		\"type\": \"Meta\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"ProcessResponse.implicitRules\",\
		\"weight\": 4190,\
		\"max\": \"1\",\
		\"type\": \"uri\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"ProcessResponse.language\",\
		\"weight\": 4191,\
		\"max\": \"1\",\
		\"type\": \"code\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"ProcessResponse.text\",\
		\"weight\": 4192,\
		\"max\": \"1\",\
		\"type\": \"Narrative\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"ProcessResponse.contained\",\
		\"weight\": 4193,\
		\"max\": \"*\",\
		\"type\": \"Resource\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"ProcessResponse.extension\",\
		\"weight\": 4194,\
		\"max\": \"*\",\
		\"type\": \"Extension\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"ProcessResponse.modifierExtension\",\
		\"weight\": 4195,\
		\"max\": \"*\",\
		\"type\": \"Extension\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"ProcessResponse.identifier\",\
		\"weight\": 4196,\
		\"max\": \"*\",\
		\"type\": \"Identifier\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"ProcessResponse.requestIdentifier\",\
		\"weight\": 4197,\
		\"max\": \"1\",\
		\"type\": \"Identifier\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"ProcessResponse.requestReference\",\
		\"weight\": 4197,\
		\"max\": \"1\",\
		\"type\": \"Reference\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"ProcessResponse.outcome\",\
		\"weight\": 4198,\
		\"max\": \"1\",\
		\"type\": \"Coding\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"ProcessResponse.disposition\",\
		\"weight\": 4199,\
		\"max\": \"1\",\
		\"type\": \"string\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"ProcessResponse.ruleset\",\
		\"weight\": 4200,\
		\"max\": \"1\",\
		\"type\": \"Coding\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"ProcessResponse.originalRuleset\",\
		\"weight\": 4201,\
		\"max\": \"1\",\
		\"type\": \"Coding\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"ProcessResponse.created\",\
		\"weight\": 4202,\
		\"max\": \"1\",\
		\"type\": \"dateTime\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"ProcessResponse.organizationIdentifier\",\
		\"weight\": 4203,\
		\"max\": \"1\",\
		\"type\": \"Identifier\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"ProcessResponse.organizationReference\",\
		\"weight\": 4203,\
		\"max\": \"1\",\
		\"type\": \"Reference\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"ProcessResponse.requestProviderIdentifier\",\
		\"weight\": 4204,\
		\"max\": \"1\",\
		\"type\": \"Identifier\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"ProcessResponse.requestProviderReference\",\
		\"weight\": 4204,\
		\"max\": \"1\",\
		\"type\": \"Reference\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"ProcessResponse.requestOrganizationIdentifier\",\
		\"weight\": 4205,\
		\"max\": \"1\",\
		\"type\": \"Identifier\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"ProcessResponse.requestOrganizationReference\",\
		\"weight\": 4205,\
		\"max\": \"1\",\
		\"type\": \"Reference\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"ProcessResponse.form\",\
		\"weight\": 4206,\
		\"max\": \"1\",\
		\"type\": \"Coding\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"ProcessResponse.notes\",\
		\"weight\": 4207,\
		\"max\": \"*\",\
		\"type\": \"BackboneElement\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"ProcessResponse.notes.id\",\
		\"weight\": 4208,\
		\"max\": \"1\",\
		\"type\": \"id\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"ProcessResponse.notes.extension\",\
		\"weight\": 4209,\
		\"max\": \"*\",\
		\"type\": \"Extension\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"ProcessResponse.notes.modifierExtension\",\
		\"weight\": 4210,\
		\"max\": \"*\",\
		\"type\": \"Extension\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"ProcessResponse.notes.type\",\
		\"weight\": 4211,\
		\"max\": \"1\",\
		\"type\": \"Coding\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"ProcessResponse.notes.text\",\
		\"weight\": 4212,\
		\"max\": \"1\",\
		\"type\": \"string\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"ProcessResponse.error\",\
		\"weight\": 4213,\
		\"max\": \"*\",\
		\"type\": \"Coding\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Protocol\",\
		\"weight\": 4214,\
		\"max\": \"*\",\
		\"type\": \"DomainResource\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Protocol.id\",\
		\"weight\": 4215,\
		\"max\": \"1\",\
		\"type\": \"id\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Protocol.meta\",\
		\"weight\": 4216,\
		\"max\": \"1\",\
		\"type\": \"Meta\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Protocol.implicitRules\",\
		\"weight\": 4217,\
		\"max\": \"1\",\
		\"type\": \"uri\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Protocol.language\",\
		\"weight\": 4218,\
		\"max\": \"1\",\
		\"type\": \"code\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Protocol.text\",\
		\"weight\": 4219,\
		\"max\": \"1\",\
		\"type\": \"Narrative\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Protocol.contained\",\
		\"weight\": 4220,\
		\"max\": \"*\",\
		\"type\": \"Resource\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Protocol.extension\",\
		\"weight\": 4221,\
		\"max\": \"*\",\
		\"type\": \"Extension\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Protocol.modifierExtension\",\
		\"weight\": 4222,\
		\"max\": \"*\",\
		\"type\": \"Extension\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Protocol.identifier\",\
		\"weight\": 4223,\
		\"max\": \"*\",\
		\"type\": \"Identifier\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Protocol.title\",\
		\"weight\": 4224,\
		\"max\": \"1\",\
		\"type\": \"string\"\
	},\
	{\
		\"min\": \"1\",\
		\"path\": \"Protocol.status\",\
		\"weight\": 4225,\
		\"max\": \"1\",\
		\"type\": \"code\"\
	},\
	{\
		\"min\": \"1\",\
		\"path\": \"Protocol.type\",\
		\"weight\": 4226,\
		\"max\": \"1\",\
		\"type\": \"code\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Protocol.subject\",\
		\"weight\": 4227,\
		\"max\": \"1\",\
		\"type\": \"Reference\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Protocol.group\",\
		\"weight\": 4228,\
		\"max\": \"1\",\
		\"type\": \"Reference\"\
	},\
	{\
		\"min\": \"1\",\
		\"path\": \"Protocol.purpose\",\
		\"weight\": 4229,\
		\"max\": \"1\",\
		\"type\": \"string\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Protocol.author\",\
		\"weight\": 4230,\
		\"max\": \"1\",\
		\"type\": \"Reference\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Protocol.step\",\
		\"weight\": 4231,\
		\"max\": \"*\",\
		\"type\": \"BackboneElement\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Protocol.step.id\",\
		\"weight\": 4232,\
		\"max\": \"1\",\
		\"type\": \"id\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Protocol.step.extension\",\
		\"weight\": 4233,\
		\"max\": \"*\",\
		\"type\": \"Extension\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Protocol.step.modifierExtension\",\
		\"weight\": 4234,\
		\"max\": \"*\",\
		\"type\": \"Extension\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Protocol.step.name\",\
		\"weight\": 4235,\
		\"max\": \"1\",\
		\"type\": \"string\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Protocol.step.description\",\
		\"weight\": 4236,\
		\"max\": \"1\",\
		\"type\": \"string\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Protocol.step.duration\",\
		\"weight\": 4237,\
		\"max\": \"1\",\
		\"type\": \"Quantity\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Protocol.step.precondition\",\
		\"weight\": 4238,\
		\"max\": \"1\",\
		\"type\": \"BackboneElement\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Protocol.step.precondition.id\",\
		\"weight\": 4239,\
		\"max\": \"1\",\
		\"type\": \"id\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Protocol.step.precondition.extension\",\
		\"weight\": 4240,\
		\"max\": \"*\",\
		\"type\": \"Extension\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Protocol.step.precondition.modifierExtension\",\
		\"weight\": 4241,\
		\"max\": \"*\",\
		\"type\": \"Extension\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Protocol.step.precondition.description\",\
		\"weight\": 4242,\
		\"max\": \"1\",\
		\"type\": \"string\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Protocol.step.precondition.condition\",\
		\"weight\": 4243,\
		\"max\": \"1\",\
		\"type\": \"BackboneElement\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Protocol.step.precondition.condition.id\",\
		\"weight\": 4244,\
		\"max\": \"1\",\
		\"type\": \"id\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Protocol.step.precondition.condition.extension\",\
		\"weight\": 4245,\
		\"max\": \"*\",\
		\"type\": \"Extension\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Protocol.step.precondition.condition.modifierExtension\",\
		\"weight\": 4246,\
		\"max\": \"*\",\
		\"type\": \"Extension\"\
	},\
	{\
		\"min\": \"1\",\
		\"path\": \"Protocol.step.precondition.condition.type\",\
		\"weight\": 4247,\
		\"max\": \"1\",\
		\"type\": \"CodeableConcept\"\
	},\
	{\
		\"min\": \"1\",\
		\"path\": \"Protocol.step.precondition.condition.valueCodeableConcept\",\
		\"weight\": 4248,\
		\"max\": \"1\",\
		\"type\": \"CodeableConcept\"\
	},\
	{\
		\"min\": \"1\",\
		\"path\": \"Protocol.step.precondition.condition.valueBoolean\",\
		\"weight\": 4248,\
		\"max\": \"1\",\
		\"type\": \"boolean\"\
	},\
	{\
		\"min\": \"1\",\
		\"path\": \"Protocol.step.precondition.condition.valueQuantity\",\
		\"weight\": 4248,\
		\"max\": \"1\",\
		\"type\": \"Quantity\"\
	},\
	{\
		\"min\": \"1\",\
		\"path\": \"Protocol.step.precondition.condition.valueRange\",\
		\"weight\": 4248,\
		\"max\": \"1\",\
		\"type\": \"Range\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Protocol.step.precondition.intersection\",\
		\"weight\": 4249,\
		\"max\": \"*\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Protocol.step.precondition.union\",\
		\"weight\": 4250,\
		\"max\": \"*\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Protocol.step.precondition.exclude\",\
		\"weight\": 4251,\
		\"max\": \"*\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Protocol.step.exit\",\
		\"weight\": 4252,\
		\"max\": \"1\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Protocol.step.firstActivity\",\
		\"weight\": 4253,\
		\"max\": \"1\",\
		\"type\": \"uri\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Protocol.step.activity\",\
		\"weight\": 4254,\
		\"max\": \"*\",\
		\"type\": \"BackboneElement\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Protocol.step.activity.id\",\
		\"weight\": 4255,\
		\"max\": \"1\",\
		\"type\": \"id\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Protocol.step.activity.extension\",\
		\"weight\": 4256,\
		\"max\": \"*\",\
		\"type\": \"Extension\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Protocol.step.activity.modifierExtension\",\
		\"weight\": 4257,\
		\"max\": \"*\",\
		\"type\": \"Extension\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Protocol.step.activity.alternative\",\
		\"weight\": 4258,\
		\"max\": \"*\",\
		\"type\": \"uri\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Protocol.step.activity.component\",\
		\"weight\": 4259,\
		\"max\": \"*\",\
		\"type\": \"BackboneElement\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Protocol.step.activity.component.id\",\
		\"weight\": 4260,\
		\"max\": \"1\",\
		\"type\": \"id\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Protocol.step.activity.component.extension\",\
		\"weight\": 4261,\
		\"max\": \"*\",\
		\"type\": \"Extension\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Protocol.step.activity.component.modifierExtension\",\
		\"weight\": 4262,\
		\"max\": \"*\",\
		\"type\": \"Extension\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Protocol.step.activity.component.sequence\",\
		\"weight\": 4263,\
		\"max\": \"1\",\
		\"type\": \"integer\"\
	},\
	{\
		\"min\": \"1\",\
		\"path\": \"Protocol.step.activity.component.activity\",\
		\"weight\": 4264,\
		\"max\": \"1\",\
		\"type\": \"uri\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Protocol.step.activity.following\",\
		\"weight\": 4265,\
		\"max\": \"*\",\
		\"type\": \"uri\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Protocol.step.activity.wait\",\
		\"weight\": 4266,\
		\"max\": \"1\",\
		\"type\": \"Quantity\"\
	},\
	{\
		\"min\": \"1\",\
		\"path\": \"Protocol.step.activity.detail\",\
		\"weight\": 4267,\
		\"max\": \"1\",\
		\"type\": \"BackboneElement\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Protocol.step.activity.detail.id\",\
		\"weight\": 4268,\
		\"max\": \"1\",\
		\"type\": \"id\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Protocol.step.activity.detail.extension\",\
		\"weight\": 4269,\
		\"max\": \"*\",\
		\"type\": \"Extension\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Protocol.step.activity.detail.modifierExtension\",\
		\"weight\": 4270,\
		\"max\": \"*\",\
		\"type\": \"Extension\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Protocol.step.activity.detail.category\",\
		\"weight\": 4271,\
		\"max\": \"1\",\
		\"type\": \"code\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Protocol.step.activity.detail.code\",\
		\"weight\": 4272,\
		\"max\": \"1\",\
		\"type\": \"CodeableConcept\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Protocol.step.activity.detail.timingCodeableConcept\",\
		\"weight\": 4273,\
		\"max\": \"1\",\
		\"type\": \"CodeableConcept\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Protocol.step.activity.detail.timingTiming\",\
		\"weight\": 4273,\
		\"max\": \"1\",\
		\"type\": \"Timing\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Protocol.step.activity.detail.location\",\
		\"weight\": 4274,\
		\"max\": \"1\",\
		\"type\": \"Reference\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Protocol.step.activity.detail.performer\",\
		\"weight\": 4275,\
		\"max\": \"*\",\
		\"type\": \"Reference\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Protocol.step.activity.detail.product\",\
		\"weight\": 4276,\
		\"max\": \"1\",\
		\"type\": \"Reference\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Protocol.step.activity.detail.quantity\",\
		\"weight\": 4277,\
		\"max\": \"1\",\
		\"type\": \"Quantity\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Protocol.step.activity.detail.description\",\
		\"weight\": 4278,\
		\"max\": \"1\",\
		\"type\": \"string\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Protocol.step.next\",\
		\"weight\": 4279,\
		\"max\": \"*\",\
		\"type\": \"BackboneElement\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Protocol.step.next.id\",\
		\"weight\": 4280,\
		\"max\": \"1\",\
		\"type\": \"id\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Protocol.step.next.extension\",\
		\"weight\": 4281,\
		\"max\": \"*\",\
		\"type\": \"Extension\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Protocol.step.next.modifierExtension\",\
		\"weight\": 4282,\
		\"max\": \"*\",\
		\"type\": \"Extension\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Protocol.step.next.description\",\
		\"weight\": 4283,\
		\"max\": \"1\",\
		\"type\": \"string\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Protocol.step.next.reference\",\
		\"weight\": 4284,\
		\"max\": \"1\",\
		\"type\": \"uri\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Protocol.step.next.condition\",\
		\"weight\": 4285,\
		\"max\": \"1\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Provenance\",\
		\"weight\": 4286,\
		\"max\": \"*\",\
		\"type\": \"DomainResource\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Provenance.id\",\
		\"weight\": 4287,\
		\"max\": \"1\",\
		\"type\": \"id\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Provenance.meta\",\
		\"weight\": 4288,\
		\"max\": \"1\",\
		\"type\": \"Meta\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Provenance.implicitRules\",\
		\"weight\": 4289,\
		\"max\": \"1\",\
		\"type\": \"uri\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Provenance.language\",\
		\"weight\": 4290,\
		\"max\": \"1\",\
		\"type\": \"code\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Provenance.text\",\
		\"weight\": 4291,\
		\"max\": \"1\",\
		\"type\": \"Narrative\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Provenance.contained\",\
		\"weight\": 4292,\
		\"max\": \"*\",\
		\"type\": \"Resource\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Provenance.extension\",\
		\"weight\": 4293,\
		\"max\": \"*\",\
		\"type\": \"Extension\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Provenance.modifierExtension\",\
		\"weight\": 4294,\
		\"max\": \"*\",\
		\"type\": \"Extension\"\
	},\
	{\
		\"min\": \"1\",\
		\"path\": \"Provenance.target\",\
		\"weight\": 4295,\
		\"max\": \"*\",\
		\"type\": \"Reference\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Provenance.period\",\
		\"weight\": 4296,\
		\"max\": \"1\",\
		\"type\": \"Period\"\
	},\
	{\
		\"min\": \"1\",\
		\"path\": \"Provenance.recorded\",\
		\"weight\": 4297,\
		\"max\": \"1\",\
		\"type\": \"instant\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Provenance.reason\",\
		\"weight\": 4298,\
		\"max\": \"*\",\
		\"type\": \"Coding\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Provenance.activity\",\
		\"weight\": 4299,\
		\"max\": \"1\",\
		\"type\": \"Coding\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Provenance.location\",\
		\"weight\": 4300,\
		\"max\": \"1\",\
		\"type\": \"Reference\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Provenance.policy\",\
		\"weight\": 4301,\
		\"max\": \"*\",\
		\"type\": \"uri\"\
	},\
	{\
		\"min\": \"1\",\
		\"path\": \"Provenance.agent\",\
		\"weight\": 4302,\
		\"max\": \"*\",\
		\"type\": \"BackboneElement\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Provenance.agent.id\",\
		\"weight\": 4303,\
		\"max\": \"1\",\
		\"type\": \"id\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Provenance.agent.extension\",\
		\"weight\": 4304,\
		\"max\": \"*\",\
		\"type\": \"Extension\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Provenance.agent.modifierExtension\",\
		\"weight\": 4305,\
		\"max\": \"*\",\
		\"type\": \"Extension\"\
	},\
	{\
		\"min\": \"1\",\
		\"path\": \"Provenance.agent.role\",\
		\"weight\": 4306,\
		\"max\": \"1\",\
		\"type\": \"Coding\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Provenance.agent.actor\",\
		\"weight\": 4307,\
		\"max\": \"1\",\
		\"type\": \"Reference\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Provenance.agent.userId\",\
		\"weight\": 4308,\
		\"max\": \"1\",\
		\"type\": \"Identifier\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Provenance.agent.relatedAgent\",\
		\"weight\": 4309,\
		\"max\": \"*\",\
		\"type\": \"BackboneElement\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Provenance.agent.relatedAgent.id\",\
		\"weight\": 4310,\
		\"max\": \"1\",\
		\"type\": \"id\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Provenance.agent.relatedAgent.extension\",\
		\"weight\": 4311,\
		\"max\": \"*\",\
		\"type\": \"Extension\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Provenance.agent.relatedAgent.modifierExtension\",\
		\"weight\": 4312,\
		\"max\": \"*\",\
		\"type\": \"Extension\"\
	},\
	{\
		\"min\": \"1\",\
		\"path\": \"Provenance.agent.relatedAgent.type\",\
		\"weight\": 4313,\
		\"max\": \"1\",\
		\"type\": \"CodeableConcept\"\
	},\
	{\
		\"min\": \"1\",\
		\"path\": \"Provenance.agent.relatedAgent.target\",\
		\"weight\": 4314,\
		\"max\": \"1\",\
		\"type\": \"uri\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Provenance.entity\",\
		\"weight\": 4315,\
		\"max\": \"*\",\
		\"type\": \"BackboneElement\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Provenance.entity.id\",\
		\"weight\": 4316,\
		\"max\": \"1\",\
		\"type\": \"id\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Provenance.entity.extension\",\
		\"weight\": 4317,\
		\"max\": \"*\",\
		\"type\": \"Extension\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Provenance.entity.modifierExtension\",\
		\"weight\": 4318,\
		\"max\": \"*\",\
		\"type\": \"Extension\"\
	},\
	{\
		\"min\": \"1\",\
		\"path\": \"Provenance.entity.role\",\
		\"weight\": 4319,\
		\"max\": \"1\",\
		\"type\": \"code\"\
	},\
	{\
		\"min\": \"1\",\
		\"path\": \"Provenance.entity.type\",\
		\"weight\": 4320,\
		\"max\": \"1\",\
		\"type\": \"Coding\"\
	},\
	{\
		\"min\": \"1\",\
		\"path\": \"Provenance.entity.reference\",\
		\"weight\": 4321,\
		\"max\": \"1\",\
		\"type\": \"uri\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Provenance.entity.display\",\
		\"weight\": 4322,\
		\"max\": \"1\",\
		\"type\": \"string\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Provenance.entity.agent\",\
		\"weight\": 4323,\
		\"max\": \"1\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Provenance.signature\",\
		\"weight\": 4324,\
		\"max\": \"*\",\
		\"type\": \"Signature\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Questionnaire\",\
		\"weight\": 4325,\
		\"max\": \"*\",\
		\"type\": \"DomainResource\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Questionnaire.id\",\
		\"weight\": 4326,\
		\"max\": \"1\",\
		\"type\": \"id\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Questionnaire.meta\",\
		\"weight\": 4327,\
		\"max\": \"1\",\
		\"type\": \"Meta\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Questionnaire.implicitRules\",\
		\"weight\": 4328,\
		\"max\": \"1\",\
		\"type\": \"uri\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Questionnaire.language\",\
		\"weight\": 4329,\
		\"max\": \"1\",\
		\"type\": \"code\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Questionnaire.text\",\
		\"weight\": 4330,\
		\"max\": \"1\",\
		\"type\": \"Narrative\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Questionnaire.contained\",\
		\"weight\": 4331,\
		\"max\": \"*\",\
		\"type\": \"Resource\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Questionnaire.extension\",\
		\"weight\": 4332,\
		\"max\": \"*\",\
		\"type\": \"Extension\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Questionnaire.modifierExtension\",\
		\"weight\": 4333,\
		\"max\": \"*\",\
		\"type\": \"Extension\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Questionnaire.url\",\
		\"weight\": 4334,\
		\"max\": \"1\",\
		\"type\": \"uri\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Questionnaire.identifier\",\
		\"weight\": 4335,\
		\"max\": \"*\",\
		\"type\": \"Identifier\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Questionnaire.version\",\
		\"weight\": 4336,\
		\"max\": \"1\",\
		\"type\": \"string\"\
	},\
	{\
		\"min\": \"1\",\
		\"path\": \"Questionnaire.status\",\
		\"weight\": 4337,\
		\"max\": \"1\",\
		\"type\": \"code\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Questionnaire.date\",\
		\"weight\": 4338,\
		\"max\": \"1\",\
		\"type\": \"dateTime\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Questionnaire.publisher\",\
		\"weight\": 4339,\
		\"max\": \"1\",\
		\"type\": \"string\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Questionnaire.telecom\",\
		\"weight\": 4340,\
		\"max\": \"*\",\
		\"type\": \"ContactPoint\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Questionnaire.useContext\",\
		\"weight\": 4341,\
		\"max\": \"*\",\
		\"type\": \"CodeableConcept\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Questionnaire.title\",\
		\"weight\": 4342,\
		\"max\": \"1\",\
		\"type\": \"string\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Questionnaire.concept\",\
		\"weight\": 4343,\
		\"max\": \"*\",\
		\"type\": \"Coding\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Questionnaire.subjectType\",\
		\"weight\": 4344,\
		\"max\": \"*\",\
		\"type\": \"code\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Questionnaire.item\",\
		\"weight\": 4345,\
		\"max\": \"*\",\
		\"type\": \"BackboneElement\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Questionnaire.item.id\",\
		\"weight\": 4346,\
		\"max\": \"1\",\
		\"type\": \"id\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Questionnaire.item.extension\",\
		\"weight\": 4347,\
		\"max\": \"*\",\
		\"type\": \"Extension\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Questionnaire.item.modifierExtension\",\
		\"weight\": 4348,\
		\"max\": \"*\",\
		\"type\": \"Extension\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Questionnaire.item.linkId\",\
		\"weight\": 4349,\
		\"max\": \"1\",\
		\"type\": \"string\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Questionnaire.item.concept\",\
		\"weight\": 4350,\
		\"max\": \"*\",\
		\"type\": \"Coding\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Questionnaire.item.prefix\",\
		\"weight\": 4351,\
		\"max\": \"1\",\
		\"type\": \"string\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Questionnaire.item.text\",\
		\"weight\": 4352,\
		\"max\": \"1\",\
		\"type\": \"string\"\
	},\
	{\
		\"min\": \"1\",\
		\"path\": \"Questionnaire.item.type\",\
		\"weight\": 4353,\
		\"max\": \"1\",\
		\"type\": \"code\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Questionnaire.item.enableWhen\",\
		\"weight\": 4354,\
		\"max\": \"*\",\
		\"type\": \"BackboneElement\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Questionnaire.item.enableWhen.id\",\
		\"weight\": 4355,\
		\"max\": \"1\",\
		\"type\": \"id\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Questionnaire.item.enableWhen.extension\",\
		\"weight\": 4356,\
		\"max\": \"*\",\
		\"type\": \"Extension\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Questionnaire.item.enableWhen.modifierExtension\",\
		\"weight\": 4357,\
		\"max\": \"*\",\
		\"type\": \"Extension\"\
	},\
	{\
		\"min\": \"1\",\
		\"path\": \"Questionnaire.item.enableWhen.question\",\
		\"weight\": 4358,\
		\"max\": \"1\",\
		\"type\": \"string\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Questionnaire.item.enableWhen.answered\",\
		\"weight\": 4359,\
		\"max\": \"1\",\
		\"type\": \"boolean\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Questionnaire.item.enableWhen.answerBoolean\",\
		\"weight\": 4360,\
		\"max\": \"1\",\
		\"type\": \"boolean\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Questionnaire.item.enableWhen.answerDecimal\",\
		\"weight\": 4360,\
		\"max\": \"1\",\
		\"type\": \"decimal\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Questionnaire.item.enableWhen.answerInteger\",\
		\"weight\": 4360,\
		\"max\": \"1\",\
		\"type\": \"integer\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Questionnaire.item.enableWhen.answerDate\",\
		\"weight\": 4360,\
		\"max\": \"1\",\
		\"type\": \"date\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Questionnaire.item.enableWhen.answerDateTime\",\
		\"weight\": 4360,\
		\"max\": \"1\",\
		\"type\": \"dateTime\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Questionnaire.item.enableWhen.answerInstant\",\
		\"weight\": 4360,\
		\"max\": \"1\",\
		\"type\": \"instant\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Questionnaire.item.enableWhen.answerTime\",\
		\"weight\": 4360,\
		\"max\": \"1\",\
		\"type\": \"time\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Questionnaire.item.enableWhen.answerString\",\
		\"weight\": 4360,\
		\"max\": \"1\",\
		\"type\": \"string\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Questionnaire.item.enableWhen.answerUri\",\
		\"weight\": 4360,\
		\"max\": \"1\",\
		\"type\": \"uri\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Questionnaire.item.enableWhen.answerAttachment\",\
		\"weight\": 4360,\
		\"max\": \"1\",\
		\"type\": \"Attachment\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Questionnaire.item.enableWhen.answerCoding\",\
		\"weight\": 4360,\
		\"max\": \"1\",\
		\"type\": \"Coding\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Questionnaire.item.enableWhen.answerQuantity\",\
		\"weight\": 4360,\
		\"max\": \"1\",\
		\"type\": \"Quantity\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Questionnaire.item.enableWhen.answerReference\",\
		\"weight\": 4360,\
		\"max\": \"1\",\
		\"type\": \"Reference\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Questionnaire.item.required\",\
		\"weight\": 4361,\
		\"max\": \"1\",\
		\"type\": \"boolean\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Questionnaire.item.repeats\",\
		\"weight\": 4362,\
		\"max\": \"1\",\
		\"type\": \"boolean\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Questionnaire.item.readOnly\",\
		\"weight\": 4363,\
		\"max\": \"1\",\
		\"type\": \"boolean\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Questionnaire.item.maxLength\",\
		\"weight\": 4364,\
		\"max\": \"1\",\
		\"type\": \"integer\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Questionnaire.item.options\",\
		\"weight\": 4365,\
		\"max\": \"1\",\
		\"type\": \"Reference\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Questionnaire.item.option\",\
		\"weight\": 4366,\
		\"max\": \"*\",\
		\"type\": \"BackboneElement\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Questionnaire.item.option.id\",\
		\"weight\": 4367,\
		\"max\": \"1\",\
		\"type\": \"id\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Questionnaire.item.option.extension\",\
		\"weight\": 4368,\
		\"max\": \"*\",\
		\"type\": \"Extension\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Questionnaire.item.option.modifierExtension\",\
		\"weight\": 4369,\
		\"max\": \"*\",\
		\"type\": \"Extension\"\
	},\
	{\
		\"min\": \"1\",\
		\"path\": \"Questionnaire.item.option.valueInteger\",\
		\"weight\": 4370,\
		\"max\": \"1\",\
		\"type\": \"integer\"\
	},\
	{\
		\"min\": \"1\",\
		\"path\": \"Questionnaire.item.option.valueDate\",\
		\"weight\": 4370,\
		\"max\": \"1\",\
		\"type\": \"date\"\
	},\
	{\
		\"min\": \"1\",\
		\"path\": \"Questionnaire.item.option.valueTime\",\
		\"weight\": 4370,\
		\"max\": \"1\",\
		\"type\": \"time\"\
	},\
	{\
		\"min\": \"1\",\
		\"path\": \"Questionnaire.item.option.valueString\",\
		\"weight\": 4370,\
		\"max\": \"1\",\
		\"type\": \"string\"\
	},\
	{\
		\"min\": \"1\",\
		\"path\": \"Questionnaire.item.option.valueCoding\",\
		\"weight\": 4370,\
		\"max\": \"1\",\
		\"type\": \"Coding\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Questionnaire.item.initialBoolean\",\
		\"weight\": 4371,\
		\"max\": \"1\",\
		\"type\": \"boolean\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Questionnaire.item.initialDecimal\",\
		\"weight\": 4371,\
		\"max\": \"1\",\
		\"type\": \"decimal\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Questionnaire.item.initialInteger\",\
		\"weight\": 4371,\
		\"max\": \"1\",\
		\"type\": \"integer\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Questionnaire.item.initialDate\",\
		\"weight\": 4371,\
		\"max\": \"1\",\
		\"type\": \"date\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Questionnaire.item.initialDateTime\",\
		\"weight\": 4371,\
		\"max\": \"1\",\
		\"type\": \"dateTime\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Questionnaire.item.initialInstant\",\
		\"weight\": 4371,\
		\"max\": \"1\",\
		\"type\": \"instant\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Questionnaire.item.initialTime\",\
		\"weight\": 4371,\
		\"max\": \"1\",\
		\"type\": \"time\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Questionnaire.item.initialString\",\
		\"weight\": 4371,\
		\"max\": \"1\",\
		\"type\": \"string\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Questionnaire.item.initialUri\",\
		\"weight\": 4371,\
		\"max\": \"1\",\
		\"type\": \"uri\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Questionnaire.item.initialAttachment\",\
		\"weight\": 4371,\
		\"max\": \"1\",\
		\"type\": \"Attachment\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Questionnaire.item.initialCoding\",\
		\"weight\": 4371,\
		\"max\": \"1\",\
		\"type\": \"Coding\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Questionnaire.item.initialQuantity\",\
		\"weight\": 4371,\
		\"max\": \"1\",\
		\"type\": \"Quantity\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Questionnaire.item.initialReference\",\
		\"weight\": 4371,\
		\"max\": \"1\",\
		\"type\": \"Reference\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Questionnaire.item.item\",\
		\"weight\": 4372,\
		\"max\": \"*\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"QuestionnaireResponse\",\
		\"weight\": 4373,\
		\"max\": \"*\",\
		\"type\": \"DomainResource\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"QuestionnaireResponse.id\",\
		\"weight\": 4374,\
		\"max\": \"1\",\
		\"type\": \"id\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"QuestionnaireResponse.meta\",\
		\"weight\": 4375,\
		\"max\": \"1\",\
		\"type\": \"Meta\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"QuestionnaireResponse.implicitRules\",\
		\"weight\": 4376,\
		\"max\": \"1\",\
		\"type\": \"uri\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"QuestionnaireResponse.language\",\
		\"weight\": 4377,\
		\"max\": \"1\",\
		\"type\": \"code\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"QuestionnaireResponse.text\",\
		\"weight\": 4378,\
		\"max\": \"1\",\
		\"type\": \"Narrative\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"QuestionnaireResponse.contained\",\
		\"weight\": 4379,\
		\"max\": \"*\",\
		\"type\": \"Resource\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"QuestionnaireResponse.extension\",\
		\"weight\": 4380,\
		\"max\": \"*\",\
		\"type\": \"Extension\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"QuestionnaireResponse.modifierExtension\",\
		\"weight\": 4381,\
		\"max\": \"*\",\
		\"type\": \"Extension\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"QuestionnaireResponse.identifier\",\
		\"weight\": 4382,\
		\"max\": \"1\",\
		\"type\": \"Identifier\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"QuestionnaireResponse.questionnaire\",\
		\"weight\": 4383,\
		\"max\": \"1\",\
		\"type\": \"Reference\"\
	},\
	{\
		\"min\": \"1\",\
		\"path\": \"QuestionnaireResponse.status\",\
		\"weight\": 4384,\
		\"max\": \"1\",\
		\"type\": \"code\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"QuestionnaireResponse.subject\",\
		\"weight\": 4385,\
		\"max\": \"1\",\
		\"type\": \"Reference\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"QuestionnaireResponse.author\",\
		\"weight\": 4386,\
		\"max\": \"1\",\
		\"type\": \"Reference\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"QuestionnaireResponse.authored\",\
		\"weight\": 4387,\
		\"max\": \"1\",\
		\"type\": \"dateTime\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"QuestionnaireResponse.source\",\
		\"weight\": 4388,\
		\"max\": \"1\",\
		\"type\": \"Reference\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"QuestionnaireResponse.encounter\",\
		\"weight\": 4389,\
		\"max\": \"1\",\
		\"type\": \"Reference\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"QuestionnaireResponse.item\",\
		\"weight\": 4390,\
		\"max\": \"*\",\
		\"type\": \"BackboneElement\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"QuestionnaireResponse.item.id\",\
		\"weight\": 4391,\
		\"max\": \"1\",\
		\"type\": \"id\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"QuestionnaireResponse.item.extension\",\
		\"weight\": 4392,\
		\"max\": \"*\",\
		\"type\": \"Extension\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"QuestionnaireResponse.item.modifierExtension\",\
		\"weight\": 4393,\
		\"max\": \"*\",\
		\"type\": \"Extension\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"QuestionnaireResponse.item.linkId\",\
		\"weight\": 4394,\
		\"max\": \"1\",\
		\"type\": \"string\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"QuestionnaireResponse.item.text\",\
		\"weight\": 4395,\
		\"max\": \"1\",\
		\"type\": \"string\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"QuestionnaireResponse.item.subject\",\
		\"weight\": 4396,\
		\"max\": \"1\",\
		\"type\": \"Reference\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"QuestionnaireResponse.item.answer\",\
		\"weight\": 4397,\
		\"max\": \"*\",\
		\"type\": \"BackboneElement\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"QuestionnaireResponse.item.answer.id\",\
		\"weight\": 4398,\
		\"max\": \"1\",\
		\"type\": \"id\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"QuestionnaireResponse.item.answer.extension\",\
		\"weight\": 4399,\
		\"max\": \"*\",\
		\"type\": \"Extension\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"QuestionnaireResponse.item.answer.modifierExtension\",\
		\"weight\": 4400,\
		\"max\": \"*\",\
		\"type\": \"Extension\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"QuestionnaireResponse.item.answer.valueBoolean\",\
		\"weight\": 4401,\
		\"max\": \"1\",\
		\"type\": \"boolean\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"QuestionnaireResponse.item.answer.valueDecimal\",\
		\"weight\": 4401,\
		\"max\": \"1\",\
		\"type\": \"decimal\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"QuestionnaireResponse.item.answer.valueInteger\",\
		\"weight\": 4401,\
		\"max\": \"1\",\
		\"type\": \"integer\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"QuestionnaireResponse.item.answer.valueDate\",\
		\"weight\": 4401,\
		\"max\": \"1\",\
		\"type\": \"date\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"QuestionnaireResponse.item.answer.valueDateTime\",\
		\"weight\": 4401,\
		\"max\": \"1\",\
		\"type\": \"dateTime\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"QuestionnaireResponse.item.answer.valueInstant\",\
		\"weight\": 4401,\
		\"max\": \"1\",\
		\"type\": \"instant\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"QuestionnaireResponse.item.answer.valueTime\",\
		\"weight\": 4401,\
		\"max\": \"1\",\
		\"type\": \"time\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"QuestionnaireResponse.item.answer.valueString\",\
		\"weight\": 4401,\
		\"max\": \"1\",\
		\"type\": \"string\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"QuestionnaireResponse.item.answer.valueUri\",\
		\"weight\": 4401,\
		\"max\": \"1\",\
		\"type\": \"uri\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"QuestionnaireResponse.item.answer.valueAttachment\",\
		\"weight\": 4401,\
		\"max\": \"1\",\
		\"type\": \"Attachment\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"QuestionnaireResponse.item.answer.valueCoding\",\
		\"weight\": 4401,\
		\"max\": \"1\",\
		\"type\": \"Coding\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"QuestionnaireResponse.item.answer.valueQuantity\",\
		\"weight\": 4401,\
		\"max\": \"1\",\
		\"type\": \"Quantity\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"QuestionnaireResponse.item.answer.valueReference\",\
		\"weight\": 4401,\
		\"max\": \"1\",\
		\"type\": \"Reference\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"QuestionnaireResponse.item.answer.item\",\
		\"weight\": 4402,\
		\"max\": \"*\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"QuestionnaireResponse.item.item\",\
		\"weight\": 4403,\
		\"max\": \"*\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"ReferralRequest\",\
		\"weight\": 4404,\
		\"max\": \"*\",\
		\"type\": \"DomainResource\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"ReferralRequest.id\",\
		\"weight\": 4405,\
		\"max\": \"1\",\
		\"type\": \"id\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"ReferralRequest.meta\",\
		\"weight\": 4406,\
		\"max\": \"1\",\
		\"type\": \"Meta\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"ReferralRequest.implicitRules\",\
		\"weight\": 4407,\
		\"max\": \"1\",\
		\"type\": \"uri\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"ReferralRequest.language\",\
		\"weight\": 4408,\
		\"max\": \"1\",\
		\"type\": \"code\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"ReferralRequest.text\",\
		\"weight\": 4409,\
		\"max\": \"1\",\
		\"type\": \"Narrative\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"ReferralRequest.contained\",\
		\"weight\": 4410,\
		\"max\": \"*\",\
		\"type\": \"Resource\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"ReferralRequest.extension\",\
		\"weight\": 4411,\
		\"max\": \"*\",\
		\"type\": \"Extension\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"ReferralRequest.modifierExtension\",\
		\"weight\": 4412,\
		\"max\": \"*\",\
		\"type\": \"Extension\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"ReferralRequest.identifier\",\
		\"weight\": 4413,\
		\"max\": \"*\",\
		\"type\": \"Identifier\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"ReferralRequest.basedOn\",\
		\"weight\": 4414,\
		\"max\": \"*\",\
		\"type\": \"Reference\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"ReferralRequest.parent\",\
		\"weight\": 4415,\
		\"max\": \"1\",\
		\"type\": \"Identifier\"\
	},\
	{\
		\"min\": \"1\",\
		\"path\": \"ReferralRequest.status\",\
		\"weight\": 4416,\
		\"max\": \"1\",\
		\"type\": \"code\"\
	},\
	{\
		\"min\": \"1\",\
		\"path\": \"ReferralRequest.category\",\
		\"weight\": 4417,\
		\"max\": \"1\",\
		\"type\": \"code\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"ReferralRequest.type\",\
		\"weight\": 4418,\
		\"max\": \"1\",\
		\"type\": \"CodeableConcept\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"ReferralRequest.priority\",\
		\"weight\": 4419,\
		\"max\": \"1\",\
		\"type\": \"CodeableConcept\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"ReferralRequest.patient\",\
		\"weight\": 4420,\
		\"max\": \"1\",\
		\"type\": \"Reference\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"ReferralRequest.context\",\
		\"weight\": 4421,\
		\"max\": \"1\",\
		\"type\": \"Reference\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"ReferralRequest.fulfillmentTime\",\
		\"weight\": 4422,\
		\"max\": \"1\",\
		\"type\": \"Period\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"ReferralRequest.authored\",\
		\"weight\": 4423,\
		\"max\": \"1\",\
		\"type\": \"dateTime\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"ReferralRequest.requester\",\
		\"weight\": 4424,\
		\"max\": \"1\",\
		\"type\": \"Reference\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"ReferralRequest.specialty\",\
		\"weight\": 4425,\
		\"max\": \"1\",\
		\"type\": \"CodeableConcept\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"ReferralRequest.recipient\",\
		\"weight\": 4426,\
		\"max\": \"*\",\
		\"type\": \"Reference\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"ReferralRequest.reason\",\
		\"weight\": 4427,\
		\"max\": \"1\",\
		\"type\": \"CodeableConcept\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"ReferralRequest.description\",\
		\"weight\": 4428,\
		\"max\": \"1\",\
		\"type\": \"string\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"ReferralRequest.serviceRequested\",\
		\"weight\": 4429,\
		\"max\": \"*\",\
		\"type\": \"CodeableConcept\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"ReferralRequest.supportingInformation\",\
		\"weight\": 4430,\
		\"max\": \"*\",\
		\"type\": \"Reference\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"RelatedPerson\",\
		\"weight\": 4431,\
		\"max\": \"*\",\
		\"type\": \"DomainResource\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"RelatedPerson.id\",\
		\"weight\": 4432,\
		\"max\": \"1\",\
		\"type\": \"id\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"RelatedPerson.meta\",\
		\"weight\": 4433,\
		\"max\": \"1\",\
		\"type\": \"Meta\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"RelatedPerson.implicitRules\",\
		\"weight\": 4434,\
		\"max\": \"1\",\
		\"type\": \"uri\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"RelatedPerson.language\",\
		\"weight\": 4435,\
		\"max\": \"1\",\
		\"type\": \"code\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"RelatedPerson.text\",\
		\"weight\": 4436,\
		\"max\": \"1\",\
		\"type\": \"Narrative\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"RelatedPerson.contained\",\
		\"weight\": 4437,\
		\"max\": \"*\",\
		\"type\": \"Resource\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"RelatedPerson.extension\",\
		\"weight\": 4438,\
		\"max\": \"*\",\
		\"type\": \"Extension\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"RelatedPerson.modifierExtension\",\
		\"weight\": 4439,\
		\"max\": \"*\",\
		\"type\": \"Extension\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"RelatedPerson.identifier\",\
		\"weight\": 4440,\
		\"max\": \"*\",\
		\"type\": \"Identifier\"\
	},\
	{\
		\"min\": \"1\",\
		\"path\": \"RelatedPerson.patient\",\
		\"weight\": 4441,\
		\"max\": \"1\",\
		\"type\": \"Reference\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"RelatedPerson.relationship\",\
		\"weight\": 4442,\
		\"max\": \"1\",\
		\"type\": \"CodeableConcept\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"RelatedPerson.name\",\
		\"weight\": 4443,\
		\"max\": \"1\",\
		\"type\": \"HumanName\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"RelatedPerson.telecom\",\
		\"weight\": 4444,\
		\"max\": \"*\",\
		\"type\": \"ContactPoint\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"RelatedPerson.gender\",\
		\"weight\": 4445,\
		\"max\": \"1\",\
		\"type\": \"code\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"RelatedPerson.birthDate\",\
		\"weight\": 4446,\
		\"max\": \"1\",\
		\"type\": \"date\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"RelatedPerson.address\",\
		\"weight\": 4447,\
		\"max\": \"*\",\
		\"type\": \"Address\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"RelatedPerson.photo\",\
		\"weight\": 4448,\
		\"max\": \"*\",\
		\"type\": \"Attachment\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"RelatedPerson.period\",\
		\"weight\": 4449,\
		\"max\": \"1\",\
		\"type\": \"Period\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"RiskAssessment\",\
		\"weight\": 4450,\
		\"max\": \"*\",\
		\"type\": \"DomainResource\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"RiskAssessment.id\",\
		\"weight\": 4451,\
		\"max\": \"1\",\
		\"type\": \"id\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"RiskAssessment.meta\",\
		\"weight\": 4452,\
		\"max\": \"1\",\
		\"type\": \"Meta\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"RiskAssessment.implicitRules\",\
		\"weight\": 4453,\
		\"max\": \"1\",\
		\"type\": \"uri\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"RiskAssessment.language\",\
		\"weight\": 4454,\
		\"max\": \"1\",\
		\"type\": \"code\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"RiskAssessment.text\",\
		\"weight\": 4455,\
		\"max\": \"1\",\
		\"type\": \"Narrative\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"RiskAssessment.contained\",\
		\"weight\": 4456,\
		\"max\": \"*\",\
		\"type\": \"Resource\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"RiskAssessment.extension\",\
		\"weight\": 4457,\
		\"max\": \"*\",\
		\"type\": \"Extension\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"RiskAssessment.modifierExtension\",\
		\"weight\": 4458,\
		\"max\": \"*\",\
		\"type\": \"Extension\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"RiskAssessment.subject\",\
		\"weight\": 4459,\
		\"max\": \"1\",\
		\"type\": \"Reference\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"RiskAssessment.date\",\
		\"weight\": 4460,\
		\"max\": \"1\",\
		\"type\": \"dateTime\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"RiskAssessment.condition\",\
		\"weight\": 4461,\
		\"max\": \"1\",\
		\"type\": \"Reference\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"RiskAssessment.encounter\",\
		\"weight\": 4462,\
		\"max\": \"1\",\
		\"type\": \"Reference\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"RiskAssessment.performer\",\
		\"weight\": 4463,\
		\"max\": \"1\",\
		\"type\": \"Reference\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"RiskAssessment.identifier\",\
		\"weight\": 4464,\
		\"max\": \"1\",\
		\"type\": \"Identifier\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"RiskAssessment.method\",\
		\"weight\": 4465,\
		\"max\": \"1\",\
		\"type\": \"CodeableConcept\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"RiskAssessment.basis\",\
		\"weight\": 4466,\
		\"max\": \"*\",\
		\"type\": \"Reference\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"RiskAssessment.prediction\",\
		\"weight\": 4467,\
		\"max\": \"*\",\
		\"type\": \"BackboneElement\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"RiskAssessment.prediction.id\",\
		\"weight\": 4468,\
		\"max\": \"1\",\
		\"type\": \"id\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"RiskAssessment.prediction.extension\",\
		\"weight\": 4469,\
		\"max\": \"*\",\
		\"type\": \"Extension\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"RiskAssessment.prediction.modifierExtension\",\
		\"weight\": 4470,\
		\"max\": \"*\",\
		\"type\": \"Extension\"\
	},\
	{\
		\"min\": \"1\",\
		\"path\": \"RiskAssessment.prediction.outcome\",\
		\"weight\": 4471,\
		\"max\": \"1\",\
		\"type\": \"CodeableConcept\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"RiskAssessment.prediction.probabilityDecimal\",\
		\"weight\": 4472,\
		\"max\": \"1\",\
		\"type\": \"decimal\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"RiskAssessment.prediction.probabilityRange\",\
		\"weight\": 4472,\
		\"max\": \"1\",\
		\"type\": \"Range\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"RiskAssessment.prediction.probabilityCodeableConcept\",\
		\"weight\": 4472,\
		\"max\": \"1\",\
		\"type\": \"CodeableConcept\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"RiskAssessment.prediction.relativeRisk\",\
		\"weight\": 4473,\
		\"max\": \"1\",\
		\"type\": \"decimal\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"RiskAssessment.prediction.whenPeriod\",\
		\"weight\": 4474,\
		\"max\": \"1\",\
		\"type\": \"Period\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"RiskAssessment.prediction.whenRange\",\
		\"weight\": 4474,\
		\"max\": \"1\",\
		\"type\": \"Range\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"RiskAssessment.prediction.rationale\",\
		\"weight\": 4475,\
		\"max\": \"1\",\
		\"type\": \"string\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"RiskAssessment.mitigation\",\
		\"weight\": 4476,\
		\"max\": \"1\",\
		\"type\": \"string\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Schedule\",\
		\"weight\": 4477,\
		\"max\": \"*\",\
		\"type\": \"DomainResource\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Schedule.id\",\
		\"weight\": 4478,\
		\"max\": \"1\",\
		\"type\": \"id\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Schedule.meta\",\
		\"weight\": 4479,\
		\"max\": \"1\",\
		\"type\": \"Meta\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Schedule.implicitRules\",\
		\"weight\": 4480,\
		\"max\": \"1\",\
		\"type\": \"uri\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Schedule.language\",\
		\"weight\": 4481,\
		\"max\": \"1\",\
		\"type\": \"code\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Schedule.text\",\
		\"weight\": 4482,\
		\"max\": \"1\",\
		\"type\": \"Narrative\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Schedule.contained\",\
		\"weight\": 4483,\
		\"max\": \"*\",\
		\"type\": \"Resource\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Schedule.extension\",\
		\"weight\": 4484,\
		\"max\": \"*\",\
		\"type\": \"Extension\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Schedule.modifierExtension\",\
		\"weight\": 4485,\
		\"max\": \"*\",\
		\"type\": \"Extension\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Schedule.identifier\",\
		\"weight\": 4486,\
		\"max\": \"*\",\
		\"type\": \"Identifier\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Schedule.serviceCategory\",\
		\"weight\": 4487,\
		\"max\": \"1\",\
		\"type\": \"CodeableConcept\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Schedule.serviceType\",\
		\"weight\": 4488,\
		\"max\": \"*\",\
		\"type\": \"CodeableConcept\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Schedule.specialty\",\
		\"weight\": 4489,\
		\"max\": \"*\",\
		\"type\": \"CodeableConcept\"\
	},\
	{\
		\"min\": \"1\",\
		\"path\": \"Schedule.actor\",\
		\"weight\": 4490,\
		\"max\": \"1\",\
		\"type\": \"Reference\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Schedule.planningHorizon\",\
		\"weight\": 4491,\
		\"max\": \"1\",\
		\"type\": \"Period\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Schedule.comment\",\
		\"weight\": 4492,\
		\"max\": \"1\",\
		\"type\": \"string\"\
	},\
	{\
		\"min\": \"1\",\
		\"path\": \"SearchParameter\",\
		\"weight\": 4493,\
		\"max\": \"1\",\
		\"type\": \"DomainResource\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"SearchParameter.id\",\
		\"weight\": 4494,\
		\"max\": \"1\",\
		\"type\": \"id\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"SearchParameter.meta\",\
		\"weight\": 4495,\
		\"max\": \"1\",\
		\"type\": \"Meta\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"SearchParameter.implicitRules\",\
		\"weight\": 4496,\
		\"max\": \"1\",\
		\"type\": \"uri\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"SearchParameter.language\",\
		\"weight\": 4497,\
		\"max\": \"1\",\
		\"type\": \"code\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"SearchParameter.text\",\
		\"weight\": 4498,\
		\"max\": \"1\",\
		\"type\": \"Narrative\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"SearchParameter.contained\",\
		\"weight\": 4499,\
		\"max\": \"*\",\
		\"type\": \"Resource\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"SearchParameter.extension\",\
		\"weight\": 4500,\
		\"max\": \"*\",\
		\"type\": \"Extension\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"SearchParameter.modifierExtension\",\
		\"weight\": 4501,\
		\"max\": \"*\",\
		\"type\": \"Extension\"\
	},\
	{\
		\"min\": \"1\",\
		\"path\": \"SearchParameter.url\",\
		\"weight\": 4502,\
		\"max\": \"1\",\
		\"type\": \"uri\"\
	},\
	{\
		\"min\": \"1\",\
		\"path\": \"SearchParameter.name\",\
		\"weight\": 4503,\
		\"max\": \"1\",\
		\"type\": \"string\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"SearchParameter.status\",\
		\"weight\": 4504,\
		\"max\": \"1\",\
		\"type\": \"code\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"SearchParameter.experimental\",\
		\"weight\": 4505,\
		\"max\": \"1\",\
		\"type\": \"boolean\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"SearchParameter.date\",\
		\"weight\": 4506,\
		\"max\": \"1\",\
		\"type\": \"dateTime\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"SearchParameter.publisher\",\
		\"weight\": 4507,\
		\"max\": \"1\",\
		\"type\": \"string\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"SearchParameter.contact\",\
		\"weight\": 4508,\
		\"max\": \"*\",\
		\"type\": \"BackboneElement\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"SearchParameter.contact.id\",\
		\"weight\": 4509,\
		\"max\": \"1\",\
		\"type\": \"id\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"SearchParameter.contact.extension\",\
		\"weight\": 4510,\
		\"max\": \"*\",\
		\"type\": \"Extension\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"SearchParameter.contact.modifierExtension\",\
		\"weight\": 4511,\
		\"max\": \"*\",\
		\"type\": \"Extension\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"SearchParameter.contact.name\",\
		\"weight\": 4512,\
		\"max\": \"1\",\
		\"type\": \"string\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"SearchParameter.contact.telecom\",\
		\"weight\": 4513,\
		\"max\": \"*\",\
		\"type\": \"ContactPoint\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"SearchParameter.useContext\",\
		\"weight\": 4514,\
		\"max\": \"*\",\
		\"type\": \"CodeableConcept\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"SearchParameter.requirements\",\
		\"weight\": 4515,\
		\"max\": \"1\",\
		\"type\": \"string\"\
	},\
	{\
		\"min\": \"1\",\
		\"path\": \"SearchParameter.code\",\
		\"weight\": 4516,\
		\"max\": \"1\",\
		\"type\": \"code\"\
	},\
	{\
		\"min\": \"1\",\
		\"path\": \"SearchParameter.base\",\
		\"weight\": 4517,\
		\"max\": \"1\",\
		\"type\": \"code\"\
	},\
	{\
		\"min\": \"1\",\
		\"path\": \"SearchParameter.type\",\
		\"weight\": 4518,\
		\"max\": \"1\",\
		\"type\": \"code\"\
	},\
	{\
		\"min\": \"1\",\
		\"path\": \"SearchParameter.description\",\
		\"weight\": 4519,\
		\"max\": \"1\",\
		\"type\": \"string\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"SearchParameter.expression\",\
		\"weight\": 4520,\
		\"max\": \"1\",\
		\"type\": \"string\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"SearchParameter.xpath\",\
		\"weight\": 4521,\
		\"max\": \"1\",\
		\"type\": \"string\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"SearchParameter.xpathUsage\",\
		\"weight\": 4522,\
		\"max\": \"1\",\
		\"type\": \"code\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"SearchParameter.target\",\
		\"weight\": 4523,\
		\"max\": \"*\",\
		\"type\": \"code\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Sequence\",\
		\"weight\": 4524,\
		\"max\": \"*\",\
		\"type\": \"DomainResource\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Sequence.id\",\
		\"weight\": 4525,\
		\"max\": \"1\",\
		\"type\": \"id\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Sequence.meta\",\
		\"weight\": 4526,\
		\"max\": \"1\",\
		\"type\": \"Meta\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Sequence.implicitRules\",\
		\"weight\": 4527,\
		\"max\": \"1\",\
		\"type\": \"uri\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Sequence.language\",\
		\"weight\": 4528,\
		\"max\": \"1\",\
		\"type\": \"code\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Sequence.text\",\
		\"weight\": 4529,\
		\"max\": \"1\",\
		\"type\": \"Narrative\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Sequence.contained\",\
		\"weight\": 4530,\
		\"max\": \"*\",\
		\"type\": \"Resource\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Sequence.extension\",\
		\"weight\": 4531,\
		\"max\": \"*\",\
		\"type\": \"Extension\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Sequence.modifierExtension\",\
		\"weight\": 4532,\
		\"max\": \"*\",\
		\"type\": \"Extension\"\
	},\
	{\
		\"min\": \"1\",\
		\"path\": \"Sequence.type\",\
		\"weight\": 4533,\
		\"max\": \"1\",\
		\"type\": \"code\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Sequence.patient\",\
		\"weight\": 4534,\
		\"max\": \"1\",\
		\"type\": \"Reference\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Sequence.specimen\",\
		\"weight\": 4535,\
		\"max\": \"1\",\
		\"type\": \"Reference\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Sequence.device\",\
		\"weight\": 4536,\
		\"max\": \"1\",\
		\"type\": \"Reference\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Sequence.quantity\",\
		\"weight\": 4537,\
		\"max\": \"1\",\
		\"type\": \"Quantity\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Sequence.species\",\
		\"weight\": 4538,\
		\"max\": \"1\",\
		\"type\": \"CodeableConcept\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Sequence.referenceSeq\",\
		\"weight\": 4539,\
		\"max\": \"*\",\
		\"type\": \"BackboneElement\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Sequence.referenceSeq.id\",\
		\"weight\": 4540,\
		\"max\": \"1\",\
		\"type\": \"id\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Sequence.referenceSeq.extension\",\
		\"weight\": 4541,\
		\"max\": \"*\",\
		\"type\": \"Extension\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Sequence.referenceSeq.modifierExtension\",\
		\"weight\": 4542,\
		\"max\": \"*\",\
		\"type\": \"Extension\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Sequence.referenceSeq.chromosome\",\
		\"weight\": 4543,\
		\"max\": \"1\",\
		\"type\": \"CodeableConcept\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Sequence.referenceSeq.genomeBuild\",\
		\"weight\": 4544,\
		\"max\": \"1\",\
		\"type\": \"string\"\
	},\
	{\
		\"min\": \"1\",\
		\"path\": \"Sequence.referenceSeq.referenceSeqId\",\
		\"weight\": 4545,\
		\"max\": \"1\",\
		\"type\": \"CodeableConcept\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Sequence.referenceSeq.referenceSeqPointer\",\
		\"weight\": 4546,\
		\"max\": \"1\",\
		\"type\": \"Reference\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Sequence.referenceSeq.referenceSeqString\",\
		\"weight\": 4547,\
		\"max\": \"1\",\
		\"type\": \"string\"\
	},\
	{\
		\"min\": \"1\",\
		\"path\": \"Sequence.referenceSeq.windowStart\",\
		\"weight\": 4548,\
		\"max\": \"1\",\
		\"type\": \"integer\"\
	},\
	{\
		\"min\": \"1\",\
		\"path\": \"Sequence.referenceSeq.windowEnd\",\
		\"weight\": 4549,\
		\"max\": \"1\",\
		\"type\": \"integer\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Sequence.variation\",\
		\"weight\": 4550,\
		\"max\": \"1\",\
		\"type\": \"BackboneElement\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Sequence.variation.id\",\
		\"weight\": 4551,\
		\"max\": \"1\",\
		\"type\": \"id\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Sequence.variation.extension\",\
		\"weight\": 4552,\
		\"max\": \"*\",\
		\"type\": \"Extension\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Sequence.variation.modifierExtension\",\
		\"weight\": 4553,\
		\"max\": \"*\",\
		\"type\": \"Extension\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Sequence.variation.start\",\
		\"weight\": 4554,\
		\"max\": \"1\",\
		\"type\": \"integer\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Sequence.variation.end\",\
		\"weight\": 4555,\
		\"max\": \"1\",\
		\"type\": \"integer\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Sequence.variation.observedAllele\",\
		\"weight\": 4556,\
		\"max\": \"1\",\
		\"type\": \"string\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Sequence.variation.referenceAllele\",\
		\"weight\": 4557,\
		\"max\": \"1\",\
		\"type\": \"string\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Sequence.variation.cigar\",\
		\"weight\": 4558,\
		\"max\": \"1\",\
		\"type\": \"string\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Sequence.quality\",\
		\"weight\": 4559,\
		\"max\": \"*\",\
		\"type\": \"BackboneElement\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Sequence.quality.id\",\
		\"weight\": 4560,\
		\"max\": \"1\",\
		\"type\": \"id\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Sequence.quality.extension\",\
		\"weight\": 4561,\
		\"max\": \"*\",\
		\"type\": \"Extension\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Sequence.quality.modifierExtension\",\
		\"weight\": 4562,\
		\"max\": \"*\",\
		\"type\": \"Extension\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Sequence.quality.start\",\
		\"weight\": 4563,\
		\"max\": \"1\",\
		\"type\": \"integer\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Sequence.quality.end\",\
		\"weight\": 4564,\
		\"max\": \"1\",\
		\"type\": \"integer\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Sequence.quality.score\",\
		\"weight\": 4565,\
		\"max\": \"1\",\
		\"type\": \"Quantity\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Sequence.quality.method\",\
		\"weight\": 4566,\
		\"max\": \"1\",\
		\"type\": \"string\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Sequence.allelicState\",\
		\"weight\": 4567,\
		\"max\": \"1\",\
		\"type\": \"CodeableConcept\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Sequence.allelicFrequency\",\
		\"weight\": 4568,\
		\"max\": \"1\",\
		\"type\": \"decimal\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Sequence.copyNumberEvent\",\
		\"weight\": 4569,\
		\"max\": \"1\",\
		\"type\": \"CodeableConcept\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Sequence.readCoverage\",\
		\"weight\": 4570,\
		\"max\": \"1\",\
		\"type\": \"integer\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Sequence.repository\",\
		\"weight\": 4571,\
		\"max\": \"*\",\
		\"type\": \"BackboneElement\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Sequence.repository.id\",\
		\"weight\": 4572,\
		\"max\": \"1\",\
		\"type\": \"id\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Sequence.repository.extension\",\
		\"weight\": 4573,\
		\"max\": \"*\",\
		\"type\": \"Extension\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Sequence.repository.modifierExtension\",\
		\"weight\": 4574,\
		\"max\": \"*\",\
		\"type\": \"Extension\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Sequence.repository.url\",\
		\"weight\": 4575,\
		\"max\": \"1\",\
		\"type\": \"uri\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Sequence.repository.name\",\
		\"weight\": 4576,\
		\"max\": \"1\",\
		\"type\": \"string\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Sequence.repository.variantId\",\
		\"weight\": 4577,\
		\"max\": \"1\",\
		\"type\": \"string\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Sequence.repository.readId\",\
		\"weight\": 4578,\
		\"max\": \"1\",\
		\"type\": \"string\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Sequence.pointer\",\
		\"weight\": 4579,\
		\"max\": \"*\",\
		\"type\": \"Reference\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Sequence.observedSeq\",\
		\"weight\": 4580,\
		\"max\": \"1\",\
		\"type\": \"string\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Sequence.observation\",\
		\"weight\": 4581,\
		\"max\": \"1\",\
		\"type\": \"Reference\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Sequence.structureVariation\",\
		\"weight\": 4582,\
		\"max\": \"1\",\
		\"type\": \"BackboneElement\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Sequence.structureVariation.id\",\
		\"weight\": 4583,\
		\"max\": \"1\",\
		\"type\": \"id\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Sequence.structureVariation.extension\",\
		\"weight\": 4584,\
		\"max\": \"*\",\
		\"type\": \"Extension\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Sequence.structureVariation.modifierExtension\",\
		\"weight\": 4585,\
		\"max\": \"*\",\
		\"type\": \"Extension\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Sequence.structureVariation.precisionOfBoundaries\",\
		\"weight\": 4586,\
		\"max\": \"1\",\
		\"type\": \"string\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Sequence.structureVariation.reportedaCGHRatio\",\
		\"weight\": 4587,\
		\"max\": \"1\",\
		\"type\": \"decimal\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Sequence.structureVariation.length\",\
		\"weight\": 4588,\
		\"max\": \"1\",\
		\"type\": \"integer\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Sequence.structureVariation.outer\",\
		\"weight\": 4589,\
		\"max\": \"1\",\
		\"type\": \"BackboneElement\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Sequence.structureVariation.outer.id\",\
		\"weight\": 4590,\
		\"max\": \"1\",\
		\"type\": \"id\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Sequence.structureVariation.outer.extension\",\
		\"weight\": 4591,\
		\"max\": \"*\",\
		\"type\": \"Extension\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Sequence.structureVariation.outer.modifierExtension\",\
		\"weight\": 4592,\
		\"max\": \"*\",\
		\"type\": \"Extension\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Sequence.structureVariation.outer.start\",\
		\"weight\": 4593,\
		\"max\": \"1\",\
		\"type\": \"integer\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Sequence.structureVariation.outer.end\",\
		\"weight\": 4594,\
		\"max\": \"1\",\
		\"type\": \"integer\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Sequence.structureVariation.inner\",\
		\"weight\": 4595,\
		\"max\": \"1\",\
		\"type\": \"BackboneElement\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Sequence.structureVariation.inner.id\",\
		\"weight\": 4596,\
		\"max\": \"1\",\
		\"type\": \"id\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Sequence.structureVariation.inner.extension\",\
		\"weight\": 4597,\
		\"max\": \"*\",\
		\"type\": \"Extension\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Sequence.structureVariation.inner.modifierExtension\",\
		\"weight\": 4598,\
		\"max\": \"*\",\
		\"type\": \"Extension\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Sequence.structureVariation.inner.start\",\
		\"weight\": 4599,\
		\"max\": \"1\",\
		\"type\": \"integer\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Sequence.structureVariation.inner.end\",\
		\"weight\": 4600,\
		\"max\": \"1\",\
		\"type\": \"integer\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Slot\",\
		\"weight\": 4601,\
		\"max\": \"*\",\
		\"type\": \"DomainResource\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Slot.id\",\
		\"weight\": 4602,\
		\"max\": \"1\",\
		\"type\": \"id\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Slot.meta\",\
		\"weight\": 4603,\
		\"max\": \"1\",\
		\"type\": \"Meta\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Slot.implicitRules\",\
		\"weight\": 4604,\
		\"max\": \"1\",\
		\"type\": \"uri\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Slot.language\",\
		\"weight\": 4605,\
		\"max\": \"1\",\
		\"type\": \"code\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Slot.text\",\
		\"weight\": 4606,\
		\"max\": \"1\",\
		\"type\": \"Narrative\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Slot.contained\",\
		\"weight\": 4607,\
		\"max\": \"*\",\
		\"type\": \"Resource\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Slot.extension\",\
		\"weight\": 4608,\
		\"max\": \"*\",\
		\"type\": \"Extension\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Slot.modifierExtension\",\
		\"weight\": 4609,\
		\"max\": \"*\",\
		\"type\": \"Extension\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Slot.identifier\",\
		\"weight\": 4610,\
		\"max\": \"*\",\
		\"type\": \"Identifier\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Slot.serviceCategory\",\
		\"weight\": 4611,\
		\"max\": \"1\",\
		\"type\": \"CodeableConcept\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Slot.serviceType\",\
		\"weight\": 4612,\
		\"max\": \"*\",\
		\"type\": \"CodeableConcept\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Slot.specialty\",\
		\"weight\": 4613,\
		\"max\": \"*\",\
		\"type\": \"CodeableConcept\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Slot.appointmentType\",\
		\"weight\": 4614,\
		\"max\": \"1\",\
		\"type\": \"CodeableConcept\"\
	},\
	{\
		\"min\": \"1\",\
		\"path\": \"Slot.schedule\",\
		\"weight\": 4615,\
		\"max\": \"1\",\
		\"type\": \"Reference\"\
	},\
	{\
		\"min\": \"1\",\
		\"path\": \"Slot.status\",\
		\"weight\": 4616,\
		\"max\": \"1\",\
		\"type\": \"code\"\
	},\
	{\
		\"min\": \"1\",\
		\"path\": \"Slot.start\",\
		\"weight\": 4617,\
		\"max\": \"1\",\
		\"type\": \"instant\"\
	},\
	{\
		\"min\": \"1\",\
		\"path\": \"Slot.end\",\
		\"weight\": 4618,\
		\"max\": \"1\",\
		\"type\": \"instant\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Slot.overbooked\",\
		\"weight\": 4619,\
		\"max\": \"1\",\
		\"type\": \"boolean\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Slot.comment\",\
		\"weight\": 4620,\
		\"max\": \"1\",\
		\"type\": \"string\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Specimen\",\
		\"weight\": 4621,\
		\"max\": \"*\",\
		\"type\": \"DomainResource\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Specimen.id\",\
		\"weight\": 4622,\
		\"max\": \"1\",\
		\"type\": \"id\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Specimen.meta\",\
		\"weight\": 4623,\
		\"max\": \"1\",\
		\"type\": \"Meta\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Specimen.implicitRules\",\
		\"weight\": 4624,\
		\"max\": \"1\",\
		\"type\": \"uri\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Specimen.language\",\
		\"weight\": 4625,\
		\"max\": \"1\",\
		\"type\": \"code\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Specimen.text\",\
		\"weight\": 4626,\
		\"max\": \"1\",\
		\"type\": \"Narrative\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Specimen.contained\",\
		\"weight\": 4627,\
		\"max\": \"*\",\
		\"type\": \"Resource\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Specimen.extension\",\
		\"weight\": 4628,\
		\"max\": \"*\",\
		\"type\": \"Extension\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Specimen.modifierExtension\",\
		\"weight\": 4629,\
		\"max\": \"*\",\
		\"type\": \"Extension\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Specimen.identifier\",\
		\"weight\": 4630,\
		\"max\": \"*\",\
		\"type\": \"Identifier\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Specimen.accessionIdentifier\",\
		\"weight\": 4631,\
		\"max\": \"1\",\
		\"type\": \"Identifier\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Specimen.status\",\
		\"weight\": 4632,\
		\"max\": \"1\",\
		\"type\": \"code\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Specimen.type\",\
		\"weight\": 4633,\
		\"max\": \"1\",\
		\"type\": \"CodeableConcept\"\
	},\
	{\
		\"min\": \"1\",\
		\"path\": \"Specimen.subject\",\
		\"weight\": 4634,\
		\"max\": \"1\",\
		\"type\": \"Reference\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Specimen.receivedTime\",\
		\"weight\": 4635,\
		\"max\": \"1\",\
		\"type\": \"dateTime\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Specimen.parent\",\
		\"weight\": 4636,\
		\"max\": \"*\",\
		\"type\": \"Reference\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Specimen.collection\",\
		\"weight\": 4637,\
		\"max\": \"1\",\
		\"type\": \"BackboneElement\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Specimen.collection.id\",\
		\"weight\": 4638,\
		\"max\": \"1\",\
		\"type\": \"id\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Specimen.collection.extension\",\
		\"weight\": 4639,\
		\"max\": \"*\",\
		\"type\": \"Extension\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Specimen.collection.modifierExtension\",\
		\"weight\": 4640,\
		\"max\": \"*\",\
		\"type\": \"Extension\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Specimen.collection.collector\",\
		\"weight\": 4641,\
		\"max\": \"1\",\
		\"type\": \"Reference\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Specimen.collection.comment\",\
		\"weight\": 4642,\
		\"max\": \"1\",\
		\"type\": \"string\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Specimen.collection.collectedDateTime\",\
		\"weight\": 4643,\
		\"max\": \"1\",\
		\"type\": \"dateTime\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Specimen.collection.collectedPeriod\",\
		\"weight\": 4643,\
		\"max\": \"1\",\
		\"type\": \"Period\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Specimen.collection.quantity\",\
		\"weight\": 4644,\
		\"max\": \"1\",\
		\"type\": \"Quantity\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Specimen.collection.method\",\
		\"weight\": 4645,\
		\"max\": \"1\",\
		\"type\": \"CodeableConcept\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Specimen.collection.bodySite\",\
		\"weight\": 4646,\
		\"max\": \"1\",\
		\"type\": \"CodeableConcept\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Specimen.treatment\",\
		\"weight\": 4647,\
		\"max\": \"*\",\
		\"type\": \"BackboneElement\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Specimen.treatment.id\",\
		\"weight\": 4648,\
		\"max\": \"1\",\
		\"type\": \"id\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Specimen.treatment.extension\",\
		\"weight\": 4649,\
		\"max\": \"*\",\
		\"type\": \"Extension\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Specimen.treatment.modifierExtension\",\
		\"weight\": 4650,\
		\"max\": \"*\",\
		\"type\": \"Extension\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Specimen.treatment.description\",\
		\"weight\": 4651,\
		\"max\": \"1\",\
		\"type\": \"string\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Specimen.treatment.procedure\",\
		\"weight\": 4652,\
		\"max\": \"1\",\
		\"type\": \"CodeableConcept\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Specimen.treatment.additive\",\
		\"weight\": 4653,\
		\"max\": \"*\",\
		\"type\": \"Reference\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Specimen.container\",\
		\"weight\": 4654,\
		\"max\": \"*\",\
		\"type\": \"BackboneElement\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Specimen.container.id\",\
		\"weight\": 4655,\
		\"max\": \"1\",\
		\"type\": \"id\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Specimen.container.extension\",\
		\"weight\": 4656,\
		\"max\": \"*\",\
		\"type\": \"Extension\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Specimen.container.modifierExtension\",\
		\"weight\": 4657,\
		\"max\": \"*\",\
		\"type\": \"Extension\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Specimen.container.identifier\",\
		\"weight\": 4658,\
		\"max\": \"*\",\
		\"type\": \"Identifier\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Specimen.container.description\",\
		\"weight\": 4659,\
		\"max\": \"1\",\
		\"type\": \"string\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Specimen.container.type\",\
		\"weight\": 4660,\
		\"max\": \"1\",\
		\"type\": \"CodeableConcept\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Specimen.container.capacity\",\
		\"weight\": 4661,\
		\"max\": \"1\",\
		\"type\": \"Quantity\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Specimen.container.specimenQuantity\",\
		\"weight\": 4662,\
		\"max\": \"1\",\
		\"type\": \"Quantity\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Specimen.container.additiveCodeableConcept\",\
		\"weight\": 4663,\
		\"max\": \"1\",\
		\"type\": \"CodeableConcept\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Specimen.container.additiveReference\",\
		\"weight\": 4663,\
		\"max\": \"1\",\
		\"type\": \"Reference\"\
	},\
	{\
		\"min\": \"1\",\
		\"path\": \"StructureDefinition\",\
		\"weight\": 4664,\
		\"max\": \"1\",\
		\"type\": \"DomainResource\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"StructureDefinition.id\",\
		\"weight\": 4665,\
		\"max\": \"1\",\
		\"type\": \"id\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"StructureDefinition.meta\",\
		\"weight\": 4666,\
		\"max\": \"1\",\
		\"type\": \"Meta\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"StructureDefinition.implicitRules\",\
		\"weight\": 4667,\
		\"max\": \"1\",\
		\"type\": \"uri\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"StructureDefinition.language\",\
		\"weight\": 4668,\
		\"max\": \"1\",\
		\"type\": \"code\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"StructureDefinition.text\",\
		\"weight\": 4669,\
		\"max\": \"1\",\
		\"type\": \"Narrative\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"StructureDefinition.contained\",\
		\"weight\": 4670,\
		\"max\": \"*\",\
		\"type\": \"Resource\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"StructureDefinition.extension\",\
		\"weight\": 4671,\
		\"max\": \"*\",\
		\"type\": \"Extension\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"StructureDefinition.modifierExtension\",\
		\"weight\": 4672,\
		\"max\": \"*\",\
		\"type\": \"Extension\"\
	},\
	{\
		\"min\": \"1\",\
		\"path\": \"StructureDefinition.url\",\
		\"weight\": 4673,\
		\"max\": \"1\",\
		\"type\": \"uri\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"StructureDefinition.identifier\",\
		\"weight\": 4674,\
		\"max\": \"*\",\
		\"type\": \"Identifier\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"StructureDefinition.version\",\
		\"weight\": 4675,\
		\"max\": \"1\",\
		\"type\": \"string\"\
	},\
	{\
		\"min\": \"1\",\
		\"path\": \"StructureDefinition.name\",\
		\"weight\": 4676,\
		\"max\": \"1\",\
		\"type\": \"string\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"StructureDefinition.display\",\
		\"weight\": 4677,\
		\"max\": \"1\",\
		\"type\": \"string\"\
	},\
	{\
		\"min\": \"1\",\
		\"path\": \"StructureDefinition.status\",\
		\"weight\": 4678,\
		\"max\": \"1\",\
		\"type\": \"code\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"StructureDefinition.experimental\",\
		\"weight\": 4679,\
		\"max\": \"1\",\
		\"type\": \"boolean\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"StructureDefinition.publisher\",\
		\"weight\": 4680,\
		\"max\": \"1\",\
		\"type\": \"string\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"StructureDefinition.contact\",\
		\"weight\": 4681,\
		\"max\": \"*\",\
		\"type\": \"BackboneElement\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"StructureDefinition.contact.id\",\
		\"weight\": 4682,\
		\"max\": \"1\",\
		\"type\": \"id\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"StructureDefinition.contact.extension\",\
		\"weight\": 4683,\
		\"max\": \"*\",\
		\"type\": \"Extension\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"StructureDefinition.contact.modifierExtension\",\
		\"weight\": 4684,\
		\"max\": \"*\",\
		\"type\": \"Extension\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"StructureDefinition.contact.name\",\
		\"weight\": 4685,\
		\"max\": \"1\",\
		\"type\": \"string\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"StructureDefinition.contact.telecom\",\
		\"weight\": 4686,\
		\"max\": \"*\",\
		\"type\": \"ContactPoint\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"StructureDefinition.date\",\
		\"weight\": 4687,\
		\"max\": \"1\",\
		\"type\": \"dateTime\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"StructureDefinition.description\",\
		\"weight\": 4688,\
		\"max\": \"1\",\
		\"type\": \"string\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"StructureDefinition.useContext\",\
		\"weight\": 4689,\
		\"max\": \"*\",\
		\"type\": \"CodeableConcept\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"StructureDefinition.requirements\",\
		\"weight\": 4690,\
		\"max\": \"1\",\
		\"type\": \"string\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"StructureDefinition.copyright\",\
		\"weight\": 4691,\
		\"max\": \"1\",\
		\"type\": \"string\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"StructureDefinition.code\",\
		\"weight\": 4692,\
		\"max\": \"*\",\
		\"type\": \"Coding\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"StructureDefinition.fhirVersion\",\
		\"weight\": 4693,\
		\"max\": \"1\",\
		\"type\": \"id\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"StructureDefinition.mapping\",\
		\"weight\": 4694,\
		\"max\": \"*\",\
		\"type\": \"BackboneElement\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"StructureDefinition.mapping.id\",\
		\"weight\": 4695,\
		\"max\": \"1\",\
		\"type\": \"id\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"StructureDefinition.mapping.extension\",\
		\"weight\": 4696,\
		\"max\": \"*\",\
		\"type\": \"Extension\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"StructureDefinition.mapping.modifierExtension\",\
		\"weight\": 4697,\
		\"max\": \"*\",\
		\"type\": \"Extension\"\
	},\
	{\
		\"min\": \"1\",\
		\"path\": \"StructureDefinition.mapping.identity\",\
		\"weight\": 4698,\
		\"max\": \"1\",\
		\"type\": \"id\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"StructureDefinition.mapping.uri\",\
		\"weight\": 4699,\
		\"max\": \"1\",\
		\"type\": \"uri\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"StructureDefinition.mapping.name\",\
		\"weight\": 4700,\
		\"max\": \"1\",\
		\"type\": \"string\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"StructureDefinition.mapping.comments\",\
		\"weight\": 4701,\
		\"max\": \"1\",\
		\"type\": \"string\"\
	},\
	{\
		\"min\": \"1\",\
		\"path\": \"StructureDefinition.kind\",\
		\"weight\": 4702,\
		\"max\": \"1\",\
		\"type\": \"code\"\
	},\
	{\
		\"min\": \"1\",\
		\"path\": \"StructureDefinition.abstract\",\
		\"weight\": 4703,\
		\"max\": \"1\",\
		\"type\": \"boolean\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"StructureDefinition.contextType\",\
		\"weight\": 4704,\
		\"max\": \"1\",\
		\"type\": \"code\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"StructureDefinition.context\",\
		\"weight\": 4705,\
		\"max\": \"*\",\
		\"type\": \"string\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"StructureDefinition.baseType\",\
		\"weight\": 4706,\
		\"max\": \"1\",\
		\"type\": \"code\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"StructureDefinition.baseDefinition\",\
		\"weight\": 4707,\
		\"max\": \"1\",\
		\"type\": \"uri\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"StructureDefinition.derivation\",\
		\"weight\": 4708,\
		\"max\": \"1\",\
		\"type\": \"code\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"StructureDefinition.snapshot\",\
		\"weight\": 4709,\
		\"max\": \"1\",\
		\"type\": \"BackboneElement\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"StructureDefinition.snapshot.id\",\
		\"weight\": 4710,\
		\"max\": \"1\",\
		\"type\": \"id\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"StructureDefinition.snapshot.extension\",\
		\"weight\": 4711,\
		\"max\": \"*\",\
		\"type\": \"Extension\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"StructureDefinition.snapshot.modifierExtension\",\
		\"weight\": 4712,\
		\"max\": \"*\",\
		\"type\": \"Extension\"\
	},\
	{\
		\"min\": \"1\",\
		\"path\": \"StructureDefinition.snapshot.element\",\
		\"weight\": 4713,\
		\"max\": \"*\",\
		\"type\": \"ElementDefinition\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"StructureDefinition.differential\",\
		\"weight\": 4714,\
		\"max\": \"1\",\
		\"type\": \"BackboneElement\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"StructureDefinition.differential.id\",\
		\"weight\": 4715,\
		\"max\": \"1\",\
		\"type\": \"id\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"StructureDefinition.differential.extension\",\
		\"weight\": 4716,\
		\"max\": \"*\",\
		\"type\": \"Extension\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"StructureDefinition.differential.modifierExtension\",\
		\"weight\": 4717,\
		\"max\": \"*\",\
		\"type\": \"Extension\"\
	},\
	{\
		\"min\": \"1\",\
		\"path\": \"StructureDefinition.differential.element\",\
		\"weight\": 4718,\
		\"max\": \"*\",\
		\"type\": \"ElementDefinition\"\
	},\
	{\
		\"min\": \"1\",\
		\"path\": \"StructureMap\",\
		\"weight\": 4719,\
		\"max\": \"1\",\
		\"type\": \"DomainResource\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"StructureMap.id\",\
		\"weight\": 4720,\
		\"max\": \"1\",\
		\"type\": \"id\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"StructureMap.meta\",\
		\"weight\": 4721,\
		\"max\": \"1\",\
		\"type\": \"Meta\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"StructureMap.implicitRules\",\
		\"weight\": 4722,\
		\"max\": \"1\",\
		\"type\": \"uri\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"StructureMap.language\",\
		\"weight\": 4723,\
		\"max\": \"1\",\
		\"type\": \"code\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"StructureMap.text\",\
		\"weight\": 4724,\
		\"max\": \"1\",\
		\"type\": \"Narrative\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"StructureMap.contained\",\
		\"weight\": 4725,\
		\"max\": \"*\",\
		\"type\": \"Resource\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"StructureMap.extension\",\
		\"weight\": 4726,\
		\"max\": \"*\",\
		\"type\": \"Extension\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"StructureMap.modifierExtension\",\
		\"weight\": 4727,\
		\"max\": \"*\",\
		\"type\": \"Extension\"\
	},\
	{\
		\"min\": \"1\",\
		\"path\": \"StructureMap.url\",\
		\"weight\": 4728,\
		\"max\": \"1\",\
		\"type\": \"uri\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"StructureMap.identifier\",\
		\"weight\": 4729,\
		\"max\": \"*\",\
		\"type\": \"Identifier\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"StructureMap.version\",\
		\"weight\": 4730,\
		\"max\": \"1\",\
		\"type\": \"string\"\
	},\
	{\
		\"min\": \"1\",\
		\"path\": \"StructureMap.name\",\
		\"weight\": 4731,\
		\"max\": \"1\",\
		\"type\": \"string\"\
	},\
	{\
		\"min\": \"1\",\
		\"path\": \"StructureMap.status\",\
		\"weight\": 4732,\
		\"max\": \"1\",\
		\"type\": \"code\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"StructureMap.experimental\",\
		\"weight\": 4733,\
		\"max\": \"1\",\
		\"type\": \"boolean\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"StructureMap.publisher\",\
		\"weight\": 4734,\
		\"max\": \"1\",\
		\"type\": \"string\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"StructureMap.contact\",\
		\"weight\": 4735,\
		\"max\": \"*\",\
		\"type\": \"BackboneElement\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"StructureMap.contact.id\",\
		\"weight\": 4736,\
		\"max\": \"1\",\
		\"type\": \"id\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"StructureMap.contact.extension\",\
		\"weight\": 4737,\
		\"max\": \"*\",\
		\"type\": \"Extension\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"StructureMap.contact.modifierExtension\",\
		\"weight\": 4738,\
		\"max\": \"*\",\
		\"type\": \"Extension\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"StructureMap.contact.name\",\
		\"weight\": 4739,\
		\"max\": \"1\",\
		\"type\": \"string\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"StructureMap.contact.telecom\",\
		\"weight\": 4740,\
		\"max\": \"*\",\
		\"type\": \"ContactPoint\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"StructureMap.date\",\
		\"weight\": 4741,\
		\"max\": \"1\",\
		\"type\": \"dateTime\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"StructureMap.description\",\
		\"weight\": 4742,\
		\"max\": \"1\",\
		\"type\": \"string\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"StructureMap.useContext\",\
		\"weight\": 4743,\
		\"max\": \"*\",\
		\"type\": \"CodeableConcept\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"StructureMap.requirements\",\
		\"weight\": 4744,\
		\"max\": \"1\",\
		\"type\": \"string\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"StructureMap.copyright\",\
		\"weight\": 4745,\
		\"max\": \"1\",\
		\"type\": \"string\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"StructureMap.structure\",\
		\"weight\": 4746,\
		\"max\": \"*\",\
		\"type\": \"BackboneElement\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"StructureMap.structure.id\",\
		\"weight\": 4747,\
		\"max\": \"1\",\
		\"type\": \"id\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"StructureMap.structure.extension\",\
		\"weight\": 4748,\
		\"max\": \"*\",\
		\"type\": \"Extension\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"StructureMap.structure.modifierExtension\",\
		\"weight\": 4749,\
		\"max\": \"*\",\
		\"type\": \"Extension\"\
	},\
	{\
		\"min\": \"1\",\
		\"path\": \"StructureMap.structure.url\",\
		\"weight\": 4750,\
		\"max\": \"1\",\
		\"type\": \"uri\"\
	},\
	{\
		\"min\": \"1\",\
		\"path\": \"StructureMap.structure.mode\",\
		\"weight\": 4751,\
		\"max\": \"1\",\
		\"type\": \"code\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"StructureMap.structure.documentation\",\
		\"weight\": 4752,\
		\"max\": \"1\",\
		\"type\": \"string\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"StructureMap.import\",\
		\"weight\": 4753,\
		\"max\": \"*\",\
		\"type\": \"uri\"\
	},\
	{\
		\"min\": \"1\",\
		\"path\": \"StructureMap.group\",\
		\"weight\": 4754,\
		\"max\": \"*\",\
		\"type\": \"BackboneElement\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"StructureMap.group.id\",\
		\"weight\": 4755,\
		\"max\": \"1\",\
		\"type\": \"id\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"StructureMap.group.extension\",\
		\"weight\": 4756,\
		\"max\": \"*\",\
		\"type\": \"Extension\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"StructureMap.group.modifierExtension\",\
		\"weight\": 4757,\
		\"max\": \"*\",\
		\"type\": \"Extension\"\
	},\
	{\
		\"min\": \"1\",\
		\"path\": \"StructureMap.group.name\",\
		\"weight\": 4758,\
		\"max\": \"1\",\
		\"type\": \"id\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"StructureMap.group.extends\",\
		\"weight\": 4759,\
		\"max\": \"1\",\
		\"type\": \"id\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"StructureMap.group.documentation\",\
		\"weight\": 4760,\
		\"max\": \"1\",\
		\"type\": \"string\"\
	},\
	{\
		\"min\": \"1\",\
		\"path\": \"StructureMap.group.input\",\
		\"weight\": 4761,\
		\"max\": \"*\",\
		\"type\": \"BackboneElement\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"StructureMap.group.input.id\",\
		\"weight\": 4762,\
		\"max\": \"1\",\
		\"type\": \"id\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"StructureMap.group.input.extension\",\
		\"weight\": 4763,\
		\"max\": \"*\",\
		\"type\": \"Extension\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"StructureMap.group.input.modifierExtension\",\
		\"weight\": 4764,\
		\"max\": \"*\",\
		\"type\": \"Extension\"\
	},\
	{\
		\"min\": \"1\",\
		\"path\": \"StructureMap.group.input.name\",\
		\"weight\": 4765,\
		\"max\": \"1\",\
		\"type\": \"id\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"StructureMap.group.input.type\",\
		\"weight\": 4766,\
		\"max\": \"1\",\
		\"type\": \"string\"\
	},\
	{\
		\"min\": \"1\",\
		\"path\": \"StructureMap.group.input.mode\",\
		\"weight\": 4767,\
		\"max\": \"1\",\
		\"type\": \"code\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"StructureMap.group.input.documentation\",\
		\"weight\": 4768,\
		\"max\": \"1\",\
		\"type\": \"string\"\
	},\
	{\
		\"min\": \"1\",\
		\"path\": \"StructureMap.group.rule\",\
		\"weight\": 4769,\
		\"max\": \"*\",\
		\"type\": \"BackboneElement\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"StructureMap.group.rule.id\",\
		\"weight\": 4770,\
		\"max\": \"1\",\
		\"type\": \"id\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"StructureMap.group.rule.extension\",\
		\"weight\": 4771,\
		\"max\": \"*\",\
		\"type\": \"Extension\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"StructureMap.group.rule.modifierExtension\",\
		\"weight\": 4772,\
		\"max\": \"*\",\
		\"type\": \"Extension\"\
	},\
	{\
		\"min\": \"1\",\
		\"path\": \"StructureMap.group.rule.name\",\
		\"weight\": 4773,\
		\"max\": \"1\",\
		\"type\": \"id\"\
	},\
	{\
		\"min\": \"1\",\
		\"path\": \"StructureMap.group.rule.source\",\
		\"weight\": 4774,\
		\"max\": \"*\",\
		\"type\": \"BackboneElement\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"StructureMap.group.rule.source.id\",\
		\"weight\": 4775,\
		\"max\": \"1\",\
		\"type\": \"id\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"StructureMap.group.rule.source.extension\",\
		\"weight\": 4776,\
		\"max\": \"*\",\
		\"type\": \"Extension\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"StructureMap.group.rule.source.modifierExtension\",\
		\"weight\": 4777,\
		\"max\": \"*\",\
		\"type\": \"Extension\"\
	},\
	{\
		\"min\": \"1\",\
		\"path\": \"StructureMap.group.rule.source.required\",\
		\"weight\": 4778,\
		\"max\": \"1\",\
		\"type\": \"boolean\"\
	},\
	{\
		\"min\": \"1\",\
		\"path\": \"StructureMap.group.rule.source.context\",\
		\"weight\": 4779,\
		\"max\": \"1\",\
		\"type\": \"id\"\
	},\
	{\
		\"min\": \"1\",\
		\"path\": \"StructureMap.group.rule.source.contextType\",\
		\"weight\": 4780,\
		\"max\": \"1\",\
		\"type\": \"code\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"StructureMap.group.rule.source.element\",\
		\"weight\": 4781,\
		\"max\": \"1\",\
		\"type\": \"string\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"StructureMap.group.rule.source.listMode\",\
		\"weight\": 4782,\
		\"max\": \"1\",\
		\"type\": \"code\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"StructureMap.group.rule.source.variable\",\
		\"weight\": 4783,\
		\"max\": \"1\",\
		\"type\": \"id\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"StructureMap.group.rule.source.condition\",\
		\"weight\": 4784,\
		\"max\": \"1\",\
		\"type\": \"string\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"StructureMap.group.rule.source.check\",\
		\"weight\": 4785,\
		\"max\": \"1\",\
		\"type\": \"string\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"StructureMap.group.rule.target\",\
		\"weight\": 4786,\
		\"max\": \"*\",\
		\"type\": \"BackboneElement\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"StructureMap.group.rule.target.id\",\
		\"weight\": 4787,\
		\"max\": \"1\",\
		\"type\": \"id\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"StructureMap.group.rule.target.extension\",\
		\"weight\": 4788,\
		\"max\": \"*\",\
		\"type\": \"Extension\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"StructureMap.group.rule.target.modifierExtension\",\
		\"weight\": 4789,\
		\"max\": \"*\",\
		\"type\": \"Extension\"\
	},\
	{\
		\"min\": \"1\",\
		\"path\": \"StructureMap.group.rule.target.context\",\
		\"weight\": 4790,\
		\"max\": \"1\",\
		\"type\": \"id\"\
	},\
	{\
		\"min\": \"1\",\
		\"path\": \"StructureMap.group.rule.target.contextType\",\
		\"weight\": 4791,\
		\"max\": \"1\",\
		\"type\": \"code\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"StructureMap.group.rule.target.element\",\
		\"weight\": 4792,\
		\"max\": \"1\",\
		\"type\": \"string\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"StructureMap.group.rule.target.variable\",\
		\"weight\": 4793,\
		\"max\": \"1\",\
		\"type\": \"id\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"StructureMap.group.rule.target.listMode\",\
		\"weight\": 4794,\
		\"max\": \"*\",\
		\"type\": \"code\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"StructureMap.group.rule.target.listRuleId\",\
		\"weight\": 4795,\
		\"max\": \"1\",\
		\"type\": \"id\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"StructureMap.group.rule.target.transform\",\
		\"weight\": 4796,\
		\"max\": \"1\",\
		\"type\": \"code\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"StructureMap.group.rule.target.parameter\",\
		\"weight\": 4797,\
		\"max\": \"*\",\
		\"type\": \"BackboneElement\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"StructureMap.group.rule.target.parameter.id\",\
		\"weight\": 4798,\
		\"max\": \"1\",\
		\"type\": \"id\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"StructureMap.group.rule.target.parameter.extension\",\
		\"weight\": 4799,\
		\"max\": \"*\",\
		\"type\": \"Extension\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"StructureMap.group.rule.target.parameter.modifierExtension\",\
		\"weight\": 4800,\
		\"max\": \"*\",\
		\"type\": \"Extension\"\
	},\
	{\
		\"min\": \"1\",\
		\"path\": \"StructureMap.group.rule.target.parameter.valueId\",\
		\"weight\": 4801,\
		\"max\": \"1\",\
		\"type\": \"id\"\
	},\
	{\
		\"min\": \"1\",\
		\"path\": \"StructureMap.group.rule.target.parameter.valueString\",\
		\"weight\": 4801,\
		\"max\": \"1\",\
		\"type\": \"string\"\
	},\
	{\
		\"min\": \"1\",\
		\"path\": \"StructureMap.group.rule.target.parameter.valueBoolean\",\
		\"weight\": 4801,\
		\"max\": \"1\",\
		\"type\": \"boolean\"\
	},\
	{\
		\"min\": \"1\",\
		\"path\": \"StructureMap.group.rule.target.parameter.valueInteger\",\
		\"weight\": 4801,\
		\"max\": \"1\",\
		\"type\": \"integer\"\
	},\
	{\
		\"min\": \"1\",\
		\"path\": \"StructureMap.group.rule.target.parameter.valueDecimal\",\
		\"weight\": 4801,\
		\"max\": \"1\",\
		\"type\": \"decimal\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"StructureMap.group.rule.rule\",\
		\"weight\": 4802,\
		\"max\": \"*\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"StructureMap.group.rule.dependent\",\
		\"weight\": 4803,\
		\"max\": \"*\",\
		\"type\": \"BackboneElement\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"StructureMap.group.rule.dependent.id\",\
		\"weight\": 4804,\
		\"max\": \"1\",\
		\"type\": \"id\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"StructureMap.group.rule.dependent.extension\",\
		\"weight\": 4805,\
		\"max\": \"*\",\
		\"type\": \"Extension\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"StructureMap.group.rule.dependent.modifierExtension\",\
		\"weight\": 4806,\
		\"max\": \"*\",\
		\"type\": \"Extension\"\
	},\
	{\
		\"min\": \"1\",\
		\"path\": \"StructureMap.group.rule.dependent.name\",\
		\"weight\": 4807,\
		\"max\": \"1\",\
		\"type\": \"id\"\
	},\
	{\
		\"min\": \"1\",\
		\"path\": \"StructureMap.group.rule.dependent.variable\",\
		\"weight\": 4808,\
		\"max\": \"*\",\
		\"type\": \"string\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"StructureMap.group.rule.documentation\",\
		\"weight\": 4809,\
		\"max\": \"1\",\
		\"type\": \"string\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Subscription\",\
		\"weight\": 4810,\
		\"max\": \"*\",\
		\"type\": \"DomainResource\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Subscription.id\",\
		\"weight\": 4811,\
		\"max\": \"1\",\
		\"type\": \"id\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Subscription.meta\",\
		\"weight\": 4812,\
		\"max\": \"1\",\
		\"type\": \"Meta\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Subscription.implicitRules\",\
		\"weight\": 4813,\
		\"max\": \"1\",\
		\"type\": \"uri\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Subscription.language\",\
		\"weight\": 4814,\
		\"max\": \"1\",\
		\"type\": \"code\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Subscription.text\",\
		\"weight\": 4815,\
		\"max\": \"1\",\
		\"type\": \"Narrative\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Subscription.contained\",\
		\"weight\": 4816,\
		\"max\": \"*\",\
		\"type\": \"Resource\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Subscription.extension\",\
		\"weight\": 4817,\
		\"max\": \"*\",\
		\"type\": \"Extension\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Subscription.modifierExtension\",\
		\"weight\": 4818,\
		\"max\": \"*\",\
		\"type\": \"Extension\"\
	},\
	{\
		\"min\": \"1\",\
		\"path\": \"Subscription.criteria\",\
		\"weight\": 4819,\
		\"max\": \"1\",\
		\"type\": \"string\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Subscription.contact\",\
		\"weight\": 4820,\
		\"max\": \"*\",\
		\"type\": \"ContactPoint\"\
	},\
	{\
		\"min\": \"1\",\
		\"path\": \"Subscription.reason\",\
		\"weight\": 4821,\
		\"max\": \"1\",\
		\"type\": \"string\"\
	},\
	{\
		\"min\": \"1\",\
		\"path\": \"Subscription.status\",\
		\"weight\": 4822,\
		\"max\": \"1\",\
		\"type\": \"code\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Subscription.error\",\
		\"weight\": 4823,\
		\"max\": \"1\",\
		\"type\": \"string\"\
	},\
	{\
		\"min\": \"1\",\
		\"path\": \"Subscription.channel\",\
		\"weight\": 4824,\
		\"max\": \"1\",\
		\"type\": \"BackboneElement\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Subscription.channel.id\",\
		\"weight\": 4825,\
		\"max\": \"1\",\
		\"type\": \"id\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Subscription.channel.extension\",\
		\"weight\": 4826,\
		\"max\": \"*\",\
		\"type\": \"Extension\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Subscription.channel.modifierExtension\",\
		\"weight\": 4827,\
		\"max\": \"*\",\
		\"type\": \"Extension\"\
	},\
	{\
		\"min\": \"1\",\
		\"path\": \"Subscription.channel.type\",\
		\"weight\": 4828,\
		\"max\": \"1\",\
		\"type\": \"code\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Subscription.channel.endpoint\",\
		\"weight\": 4829,\
		\"max\": \"1\",\
		\"type\": \"uri\"\
	},\
	{\
		\"min\": \"1\",\
		\"path\": \"Subscription.channel.payload\",\
		\"weight\": 4830,\
		\"max\": \"1\",\
		\"type\": \"string\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Subscription.channel.header\",\
		\"weight\": 4831,\
		\"max\": \"1\",\
		\"type\": \"string\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Subscription.end\",\
		\"weight\": 4832,\
		\"max\": \"1\",\
		\"type\": \"instant\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Subscription.tag\",\
		\"weight\": 4833,\
		\"max\": \"*\",\
		\"type\": \"Coding\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Substance\",\
		\"weight\": 4834,\
		\"max\": \"*\",\
		\"type\": \"DomainResource\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Substance.id\",\
		\"weight\": 4835,\
		\"max\": \"1\",\
		\"type\": \"id\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Substance.meta\",\
		\"weight\": 4836,\
		\"max\": \"1\",\
		\"type\": \"Meta\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Substance.implicitRules\",\
		\"weight\": 4837,\
		\"max\": \"1\",\
		\"type\": \"uri\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Substance.language\",\
		\"weight\": 4838,\
		\"max\": \"1\",\
		\"type\": \"code\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Substance.text\",\
		\"weight\": 4839,\
		\"max\": \"1\",\
		\"type\": \"Narrative\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Substance.contained\",\
		\"weight\": 4840,\
		\"max\": \"*\",\
		\"type\": \"Resource\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Substance.extension\",\
		\"weight\": 4841,\
		\"max\": \"*\",\
		\"type\": \"Extension\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Substance.modifierExtension\",\
		\"weight\": 4842,\
		\"max\": \"*\",\
		\"type\": \"Extension\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Substance.identifier\",\
		\"weight\": 4843,\
		\"max\": \"*\",\
		\"type\": \"Identifier\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Substance.category\",\
		\"weight\": 4844,\
		\"max\": \"*\",\
		\"type\": \"CodeableConcept\"\
	},\
	{\
		\"min\": \"1\",\
		\"path\": \"Substance.code\",\
		\"weight\": 4845,\
		\"max\": \"1\",\
		\"type\": \"CodeableConcept\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Substance.description\",\
		\"weight\": 4846,\
		\"max\": \"1\",\
		\"type\": \"string\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Substance.instance\",\
		\"weight\": 4847,\
		\"max\": \"*\",\
		\"type\": \"BackboneElement\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Substance.instance.id\",\
		\"weight\": 4848,\
		\"max\": \"1\",\
		\"type\": \"id\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Substance.instance.extension\",\
		\"weight\": 4849,\
		\"max\": \"*\",\
		\"type\": \"Extension\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Substance.instance.modifierExtension\",\
		\"weight\": 4850,\
		\"max\": \"*\",\
		\"type\": \"Extension\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Substance.instance.identifier\",\
		\"weight\": 4851,\
		\"max\": \"1\",\
		\"type\": \"Identifier\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Substance.instance.expiry\",\
		\"weight\": 4852,\
		\"max\": \"1\",\
		\"type\": \"dateTime\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Substance.instance.quantity\",\
		\"weight\": 4853,\
		\"max\": \"1\",\
		\"type\": \"Quantity\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Substance.ingredient\",\
		\"weight\": 4854,\
		\"max\": \"*\",\
		\"type\": \"BackboneElement\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Substance.ingredient.id\",\
		\"weight\": 4855,\
		\"max\": \"1\",\
		\"type\": \"id\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Substance.ingredient.extension\",\
		\"weight\": 4856,\
		\"max\": \"*\",\
		\"type\": \"Extension\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Substance.ingredient.modifierExtension\",\
		\"weight\": 4857,\
		\"max\": \"*\",\
		\"type\": \"Extension\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Substance.ingredient.quantity\",\
		\"weight\": 4858,\
		\"max\": \"1\",\
		\"type\": \"Ratio\"\
	},\
	{\
		\"min\": \"1\",\
		\"path\": \"Substance.ingredient.substance\",\
		\"weight\": 4859,\
		\"max\": \"1\",\
		\"type\": \"Reference\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"SupplyDelivery\",\
		\"weight\": 4860,\
		\"max\": \"*\",\
		\"type\": \"DomainResource\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"SupplyDelivery.id\",\
		\"weight\": 4861,\
		\"max\": \"1\",\
		\"type\": \"id\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"SupplyDelivery.meta\",\
		\"weight\": 4862,\
		\"max\": \"1\",\
		\"type\": \"Meta\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"SupplyDelivery.implicitRules\",\
		\"weight\": 4863,\
		\"max\": \"1\",\
		\"type\": \"uri\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"SupplyDelivery.language\",\
		\"weight\": 4864,\
		\"max\": \"1\",\
		\"type\": \"code\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"SupplyDelivery.text\",\
		\"weight\": 4865,\
		\"max\": \"1\",\
		\"type\": \"Narrative\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"SupplyDelivery.contained\",\
		\"weight\": 4866,\
		\"max\": \"*\",\
		\"type\": \"Resource\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"SupplyDelivery.extension\",\
		\"weight\": 4867,\
		\"max\": \"*\",\
		\"type\": \"Extension\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"SupplyDelivery.modifierExtension\",\
		\"weight\": 4868,\
		\"max\": \"*\",\
		\"type\": \"Extension\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"SupplyDelivery.identifier\",\
		\"weight\": 4869,\
		\"max\": \"1\",\
		\"type\": \"Identifier\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"SupplyDelivery.status\",\
		\"weight\": 4870,\
		\"max\": \"1\",\
		\"type\": \"code\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"SupplyDelivery.patient\",\
		\"weight\": 4871,\
		\"max\": \"1\",\
		\"type\": \"Reference\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"SupplyDelivery.type\",\
		\"weight\": 4872,\
		\"max\": \"1\",\
		\"type\": \"CodeableConcept\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"SupplyDelivery.quantity\",\
		\"weight\": 4873,\
		\"max\": \"1\",\
		\"type\": \"Quantity\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"SupplyDelivery.suppliedItem\",\
		\"weight\": 4874,\
		\"max\": \"1\",\
		\"type\": \"Reference\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"SupplyDelivery.supplier\",\
		\"weight\": 4875,\
		\"max\": \"1\",\
		\"type\": \"Reference\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"SupplyDelivery.whenPrepared\",\
		\"weight\": 4876,\
		\"max\": \"1\",\
		\"type\": \"Period\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"SupplyDelivery.time\",\
		\"weight\": 4877,\
		\"max\": \"1\",\
		\"type\": \"dateTime\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"SupplyDelivery.destination\",\
		\"weight\": 4878,\
		\"max\": \"1\",\
		\"type\": \"Reference\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"SupplyDelivery.receiver\",\
		\"weight\": 4879,\
		\"max\": \"*\",\
		\"type\": \"Reference\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"SupplyRequest\",\
		\"weight\": 4880,\
		\"max\": \"*\",\
		\"type\": \"DomainResource\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"SupplyRequest.id\",\
		\"weight\": 4881,\
		\"max\": \"1\",\
		\"type\": \"id\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"SupplyRequest.meta\",\
		\"weight\": 4882,\
		\"max\": \"1\",\
		\"type\": \"Meta\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"SupplyRequest.implicitRules\",\
		\"weight\": 4883,\
		\"max\": \"1\",\
		\"type\": \"uri\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"SupplyRequest.language\",\
		\"weight\": 4884,\
		\"max\": \"1\",\
		\"type\": \"code\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"SupplyRequest.text\",\
		\"weight\": 4885,\
		\"max\": \"1\",\
		\"type\": \"Narrative\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"SupplyRequest.contained\",\
		\"weight\": 4886,\
		\"max\": \"*\",\
		\"type\": \"Resource\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"SupplyRequest.extension\",\
		\"weight\": 4887,\
		\"max\": \"*\",\
		\"type\": \"Extension\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"SupplyRequest.modifierExtension\",\
		\"weight\": 4888,\
		\"max\": \"*\",\
		\"type\": \"Extension\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"SupplyRequest.patient\",\
		\"weight\": 4889,\
		\"max\": \"1\",\
		\"type\": \"Reference\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"SupplyRequest.source\",\
		\"weight\": 4890,\
		\"max\": \"1\",\
		\"type\": \"Reference\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"SupplyRequest.date\",\
		\"weight\": 4891,\
		\"max\": \"1\",\
		\"type\": \"dateTime\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"SupplyRequest.identifier\",\
		\"weight\": 4892,\
		\"max\": \"1\",\
		\"type\": \"Identifier\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"SupplyRequest.status\",\
		\"weight\": 4893,\
		\"max\": \"1\",\
		\"type\": \"code\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"SupplyRequest.kind\",\
		\"weight\": 4894,\
		\"max\": \"1\",\
		\"type\": \"CodeableConcept\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"SupplyRequest.orderedItem\",\
		\"weight\": 4895,\
		\"max\": \"1\",\
		\"type\": \"Reference\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"SupplyRequest.supplier\",\
		\"weight\": 4896,\
		\"max\": \"*\",\
		\"type\": \"Reference\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"SupplyRequest.reasonCodeableConcept\",\
		\"weight\": 4897,\
		\"max\": \"1\",\
		\"type\": \"CodeableConcept\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"SupplyRequest.reasonReference\",\
		\"weight\": 4897,\
		\"max\": \"1\",\
		\"type\": \"Reference\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"SupplyRequest.when\",\
		\"weight\": 4898,\
		\"max\": \"1\",\
		\"type\": \"BackboneElement\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"SupplyRequest.when.id\",\
		\"weight\": 4899,\
		\"max\": \"1\",\
		\"type\": \"id\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"SupplyRequest.when.extension\",\
		\"weight\": 4900,\
		\"max\": \"*\",\
		\"type\": \"Extension\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"SupplyRequest.when.modifierExtension\",\
		\"weight\": 4901,\
		\"max\": \"*\",\
		\"type\": \"Extension\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"SupplyRequest.when.code\",\
		\"weight\": 4902,\
		\"max\": \"1\",\
		\"type\": \"CodeableConcept\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"SupplyRequest.when.schedule\",\
		\"weight\": 4903,\
		\"max\": \"1\",\
		\"type\": \"Timing\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Task\",\
		\"weight\": 4904,\
		\"max\": \"*\",\
		\"type\": \"DomainResource\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Task.id\",\
		\"weight\": 4905,\
		\"max\": \"1\",\
		\"type\": \"id\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Task.meta\",\
		\"weight\": 4906,\
		\"max\": \"1\",\
		\"type\": \"Meta\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Task.implicitRules\",\
		\"weight\": 4907,\
		\"max\": \"1\",\
		\"type\": \"uri\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Task.language\",\
		\"weight\": 4908,\
		\"max\": \"1\",\
		\"type\": \"code\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Task.text\",\
		\"weight\": 4909,\
		\"max\": \"1\",\
		\"type\": \"Narrative\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Task.contained\",\
		\"weight\": 4910,\
		\"max\": \"*\",\
		\"type\": \"Resource\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Task.extension\",\
		\"weight\": 4911,\
		\"max\": \"*\",\
		\"type\": \"Extension\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Task.modifierExtension\",\
		\"weight\": 4912,\
		\"max\": \"*\",\
		\"type\": \"Extension\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Task.identifier\",\
		\"weight\": 4913,\
		\"max\": \"1\",\
		\"type\": \"Identifier\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Task.type\",\
		\"weight\": 4914,\
		\"max\": \"1\",\
		\"type\": \"CodeableConcept\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Task.description\",\
		\"weight\": 4915,\
		\"max\": \"1\",\
		\"type\": \"string\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Task.performerType\",\
		\"weight\": 4916,\
		\"max\": \"*\",\
		\"type\": \"Coding\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Task.priority\",\
		\"weight\": 4917,\
		\"max\": \"1\",\
		\"type\": \"code\"\
	},\
	{\
		\"min\": \"1\",\
		\"path\": \"Task.status\",\
		\"weight\": 4918,\
		\"max\": \"1\",\
		\"type\": \"code\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Task.failureReason\",\
		\"weight\": 4919,\
		\"max\": \"1\",\
		\"type\": \"CodeableConcept\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Task.subject\",\
		\"weight\": 4920,\
		\"max\": \"1\",\
		\"type\": \"Reference\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Task.for\",\
		\"weight\": 4921,\
		\"max\": \"1\",\
		\"type\": \"Reference\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Task.definition\",\
		\"weight\": 4922,\
		\"max\": \"1\",\
		\"type\": \"uri\"\
	},\
	{\
		\"min\": \"1\",\
		\"path\": \"Task.created\",\
		\"weight\": 4923,\
		\"max\": \"1\",\
		\"type\": \"dateTime\"\
	},\
	{\
		\"min\": \"1\",\
		\"path\": \"Task.lastModified\",\
		\"weight\": 4924,\
		\"max\": \"1\",\
		\"type\": \"dateTime\"\
	},\
	{\
		\"min\": \"1\",\
		\"path\": \"Task.creator\",\
		\"weight\": 4925,\
		\"max\": \"1\",\
		\"type\": \"Reference\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Task.owner\",\
		\"weight\": 4926,\
		\"max\": \"1\",\
		\"type\": \"Reference\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Task.parent\",\
		\"weight\": 4927,\
		\"max\": \"1\",\
		\"type\": \"Reference\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Task.input\",\
		\"weight\": 4928,\
		\"max\": \"*\",\
		\"type\": \"BackboneElement\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Task.input.id\",\
		\"weight\": 4929,\
		\"max\": \"1\",\
		\"type\": \"id\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Task.input.extension\",\
		\"weight\": 4930,\
		\"max\": \"*\",\
		\"type\": \"Extension\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Task.input.modifierExtension\",\
		\"weight\": 4931,\
		\"max\": \"*\",\
		\"type\": \"Extension\"\
	},\
	{\
		\"min\": \"1\",\
		\"path\": \"Task.input.name\",\
		\"weight\": 4932,\
		\"max\": \"1\",\
		\"type\": \"string\"\
	},\
	{\
		\"min\": \"1\",\
		\"path\": \"Task.input.valueBoolean\",\
		\"weight\": 4933,\
		\"max\": \"1\",\
		\"type\": \"boolean\"\
	},\
	{\
		\"min\": \"1\",\
		\"path\": \"Task.input.valueInteger\",\
		\"weight\": 4933,\
		\"max\": \"1\",\
		\"type\": \"integer\"\
	},\
	{\
		\"min\": \"1\",\
		\"path\": \"Task.input.valueDecimal\",\
		\"weight\": 4933,\
		\"max\": \"1\",\
		\"type\": \"decimal\"\
	},\
	{\
		\"min\": \"1\",\
		\"path\": \"Task.input.valueBase64Binary\",\
		\"weight\": 4933,\
		\"max\": \"1\",\
		\"type\": \"base64Binary\"\
	},\
	{\
		\"min\": \"1\",\
		\"path\": \"Task.input.valueInstant\",\
		\"weight\": 4933,\
		\"max\": \"1\",\
		\"type\": \"instant\"\
	},\
	{\
		\"min\": \"1\",\
		\"path\": \"Task.input.valueString\",\
		\"weight\": 4933,\
		\"max\": \"1\",\
		\"type\": \"string\"\
	},\
	{\
		\"min\": \"1\",\
		\"path\": \"Task.input.valueUri\",\
		\"weight\": 4933,\
		\"max\": \"1\",\
		\"type\": \"uri\"\
	},\
	{\
		\"min\": \"1\",\
		\"path\": \"Task.input.valueDate\",\
		\"weight\": 4933,\
		\"max\": \"1\",\
		\"type\": \"date\"\
	},\
	{\
		\"min\": \"1\",\
		\"path\": \"Task.input.valueDateTime\",\
		\"weight\": 4933,\
		\"max\": \"1\",\
		\"type\": \"dateTime\"\
	},\
	{\
		\"min\": \"1\",\
		\"path\": \"Task.input.valueTime\",\
		\"weight\": 4933,\
		\"max\": \"1\",\
		\"type\": \"time\"\
	},\
	{\
		\"min\": \"1\",\
		\"path\": \"Task.input.valueCode\",\
		\"weight\": 4933,\
		\"max\": \"1\",\
		\"type\": \"code\"\
	},\
	{\
		\"min\": \"1\",\
		\"path\": \"Task.input.valueOid\",\
		\"weight\": 4933,\
		\"max\": \"1\",\
		\"type\": \"oid\"\
	},\
	{\
		\"min\": \"1\",\
		\"path\": \"Task.input.valueId\",\
		\"weight\": 4933,\
		\"max\": \"1\",\
		\"type\": \"id\"\
	},\
	{\
		\"min\": \"1\",\
		\"path\": \"Task.input.valueUnsignedInt\",\
		\"weight\": 4933,\
		\"max\": \"1\",\
		\"type\": \"unsignedInt\"\
	},\
	{\
		\"min\": \"1\",\
		\"path\": \"Task.input.valuePositiveInt\",\
		\"weight\": 4933,\
		\"max\": \"1\",\
		\"type\": \"positiveInt\"\
	},\
	{\
		\"min\": \"1\",\
		\"path\": \"Task.input.valueMarkdown\",\
		\"weight\": 4933,\
		\"max\": \"1\",\
		\"type\": \"markdown\"\
	},\
	{\
		\"min\": \"1\",\
		\"path\": \"Task.input.valueAnnotation\",\
		\"weight\": 4933,\
		\"max\": \"1\",\
		\"type\": \"Annotation\"\
	},\
	{\
		\"min\": \"1\",\
		\"path\": \"Task.input.valueAttachment\",\
		\"weight\": 4933,\
		\"max\": \"1\",\
		\"type\": \"Attachment\"\
	},\
	{\
		\"min\": \"1\",\
		\"path\": \"Task.input.valueIdentifier\",\
		\"weight\": 4933,\
		\"max\": \"1\",\
		\"type\": \"Identifier\"\
	},\
	{\
		\"min\": \"1\",\
		\"path\": \"Task.input.valueCodeableConcept\",\
		\"weight\": 4933,\
		\"max\": \"1\",\
		\"type\": \"CodeableConcept\"\
	},\
	{\
		\"min\": \"1\",\
		\"path\": \"Task.input.valueCoding\",\
		\"weight\": 4933,\
		\"max\": \"1\",\
		\"type\": \"Coding\"\
	},\
	{\
		\"min\": \"1\",\
		\"path\": \"Task.input.valueQuantity\",\
		\"weight\": 4933,\
		\"max\": \"1\",\
		\"type\": \"Quantity\"\
	},\
	{\
		\"min\": \"1\",\
		\"path\": \"Task.input.valueRange\",\
		\"weight\": 4933,\
		\"max\": \"1\",\
		\"type\": \"Range\"\
	},\
	{\
		\"min\": \"1\",\
		\"path\": \"Task.input.valuePeriod\",\
		\"weight\": 4933,\
		\"max\": \"1\",\
		\"type\": \"Period\"\
	},\
	{\
		\"min\": \"1\",\
		\"path\": \"Task.input.valueRatio\",\
		\"weight\": 4933,\
		\"max\": \"1\",\
		\"type\": \"Ratio\"\
	},\
	{\
		\"min\": \"1\",\
		\"path\": \"Task.input.valueSampledData\",\
		\"weight\": 4933,\
		\"max\": \"1\",\
		\"type\": \"SampledData\"\
	},\
	{\
		\"min\": \"1\",\
		\"path\": \"Task.input.valueSignature\",\
		\"weight\": 4933,\
		\"max\": \"1\",\
		\"type\": \"Signature\"\
	},\
	{\
		\"min\": \"1\",\
		\"path\": \"Task.input.valueHumanName\",\
		\"weight\": 4933,\
		\"max\": \"1\",\
		\"type\": \"HumanName\"\
	},\
	{\
		\"min\": \"1\",\
		\"path\": \"Task.input.valueAddress\",\
		\"weight\": 4933,\
		\"max\": \"1\",\
		\"type\": \"Address\"\
	},\
	{\
		\"min\": \"1\",\
		\"path\": \"Task.input.valueContactPoint\",\
		\"weight\": 4933,\
		\"max\": \"1\",\
		\"type\": \"ContactPoint\"\
	},\
	{\
		\"min\": \"1\",\
		\"path\": \"Task.input.valueTiming\",\
		\"weight\": 4933,\
		\"max\": \"1\",\
		\"type\": \"Timing\"\
	},\
	{\
		\"min\": \"1\",\
		\"path\": \"Task.input.valueReference\",\
		\"weight\": 4933,\
		\"max\": \"1\",\
		\"type\": \"Reference\"\
	},\
	{\
		\"min\": \"1\",\
		\"path\": \"Task.input.valueMeta\",\
		\"weight\": 4933,\
		\"max\": \"1\",\
		\"type\": \"Meta\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Task.output\",\
		\"weight\": 4934,\
		\"max\": \"*\",\
		\"type\": \"BackboneElement\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Task.output.id\",\
		\"weight\": 4935,\
		\"max\": \"1\",\
		\"type\": \"id\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Task.output.extension\",\
		\"weight\": 4936,\
		\"max\": \"*\",\
		\"type\": \"Extension\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"Task.output.modifierExtension\",\
		\"weight\": 4937,\
		\"max\": \"*\",\
		\"type\": \"Extension\"\
	},\
	{\
		\"min\": \"1\",\
		\"path\": \"Task.output.name\",\
		\"weight\": 4938,\
		\"max\": \"1\",\
		\"type\": \"string\"\
	},\
	{\
		\"min\": \"1\",\
		\"path\": \"Task.output.valueBoolean\",\
		\"weight\": 4939,\
		\"max\": \"1\",\
		\"type\": \"boolean\"\
	},\
	{\
		\"min\": \"1\",\
		\"path\": \"Task.output.valueInteger\",\
		\"weight\": 4939,\
		\"max\": \"1\",\
		\"type\": \"integer\"\
	},\
	{\
		\"min\": \"1\",\
		\"path\": \"Task.output.valueDecimal\",\
		\"weight\": 4939,\
		\"max\": \"1\",\
		\"type\": \"decimal\"\
	},\
	{\
		\"min\": \"1\",\
		\"path\": \"Task.output.valueBase64Binary\",\
		\"weight\": 4939,\
		\"max\": \"1\",\
		\"type\": \"base64Binary\"\
	},\
	{\
		\"min\": \"1\",\
		\"path\": \"Task.output.valueInstant\",\
		\"weight\": 4939,\
		\"max\": \"1\",\
		\"type\": \"instant\"\
	},\
	{\
		\"min\": \"1\",\
		\"path\": \"Task.output.valueString\",\
		\"weight\": 4939,\
		\"max\": \"1\",\
		\"type\": \"string\"\
	},\
	{\
		\"min\": \"1\",\
		\"path\": \"Task.output.valueUri\",\
		\"weight\": 4939,\
		\"max\": \"1\",\
		\"type\": \"uri\"\
	},\
	{\
		\"min\": \"1\",\
		\"path\": \"Task.output.valueDate\",\
		\"weight\": 4939,\
		\"max\": \"1\",\
		\"type\": \"date\"\
	},\
	{\
		\"min\": \"1\",\
		\"path\": \"Task.output.valueDateTime\",\
		\"weight\": 4939,\
		\"max\": \"1\",\
		\"type\": \"dateTime\"\
	},\
	{\
		\"min\": \"1\",\
		\"path\": \"Task.output.valueTime\",\
		\"weight\": 4939,\
		\"max\": \"1\",\
		\"type\": \"time\"\
	},\
	{\
		\"min\": \"1\",\
		\"path\": \"Task.output.valueCode\",\
		\"weight\": 4939,\
		\"max\": \"1\",\
		\"type\": \"code\"\
	},\
	{\
		\"min\": \"1\",\
		\"path\": \"Task.output.valueOid\",\
		\"weight\": 4939,\
		\"max\": \"1\",\
		\"type\": \"oid\"\
	},\
	{\
		\"min\": \"1\",\
		\"path\": \"Task.output.valueId\",\
		\"weight\": 4939,\
		\"max\": \"1\",\
		\"type\": \"id\"\
	},\
	{\
		\"min\": \"1\",\
		\"path\": \"Task.output.valueUnsignedInt\",\
		\"weight\": 4939,\
		\"max\": \"1\",\
		\"type\": \"unsignedInt\"\
	},\
	{\
		\"min\": \"1\",\
		\"path\": \"Task.output.valuePositiveInt\",\
		\"weight\": 4939,\
		\"max\": \"1\",\
		\"type\": \"positiveInt\"\
	},\
	{\
		\"min\": \"1\",\
		\"path\": \"Task.output.valueMarkdown\",\
		\"weight\": 4939,\
		\"max\": \"1\",\
		\"type\": \"markdown\"\
	},\
	{\
		\"min\": \"1\",\
		\"path\": \"Task.output.valueAnnotation\",\
		\"weight\": 4939,\
		\"max\": \"1\",\
		\"type\": \"Annotation\"\
	},\
	{\
		\"min\": \"1\",\
		\"path\": \"Task.output.valueAttachment\",\
		\"weight\": 4939,\
		\"max\": \"1\",\
		\"type\": \"Attachment\"\
	},\
	{\
		\"min\": \"1\",\
		\"path\": \"Task.output.valueIdentifier\",\
		\"weight\": 4939,\
		\"max\": \"1\",\
		\"type\": \"Identifier\"\
	},\
	{\
		\"min\": \"1\",\
		\"path\": \"Task.output.valueCodeableConcept\",\
		\"weight\": 4939,\
		\"max\": \"1\",\
		\"type\": \"CodeableConcept\"\
	},\
	{\
		\"min\": \"1\",\
		\"path\": \"Task.output.valueCoding\",\
		\"weight\": 4939,\
		\"max\": \"1\",\
		\"type\": \"Coding\"\
	},\
	{\
		\"min\": \"1\",\
		\"path\": \"Task.output.valueQuantity\",\
		\"weight\": 4939,\
		\"max\": \"1\",\
		\"type\": \"Quantity\"\
	},\
	{\
		\"min\": \"1\",\
		\"path\": \"Task.output.valueRange\",\
		\"weight\": 4939,\
		\"max\": \"1\",\
		\"type\": \"Range\"\
	},\
	{\
		\"min\": \"1\",\
		\"path\": \"Task.output.valuePeriod\",\
		\"weight\": 4939,\
		\"max\": \"1\",\
		\"type\": \"Period\"\
	},\
	{\
		\"min\": \"1\",\
		\"path\": \"Task.output.valueRatio\",\
		\"weight\": 4939,\
		\"max\": \"1\",\
		\"type\": \"Ratio\"\
	},\
	{\
		\"min\": \"1\",\
		\"path\": \"Task.output.valueSampledData\",\
		\"weight\": 4939,\
		\"max\": \"1\",\
		\"type\": \"SampledData\"\
	},\
	{\
		\"min\": \"1\",\
		\"path\": \"Task.output.valueSignature\",\
		\"weight\": 4939,\
		\"max\": \"1\",\
		\"type\": \"Signature\"\
	},\
	{\
		\"min\": \"1\",\
		\"path\": \"Task.output.valueHumanName\",\
		\"weight\": 4939,\
		\"max\": \"1\",\
		\"type\": \"HumanName\"\
	},\
	{\
		\"min\": \"1\",\
		\"path\": \"Task.output.valueAddress\",\
		\"weight\": 4939,\
		\"max\": \"1\",\
		\"type\": \"Address\"\
	},\
	{\
		\"min\": \"1\",\
		\"path\": \"Task.output.valueContactPoint\",\
		\"weight\": 4939,\
		\"max\": \"1\",\
		\"type\": \"ContactPoint\"\
	},\
	{\
		\"min\": \"1\",\
		\"path\": \"Task.output.valueTiming\",\
		\"weight\": 4939,\
		\"max\": \"1\",\
		\"type\": \"Timing\"\
	},\
	{\
		\"min\": \"1\",\
		\"path\": \"Task.output.valueReference\",\
		\"weight\": 4939,\
		\"max\": \"1\",\
		\"type\": \"Reference\"\
	},\
	{\
		\"min\": \"1\",\
		\"path\": \"Task.output.valueMeta\",\
		\"weight\": 4939,\
		\"max\": \"1\",\
		\"type\": \"Meta\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"TestScript\",\
		\"weight\": 4940,\
		\"max\": \"*\",\
		\"type\": \"DomainResource\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"TestScript.id\",\
		\"weight\": 4941,\
		\"max\": \"1\",\
		\"type\": \"id\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"TestScript.meta\",\
		\"weight\": 4942,\
		\"max\": \"1\",\
		\"type\": \"Meta\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"TestScript.implicitRules\",\
		\"weight\": 4943,\
		\"max\": \"1\",\
		\"type\": \"uri\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"TestScript.language\",\
		\"weight\": 4944,\
		\"max\": \"1\",\
		\"type\": \"code\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"TestScript.text\",\
		\"weight\": 4945,\
		\"max\": \"1\",\
		\"type\": \"Narrative\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"TestScript.contained\",\
		\"weight\": 4946,\
		\"max\": \"*\",\
		\"type\": \"Resource\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"TestScript.extension\",\
		\"weight\": 4947,\
		\"max\": \"*\",\
		\"type\": \"Extension\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"TestScript.modifierExtension\",\
		\"weight\": 4948,\
		\"max\": \"*\",\
		\"type\": \"Extension\"\
	},\
	{\
		\"min\": \"1\",\
		\"path\": \"TestScript.url\",\
		\"weight\": 4949,\
		\"max\": \"1\",\
		\"type\": \"uri\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"TestScript.version\",\
		\"weight\": 4950,\
		\"max\": \"1\",\
		\"type\": \"string\"\
	},\
	{\
		\"min\": \"1\",\
		\"path\": \"TestScript.name\",\
		\"weight\": 4951,\
		\"max\": \"1\",\
		\"type\": \"string\"\
	},\
	{\
		\"min\": \"1\",\
		\"path\": \"TestScript.status\",\
		\"weight\": 4952,\
		\"max\": \"1\",\
		\"type\": \"code\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"TestScript.identifier\",\
		\"weight\": 4953,\
		\"max\": \"1\",\
		\"type\": \"Identifier\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"TestScript.experimental\",\
		\"weight\": 4954,\
		\"max\": \"1\",\
		\"type\": \"boolean\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"TestScript.publisher\",\
		\"weight\": 4955,\
		\"max\": \"1\",\
		\"type\": \"string\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"TestScript.contact\",\
		\"weight\": 4956,\
		\"max\": \"*\",\
		\"type\": \"BackboneElement\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"TestScript.contact.id\",\
		\"weight\": 4957,\
		\"max\": \"1\",\
		\"type\": \"id\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"TestScript.contact.extension\",\
		\"weight\": 4958,\
		\"max\": \"*\",\
		\"type\": \"Extension\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"TestScript.contact.modifierExtension\",\
		\"weight\": 4959,\
		\"max\": \"*\",\
		\"type\": \"Extension\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"TestScript.contact.name\",\
		\"weight\": 4960,\
		\"max\": \"1\",\
		\"type\": \"string\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"TestScript.contact.telecom\",\
		\"weight\": 4961,\
		\"max\": \"*\",\
		\"type\": \"ContactPoint\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"TestScript.date\",\
		\"weight\": 4962,\
		\"max\": \"1\",\
		\"type\": \"dateTime\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"TestScript.description\",\
		\"weight\": 4963,\
		\"max\": \"1\",\
		\"type\": \"string\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"TestScript.useContext\",\
		\"weight\": 4964,\
		\"max\": \"*\",\
		\"type\": \"CodeableConcept\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"TestScript.requirements\",\
		\"weight\": 4965,\
		\"max\": \"1\",\
		\"type\": \"string\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"TestScript.copyright\",\
		\"weight\": 4966,\
		\"max\": \"1\",\
		\"type\": \"string\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"TestScript.origin\",\
		\"weight\": 4967,\
		\"max\": \"*\",\
		\"type\": \"BackboneElement\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"TestScript.origin.id\",\
		\"weight\": 4968,\
		\"max\": \"1\",\
		\"type\": \"id\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"TestScript.origin.extension\",\
		\"weight\": 4969,\
		\"max\": \"*\",\
		\"type\": \"Extension\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"TestScript.origin.modifierExtension\",\
		\"weight\": 4970,\
		\"max\": \"*\",\
		\"type\": \"Extension\"\
	},\
	{\
		\"min\": \"1\",\
		\"path\": \"TestScript.origin.index\",\
		\"weight\": 4971,\
		\"max\": \"1\",\
		\"type\": \"integer\"\
	},\
	{\
		\"min\": \"1\",\
		\"path\": \"TestScript.origin.profile\",\
		\"weight\": 4972,\
		\"max\": \"1\",\
		\"type\": \"Coding\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"TestScript.destination\",\
		\"weight\": 4973,\
		\"max\": \"*\",\
		\"type\": \"BackboneElement\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"TestScript.destination.id\",\
		\"weight\": 4974,\
		\"max\": \"1\",\
		\"type\": \"id\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"TestScript.destination.extension\",\
		\"weight\": 4975,\
		\"max\": \"*\",\
		\"type\": \"Extension\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"TestScript.destination.modifierExtension\",\
		\"weight\": 4976,\
		\"max\": \"*\",\
		\"type\": \"Extension\"\
	},\
	{\
		\"min\": \"1\",\
		\"path\": \"TestScript.destination.index\",\
		\"weight\": 4977,\
		\"max\": \"1\",\
		\"type\": \"integer\"\
	},\
	{\
		\"min\": \"1\",\
		\"path\": \"TestScript.destination.profile\",\
		\"weight\": 4978,\
		\"max\": \"1\",\
		\"type\": \"Coding\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"TestScript.metadata\",\
		\"weight\": 4979,\
		\"max\": \"1\",\
		\"type\": \"BackboneElement\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"TestScript.metadata.id\",\
		\"weight\": 4980,\
		\"max\": \"1\",\
		\"type\": \"id\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"TestScript.metadata.extension\",\
		\"weight\": 4981,\
		\"max\": \"*\",\
		\"type\": \"Extension\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"TestScript.metadata.modifierExtension\",\
		\"weight\": 4982,\
		\"max\": \"*\",\
		\"type\": \"Extension\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"TestScript.metadata.link\",\
		\"weight\": 4983,\
		\"max\": \"*\",\
		\"type\": \"BackboneElement\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"TestScript.metadata.link.id\",\
		\"weight\": 4984,\
		\"max\": \"1\",\
		\"type\": \"id\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"TestScript.metadata.link.extension\",\
		\"weight\": 4985,\
		\"max\": \"*\",\
		\"type\": \"Extension\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"TestScript.metadata.link.modifierExtension\",\
		\"weight\": 4986,\
		\"max\": \"*\",\
		\"type\": \"Extension\"\
	},\
	{\
		\"min\": \"1\",\
		\"path\": \"TestScript.metadata.link.url\",\
		\"weight\": 4987,\
		\"max\": \"1\",\
		\"type\": \"uri\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"TestScript.metadata.link.description\",\
		\"weight\": 4988,\
		\"max\": \"1\",\
		\"type\": \"string\"\
	},\
	{\
		\"min\": \"1\",\
		\"path\": \"TestScript.metadata.capability\",\
		\"weight\": 4989,\
		\"max\": \"*\",\
		\"type\": \"BackboneElement\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"TestScript.metadata.capability.id\",\
		\"weight\": 4990,\
		\"max\": \"1\",\
		\"type\": \"id\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"TestScript.metadata.capability.extension\",\
		\"weight\": 4991,\
		\"max\": \"*\",\
		\"type\": \"Extension\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"TestScript.metadata.capability.modifierExtension\",\
		\"weight\": 4992,\
		\"max\": \"*\",\
		\"type\": \"Extension\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"TestScript.metadata.capability.required\",\
		\"weight\": 4993,\
		\"max\": \"1\",\
		\"type\": \"boolean\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"TestScript.metadata.capability.validated\",\
		\"weight\": 4994,\
		\"max\": \"1\",\
		\"type\": \"boolean\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"TestScript.metadata.capability.description\",\
		\"weight\": 4995,\
		\"max\": \"1\",\
		\"type\": \"string\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"TestScript.metadata.capability.origin\",\
		\"weight\": 4996,\
		\"max\": \"*\",\
		\"type\": \"integer\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"TestScript.metadata.capability.destination\",\
		\"weight\": 4997,\
		\"max\": \"1\",\
		\"type\": \"integer\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"TestScript.metadata.capability.link\",\
		\"weight\": 4998,\
		\"max\": \"*\",\
		\"type\": \"uri\"\
	},\
	{\
		\"min\": \"1\",\
		\"path\": \"TestScript.metadata.capability.conformance\",\
		\"weight\": 4999,\
		\"max\": \"1\",\
		\"type\": \"Reference\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"TestScript.fixture\",\
		\"weight\": 5000,\
		\"max\": \"*\",\
		\"type\": \"BackboneElement\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"TestScript.fixture.id\",\
		\"weight\": 5001,\
		\"max\": \"1\",\
		\"type\": \"id\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"TestScript.fixture.extension\",\
		\"weight\": 5002,\
		\"max\": \"*\",\
		\"type\": \"Extension\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"TestScript.fixture.modifierExtension\",\
		\"weight\": 5003,\
		\"max\": \"*\",\
		\"type\": \"Extension\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"TestScript.fixture.autocreate\",\
		\"weight\": 5004,\
		\"max\": \"1\",\
		\"type\": \"boolean\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"TestScript.fixture.autodelete\",\
		\"weight\": 5005,\
		\"max\": \"1\",\
		\"type\": \"boolean\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"TestScript.fixture.resource\",\
		\"weight\": 5006,\
		\"max\": \"1\",\
		\"type\": \"Reference\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"TestScript.profile\",\
		\"weight\": 5007,\
		\"max\": \"*\",\
		\"type\": \"Reference\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"TestScript.variable\",\
		\"weight\": 5008,\
		\"max\": \"*\",\
		\"type\": \"BackboneElement\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"TestScript.variable.id\",\
		\"weight\": 5009,\
		\"max\": \"1\",\
		\"type\": \"id\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"TestScript.variable.extension\",\
		\"weight\": 5010,\
		\"max\": \"*\",\
		\"type\": \"Extension\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"TestScript.variable.modifierExtension\",\
		\"weight\": 5011,\
		\"max\": \"*\",\
		\"type\": \"Extension\"\
	},\
	{\
		\"min\": \"1\",\
		\"path\": \"TestScript.variable.name\",\
		\"weight\": 5012,\
		\"max\": \"1\",\
		\"type\": \"string\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"TestScript.variable.defaultValue\",\
		\"weight\": 5013,\
		\"max\": \"1\",\
		\"type\": \"string\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"TestScript.variable.headerField\",\
		\"weight\": 5014,\
		\"max\": \"1\",\
		\"type\": \"string\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"TestScript.variable.path\",\
		\"weight\": 5015,\
		\"max\": \"1\",\
		\"type\": \"string\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"TestScript.variable.sourceId\",\
		\"weight\": 5016,\
		\"max\": \"1\",\
		\"type\": \"id\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"TestScript.rule\",\
		\"weight\": 5017,\
		\"max\": \"*\",\
		\"type\": \"BackboneElement\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"TestScript.rule.id\",\
		\"weight\": 5018,\
		\"max\": \"1\",\
		\"type\": \"id\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"TestScript.rule.extension\",\
		\"weight\": 5019,\
		\"max\": \"*\",\
		\"type\": \"Extension\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"TestScript.rule.modifierExtension\",\
		\"weight\": 5020,\
		\"max\": \"*\",\
		\"type\": \"Extension\"\
	},\
	{\
		\"min\": \"1\",\
		\"path\": \"TestScript.rule.resource\",\
		\"weight\": 5021,\
		\"max\": \"1\",\
		\"type\": \"Reference\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"TestScript.rule.param\",\
		\"weight\": 5022,\
		\"max\": \"*\",\
		\"type\": \"BackboneElement\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"TestScript.rule.param.id\",\
		\"weight\": 5023,\
		\"max\": \"1\",\
		\"type\": \"id\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"TestScript.rule.param.extension\",\
		\"weight\": 5024,\
		\"max\": \"*\",\
		\"type\": \"Extension\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"TestScript.rule.param.modifierExtension\",\
		\"weight\": 5025,\
		\"max\": \"*\",\
		\"type\": \"Extension\"\
	},\
	{\
		\"min\": \"1\",\
		\"path\": \"TestScript.rule.param.name\",\
		\"weight\": 5026,\
		\"max\": \"1\",\
		\"type\": \"string\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"TestScript.rule.param.value\",\
		\"weight\": 5027,\
		\"max\": \"1\",\
		\"type\": \"string\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"TestScript.ruleset\",\
		\"weight\": 5028,\
		\"max\": \"*\",\
		\"type\": \"BackboneElement\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"TestScript.ruleset.id\",\
		\"weight\": 5029,\
		\"max\": \"1\",\
		\"type\": \"id\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"TestScript.ruleset.extension\",\
		\"weight\": 5030,\
		\"max\": \"*\",\
		\"type\": \"Extension\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"TestScript.ruleset.modifierExtension\",\
		\"weight\": 5031,\
		\"max\": \"*\",\
		\"type\": \"Extension\"\
	},\
	{\
		\"min\": \"1\",\
		\"path\": \"TestScript.ruleset.resource\",\
		\"weight\": 5032,\
		\"max\": \"1\",\
		\"type\": \"Reference\"\
	},\
	{\
		\"min\": \"1\",\
		\"path\": \"TestScript.ruleset.rule\",\
		\"weight\": 5033,\
		\"max\": \"*\",\
		\"type\": \"BackboneElement\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"TestScript.ruleset.rule.id\",\
		\"weight\": 5034,\
		\"max\": \"1\",\
		\"type\": \"id\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"TestScript.ruleset.rule.extension\",\
		\"weight\": 5035,\
		\"max\": \"*\",\
		\"type\": \"Extension\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"TestScript.ruleset.rule.modifierExtension\",\
		\"weight\": 5036,\
		\"max\": \"*\",\
		\"type\": \"Extension\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"TestScript.ruleset.rule.param\",\
		\"weight\": 5037,\
		\"max\": \"*\",\
		\"type\": \"BackboneElement\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"TestScript.ruleset.rule.param.id\",\
		\"weight\": 5038,\
		\"max\": \"1\",\
		\"type\": \"id\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"TestScript.ruleset.rule.param.extension\",\
		\"weight\": 5039,\
		\"max\": \"*\",\
		\"type\": \"Extension\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"TestScript.ruleset.rule.param.modifierExtension\",\
		\"weight\": 5040,\
		\"max\": \"*\",\
		\"type\": \"Extension\"\
	},\
	{\
		\"min\": \"1\",\
		\"path\": \"TestScript.ruleset.rule.param.name\",\
		\"weight\": 5041,\
		\"max\": \"1\",\
		\"type\": \"string\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"TestScript.ruleset.rule.param.value\",\
		\"weight\": 5042,\
		\"max\": \"1\",\
		\"type\": \"string\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"TestScript.setup\",\
		\"weight\": 5043,\
		\"max\": \"1\",\
		\"type\": \"BackboneElement\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"TestScript.setup.id\",\
		\"weight\": 5044,\
		\"max\": \"1\",\
		\"type\": \"id\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"TestScript.setup.extension\",\
		\"weight\": 5045,\
		\"max\": \"*\",\
		\"type\": \"Extension\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"TestScript.setup.modifierExtension\",\
		\"weight\": 5046,\
		\"max\": \"*\",\
		\"type\": \"Extension\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"TestScript.setup.metadata\",\
		\"weight\": 5047,\
		\"max\": \"1\"\
	},\
	{\
		\"min\": \"1\",\
		\"path\": \"TestScript.setup.action\",\
		\"weight\": 5048,\
		\"max\": \"*\",\
		\"type\": \"BackboneElement\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"TestScript.setup.action.id\",\
		\"weight\": 5049,\
		\"max\": \"1\",\
		\"type\": \"id\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"TestScript.setup.action.extension\",\
		\"weight\": 5050,\
		\"max\": \"*\",\
		\"type\": \"Extension\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"TestScript.setup.action.modifierExtension\",\
		\"weight\": 5051,\
		\"max\": \"*\",\
		\"type\": \"Extension\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"TestScript.setup.action.operation\",\
		\"weight\": 5052,\
		\"max\": \"1\",\
		\"type\": \"BackboneElement\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"TestScript.setup.action.operation.id\",\
		\"weight\": 5053,\
		\"max\": \"1\",\
		\"type\": \"id\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"TestScript.setup.action.operation.extension\",\
		\"weight\": 5054,\
		\"max\": \"*\",\
		\"type\": \"Extension\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"TestScript.setup.action.operation.modifierExtension\",\
		\"weight\": 5055,\
		\"max\": \"*\",\
		\"type\": \"Extension\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"TestScript.setup.action.operation.type\",\
		\"weight\": 5056,\
		\"max\": \"1\",\
		\"type\": \"Coding\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"TestScript.setup.action.operation.resource\",\
		\"weight\": 5057,\
		\"max\": \"1\",\
		\"type\": \"code\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"TestScript.setup.action.operation.label\",\
		\"weight\": 5058,\
		\"max\": \"1\",\
		\"type\": \"string\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"TestScript.setup.action.operation.description\",\
		\"weight\": 5059,\
		\"max\": \"1\",\
		\"type\": \"string\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"TestScript.setup.action.operation.accept\",\
		\"weight\": 5060,\
		\"max\": \"1\",\
		\"type\": \"code\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"TestScript.setup.action.operation.contentType\",\
		\"weight\": 5061,\
		\"max\": \"1\",\
		\"type\": \"code\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"TestScript.setup.action.operation.destination\",\
		\"weight\": 5062,\
		\"max\": \"1\",\
		\"type\": \"integer\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"TestScript.setup.action.operation.encodeRequestUrl\",\
		\"weight\": 5063,\
		\"max\": \"1\",\
		\"type\": \"boolean\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"TestScript.setup.action.operation.origin\",\
		\"weight\": 5064,\
		\"max\": \"1\",\
		\"type\": \"integer\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"TestScript.setup.action.operation.params\",\
		\"weight\": 5065,\
		\"max\": \"1\",\
		\"type\": \"string\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"TestScript.setup.action.operation.requestHeader\",\
		\"weight\": 5066,\
		\"max\": \"*\",\
		\"type\": \"BackboneElement\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"TestScript.setup.action.operation.requestHeader.id\",\
		\"weight\": 5067,\
		\"max\": \"1\",\
		\"type\": \"id\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"TestScript.setup.action.operation.requestHeader.extension\",\
		\"weight\": 5068,\
		\"max\": \"*\",\
		\"type\": \"Extension\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"TestScript.setup.action.operation.requestHeader.modifierExtension\",\
		\"weight\": 5069,\
		\"max\": \"*\",\
		\"type\": \"Extension\"\
	},\
	{\
		\"min\": \"1\",\
		\"path\": \"TestScript.setup.action.operation.requestHeader.field\",\
		\"weight\": 5070,\
		\"max\": \"1\",\
		\"type\": \"string\"\
	},\
	{\
		\"min\": \"1\",\
		\"path\": \"TestScript.setup.action.operation.requestHeader.value\",\
		\"weight\": 5071,\
		\"max\": \"1\",\
		\"type\": \"string\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"TestScript.setup.action.operation.responseId\",\
		\"weight\": 5072,\
		\"max\": \"1\",\
		\"type\": \"id\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"TestScript.setup.action.operation.sourceId\",\
		\"weight\": 5073,\
		\"max\": \"1\",\
		\"type\": \"id\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"TestScript.setup.action.operation.targetId\",\
		\"weight\": 5074,\
		\"max\": \"1\",\
		\"type\": \"id\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"TestScript.setup.action.operation.url\",\
		\"weight\": 5075,\
		\"max\": \"1\",\
		\"type\": \"string\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"TestScript.setup.action.assert\",\
		\"weight\": 5076,\
		\"max\": \"1\",\
		\"type\": \"BackboneElement\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"TestScript.setup.action.assert.id\",\
		\"weight\": 5077,\
		\"max\": \"1\",\
		\"type\": \"id\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"TestScript.setup.action.assert.extension\",\
		\"weight\": 5078,\
		\"max\": \"*\",\
		\"type\": \"Extension\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"TestScript.setup.action.assert.modifierExtension\",\
		\"weight\": 5079,\
		\"max\": \"*\",\
		\"type\": \"Extension\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"TestScript.setup.action.assert.label\",\
		\"weight\": 5080,\
		\"max\": \"1\",\
		\"type\": \"string\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"TestScript.setup.action.assert.description\",\
		\"weight\": 5081,\
		\"max\": \"1\",\
		\"type\": \"string\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"TestScript.setup.action.assert.direction\",\
		\"weight\": 5082,\
		\"max\": \"1\",\
		\"type\": \"code\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"TestScript.setup.action.assert.compareToSourceId\",\
		\"weight\": 5083,\
		\"max\": \"1\",\
		\"type\": \"string\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"TestScript.setup.action.assert.compareToSourcePath\",\
		\"weight\": 5084,\
		\"max\": \"1\",\
		\"type\": \"string\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"TestScript.setup.action.assert.contentType\",\
		\"weight\": 5085,\
		\"max\": \"1\",\
		\"type\": \"code\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"TestScript.setup.action.assert.headerField\",\
		\"weight\": 5086,\
		\"max\": \"1\",\
		\"type\": \"string\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"TestScript.setup.action.assert.minimumId\",\
		\"weight\": 5087,\
		\"max\": \"1\",\
		\"type\": \"string\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"TestScript.setup.action.assert.navigationLinks\",\
		\"weight\": 5088,\
		\"max\": \"1\",\
		\"type\": \"boolean\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"TestScript.setup.action.assert.operator\",\
		\"weight\": 5089,\
		\"max\": \"1\",\
		\"type\": \"code\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"TestScript.setup.action.assert.path\",\
		\"weight\": 5090,\
		\"max\": \"1\",\
		\"type\": \"string\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"TestScript.setup.action.assert.resource\",\
		\"weight\": 5091,\
		\"max\": \"1\",\
		\"type\": \"code\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"TestScript.setup.action.assert.response\",\
		\"weight\": 5092,\
		\"max\": \"1\",\
		\"type\": \"code\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"TestScript.setup.action.assert.responseCode\",\
		\"weight\": 5093,\
		\"max\": \"1\",\
		\"type\": \"string\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"TestScript.setup.action.assert.rule\",\
		\"weight\": 5094,\
		\"max\": \"1\",\
		\"type\": \"BackboneElement\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"TestScript.setup.action.assert.rule.id\",\
		\"weight\": 5095,\
		\"max\": \"1\",\
		\"type\": \"id\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"TestScript.setup.action.assert.rule.extension\",\
		\"weight\": 5096,\
		\"max\": \"*\",\
		\"type\": \"Extension\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"TestScript.setup.action.assert.rule.modifierExtension\",\
		\"weight\": 5097,\
		\"max\": \"*\",\
		\"type\": \"Extension\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"TestScript.setup.action.assert.rule.param\",\
		\"weight\": 5098,\
		\"max\": \"*\",\
		\"type\": \"BackboneElement\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"TestScript.setup.action.assert.rule.param.id\",\
		\"weight\": 5099,\
		\"max\": \"1\",\
		\"type\": \"id\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"TestScript.setup.action.assert.rule.param.extension\",\
		\"weight\": 5100,\
		\"max\": \"*\",\
		\"type\": \"Extension\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"TestScript.setup.action.assert.rule.param.modifierExtension\",\
		\"weight\": 5101,\
		\"max\": \"*\",\
		\"type\": \"Extension\"\
	},\
	{\
		\"min\": \"1\",\
		\"path\": \"TestScript.setup.action.assert.rule.param.name\",\
		\"weight\": 5102,\
		\"max\": \"1\",\
		\"type\": \"string\"\
	},\
	{\
		\"min\": \"1\",\
		\"path\": \"TestScript.setup.action.assert.rule.param.value\",\
		\"weight\": 5103,\
		\"max\": \"1\",\
		\"type\": \"string\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"TestScript.setup.action.assert.ruleset\",\
		\"weight\": 5104,\
		\"max\": \"1\",\
		\"type\": \"BackboneElement\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"TestScript.setup.action.assert.ruleset.id\",\
		\"weight\": 5105,\
		\"max\": \"1\",\
		\"type\": \"id\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"TestScript.setup.action.assert.ruleset.extension\",\
		\"weight\": 5106,\
		\"max\": \"*\",\
		\"type\": \"Extension\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"TestScript.setup.action.assert.ruleset.modifierExtension\",\
		\"weight\": 5107,\
		\"max\": \"*\",\
		\"type\": \"Extension\"\
	},\
	{\
		\"min\": \"1\",\
		\"path\": \"TestScript.setup.action.assert.ruleset.rule\",\
		\"weight\": 5108,\
		\"max\": \"*\",\
		\"type\": \"BackboneElement\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"TestScript.setup.action.assert.ruleset.rule.id\",\
		\"weight\": 5109,\
		\"max\": \"1\",\
		\"type\": \"id\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"TestScript.setup.action.assert.ruleset.rule.extension\",\
		\"weight\": 5110,\
		\"max\": \"*\",\
		\"type\": \"Extension\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"TestScript.setup.action.assert.ruleset.rule.modifierExtension\",\
		\"weight\": 5111,\
		\"max\": \"*\",\
		\"type\": \"Extension\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"TestScript.setup.action.assert.ruleset.rule.param\",\
		\"weight\": 5112,\
		\"max\": \"*\",\
		\"type\": \"BackboneElement\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"TestScript.setup.action.assert.ruleset.rule.param.id\",\
		\"weight\": 5113,\
		\"max\": \"1\",\
		\"type\": \"id\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"TestScript.setup.action.assert.ruleset.rule.param.extension\",\
		\"weight\": 5114,\
		\"max\": \"*\",\
		\"type\": \"Extension\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"TestScript.setup.action.assert.ruleset.rule.param.modifierExtension\",\
		\"weight\": 5115,\
		\"max\": \"*\",\
		\"type\": \"Extension\"\
	},\
	{\
		\"min\": \"1\",\
		\"path\": \"TestScript.setup.action.assert.ruleset.rule.param.name\",\
		\"weight\": 5116,\
		\"max\": \"1\",\
		\"type\": \"string\"\
	},\
	{\
		\"min\": \"1\",\
		\"path\": \"TestScript.setup.action.assert.ruleset.rule.param.value\",\
		\"weight\": 5117,\
		\"max\": \"1\",\
		\"type\": \"string\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"TestScript.setup.action.assert.sourceId\",\
		\"weight\": 5118,\
		\"max\": \"1\",\
		\"type\": \"id\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"TestScript.setup.action.assert.validateProfileId\",\
		\"weight\": 5119,\
		\"max\": \"1\",\
		\"type\": \"id\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"TestScript.setup.action.assert.value\",\
		\"weight\": 5120,\
		\"max\": \"1\",\
		\"type\": \"string\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"TestScript.setup.action.assert.warningOnly\",\
		\"weight\": 5121,\
		\"max\": \"1\",\
		\"type\": \"boolean\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"TestScript.test\",\
		\"weight\": 5122,\
		\"max\": \"*\",\
		\"type\": \"BackboneElement\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"TestScript.test.id\",\
		\"weight\": 5123,\
		\"max\": \"1\",\
		\"type\": \"id\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"TestScript.test.extension\",\
		\"weight\": 5124,\
		\"max\": \"*\",\
		\"type\": \"Extension\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"TestScript.test.modifierExtension\",\
		\"weight\": 5125,\
		\"max\": \"*\",\
		\"type\": \"Extension\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"TestScript.test.name\",\
		\"weight\": 5126,\
		\"max\": \"1\",\
		\"type\": \"string\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"TestScript.test.description\",\
		\"weight\": 5127,\
		\"max\": \"1\",\
		\"type\": \"string\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"TestScript.test.metadata\",\
		\"weight\": 5128,\
		\"max\": \"1\"\
	},\
	{\
		\"min\": \"1\",\
		\"path\": \"TestScript.test.action\",\
		\"weight\": 5129,\
		\"max\": \"*\",\
		\"type\": \"BackboneElement\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"TestScript.test.action.id\",\
		\"weight\": 5130,\
		\"max\": \"1\",\
		\"type\": \"id\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"TestScript.test.action.extension\",\
		\"weight\": 5131,\
		\"max\": \"*\",\
		\"type\": \"Extension\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"TestScript.test.action.modifierExtension\",\
		\"weight\": 5132,\
		\"max\": \"*\",\
		\"type\": \"Extension\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"TestScript.test.action.operation\",\
		\"weight\": 5133,\
		\"max\": \"1\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"TestScript.test.action.assert\",\
		\"weight\": 5134,\
		\"max\": \"1\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"TestScript.teardown\",\
		\"weight\": 5135,\
		\"max\": \"1\",\
		\"type\": \"BackboneElement\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"TestScript.teardown.id\",\
		\"weight\": 5136,\
		\"max\": \"1\",\
		\"type\": \"id\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"TestScript.teardown.extension\",\
		\"weight\": 5137,\
		\"max\": \"*\",\
		\"type\": \"Extension\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"TestScript.teardown.modifierExtension\",\
		\"weight\": 5138,\
		\"max\": \"*\",\
		\"type\": \"Extension\"\
	},\
	{\
		\"min\": \"1\",\
		\"path\": \"TestScript.teardown.action\",\
		\"weight\": 5139,\
		\"max\": \"*\",\
		\"type\": \"BackboneElement\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"TestScript.teardown.action.id\",\
		\"weight\": 5140,\
		\"max\": \"1\",\
		\"type\": \"id\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"TestScript.teardown.action.extension\",\
		\"weight\": 5141,\
		\"max\": \"*\",\
		\"type\": \"Extension\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"TestScript.teardown.action.modifierExtension\",\
		\"weight\": 5142,\
		\"max\": \"*\",\
		\"type\": \"Extension\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"TestScript.teardown.action.operation\",\
		\"weight\": 5143,\
		\"max\": \"1\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"VisionPrescription\",\
		\"weight\": 5144,\
		\"max\": \"*\",\
		\"type\": \"DomainResource\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"VisionPrescription.id\",\
		\"weight\": 5145,\
		\"max\": \"1\",\
		\"type\": \"id\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"VisionPrescription.meta\",\
		\"weight\": 5146,\
		\"max\": \"1\",\
		\"type\": \"Meta\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"VisionPrescription.implicitRules\",\
		\"weight\": 5147,\
		\"max\": \"1\",\
		\"type\": \"uri\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"VisionPrescription.language\",\
		\"weight\": 5148,\
		\"max\": \"1\",\
		\"type\": \"code\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"VisionPrescription.text\",\
		\"weight\": 5149,\
		\"max\": \"1\",\
		\"type\": \"Narrative\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"VisionPrescription.contained\",\
		\"weight\": 5150,\
		\"max\": \"*\",\
		\"type\": \"Resource\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"VisionPrescription.extension\",\
		\"weight\": 5151,\
		\"max\": \"*\",\
		\"type\": \"Extension\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"VisionPrescription.modifierExtension\",\
		\"weight\": 5152,\
		\"max\": \"*\",\
		\"type\": \"Extension\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"VisionPrescription.identifier\",\
		\"weight\": 5153,\
		\"max\": \"*\",\
		\"type\": \"Identifier\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"VisionPrescription.dateWritten\",\
		\"weight\": 5154,\
		\"max\": \"1\",\
		\"type\": \"dateTime\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"VisionPrescription.patient\",\
		\"weight\": 5155,\
		\"max\": \"1\",\
		\"type\": \"Reference\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"VisionPrescription.prescriber\",\
		\"weight\": 5156,\
		\"max\": \"1\",\
		\"type\": \"Reference\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"VisionPrescription.encounter\",\
		\"weight\": 5157,\
		\"max\": \"1\",\
		\"type\": \"Reference\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"VisionPrescription.reasonCodeableConcept\",\
		\"weight\": 5158,\
		\"max\": \"1\",\
		\"type\": \"CodeableConcept\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"VisionPrescription.reasonReference\",\
		\"weight\": 5158,\
		\"max\": \"1\",\
		\"type\": \"Reference\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"VisionPrescription.dispense\",\
		\"weight\": 5159,\
		\"max\": \"*\",\
		\"type\": \"BackboneElement\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"VisionPrescription.dispense.id\",\
		\"weight\": 5160,\
		\"max\": \"1\",\
		\"type\": \"id\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"VisionPrescription.dispense.extension\",\
		\"weight\": 5161,\
		\"max\": \"*\",\
		\"type\": \"Extension\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"VisionPrescription.dispense.modifierExtension\",\
		\"weight\": 5162,\
		\"max\": \"*\",\
		\"type\": \"Extension\"\
	},\
	{\
		\"min\": \"1\",\
		\"path\": \"VisionPrescription.dispense.product\",\
		\"weight\": 5163,\
		\"max\": \"1\",\
		\"type\": \"Coding\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"VisionPrescription.dispense.eye\",\
		\"weight\": 5164,\
		\"max\": \"1\",\
		\"type\": \"code\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"VisionPrescription.dispense.sphere\",\
		\"weight\": 5165,\
		\"max\": \"1\",\
		\"type\": \"decimal\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"VisionPrescription.dispense.cylinder\",\
		\"weight\": 5166,\
		\"max\": \"1\",\
		\"type\": \"decimal\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"VisionPrescription.dispense.axis\",\
		\"weight\": 5167,\
		\"max\": \"1\",\
		\"type\": \"integer\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"VisionPrescription.dispense.prism\",\
		\"weight\": 5168,\
		\"max\": \"1\",\
		\"type\": \"decimal\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"VisionPrescription.dispense.base\",\
		\"weight\": 5169,\
		\"max\": \"1\",\
		\"type\": \"code\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"VisionPrescription.dispense.add\",\
		\"weight\": 5170,\
		\"max\": \"1\",\
		\"type\": \"decimal\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"VisionPrescription.dispense.power\",\
		\"weight\": 5171,\
		\"max\": \"1\",\
		\"type\": \"decimal\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"VisionPrescription.dispense.backCurve\",\
		\"weight\": 5172,\
		\"max\": \"1\",\
		\"type\": \"decimal\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"VisionPrescription.dispense.diameter\",\
		\"weight\": 5173,\
		\"max\": \"1\",\
		\"type\": \"decimal\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"VisionPrescription.dispense.duration\",\
		\"weight\": 5174,\
		\"max\": \"1\",\
		\"type\": \"Quantity\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"VisionPrescription.dispense.color\",\
		\"weight\": 5175,\
		\"max\": \"1\",\
		\"type\": \"string\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"VisionPrescription.dispense.brand\",\
		\"weight\": 5176,\
		\"max\": \"1\",\
		\"type\": \"string\"\
	},\
	{\
		\"min\": \"0\",\
		\"path\": \"VisionPrescription.dispense.notes\",\
		\"weight\": 5177,\
		\"max\": \"1\",\
		\"type\": \"string\"\
	}\
]"function require_resource(e)return t[e]or error("resource '"..tostring(e).."' not found");end end
local e,t,a,h
if js and js.global then
h={}
h.dump=require("pure-xml-dump")
h.load=require("pure-xml-load")
a=require("lunajson")
package.loaded["cjson.safe"]={encode=function()end}
else
h=require("xml")
e=require("cjson")
t=require("datafile")
end
local D=require("resty.prettycjson")
local w,g,s,u,L,H,r,b,R
=ipairs,pairs,type,print,tonumber,string.gmatch,table.remove,string.format,table.sort
local l,c,T,v,y
local A,O,x,E
local _,o,j,k,q
local f,z,S
local I,m,N
local n
local i
local d,p
if e then
i=e.null
d,p=e.decode,e.encode
elseif a then
i=function()end
d=function(e)
return a.decode(e,nil,i)
end
p=function(e)
return a.encode(e,i)
end
else
error("neither cjson nor luajson libraries found for JSON parsing")
end
o=function(e)
local e=io.open(e,"r")
if e~=nil then io.close(e)return true else return false end
end
c=function(e)
local a={(e or""),"fhir-data/fhir-elements.json","src/fhir-data/fhir-elements.json","../src/fhir-data/fhir-elements.json","fhir-data/fhir-elements.json"}
local e
for a,t in w(a)do
if o(t)then
io.input(t)
e=d(io.read("*a"))
break
end
end
if not e and t then
local t,a=t.open("src/fhir-data/fhir-elements.json","r")
e=d(t:read("*a"))
end
if not e and require_resource then
e=d(require_resource("fhir-data/fhir-elements.json"))
end
assert(e,string.format("read_fhir_data: FHIR Schema could not be found in these locations:\n  %s.\n%s%s",table.concat(a," "),t and"Datafile could not find LuaRocks installation as well."or'',require_resource and"Embedded JSON data could not be found as well."or''))
return e
end
T=function(e,a)
if not e then return nil end
for t=1,#e do
if e[t]==a then return t end
end
end
N=function(e,a)
if not e then return nil end
local t={}
if s(a)=="function"then
for o=1,#e do
local e=e[o]
t[e]=a(e)
end
else
for o=1,#e do
t[e[o]]=a
end
end
return t
end
slice=function(e,t,o)
local a={}
for t=(t and t or 1),(o and o or#e)do
a[t]=e[t]
end
return a
end
v=function(a)
n={}
local i,o
o=function(t)
local e=n
for t in H(t.path,"([^%.]+)")do
e[t]=e[t]or{}
e=e[t]
end
e._max=t.max
e._type=t.type
e._type_json=t.type_json
e._weight=t.weight
e._derivations=N(t.derivations,function(e)return n[e]end)
i(e)
if s(n[t.type])=="table"then
e[1]=n[t.type]
end
end
i=function(e,t)
if not(e and e._derivations)then return end
local t=t and t._derivations or e._derivations
for a,t in g(t)do
if t._derivations then
for a,t in g(t._derivations)do
if e~=t then
e._derivations[a]=t
end
end
end
end
end
for e=1,#a do
local e=a[e]
o(e)
end
for e=1,#a do
local e=a[e]
o(e)
end
for e=1,#a do
local e=a[e]
o(e)
end
return n
end
j=function(t,e)
return e(t)
end
k=function(e,t)
io.input(e)
local e=io.read("*a")
io.input():close()
return t(e)
end
y=function(a,e)
local o=e.value
local t=l(a,e.xml)
if not t then
u(string.format("Warning: %s is not a known FHIR element; couldn't check its FHIR type to decide the JSON type.",table.concat(a,".")))
return o
end
local t=t._type or t._type_json
if t=="boolean"then
if e.value=="true"then return true
elseif e.value=="false"then return false
else
u(string.format("Warning: %s.%s is of type %s in FHIR JSON - its XML value of %s is invalid.",table.concat(a),e.xml,t,e.value))
end
elseif t=="integer"or
t=="unsignedInt"or
t=="positiveInt"or
t=="decimal"then
return L(e.value)
else return o end
end
l=function(t,a)
local e
for o=1,#t+1 do
local t=(t[o]or a)
if not e then
e=n[t]
elseif e[t]then
e=e[t]
elseif e[1]then
e=e[1][t]or(e[1]._derivations and e[1]._derivations[t]or nil)
else
e=nil
break
end
end
return e
end
q=function(o,i)
local e,t
local a=l(o,i)
if not a then
u(string.format("Warning: %s.%s is not a known FHIR element; couldn't check max cardinality for it to decide on a JSON object or array.",table.concat(o,"."),i))
end
if a and a._max=="*"then
e={{}}
t=e[1]
else
e={}
t=e
end
return e,t
end
A=function(t,a)
local e=l(t,a)
if e==nil then
u(string.format("Warning: %s.%s is not a known FHIR element; couldn't check max cardinality for it to decide on a JSON object or array.",table.concat(t,"."),a))
end
if e and e._max=="*"then
return"array"
end
return"object"
end
print_xml_value=function(e,a,o,n)
if not a[e.xml]then
local t
if A(o,e.xml)=="array"then
t={}
local a=a["_"..e.xml]
if a then
for e=1,#a do
t[#t+1]=i
end
end
t[#t+1]=y(o,e)
else
t=y(o,e)
end
a[e.xml]=t
else
local t=a[e.xml]
t[#t+1]=y(o,e)
local e=a["_"..e.xml]
if e and not n then
e[#e+1]=i
end
end
end
need_shadow_element=function(a,e,t)
if a~=1 and e[1]
and t[#t]~="extension"and e.xml~="extension"
then
if e.id then return true
else
for t=1,#e do
if e[t].xml=="extension"then return true end
end
end
end
end
O=function(e,a,l,o,h)
assert(e.xml,"error from parsed xml: node.xml is missing")
local n=a-1
local d=need_shadow_element(a,e,h)
local t
if a~=1 then
t=o[n][#o[n]]
end
if a==1 then
l.resourceType=e.xml
elseif h[#h]=="contained"then
t.resourceType=e.xml
o[a]=o[a]or{}
o[a][#o[a]+1]=t
return
elseif e.value then
print_xml_value(e,t,h,d)
end
if s(e[1])=="table"and a~=1 then
local n,r
if s(t[e.xml])=="table"and not d then
local e=t[e.xml]
e[#e+1]={}
r=e[#e]
elseif not t[e.xml]and(e[1]or e.value)and not d then
n,r=q(h,e.xml)
t[e.xml]=n
end
if d then
n,r=q(h,e.xml)
local a=b('_%s',e.xml)
local o
if not t[a]then
t[a]=n
o=true
else
t[a][#t[a]+1]=r
end
local a=T(t[e.xml],e.value)
if o and a and a>1 then
n[1]=nil
for e=1,a-1 do
n[#n+1]=i
end
n[#n+1]={}
r=n[#n]
end
if not e.value and t[e.xml]then
if s(t[e.xml][#t[e.xml]])=="table"then
t[e.xml][#t[e.xml]]=nil
end
t[e.xml][#t[e.xml]+1]=i
end
end
o[a]=o[a]or{}
o[a][#o[a]+1]=r
end
if e.url then
o[a][#o[a]].url=e.url
end
if e.id then
o[a][#o[a]].id=e.id
end
return l
end
E=function(a,t,e)
a[e][#a[e]][t.xml]=h.dump(t)
end
x=function(e,t,o,i,a)
t=(t and(t+1)or 1)
o=O(e,t,o,i,a)
a[#a+1]=e.xml
for n,e in w(e)do
if e.xml=="div"and e.xmlns=="http://www.w3.org/1999/xhtml"then
E(i,e,t)
else
assert(s(e)=="table",b("unexpected type value encountered: %s (%s), expecting table",tostring(e),s(e)))
x(e,t,o,i,a)
end
end
r(a)
return o
end
_=function(a,e)
n=n or v(c())
assert(next(n),"convert_to_json: FHIR Schema could not be parsed in.")
local t
if e and e.file then
t=k(a,h.load)
else
t=j(a,h.load)
end
local a={}
local o={[1]={a}}
local i={}
local t=x(t,nil,a,o,i)
return(e and e.pretty)and D(t,nil,'  ',nil,p)
or p(t)
end
z=function(a,o,n,t,s)
if a:find("_",1,true)then return end
local e=n[#n]
if a=="div"then
e[#e+1]=h.load(o)
elseif a=="url"then
e.url=o
elseif a=="id"then
local t=l(slice(t,1,#t-1),t[#t])._type
if t~="Resource"and t~="DomainResource"then
e.id=o
else
e[#e+1]={xml=a,value=tostring(o)}
end
elseif o==i then
e[#e+1]={xml=a}
else
e[#e+1]={xml=a,value=tostring(o)}
end
local o=e[#e]
if o then
o._weight=get_xml_weight(t,a)
o._count=#e
end
if s then
n[#n+1]=e[#e]
t[#t+1]=e[#e].xml
f(s,n,t)
r(n)
r(t)
end
end
get_xml_weight=function(e,t)
local a=l(e,t)
if not a then
u(string.format("Warning: %s.%s is not a known FHIR element; won't be able to sort it properly in the XML output.",table.concat(e,"."),t))
return 0
else
return a._weight
end
end
m=function(i,n,e,a)
if i:find("_",1,true)then return end
local t=e[#e]
t[#t+1]={xml=i}
local o=t[#t]
o._weight=get_xml_weight(a,i)
o._count=#t
e[#e+1]=o
a[#a+1]=o.xml
f(n,e,a)
r(e)
r(a)
end
print_contained_resource=function(a,t,o)
local e=t[#t]
e[#e+1]={xml=a.resourceType,xmlns="http://hl7.org/fhir"}
t[#t+1]=e[#e]
o[#o+1]=e[#e].xml
a.resourceType=nil
end
f=function(n,t,o)
local h
if n.resourceType then
print_contained_resource(n,t,o)
h=true
end
for a,e in g(n)do
if s(e)=="table"then
if s(e[1])=="table"then
for n,e in w(e)do
if e~=i then
m(a,e,t,o)
end
end
elseif e[1]and s(e[1])~="table"then
for h,s in w(e)do
local n,e=n[b("_%s",a)]
if n then
e=n[h]
if e==i then e=nil end
end
z(a,s,t,o,e)
end
elseif e~=i then
m(a,e,t,o)
end
elseif e~=i then
z(a,e,t,o,n[b("_%s",a)])
end
if a:sub(1,1)=='_'and not n[a:sub(2)]then
m(a:sub(2),e,t,o)
end
end
local e=t[#t]
R(e,function(e,t)
return(e.xml==t.xml)and(e._count<t._count)or(e._weight<t._weight)
end)
for t=1,#e do
local e=e[t]
e._weight=nil
e._count=nil
end
if h then
r(t)
r(o)
end
end
S=function(e,t,o,a)
if e.resourceType then
t.xmlns="http://hl7.org/fhir"
t.xml=e.resourceType
e.resourceType=nil
a[#a+1]=t.xml
end
return f(e,o,a)
end
I=function(e,a)
n=n or v(c())
assert(next(n),"convert_to_xml: FHIR Schema could not be parsed in.")
local t
if a and a.file then
t=k(e,d)
else
t=j(e,d)
end
local e,o={},{}
local a={e}
S(t,e,a,o)
return h.dump(e)
end
v(c())
return{
to_json=_,
to_xml=I
}
