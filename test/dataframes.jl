
module TestDataFrames

using Base.Test
using DataArrays, DataFrames
using DataFramesMeta

df = DataFrame(A = 1:3, B = [2, 1, 2])
x = [2, 1, 0]

@test  @with(df, :A + 1)   ==  df[:A] + 1
@test  @with(df, :A + :B)  ==  df[:A] + df[:B]
@test  @with(df, :A + x)   ==  df[:A] + x
x = @with df begin
    res = 0.0
    for i in 1:length(:A)
        res += :A[i] * :B[i]
    end
    res
end
@test  x == sum(df[:A] .* df[:B])
@test  @with(df, df[:A .> 1, ^([:B, :A])]) == df[df[:A] .> 1, [:B, :A]]
@test  @with(df, DataFrame(a = :A * 2, b = :A + :B)) == DataFrame(a = df[:A] * 2, b = df[:A] + df[:B])
    
@test  @select(df, :A .> 1)           == df[df[:A] .> 1,:]
@test  @select(df, :B .> 1)           == df[df[:B] .> 1,:]  
@test  @select(df, :A .> x)           == df[df[:A] .> x,:]
@test  @select(df, :B .> x)           == df[df[:B] .> x,:]
@test  @select(df, :A .> :B)          == df[df[:A] .> df[:B],:]
@test  @select(df, :A .> 1, [:B, :A]) == df[df[:A] .> 1, [:B, :A]]

end # module
