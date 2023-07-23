function P=SelectFromPopulation(pop,grid,beta)

    sg=grid([grid.N]>0);

    p=1./[sg.N].^beta;
    p=p/sum(p);

    k=RouletteWheelSelection(p);

    Members=sg(k).Members;

    i=Members(randi([1 numel(Members)]));
    
    P=pop(i);

end