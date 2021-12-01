function fig = plot_sobol_indices_single(SobolResults1st,SobolResults2nd)
    
    y = [SobolResults1st,SobolResults2nd];
    set(groot,'defaultAxesTickLabelInterpreter','latex');
    set(groot,'defaultLegendInterpreter','latex');
    set(groot,'defaultTextInterpreter','latex');
    
    fig = figure();
    set(gcf,'Units','Normalized','OuterPosition',[0 0 1 1])
    XTick_Str = {'$\chi$';'$f$';'$k_1$';'$k_2$';'$\kappa$';'$\Lambda$';...
        '$\omega$';'$\zeta$';'$f\omega$';'$\kappa\omega$';'$k_1 k_2$';...
        '$k_2 \Lambda$'; '$k_1 \Lambda$'};
    
    b = bar(y,'FaceColor','flat');
    set(b, 'FaceColor', 'Flat')
    b(1).CData = [236, 0, 140]/255;
                
    set(gca,'XTickLabel',XTick_Str,'XTick',1:numel(XTick_Str))
    set(gca,'fontsize',18,'XColor','k','YColor','k','GridColor','k');
    grid on
    grid minor
    ylim([0 1])
    ylabel('Sobol'' Index','fontsize',18); xlabel('Parameters','fontsize',18);
    title('Sobol Index based on PCE','FontSize',18,'FontName','Helvetica');
    hold on
end