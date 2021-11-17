function fig = plot_sobol_indices(mySobolAnalysis,order,method,NSamples)

title_name = ['Sobol Index based on ', method];
paramsNames = {'$\chi$';'$f$';'$k_1$';'$k_2$';'$\kappa$';'$\Lambda$';'$\omega$';'$\zeta$'};

color = [0.5 0.5 0.5];

if order == 1
    if contains(method,'MC')
        y_mc = mySobolAnalysis.Results.FirstOrder;
        error_mc = mySobolAnalysis.Results.Bootstrap.FirstOrder.ConfLevel;
        
        y = [y_mc]; %#ok<NBRAK>
        
    elseif contains(method,'PCE')
        y_pce = mySobolAnalysis.Results.FirstOrder;
        
        y = [y_pce]; %#ok<NBRAK>
    end
    
    fig = figure();
    set(gcf,'Units','Normalized','OuterPosition',[0 0 1 1])
    b = bar(y);
    hold on
    b(1).FaceColor = color;
    b(1).EdgeColor = color;
    
    if contains(method,'MC')
        er = errorbar(y_mc,error_mc,'LineWidth',2);
        er.Color = [0 0 0];
        er.LineStyle = 'none';
    end
    
    label_x = paramsNames';
    label_y = {'First Order'};
    ylim([ 0 1]);
    
elseif order == 2
    [Valu_max, Varldx_max] = maxk(mySobolAnalysis.Results.AllOrders{1,2},5);
    
    Varldx_numC = mySobolAnalysis.Results.VarIdx{2, 1}(Varldx_max,:);
    
    for i = 1:5
        Par_plot(i,1) = paramsNames(Varldx_numC(i,1)); %#ok<AGROW>
        Par_plot(i,2) = paramsNames(Varldx_numC(i,2)); %#ok<AGROW>
        Name_par(i,1) = strcat({'$'},Par_plot(i,1),{' '},Par_plot(i,2),{'$'}); %#ok<AGROW>
    end
    
    y = Valu_max;
    label_x = Name_par';
    label_y = {'Second Order'};
    
    fig = figure();
    set(gcf,'Units','Normalized','OuterPosition',[0 0 1 1])
    b = bar(y);
    hold on
    b(1).FaceColor = color;
    b(1).EdgeColor = color;
    
    ylim([0 max(y)*1.2])
end
set(gca, 'XTickLabel',label_x, 'XTick',1:numel(label_x),...
    'FontName','Helvetica','FontSize',18,'linewidth',1.2,...
    'TickLabelInterpreter','latex');

ax = gca; xrule = ax.XAxis; xrule.FontSize = 20;

set(gca,'Box','on');
set(gca,'XGrid','on','YGrid','on');

uq_legend({sprintf('PCE-based (%d simulations)',NSamples)},'Location', 'northeast','fontsize',18)

ylabel(label_y,'FontSize',18,'FontName','Helvetica');
title(title_name,'FontSize',18,'FontName','Helvetica');
hold off
end