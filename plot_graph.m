function plot_graph(smrod, wierzch)
    mm = max(max(smrod));
	g1 = mm/3;
	g2 = 2*g1;
	
	slabe=smrod<g1;
    srednie=(smrod<g2 & smrod>=g1);
    mocne=(smrod>=g2);
    gplot(slabe,wierzch,'.');
    hold on;
    gplot(srednie,wierzch,'.');
    hold on;
    gplot(mocne, wierzch,'r');
end