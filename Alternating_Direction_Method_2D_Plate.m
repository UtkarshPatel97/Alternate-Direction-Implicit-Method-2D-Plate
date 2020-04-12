clc;
clear all;
m = input('Enter the no of nodes in x direction : ');
n = input('Enter the no of nodes in y direction : ');
L = input('Enter the Total length : ');
W = input('Enter the Total width : ');
t = input('Enter the total time period : ');
dt = input('Enter the value of time step : ');
v = t/dt;
dt2 = dt/2;
dx = L/m;
dy = W/n;
left = input('Enter the Temp of Left side : ');
right = input('Enter the Temp of right side : ');
up = input('Enter the temp of up side : ');
down = input('Enter the temp of down side : ');
alpha = input('Enter the thermal diffusivity of material : ');
if alpha == 0
   c = input('Enter the specific heat of material : ');
   k = input('Enter the thermal conductivity of material : ');
   rho = input('Enter the density of material : ');
   alpha = k/(rho*c);
end
lamda1 = alpha*dt2/(dx*dx);
lamda2 = alpha*dt2/(dy*dy);
w = zeros(n,m);
for i = 1
    for j = 2:(m-1)
        w(i,j) = up;
    end
end
for i = n
    for j = 2:(m-1)
        w(i,j) = down;
    end
end
for j = 1
    for i = 2:(n-1)
        w(i,j) = left;
    end
end
for j = m
    for i = 2:(n-1)
        w(i,j) = right;
    end
end
w(1,1) = (up + left)/2;
w(n,1) = (left + down)/2;
w(n,m) = (down + right)/2;
w(1,m) = (right + up)/2;
o = m-2;
p = n-2;
q = o*p;
for l = 1:v
B = zeros(q,1);
z = 0;
for i = (m-1) : -1 : 2
    for j = 2:(n-1)
        z = z+1;
       B(z,1)= lamda2*w(i+1,j) + (1 - 2*lamda2)*w(i,j) + lamda2*w(i-1,j);
        if j == 2
           B(z,1) = lamda1*w(i,j-1); 
        end
        if j == (n-1)
           B(z,1) = lamda1*w(i,j+1); 
        end
    end
end
dd = (1 + 2*lamda1);
ud = -lamda1;
ld = -lamda1;
A = zeros(q,q);
for i = 1:q
   A(i,i) = dd; 
end
for i = 1:(q-1)
   A(i,i+1) = ud; 
   r = rem(i,o);
   if r == 0
      A(i,i+1) = 0; 
   end
end
for i = 2:q
   A(i,i-1) = ld;
end
for i = 2:(q-1)
   r = rem(i,o);
   if r == 0
      A(i+1,i) = 0; 
   end
end
MA = zeros(q,q);
MB = zeros(q,1);
MA(1,1) = A(1,1);
MB(1,1) = B(1,1);
for i = 2:q
     MA(i,i) = A(i,i) - A(i,i-1)*A(i-1,i)/MA(i-1,i-1) ; 
     MB(i,1) = B(i,1) - MB(i-1,1)*A(i,i-1)/MA(i-1,i-1) ; 
end
for i = 1:(q-1)
   MA(i,i+1) = A(i,i+1); 
end
C = zeros(q,1);
for i = q : -1 : 1
   if i == q
      C(i,1) = MB(i,1)/MA(i,i); 
   end
   if i < q
       C(i,1) = MB(i,1) - MA(i,i+1)*C(i+1,1)/MA(i,i);
   end
end
y = 0;
for i = (m-1) : -1 : 2
    for j = 2:(n-1)
        y = y+1;
        w(i,j) = C(y,1);
    end
end



B = zeros(q,1);
z = 0;
for j = 2 : (n-1)
    for i = (m-1) : -1 : 2
        z = z+1;
       B(z,1)= lamda1*w(i,j-1) + (1 - 2*lamda1)*w(i,j) + lamda1*w(i,j-1);
        if i == 2
           B(z,1) = lamda2*w(i-1,j); 
        end
        if i == (m-1)
           B(z,1) = lamda2*w(i+1,j); 
        end
    end
end
dd = (1 + 2*lamda2);
ud = -lamda2;
ld = -lamda2;
A = zeros(q,q);
for i = 1:q
   A(i,i) = dd; 
end
for i = 1:(q-1)
   A(i,i+1) = ud; 
   r = rem(i,o);
   if r == 0
      A(i,i+1) = 0; 
   end
end
for i = 2:q
   A(i,i-1) = ld;
end
for i = 2:(q-1)
   r = rem(i,o);
   if r == 0
      A(i+1,i) = 0; 
   end
end
MA = zeros(q,q);
MB = zeros(q,1);
MA(1,1) = A(1,1);
MB(1,1) = B(1,1);
for i = 2:q
     MA(i,i) = A(i,i) - A(i,i-1)*A(i-1,i)/MA(i-1,i-1) ; 
     MB(i,1) = B(i,1) - MB(i-1,1)*A(i,i-1)/MA(i-1,i-1) ; 
end
for i = 1:(q-1)
   MA(i,i+1) = A(i,i+1); 
end
C = zeros(q,1);
for i = q : -1 : 1
   if i == q
      C(i,1) = MB(i,1)/MA(i,i); 
   end
   if i < q
       C(i,1) = MB(i,1) - MA(i,i+1)*C(i+1,1)/MA(i,i);
   end
end
y = 0;
for j = 2:(n-1)
    for i = (m-1) : -1 : 2
        y = y+1;
        w(i,j) = C(y,1);
    end
end
s = l*dt;
if s == 100
    clc;
   fprintf('at %d sec: \n',s);
   disp(w);
end
if s == 200
   fprintf('at %d sec: \n',s);
   disp(w);
end
if s == 300
   fprintf('at %d sec: \n',s);
   disp(w);
end
if s == 1000
   fprintf('at %d sec: \n',s);
   disp(w);
end
end