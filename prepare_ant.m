function ant = prepare_ant(nr_cities)
	ant = zeros(nr_cities+1, 1);
	ant(1) = random("unid", nr_cities);
end