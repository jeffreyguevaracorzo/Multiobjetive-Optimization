function PlotCosts(PF)
    
    PFC=[PF.Cost];
    plot(PFC(1,:),PFC(2,:),'x');
    xlabel('1^{st} Objective');
    ylabel('2^{nd} Objective');
    grid on;

end