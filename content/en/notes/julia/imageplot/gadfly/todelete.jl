txt = readlines(out_path);
lines2replace = occursin.(r"(?<=figure src=)", txt);
matches = match.(r"(?<=\").*(?=\")",txt[lines2replace]);
newfigref = String[];
for mt in matches
	str0 = mt.match;
	str1 = replace("\\\\using_gadfly_10_1.png", r"^(\\|/){1,2}" => "");
	newref = "![]($str1)"
	push!(newfigref, newref);
end

txt[lines2replace] .= newfigref;

open(out_path, "w") do io
	for line in txt
		println(io, line);
	end
end