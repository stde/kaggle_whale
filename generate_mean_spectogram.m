

clear all; close all; dbstop if error

%% load data


dir = 'data/preprocessed_data';
prefix = 'spec_data_all';
labels = load('data/labels.txt');
  
train01 = load(strcat(dir,'/',prefix,'train','01'));
train02 = load(strcat(dir,'/',prefix,'train','02'));
train03 = load(strcat(dir,'/',prefix,'train','03'));

training_data = [train01.data01; train02.data02; train03.data03];

pos_ex = training_data(labels == 1,:);
neg_ex = training_data(labels == 0,:);


mean_spec.positive = mean(pos_ex,1);
mean_spec.negative = mean(neg_ex,1);

save('mean_spectograms.mat','mean_spec');

exit


