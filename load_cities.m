function [distances, stink, nr_cities, cities] = load_cities(filename)
	% load cities from data file
	cities = load("-ascii", filename);
	nr_cities = size(cities,1)
	
	% compute distance array
	distances = zeros(nr_cities, nr_cities);
	
	for x = 2:nr_cities
		for y = 1:x-1
			pos_1 = cities(x, 2:3);
			pos_2 = cities(y, 2:3);
			dist=sqrt(sum((pos_1-pos_2).^2));
			distances(x,y) = distances(y,x) = dist;
		end
	end
	
	% initial feromone values
	stink = ones(nr_cities, nr_cities);
end