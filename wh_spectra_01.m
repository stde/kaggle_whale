function [t,f,y]=wh_spectra_01(fname,per,pflag)
%--------------------------------------------------------------------------
%
%   This function creates a spectrogram specifically for the right whale
%   call detection project.
%
%       [t,f,y]=wh_spectra_01(fname,per,pflag)
%
%           fname is the path to the *.aiff file
%
%           per is the percent of most powerful frequencies to plot. If per
%           = .1, the 90% of points with the lowest power will be set to 0. 
%           (default = 1).
%
%           pflag is 1 for a plot, 0 for no plot (default = 1)
%
%           t, f, y, are the time, frequency, and magnitude arrays of the
%           spectrogram, they are formatted to work with functions like
%           pcolor(t,f,y)
%
% Author: Nathan Rosenstock
% Last Modified: February 23, 2013
%   THIS CODE IS PROVIDED AS IS, WITH NO GUARENTEES OF CORRECTNESS, USE AT
%   YOUR OWN RISK.
%  returns 52,188
%--------------------------------------------------------------------------

%default inputs
if nargin==1
    pflag=1;
    per=1;
elseif nargin==2
    pflag=1;
end

%constants
nfft=256;
nt=20;
fs=2000;
dt=1/fs;
fmax=400;

%read in data
x=double(aiffread(fname));
n=length(x);

%initialize outputs
nf=nfft/2+1;
tt=dt*(nfft-1)/2:nt*dt:(n-1)*dt-(nfft/2)*dt;
ntt=length(tt);
f=linspace(0,fs/2,nf)'*ones(1,ntt);
t=ones(nf,1)*tt;
y=zeros(nf,ntt);

%create window vector
xw=[0:nfft-1]';
wind=.5*(1-cos((xw*2*pi)/(nfft-1)));

%create ffts
for i=1:ntt
    
    %fft
    zi=(i-1)*nt+1:nfft*i-(i-1)*(nfft-nt);
    xss=fft(x(zi).*wind,nfft)/nfft;
    yy=2*abs(xss(1:(nfft/2)+1));
    
    %update y
    y(:,i)=yy;
    
end

%reduce t,f,y to fmax
zi=f(:,1)<=fmax;
f=f(zi,:);
t=t(zi,:);
y=y(zi,:);

%eliminate least powerful points
if per<1
    sy=sort(y(:));
    si=floor((1-per)*length(sy));
    sval=sy(si);
    y(y<=sval)=0;
end

%create plot
if pflag
    hold off;
    pcolor(t,f,y);
    shading flat;
    xlabel('Time (sec)');
    ylabel('Frequency (Hz)');
    title('Spectrogram');
end



