% 
% clear all; close all; dbstop if error
% 
% %% load data
% 
% 
% dir = 'data/preprocessed_data';
% prefix = 'spec_data_all';
 labels = load('data/labels.txt');
%   
% train01 = load(strcat(dir,'/',prefix,'train','01'));
% train02 = load(strcat(dir,'/',prefix,'train','02'));
% train03 = load(strcat(dir,'/',prefix,'train','03'));
% 
% training_data = [train01.data01; train02.data02; train03.data03];
% 
% for i=1:size(training_data,1)
%     tmp = reshape(training_data(i,:),52,188);
%     tmp = tmp./max(max(tmp));
%     tmp = bfilter2(tmp,5,[3 0.125]);
%     training_data(i,:) = tmp(:);
% end
% 
% 
%  mscale = load('data/preprocessed_data/multscale_dist_alltrain.mat');
%  mscale = mscale.dist_data;
%  
%  training_data = [training_data mscale];
%  
%  clear mscale;
%  
%  disp('Training Data ready!');
% 
% clear train01 train02 train03;
% 
% %% filter stuff
% test01 = load(strcat(dir,'/',prefix,'test','01'));
% test02 = load(strcat(dir,'/',prefix,'test','02'));
% test03 = load(strcat(dir,'/',prefix,'test','03'));
% 
% test_data = [test01.data01; test02.data02; test03.data03];
% 
% for i=1:size(test_data,1)
%     tmp = reshape(test_data(i,:),52,188);
%     tmp = tmp./max(max(tmp));
%     tmp = bfilter2(tmp,5,[3 0.125]);
%     test_data(i,:) = tmp(:);
% end
% 
% %% mscale stuff
% clear test01 test02 test03;
%  mscale = load('data/preprocessed_data/multscale_dist_alltest.mat');
%  mscale = mscale.dist_data;
%  test_data = [test_data mscale];
%  
%  clear mscale
% 
%  disp('Test Data ready!');
 %% Deep Stuff
 
 tr01 = load('traindata_allprepr_01');
 tr02 = load('traindata_allprepr_02');
 tr03 = load('traindata_allprepr_03');

 
 training_data = [tr01.train01; tr02.train02; tr03.train03];
 clear tr01 tr02 tr03;
 
 tr01 = load('testdata_allprepr_01');
 tr02 = load('testdata_allprepr_02');
 tr03 = load('testdata_allprepr_03');
 
 test_data = [tr01.test01; tr02.test02; tr03.test03];
 clear tr01 tr02 tr03;
 
disp('Data loaded!');

 
 deepData = load('data/preprocessed_data/deep_data_all.mat'); 
 deepData =  deepData.deepF;
 
 mu = mean(deepData,1);
 
 for i = 1:size(deepData,1)
     deepData(i,:) =  deepData(i,:) - mu;
 end

 
 training_data = [training_data deepData(1:size(training_data,1),:)];
 test_data = [test_data deepData(1:size(test_data,1),:)];
 
 clear deepDataTrain;
 clear deepDataTest;
 
 
 

 disp('Deep Data Ready!');
 
 
 disp('Starting Learning now!');
 
matlabpool close force local;
matlabpool open local 3;

paroptions = statset('UseParallel',true);

nb = TreeBagger(250,training_data,labels,'Options',paroptions);
[~,Predicted]  = nb.predict(test_data);

Predicted = Predicted(:,1);

save('Predicted2_rf_spec_data_mscale_filter_deep_alltest.mat','Predicted');

matlabpool close;

exit;


