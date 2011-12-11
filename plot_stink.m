function plot_stink(stink, coords)

	mm = max(max(stink));
	stink = stink ./ mm;
	
	cc = size(coords, 1);
	
	pairs = cc*(cc-1) / 2;
	dists = zeros(pairs, 3);

	r = 1;
	for c1 = 1:cc-1
		for c2 = c1+1:cc
			dists(r, 1) = c1;
			dists(r, 2) = c2;
			dists(r, 3) = stink(c1, c2);
			r = r + 1;
		end
	end

	[s, i] = sort (dists (:, 3));
	dists = dists (i, :);

	for i = 1:pairs
		col = 1 - dists(i, 3);
		if col > 0.9
			continue;
		end

		c1 = dists(i, 1);
		c2 = dists(i, 2);

		style = '-';
%		if col > 0.7
%			style = ':';
%		else if col > 0.3
%			style = '-.';
%		end
			

		width = ceil((1-col)*3);

		x = [coords(c1, 1), coords(c2, 1)];
		y = [coords(c1, 2), coords(c2, 2)];
		line(x, y, 'color', [col, col, col], 'linewidth', width, 'linestyle', style, 'marker', 'o', 'markersize', 1);
	end

end
