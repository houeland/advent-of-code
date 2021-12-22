cubes = {}

for z in -51..51 do
  for y in -51..51 do
    for x in -51..51 do
      cubes["#{x}:#{y}:#{z}"] = 0
    end
  end
end

def print_total(cubes)
total = 0
for z in -50..50 do
  for y in -50..50 do
    for x in -50..50 do
      total += cubes["#{x}:#{y}:#{z}"]
    end
  end
end
puts total
end

print_total(cubes)

def update_cuboid (cubes, newval, xr, yr, zr)
  xrmin, xrmax = xr
  yrmin, yrmax = yr
  zrmin, zrmax = zr
  for z in zrmin..zrmax do
    for y in yrmin..yrmax do
      for x in xrmin..xrmax do
        cubes["#{x}:#{y}:#{z}"] = newval
      end
    end
  end
end

STDIN.read.split("\n").each do |a|
 cmd, rest = a.split(" ")
 newval=1
 newval=0 if cmd == "off"
 xr, yr, zr = rest.split(",")
 _, xr = xr.split("=")
 _, yr = yr.split("=")
 _, zr = zr.split("=")
 xrmin, xrmax = xr.split("..").map { |s| s.to_i }
 yrmin, yrmax = yr.split("..").map { |s| s.to_i }
 zrmin, zrmax = zr.split("..").map { |s| s.to_i }
 xrmin = [[xrmin, -51].max, 51].min
 yrmin = [[yrmin, -51].max, 51].min
 zrmin = [[zrmin, -51].max, 51].min
 xrmax = [[xrmax, -51].max, 51].min
 yrmax = [[yrmax, -51].max, 51].min
 zrmax = [[zrmax, -51].max, 51].min
 xr = [xrmin, xrmax]
 yr = [yrmin, yrmax]
 zr = [zrmin, zrmax]
 puts "newval=#{newval} xr=#{xr} yr=#{yr} zr=#{zr}"
 update_cuboid(cubes, newval, xr, yr, zr)
end

print_total(cubes)
