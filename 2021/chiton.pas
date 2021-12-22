var
	i, j: longint;
	x, y, cost, convvalue, whatever: integer;
	addem: integer;
	convstr: string;
	lastline: string;
	input: array of string;
	inputcost: array of array of integer;
	inputlength: integer;
	costlength: integer;
	queue_x: array of integer;
	queue_y: array of integer;
	queue_cost: array of integer;
	queuelength: longint;
	lowestcost: array of array of integer;
	width, height, singlewidth, singleheight: integer;

	procedure AddInput(const Str: string);
		begin
			if inputlength = length(input) then begin
				SetLength(input, length(input) + 1024);
				SetLength(inputcost, length(inputcost) + 1024);
				SetLength(lowestcost, length(lowestcost) + 1024);
			end;
			input[inputlength] := Str;

			SetLength(lowestcost[costlength], Length(Str)*5);
		        for j := 0 to 5*Length(Str)-1 do lowestcost[costlength][j] := 10000;
			inc(costlength);
			SetLength(lowestcost[costlength], Length(Str)*5);
		        for j := 0 to 5*Length(Str)-1 do lowestcost[costlength][j] := 10000;
			inc(costlength);
			SetLength(lowestcost[costlength], Length(Str)*5);
		        for j := 0 to 5*Length(Str)-1 do lowestcost[costlength][j] := 10000;
			inc(costlength);
			SetLength(lowestcost[costlength], Length(Str)*5);
		        for j := 0 to 5*Length(Str)-1 do lowestcost[costlength][j] := 10000;
			inc(costlength);
			SetLength(lowestcost[costlength], Length(Str)*5);
		        for j := 0 to 5*Length(Str)-1 do lowestcost[costlength][j] := 10000;
			inc(costlength);

			SetLength(inputcost[inputlength], Length(Str));
		        for j := 0 to Length(Str)-1 do begin
				convstr := copy(Str, j+1, 1);
				Val(convstr, convvalue, whatever);
				inputcost[inputlength][j] := convvalue;
			end;
			inc(inputlength);
		end;

	function ICost(y: integer; x: integer): integer;
		begin
			addem := 0;
			// writeln('o x',x,'y',y);
			while y >= singleheight do begin
				y := y - singleheight;
				addem := addem + 1;
			end;
			while x >= singlewidth do begin
				x := x - singlewidth;
				addem := addem + 1;
			end;
			// writeln('f x',x,'y',y);
			// writeln('  thatis', inputcost[y][x]);
			addem := addem + inputcost[y][x];
			while addem > 9 do addem := addem - 9;
			ICost := addem;
		end;

	procedure AddToQueue(x: integer; y: integer; cost: integer);
		begin
			if queuelength = length(queue_x) then begin
				SetLength(queue_x, length(queue_x) + 1024);
				SetLength(queue_y, length(queue_y) + 1024);
				SetLength(queue_cost, length(queue_cost) + 1024);
			end;
			queue_x[queuelength] := x;
			queue_y[queuelength] := y;
			queue_cost[queuelength] := cost;
			inc(queuelength);
			lowestcost[y][x] := cost+1;
		end;

	procedure PrintCosts();
	begin
	        for i := 0 to height-1 do begin
			write(i, 'inputcost');
		        for j := 0 to width-1 do begin
				write(ICost(i, j), ',');
			end;
			writeln('');
		end;
	        for i := 0 to height-1 do begin
			write(i, 'lowestcost');
		        for j := 0 to width-1 do begin
				write(lowestcost[i][j], ',');
			end;
			writeln('');
		end;
	end;

	procedure Reset();
	begin
		queuelength := 0;
	        for i := 0 to height-1 do begin
		        for j := 0 to width-1 do begin
				lowestcost[i][j] := 10000;
			end;
		end;
	end;

	procedure ProcessQueue();
	begin
		i := 0;
		while (i < queuelength) do begin
			x := queue_x[i];
			y := queue_y[i];
			cost := queue_cost[i];
			// if y = 0 then writeln('queue check', i, ' ', x, ',', y);
			inc(i);
			// if y = 0 then writeln('stillgoing');
			if cost < lowestcost[y][x] then begin
				// writeln('set it to', cost);
				lowestcost[y][x] := cost;
				if x+1 < width then begin
					if cost+ICost(y,x+1) < lowestcost[y][x+1] then AddToQueue(x+1, y, cost+ICost(y,x+1));
				end;
				if y+1 < height then begin
					if cost+ICost(y+1,x) < lowestcost[y+1][x] then AddToQueue(x, y+1, cost+ICost(y+1,x));
				end;
				if x-1 >= 0 then begin
					if cost+ICost(y,x-1) < lowestcost[y][x-1] then AddToQueue(x-1, y, cost+ICost(y,x-1));
				end;
				if y-1 >= 0 then begin
					if cost+ICost(y-1,x) < lowestcost[y-1][x] then AddToQueue(x, y-1, cost+ICost(y-1,x));
				end;
			end;
			// if y = 0 then writeln('yodone');
	        end;
	end;
begin
	writeln('wellhello');
	lastline := '';
	while (lastline <> 'X') do begin
		readln(lastline);
		if lastline <> 'X' then
			AddInput(lastline);
        end;
	writeln('got input');
        //for i := 0 to inputlength-1 do writeln(i, 'yo', input[i]);
	singleheight := inputlength;
	singlewidth := length(inputcost[0]);
	height := singleheight * 5;
	width := singlewidth * 5;
	writeln('width', singlewidth, 'big', width);
	writeln('height', singleheight, 'big', height);
	//PrintCosts();

	height := singleheight;
	width := singlewidth;
	Reset();
	AddToQueue(0, 0, 0);
	ProcessQueue();
	//PrintCosts();
	writeln('so uh queuelength is ', queuelength);
	writeln('part1 answer is ', lowestcost[height-1][width-1]);

	height := singleheight * 5;
	width := singlewidth * 5;
	Reset();
	AddToQueue(0, 0, 0);
	ProcessQueue();
	//PrintCosts();
	writeln('so uh queuelength is ', queuelength);
	writeln('part2 answer is ', lowestcost[height-1][width-1]);
end.
