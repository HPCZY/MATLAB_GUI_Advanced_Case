clear; close all; clc

maxIter = 1000;
WB = myWaitBar(maxIter);

for iter = 1:maxIter
    pause(0.001)
%     if ~rem(iter,10)
       WB.updata(iter)
%        break
%     end
    
end
WB.closeWaitBar();
