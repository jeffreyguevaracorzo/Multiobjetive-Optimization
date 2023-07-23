function y=Mutate(x,params)

    h=params.h;
    VarMin=params.VarMin;
    VarMax=params.VarMax;

    sigma=h*(VarMax-VarMin);
    
    y=x+sigma*randn(size(x));
    
    % y=x+sigma*unifrnd(-1,1,size(x));
    
    y=min(max(y,VarMin),VarMax);

end