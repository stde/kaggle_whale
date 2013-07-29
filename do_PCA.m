
clear all; close all; dbstop if error

%% load data


dir = 'data/preprocessed_data';
prefix = 'spec_data_all';
labels = load('data/labels.txt');
  
train01 = load(strcat(dir,'/',prefix,'train','01'));
train02 = load(strcat(dir,'/',prefix,'train','02'));
train03 = load(strcat(dir,'/',prefix,'train','03'));

training_data = [train01.data01; train02.data02; train03.data03];

matlabpool close force local;

matlabpool open local 5;
parfor i=1:size(training_data,1)
    tmp = reshape(training_data(i,:),52,188);
    tmp = tmp./max(max(tmp));
    tmp = bfilter2(tmp,5,[3 0.125]);
    training_data(i,:) = tmp(:);
end


 mscale = load('data/preprocessed_data/multscale_dist_alltrain.mat');
 mscale = mscale.dist_data;
 
 training_data = [training_data mscale];
 
 
 
 
 
 
 clear mscale;
 

clear train01 train02 train03;


test01 = load(strcat(dir,'/',prefix,'test','01'));
test02 = load(strcat(dir,'/',prefix,'test','02'));
test03 = load(strcat(dir,'/',prefix,'test','03'));

test_data = [test01.data01; test02.data02; test03.data03];

parfor i=1:size(test_data,1)
    tmp = reshape(test_data(i,:),52,188);
    tmp = tmp./max(max(tmp));
    tmp = bfilter2(tmp,5,[3 0.125]);
    test_data(i,:) = tmp(:);
end


clear test01 test02 test03;
 mscale = load('data/preprocessed_data/multscale_dist_alltest.mat');
 mscale = mscale.dist_data;
 test_data = [test_data mscale];
 
[~,scores,latent] = princomp([training_data; test_data]);

clear training_data;
clear test_data;

tmp = round(size(scores,1)/5);
prin01 = scores(1:tmp,:);
prin02 = scores(tmp+1:2*tmp,:);
prin03 = scores(2*tmp+1:3*tmp,:);
prin04 = scores(3*tmp+1:4*tmp,:);
prin05 = scores(4*tmp+1:end,:);
clear scores;

save('princomp_data01.mat','prin01');
save('princomp_data02.mat','prin02');
save('princomp_data03.mat','prin03');
save('princomp_data04.mat','prin04');
save('princomp_data05.mat','prin05');
save('princomp_latent.mat','latent');





exit
 

