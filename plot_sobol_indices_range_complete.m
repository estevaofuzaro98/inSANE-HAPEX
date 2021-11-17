function fig = plot_sobol_indices_range_complete(SobolResults,paramRange,paramName)
    
    XTick_Str = cellfun(@num2str,num2cell(paramRange(:)),'uniformoutput',false);
    
    [maxValPar, maxIdxPar] = maxk(SobolResults.AllOrders{1,2},2);
    number2name = SobolResults.VarIdx{2,1}(maxIdxPar,:);

    for i = 1:2
        parPlot(i,1) = XTick_Str(number2name(i,1)); %#ok<AGROW>
        parPlot(i,2) = XTick_Str(number2name(i,2)); %#ok<AGROW>
        namePar(i,1) = strcat({'$'},parPlot(i,1),{' '},parPlot(i,2),{'$'}); %#ok<AGROW>
    end
    
    y = [SobolResults.FirstOrder;maxValPar];
    set(groot,'defaultAxesTickLabelInterpreter','latex');
    set(groot,'defaultLegendInterpreter','latex');
    set(groot,'defaultTextInterpreter','latex');
    
    fig = figure();
    set(gcf,'Units','Normalized','OuterPosition',[0 0 1 1])
    
    b = bar(y,'stacked','FaceColor','flat');
    set(b, 'FaceColor', 'Flat')
    b(1).CData = [255, 241, 0]/255;
    b(2).CData = [255, 140, 0]/255;
    b(3).CData = [232, 17, 35]/255;
    b(4).CData = [236, 0, 140]/255;
    b(5).CData = [104, 33, 122]/255;
    b(6).CData = [0, 24, 143]/255;
    b(7).CData = [0, 188, 242]/255;
    b(8).CData = [0, 178, 148]/255;
    b(9).CData = [0, 158, 73]/255;
    b(10).CData = [186, 216, 10]/255;
            
    set(gca,'XTickLabel',XTick_Str,'XTick',1:numel(XTick_Str))
    set(gca,'fontsize',18,'XColor','k','YColor','k','GridColor','k');
    grid on
    grid minor
    ylabel('Sobol'' Index','fontsize',18); xlabel(paramName,'fontsize',18);
    legend({'$\chi$';'$f$';'$k_1$';'$k_2$';'$\kappa$';'$\Lambda$';...
        '$\omega$';'$\zeta$';namePar(1,1);namePar(2,1)},'Location','northeast','fontsize',18)
    title('Sobol Index based on PCE','FontSize',18,'FontName','Helvetica');
    hold on
end