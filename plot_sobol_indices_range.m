function fig = plot_sobol_indices_range(SobolResults1st,SobolResults2nd,paramRange,paramName)
    
    y = [SobolResults1st,SobolResults2nd];
    set(groot,'defaultAxesTickLabelInterpreter','latex');
    set(groot,'defaultLegendInterpreter','latex');
    set(groot,'defaultTextInterpreter','latex');
    
    fig = figure();
    set(gcf,'Units','Normalized','OuterPosition',[0 0 1 1])
    XTick_Str = cellfun(@num2str,num2cell(paramRange(:)),'uniformoutput',false);
    
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
    b(11).CData = [144, 140, 152]/255;
    b(12).CData = [107, 104, 112]/255;
    b(13).CData = [69, 67, 73]/255;
            
    set(gca,'XTickLabel',XTick_Str,'XTick',1:numel(XTick_Str))
    set(gca,'fontsize',18,'XColor','k','YColor','k','GridColor','k');
    grid on
    grid minor
    ylim([0 1])
    ylabel('Sobol'' Index','fontsize',18); xlabel(paramName,'fontsize',18);
    legend({'$\chi$';'$f$';'$k_1$';'$k_2$';'$\kappa$';'$\Lambda$';...
        '$\omega$';'$\zeta$';'$f\omega$';'$\kappa\omega$';'$k_1 k_2$';...
        '$k_2 \Lambda$'; '$k_1 \Lambda$'},'Location','northeast','fontsize',18)
    title('Sobol Index based on PCE','FontSize',18,'FontName','Helvetica');
    hold on
end