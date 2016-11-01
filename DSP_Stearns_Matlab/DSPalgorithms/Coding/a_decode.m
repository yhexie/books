function x=a_decode(y,fN,ipr)
% x=a_decode(y,fN)
% Arithmetic decoding using the same integer frequency table
% used by a_encode.
%
% y  =int*8 code vector generated by a_encode.
% fN =length(x)*(frequency table used by a_encode for encoding).
%     NOTE: sum(fN) must equal the length of x.
% x  =decoded vector.
% Note: You may include a third argument, i.e., a_decode(y,fN,ipr).
%       If ipr=1 decoding info is printed. If ipr=2, more is printed.
% See also: a_encode, freq
if nargin==2,
	ipr=0;
elseif nargin<2,
   error('a_decode requires at least 2 arguments.')
end
N=length(fN);
if N>=2^16
	error('Number of symbols exceeds 2^16-1.');
end
Nx=sum(fN);
if Nx<2,
   error('sum(fN) must equal length(x) and be >1.')
end
% Set word partitions. W =same as in a_encode.
W=44;
% Initialize on the basis of W.
t=2^(W/2)-1;
t1=(t+1)/4;
t2=2*t1;
t3=3*t1;
% Compute cf as computed in a_encode. Initialize L,H.
M=triu(ones(N,N));
cf=[0 fN*M];
L=0;
H=t;
if ipr==1 | ipr==2,
   fprintf('cf:\n');
   fprintf('%7.0f%7.0f%7.0f%7.0f%7.0f%7.0f%7.0f%7.0f%7.0f%7.0f\n',cf);
	fprintf('\nL,H: %12.1f%12.1f \n',[L,H]);
end
% ix=index in x; jb=bit location in y; val=working value.
x=zeros(Nx,1);
jb=0;
val=0;
for i=1:W/2,
   [bit,jb]=a_input(y,jb,ipr);
   val=2*val+bit;
end
% Decode loop starts here.
for ix=1:Nx,
% Find sym= current symbol. sym values begin at 1, so x=sym-1.
   R=H-L;
   cfx=fix(((val-L+1)*Nx-1)/R);
   i=2;
   while cf(i)<=cfx,
      i=i+1;
      if i>N+1,
         error('Fatal error. cfx > Nx.')
      end
   end
   sym=i-1;
   x(ix)=sym-1;
	if ipr==1 | ipr==2,
	   fprintf('L,H,val,cfx,ix,x:%10.0f%10.0f%12.1f%7.0f%7.0f%5.0f\n',...
      L,H,val,cfx,ix,sym-1)
	end
% Adjust H and L as in a_encode.
   H=fix(L+(R*cf(sym+1))/Nx-1);
   L=fix(L+(R*cf(sym))/Nx);
% Ensure L < t2 <= H, and (L,H) not in [t1,t3).
   while H<t2 | L>=t2 | (L>=t1 & H<t3),
      if L>=t2
         val=val-t2;
         L=L-t2;
         H=H-t2;
      elseif L>=t1 & H<t3
         val=val-t1;
         L=L-t1;
         H=H-t1;
      end
      [bit,jb]=a_input(y,jb,ipr);
      val=2*val+bit;
      L=2*L;
      H=2*H+1;
   end
end 
