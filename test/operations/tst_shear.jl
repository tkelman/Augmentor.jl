@testset "ShearX" begin
    @test typeof(@inferred(ShearX(1))) <: ShearX <: Augmentor.AffineOperation
    @testset "constructor" begin
        @test_throws MethodError ShearX()
        @test_throws MethodError ShearX(:a)
        @test_throws MethodError ShearX([:a])
        @test_throws ArgumentError ShearX(3:1)
        @test_throws ArgumentError ShearX(-71:1)
        @test_throws ArgumentError ShearX(1:71)
        @test_throws ArgumentError ShearX([2,71,-4])
        @test_throws ArgumentError ShearX(71)
        @test @inferred(ShearX(70)) === ShearX(70:70)
        @test @inferred(ShearX(-70)) === ShearX(-70:-70)
        @test @inferred(ShearX(0.7)) === ShearX(0.7:1:0.7)
        @test str_show(ShearX(0.7)) == "Augmentor.ShearX(0.7)"
        @test str_showcompact(ShearX(0.7)) == "ShearX 0.7 degree"
        @test @inferred(ShearX(10)) === ShearX(10:10)
        @test str_show(ShearX(10)) == "Augmentor.ShearX(10)"
        @test str_showcompact(ShearX(10)) == "ShearX 10 degree"
        op = @inferred(ShearX(-1:1))
        @test str_show(op) == "Augmentor.ShearX(-1:1)"
        @test str_showcompact(op) == "ShearX by ϕ ∈ -1:1 degree"
        op = @inferred(ShearX([2,30]))
        @test op.degree == [2,30]
        @test str_show(op) == "Augmentor.ShearX([2,$(SPACE)30])"
        @test str_showcompact(op) == "ShearX by ϕ ∈ [2,$(SPACE)30] degree"
    end
    @testset "eager" begin
        @test_throws MethodError Augmentor.applyeager(ShearX(10), nothing)
        @test @inferred(Augmentor.supports_eager(ShearX)) === false
        # TODO: more tests
        for img in (square, OffsetArray(square, 0, 0), view(square, IdentityRange(1:3), IdentityRange(1:3)))
            wv = @inferred Augmentor.applyeager(ShearX(45), img)
            @test size(wv) == (3,5)
            @test typeof(wv) <: Array
            wv = @inferred Augmentor.applyeager(ShearX(45), img)
            @test size(wv) == (3,5)
            @test typeof(wv) <: Array
        end
    end
    @testset "affine" begin
        @test @inferred(Augmentor.isaffine(ShearX)) === true
        @test @inferred(Augmentor.supports_affine(ShearX)) === true
        @test_throws MethodError Augmentor.applyaffine(ShearX(45), nothing)
        @test @inferred(Augmentor.toaffine(ShearX(45), rect)) ≈ AffineMap([1. 0.; -1. 1.], [0.,1.5])
        @test @inferred(Augmentor.toaffine(ShearX(-45), rect)) ≈ AffineMap([1. 0.; 1. 1.], [0.,-1.5])
        wv = @inferred Augmentor.applyaffine(ShearX(45), Augmentor.prepareaffine(square))
        @test parent(wv).itp.coefs === square
        @test indices(wv) == (1:3,0:4)
        @test typeof(wv) <: InvWarpedView{eltype(square),2}
        wv2 = @inferred Augmentor.applyaffine(ShearX(-45), wv)
        @test parent(wv).itp.coefs === square
        @test wv2[1:3,1:3] == square
        @test typeof(wv) <: InvWarpedView{eltype(square),2}
    end
    @testset "lazy" begin
        @test @inferred(Augmentor.supports_lazy(ShearX(45))) === true
        wv = @inferred Augmentor.applylazy(ShearX(45), square)
        @test parent(wv).itp.coefs === square
        @test indices(wv) == (1:3,0:4)
        @test typeof(wv) <: InvWarpedView{eltype(square),2}
        wv2 = @inferred Augmentor.applylazy(ShearX(-45), wv)
        @test parent(wv).itp.coefs === square
        @test wv2[1:3,1:3] == square
        @test typeof(wv) <: InvWarpedView{eltype(square),2}
    end
    @testset "view" begin
        @test @inferred(Augmentor.supports_view(ShearX)) === false
    end
    @testset "stepview" begin
        @test @inferred(Augmentor.supports_stepview(ShearX)) === false
    end
    @testset "permute" begin
        @test @inferred(Augmentor.supports_permute(ShearX)) === false
    end
