%Testbench generated using HDL IP Designer
% generate input stimulus for DUT
numSamples = 200;

x = randn(numSamples,1);

testbench.data = fi(x,1,16,15);

data = testbench.data ;
NumDim = length(size( data ));
NumSamples = size( data ,1);
SamplesPerFrame = 1;
NumChannels = size( data ,2);
valid = true(1,NumSamples);
dataIn = data;
validIn = valid;
 
% call DUT with stimulus and save output
    for ii = 1:1:NumSamples
    [dataOut(ii), validOut(ii)] = LowpassFilter(dataIn(ii), validIn(ii));
    end
    
