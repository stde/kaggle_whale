function fdata = doFourier(data)


N_data = size(data,1);

%T = 1/Fs; % Sample time
L = size(data,2); % Length of signal
%t = (0:L-1)*T; % Time vector
NFFT = 2^nextpow2(L); % Next power of 2 from length of y


for i=1:N_data

    % 
     Y = fft(data(i,:),NFFT)/L;
    
     fdata(i,:)  = abs(Y(1:NFFT/2+1) );
    %  fdata(i,:) = [real(Y(1:NFFT/2+1))  imag(Y(1:NFFT/2+1))];
    
end

end