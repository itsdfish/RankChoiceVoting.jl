using SafeTestsets

files = readdir()
filter!(x -> x ≠ "runtests.jl", files )
map(f -> include(f), files)