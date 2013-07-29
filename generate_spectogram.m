
clear all; close all; dbstop if error

%% load data


dir = 'data/train';
prefix = 'train';
type = '.aiff';


labels = load('data/labels.txt');

%N_data = 18000; % 0.89
N_data = 30000;   % 0.654
N_train = round(N_data*0.75);
N_test = N_data - N_train;
dim = 4000; % dimensionality of data

data = zeros(N_data,dim);
matlabpool close force local;
matlabpool open local 7;

parfor i=1:N_data
    
    u = double(aiffread(strcat(dir,'/',prefix,num2str(i),type)));
    data(i,:) = u';
    
    
end


display('finished reading')



%% model parameter

N_pca =  200;  %  first N_pca Dimension to take




%% generate Fourier transform
Fs = 2000; % Sampling frequency
T = 1/Fs; % Sample time
L = 4000; % Length of signal
t = (0:L-1)*T; % Time vector
 NFFT = 2^nextpow2(L); % Next power of 2 from length of y

spec_data = zeros(N_data,11223);
fdata = zeros(N_data,NFFT/2+1);


parfor i=1:N_data
    
    
    [~,~,~,P] = spectrogram(data(i,:),90);
    spec_data(i,:) = P(:)';
    
     Y = fft(data(i,:),NFFT)/L;
    
     fdata(i,:)  = abs(Y(1:NFFT/2+1) );
    %  fdata(i,:) = [real(Y(1:NFFT/2+1))  imag(Y(1:NFFT/2+1))];
    
end
tmp = round(N_data/3);

%data01 = data(1:tmp,:);
%data02 = data(tmp+1:2*tmp,:);
%data03 = data(2*tmp+1:end,:);

%clear data;

%save('data_alltrain01.mat','data01');
%save('data_alltrain02.mat','data02');
%save('data_alltrain03.mat','data03');

%clear data01; clear data02; clear data03;

data01 = spec_data(1:tmp,:);
data02 = spec_data(tmp+1:2*tmp,:);
data03 = spec_data(2*tmp+1:end,:);

save('spec_data_alltrain01.mat','data01');
save('spec_data_alltrain02.mat','data02');
save('spec_data_alltrain03.mat','data03');

clear data01; clear data02; clear data03;

data01 = fdata(1:tmp,:);
data02 = fdata(tmp+1:2*tmp,:);
data03 = fdata(2*tmp+1:end,:);

save('f_data_alltrain01.mat','data01');
save('f_data_alltrain02.mat','data02');
save('f_data_alltrain03.mat','data03');

clear data01; clear data02; clear data03;



matlabpool close;
exit
