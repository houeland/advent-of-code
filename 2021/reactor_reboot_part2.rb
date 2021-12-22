cubes = {}

def xmin(c)
  return c[0][0]
end

def xmax(c)
  return c[0][1]
end

def ymin(c)
  return c[1][0]
end

def ymax(c)
  return c[1][1]
end

def zmin(c)
  return c[2][0]
end

def zmax(c)
  return c[2][1]
end

def amin(a)
  return a[0]
end

def amax(a)
  return a[1]
end

def checkoverlap(cube1, cube2)
  overlap = true
  overlap = false if xmin(cube1) > xmax(cube2)
  overlap = false if xmin(cube2) > xmax(cube1)
  overlap = false if ymin(cube1) > ymax(cube2)
  overlap = false if ymin(cube2) > ymax(cube1)
  overlap = false if zmin(cube1) > zmax(cube2)
  overlap = false if zmin(cube2) > zmax(cube1)
  return overlap
end

def checkoverlap_x(cube1, cube2)
  overlap = true
  overlap = false if amin(cube1) > amax(cube2)
  overlap = false if amin(cube2) > amax(cube1)
  return overlap
end

# case0    +++ ---

# case1
#     ++++
#       -----

# case2
#     ++++
#  -----

# case3
#     ++++++++++
#       -----

# case4
#       ++++++
#   -------------

def split_x_cube(ox, rx)
  #puts "split_x ox: #{ox}"
  #puts "split_x rx: #{rx}"
  oxmin = amin(ox)
  oxmax = amax(ox)
  rxmin = amin(rx)
  rxmax = amax(rx)
  where_xs = []
  if not checkoverlap_x(ox, rx) then
    #puts "no overlap!"
    where_xs.append([oxmin, oxmax])
  elsif oxmin < rxmin and oxmax <= rxmax then
    #puts "case1!"
    where_xs.append([oxmin, rxmin-1])
    where_xs.append([rxmin, oxmax])
  elsif oxmin >= rxmin and oxmax > rxmax then
    #puts "case2!"
    where_xs.append([oxmin, rxmax])
    where_xs.append([rxmax+1, oxmax])
  elsif oxmin < rxmin and oxmax > rxmax then
    #puts "case3!"
    where_xs.append([oxmin, rxmin-1])
    where_xs.append([rxmin, rxmax])
    where_xs.append([rxmax+1, oxmax])
  else
    #puts "case4!"
    where_xs.append([oxmin, oxmax])
  end

  #puts "where_xs: #{where_xs}"
  #puts ""
  return where_xs
end


oncubelist = []

num_overlaps = 0

def format_cube(cube)
  cxmin = xmin(cube)
  cxmax = xmax(cube)
  cymin = ymin(cube)
  cymax = ymax(cube)
  czmin = zmin(cube)
  czmax = zmax(cube)
  return "x:#{cxmin}..#{cxmax}y:#{cymin}..#{cymax}z:#{czmin}..#{czmax}"
end

def format_cubelist(cubelist)
  return cubelist.map { |c| format_cube(c) }
end


#x_old = [-10, 10]
#split_x_cube(x_old, [-100, -50])
#split_x_cube(x_old, [50, 100])
#split_x_cube(x_old, [-100, 0])
#split_x_cube(x_old, [0, 100])
#split_x_cube(x_old, [-100, 100])
#split_x_cube(x_old, [-5, 5])


STDIN.read.split("\n").each do |a|
 cmd, rest = a.split(" ")
 xr, yr, zr = rest.split(",")
 _, xr = xr.split("=")
 _, yr = yr.split("=")
 _, zr = zr.split("=")
 xr = xr.split("..").map { |s| s.to_i }
 yr = yr.split("..").map { |s| s.to_i }
 zr = zr.split("..").map { |s| s.to_i }
 newcube = [xr, yr, zr]
 newcubelist = []
 puts "#{cmd} #{format_cube(newcube)}"
 oncubelist.each do |oldcube|
   if checkoverlap(oldcube, newcube) then
     #puts "old: #{format_cube(oldcube)}"
     #puts "del: #{format_cube(newcube)}"
     xs_list = split_x_cube(oldcube[0], newcube[0])
     ys_list = split_x_cube(oldcube[1], newcube[1])
     zs_list = split_x_cube(oldcube[2], newcube[2])
     xs_list.each do |xs|
      ys_list.each do |ys|
       zs_list.each do |zs|
         c = [xs, ys, zs]
         #puts "c: #{format_cube(c)}"
         if checkoverlap(c, newcube) then
           #puts "kill!"
         else
           #puts "add!"
           newcubelist.append(c)
         end
       end
      end
     end
   else
     newcubelist.append(oldcube)
   end
 end
 oncubelist = newcubelist
 if cmd == "on" then
  oncubelist.append(newcube)
 end
 #puts "new oncubelist: #{format_cubelist(oncubelist)}"
 puts "new oncubelist: #{oncubelist.length}"
 #puts ""
end

def sum_cubes_volume(cubelist)
  volume_sum = 0
  cubelist.each do |c|
    dx = xmax(c) - xmin(c) + 1
    dy = ymax(c) - ymin(c) + 1
    dz = zmax(c) - zmin(c) + 1
    volume = dx * dy * dz
    # puts "#{format_cube(c)} ==> #{volume}"
    volume_sum += volume
  end
  puts ""
  puts "total volume: #{volume_sum}"
end

sum_cubes_volume(oncubelist)
