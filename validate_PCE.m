function [X,Y,YPC] = validate_PCE(sample_size)

    X = uq_getSample(sample_size);
    
    for ii=1:size(X,1)
        Y(ii,:) = harvester_solver_sobol(X(ii,:)); %#ok<AGROW>
    end
    
    YPC = uq_evalModel(X);
end
