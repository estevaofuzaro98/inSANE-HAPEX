function [X,Y,YPCE] = validate_PCE(sample_size,myModel,myPCE)
    X = uq_getSample(sample_size);
    Y = uq_evalModel(myModel,X);
    YPCE = uq_evalModel(myPCE,X);
end
