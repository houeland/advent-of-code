// let xmin = 20
// let xmax = 30
// let ymin = -10
// let ymax = -5

let xmin = 253
let xmax = 280
let ymin = -73
let ymax = -46

var highestever = 0

func tryshot(dxs: Int, dys: Int) -> Bool {
	var x = 0;
	var y = 0;
	var dx = dxs;
	var dy = dys;
	var highestnow = 0;
	while (y > ymin) {
		x += dx;
		y += dy;
		if (y > highestnow) { highestnow = y }
		if (x >= xmin && x <= xmax && y >= ymin && y <= ymax) {
			if (highestnow > highestever) { highestever = highestnow }
			return true
		}
		if (dx > 0) { dx -= 1 }
		dy -= 1;
	}
	return false
}

var goodones = 0;

for dy in -100...100 {
	for dx in 0...300 {
		if (tryshot(dxs:dx, dys:dy)) {
			goodones += 1
		}
	}
}

print("highest", highestever);
print("count", goodones);
