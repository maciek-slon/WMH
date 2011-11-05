function [distances, stink, nr_cities, cities] = load_cities(filename, type='euc')	
	% load cities from data file
	cities = load('-ascii', filename);
	nr_cities = size(cities,1);
	
	% compute distance array
	distances = zeros(nr_cities, nr_cities);
	
	for x = 2:nr_cities
		for y = 1:x-1
			x_1 = cities(x, 2);
			y_1 = cities(x, 3);
			x_2 = cities(y, 2);
			y_2 = cities(y, 3);
			
			dist = 0;
			if type == 'geo'
				lat_1 = calculate(x_1);
				lon_1 = calculate(y_1);
				lat_2 = calculate(x_2);
				lon_2 = calculate(y_2);
				
				RRR = 6378.388;
				q1 = cos(lon_1 - lon_2);
				q2 = cos(lat_1 - lat_2);
				q3 = cos(lat_1 + lat_2);
				
				dist = round(RRR*acos(0.5 * ((1.0+q1)*q2 - (1.0-q1)*q3)) + 1.0);
				distances(x,y) = round(dist);
				distances(y,x) = round(dist);
			else if type=='euc'
				dist = sqrt((x_2-x_1)^2 + (y_2-y_1)^2);
				distances(x,y) = round(dist);
				distances(y,x) = round(dist);
			end
			
		end
	end
	
	% initial feromone values
	stink = ones(nr_cities, nr_cities);
end

