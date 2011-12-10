function plot_stink(stink, coords)

	mm = max(max(stink));
	stink = stink ./ mm;
	
	cc = size(coords, 1);
	
	for c1 = 1:cc-1
		for c2 = c1+1:cc
			col = 1 - stink(c1, c2);
			if col > 0.9
				continue;
			end
	
			style = '-';
			if col > 0.7
				style = ':';
			else if col > 0.3
				style = '-.';
			end
				
	
			width = ceil((1-col)*3);
	
			x = [coords(c1, 1), coords(c2, 1)];
			y = [coords(c1, 2), coords(c2, 2)];
			line(x, y, 'color', [col, col, col], 'linewidth', width, 'linestyle', style, 'marker', 'o', 'markersize', 1);
		end
	end

end