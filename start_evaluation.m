%% load spec data
clear all;
dbstop if error

dir = 'data/preprocessed_data';
prefix = 'spec_data_all';
labels = load('data/labels.txt');
  
train01 = load(strcat(dir,'/',prefix,'train','01'));
%train02 = load(strcat(dir,'/',prefix,'train','02'));
%train03 = load(strcat(dir,'/',prefix,'train','03'));

%data = [train01.data01; train02.data02; train03.data03];

data = train01.data01;

clear train01 train02 train03;


for i=1:size(data,1)
    tmp = reshape(data(i,:),52,188);
    tmp = tmp./max(max(tmp));
    tmp = bfilter2(tmp,5,[3 0.125]);
    data(i,:) = tmp(:);
end


%% add Distance to mean spectogram (multi-scale)

mean_spec = load('data/preprocessed_data/mean_spectograms.mat');

meanp.r0 = mean_spec.mean_spec.positive;
meanp.r0 = reshape(meanp.r0,52,188);
meanp.r1 = imresize(meanp.r0,0.5);
meanp.r2 = imresize(meanp.r1,0.5);
meanp.r3 = imresize(meanp.r2,0.5);
meanp.r4 = imresize(meanp.r3,0.5);

% meann.r0 = mean_spec.mean_spec.negative;
% meann.r0 = reshape(meann.r0,52,188);
% meann.r1 = imresize(meann.r0,0.5);
% meann.r2 = imresize(meann.r1,0.5);
% meann.r3 = imresize(meann.r2,0.5);
% meann.r4 = imresize(meann.r3,0.5);



fdatap = zeros(size(data,1),5);
% fdatan = zeros(size(data,1),5);


for i=1:size(data,1)
    spec.r0 = reshape(data(i,:),52,188);
    spec.r1 = imresize(spec.r0,0.5);
    spec.r2 = imresize(spec.r1,0.5);
    spec.r3 = imresize(spec.r2,0.5);
    spec.r4 = imresize(spec.r3,0.5);
    fdatap(i,:) = multiscaledist(spec,meanp);
%     fdatan(i,:) = multiscaledist(spec,meann);
    
end

    data = [data fdatap];
    clear fdatap fdatan;


%% 


CVO = cvpartition(labels(1:10000),'k',5);

AUC = zeros(CVO.NumTestSets,1);

matlabpool close force local;
matlabpool open local 5

n_trees = 10;
for i = 1:CVO.NumTestSets
    trIdx = CVO.training(i);
    teIdx = CVO.test(i);
    nb = TreeBagger(n_trees,data(trIdx,:),labels(trIdx));
    [~,Predicted]  = nb.predict(data(teIdx,:));

    Predicted = 1 - Predicted(:,1);
    [~, ~, ~, auc ] = perfcurve(labels(teIdx), Predicted, 1);
     AUC(i) = auc;

end
mean(AUC)

matlabpool close
% 0.8316 with no filtering
% 0.8691     with 3 0.125 filtering 
%exit