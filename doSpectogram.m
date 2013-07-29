function spec_data = doSpectogram(data,s)


N_data = size(data,1);

spec_data = zeros(N_data,s);


for i=1:N_data
    
    
    [~,~,~,P] = spectrogram(data(i,:),90);
    spec_data(i,:) = P(:)';
    

    
end

end