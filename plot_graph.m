function plot_graph()
    n=5;
    wierzch=rand(n,2);
    smrod=rand(n,n)*2;
    smrod=smrod*smrod';
    smrod=smrod./max(max(smrod));
    smrod=smrod*1.5;
    slabe=smrod<0.5;
    srednie=(smrod<1.0 & smrod>=0.5);
    mocne=(smrod>=1.0);
    gplot(slabe,wierzch,'k:*');
    hold on;
    gplot(srednie,wierzch,'b--*');
    hold on;
    gplot(mocne, wierzch,'r-*');
end