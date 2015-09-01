@doc """
# Description
Find the conical hull defined by the following constraints:
  1ᵀx = c
  Ax ≤ b
  x ≥ 0
# Returns
* `::PolyhedralCone`: conical hull of constraints
""" ->
function cone_from_constraints{T<:Real}(A::Matrix{T}, b::Vector{T}, c::T)
    m, n = size(A)
    m == length(b) || error("A and b must have consistent dimensions")
    c > 0 || error("c must be strictly positive")
    A_poly = Array(T, m+n, n)
    A_poly[1:m,:] = broadcast(*, b, ones(T,m,n)) - A
    A_poly[n+1:n+m,:] = eye(T, n)
    return PolyhedralCone(A_poly)
end

function cone_from_constraints{T<:Rational}(A::Matrix{T}, b::Vector{T}, c::T)
    m, n = size(A)
    m == length(b) || error("A and b must have consistent dimensions")
    c > 0 || error("c must be strictly positive")
    A_poly = Array(T, m+n, n)
    A_poly[1:m,:] = broadcast(*, b, ones(T,m,n)) - A
    A_poly[n+1:n+m,:] = eye(T, n)
    return PolyhedralCone(cones.intmat(A_poly))
end
    
@doc """
# Description
Finds the conical hull of of the region define
by the following constraints:

1ᵀ x = 1
x ≤ u
x ≥ 0
# Returns
* `::PolyhedralCone` conical hull from constraints
""" ->
function quota_cone{T<:Real}(u::Vector{T})
    n = length(u)
    return cone_from_constraints(eye(T,n), u, one(T))
end

function checkRiskRegionArgs(μ::Vector{Float64}, Σ::Matrix{Float64},
                             K::Cone, α::Float64)
        if length(μ) != size(Σ, 1) ArgumentError("μ and Σ must have consistent dimensions") end
        if !isposdef(Σ) ArgumentError("Σ must be a positive definite matrix") end
        if length(K) != length(μ) ArgumentError("Cone must be in same dimension as mean vector") end
        if α <= 0 ArgumentError("α must be strictly positive") end
end
