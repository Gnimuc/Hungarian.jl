
using Gadfly
using BenchmarkTools
using Hungarian
using Munkres

dims = [10, 50, 100, 200, 400, 800, 1000, 2000];

benchH = []
benchM = []

for n in dims
    A = rand(n,n)
    push!(benchH, @benchmark hungarian($A))
    push!(benchM, @benchmark munkres($A))
end

meanH = mean.(benchH);
meanM = mean.(benchM);

maximumH = maximum.(benchH);
maximumM = maximum.(benchM);

minimumH = minimum.(benchH);
minimumM = minimum.(benchM);

gt = plot(layer(x=dims,
                y=time.(meanH)/1e9,
                ymin=time.(minimumH)/1e9,
                ymax=time.(maximumH)/1e9,
                Theme(default_color=color("green")),
                Geom.point, Geom.errorbar),
           layer(x=dims,
                y=time.(meanM)/1e9,
                ymin=time.(minimumM)/1e9,
                ymax=time.(maximumM)/1e9,
                Geom.point, Geom.errorbar),
                Scale.y_log10,
                Guide.XLabel("Dimentions(NxN)"),
                Guide.YLabel("Time/s"),
                Guide.xticks(ticks=dims))

memH = memory.(meanH)/(1024*1024);
memM = memory.(meanM)/(1024*1024);

gm = plot(layer(x=dims, y=memH, Geom.point,
                Theme(default_color=color("green"))),
          layer(x=dims, y=memM,Geom.point),
                Scale.y_log10,
                Guide.XLabel("Dimentions"),
                Guide.YLabel("Memory/Mb"),
                Guide.xticks(ticks=dims))