end

# --------------------------------------------------------------------

@testset "ShearY" begin
    @test typeof(@inferred(ShearY(1))) <: ShearY <: Augmentor.AffineOperation
    @testset "constructor" begin
        @test_throws MethodError ShearY()
        @test_throws MethodError ShearY(:a)
        @test_throws MethodError ShearY([:a])
        @test_throws ArgumentError ShearY(3:1)
        @test_throws ArgumentError ShearY(-71:1)
        @test_throws ArgumentError ShearY(1:71)
        @test_throws ArgumentError ShearY([2,71,-4])
        @test_throws ArgumentError ShearY(71)
        @test @inferred(ShearY(70)) === ShearY(70:70)
        @test @inferred(ShearY(-70)) === ShearY(-70:-70)
        @test @inferred(ShearY(0.7)) === ShearY(0.7:1:0.7)
        @test str_show(ShearY(0.7)) == "Augmentor.ShearY(0.7)"
        @test str_showcompact(ShearY(0.7)) == "ShearY 0.7 degree"
        @test @inferred(ShearY(10)) === ShearY(10:10)
        @test str_show(ShearY(10)) == "Augmentor.ShearY(10)"
        @test str_showcompact(ShearY(10)) == "ShearY 10 degree"
        op = @inferred(ShearY(-1:1))
        @test str_show(op) == "Augmentor.ShearY(-1:1)"
        @test str_showcompact(op) == "ShearY by ψ ∈ -1:1 degree"
        op = @inferred(ShearY([2,30]))
        @test op.degree == [2,30]
        @test str_show(op) == "Augmentor.ShearY([2,$(SPACE)30])"
        @test str_showcompact(op) == "ShearY by ψ ∈ [2,$(SPACE)30] degree"
    end
    @testset "eager" begin
        @test_throws MethodError Augmentor.applyeager(ShearY(10), nothing)
        @test @inferred(Augmentor.supports_eager(ShearY)) === false
        # TODO: more tests
        for img in (square, OffsetArray(square, 0, 0), view(square, IdentityRange(1:3), IdentityRange(1:3)))
            wv = @inferred Augmentor.applyeager(ShearY(45), img)
            @test size(wv) == (5,3)
            @test typeof(wv) <: Array
            wv = @inferred Augmentor.applyeager(ShearY(45), img)
            @test size(wv) == (5,3)
            @test typeof(wv) <: Array
        end
    end
    @testset "affine" begin
        @test @inferred(Augmentor.isaffine(ShearY)) === true
        @test @inferred(Augmentor.supports_affine(ShearY)) === true
        @test_throws MethodError Augmentor.applyaffine(ShearY(45), nothing)
        @test @inferred(Augmentor.toaffine(ShearY(45), rect)) ≈ AffineMap([1. -1.; 0. 1.], [2.,0.])
        @test @inferred(Augmentor.toaffine(ShearY(-45), rect)) ≈ AffineMap([1. 1.; 0. 1.], [-2.,0.])
        wv = @inferred Augmentor.applyaffine(ShearY(45), Augmentor.prepareaffine(square))
        @test parent(wv).itp.coefs === square
        @test indices(wv) == (0:4,1:3)
        @test typeof(wv) <: InvWarpedView{eltype(square),2}
        wv2 = @inferred Augmentor.applyaffine(ShearY(-45), wv)
        @test parent(wv).itp.coefs === square
        @test wv2[1:3,1:3] == square
        @test typeof(wv) <: InvWarpedView{eltype(square),2}
    end
    @testset "lazy" begin
        @test @inferred(Augmentor.supports_lazy(ShearY(45))) === true
        wv = @inferred Augmentor.applylazy(ShearY(45), square)
        @test parent(wv).itp.coefs === square
        @test indices(wv) == (0:4,1:3)
        @test typeof(wv) <: InvWarpedView{eltype(square),2}
        wv2 = @inferred Augmentor.applylazy(ShearY(-45), wv)
        @test parent(wv).itp.coefs === square
        @test wv2[1:3,1:3] == square
        @test typeof(wv) <: InvWarpedView{eltype(square),2}
    end
    @testset "view" begin
        @test @inferred(Augmentor.supports_view(ShearY)) === false
    end
    @testset "stepview" begin
        @test @inferred(Augmentor.supports_stepview(ShearY)) === false
    end
    @testset "permute" begin
        @test @inferred(Augmentor.supports_permute(ShearY)) === false
    end
end
