
% generates feature vector based on distances to mean spectogram
dbstop if error
dir = 'data/preprocessed_data';
prefix = 'spec_data_all';

  
test01 = load(strcat(dir,'/',prefix,'test','01'));
test02 = load(strcat(dir,'/',prefix,'test','02'));
test03 = load(strcat(dir,'/',prefix,'test','03'));

data = [test01.data01; test02.data02; test03.data03];
clear test01 test02 test03;


mean_spec = load('data/preprocessed_data/mean_spectograms.mat');

meanp.r0 = mean_spec.mean_spec.positive;
meanp.r0 = reshape(meanp.r0,52,188);
meanp.r1 = imresize(meanp.r0,0.5);
meanp.r2 = imresize(meanp.r1,0.5);
meanp.r3 = imresize(meanp.r2,0.5);
meanp.r4 = imresize(meanp.r3,0.5);


dist_data = zeros(size(data,1),5);


for i=1:size(data,1)
    spec.r0 = reshape(data(i,:),52,188);
    spec.r1 = imresize(spec.r0,0.5);
    spec.r2 = imresize(spec.r1,0.5);
    spec.r3 = imresize(spec.r2,0.5);
    spec.r4 = imresize(spec.r3,0.5);
    dist_data(i,:) = multiscaledist(spec,meanp);
    
end

save('multscale_dist_alltest.mat','dist_data');

exit

