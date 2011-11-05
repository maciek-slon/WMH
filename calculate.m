function val = calculate(x) 
	deg = round(x);
	mins = x - deg;
	val = pi * (deg + 5.0 * mins / 3.0) / 180.0;
end