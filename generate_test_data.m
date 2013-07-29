
clear all; close all; dbstop if error

%% load data


dire = 'data/train';
prefix = 'train';
type = '.aiff';



%N_data = 18000; % 0.89
N_data = 30000;   % 0.654


%f_data = zeros(N_data, 2^nextpow2(dim/2)+1);
spec_data = zeros(N_data,  9776);
matlabpool close force local;
matlabpool open local 3;

parfor i=1:N_data
    
    [~,~, tmp ] =  (wh_spectra_01(strcat(dire,'/',prefix,num2str(i),type),1,0));
    spec_data(i,:) = tmp(:);
   
end

tmp = round(N_data/3);
data01 = spec_data(1:tmp,:);
data02 = spec_data(tmp+1:2*tmp,:);
data03 = spec_data(2*tmp+1:end,:);
clear fdata;

save('spec_data_alltrain01.mat','data01');
save('spec_data_alltrain02.mat','data02');
save('spec_data_alltrain03.mat','data03');

matlabpool close;

exit






