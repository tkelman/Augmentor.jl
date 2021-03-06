immutable CacheImage <: Operation end

applyeager(op::CacheImage, img::Array) = img
applyeager(op::CacheImage, img::OffsetArray) = img
applyeager(op::CacheImage, img) = copy(img)

function Base.show(io::IO, op::CacheImage)
    if get(io, :compact, false)
        print(io, "Cache into temporary buffer")
    else
        print(io, "$(typeof(op))()")
    end
end

# --------------------------------------------------------------------

immutable CacheImageInto{T<:AbstractArray} <: Operation
    buffer::T
end
CacheImage(buffer::AbstractArray) = CacheImageInto(buffer)

@inline supports_lazy{T<:CacheImageInto}(::Type{T}) = true

@inline match_idx(buffer::AbstractArray, inds::Tuple) = buffer
@inline match_idx{N}(buffer::Array, inds::NTuple{N,UnitRange}) =
    OffsetArray(buffer, inds)

applyeager(op::CacheImageInto, img) = applylazy(op, img)

function applylazy(op::CacheImageInto, img)
    copy!(match_idx(op.buffer, indices(img)), img)
end

function Base.show(io::IO, op::CacheImageInto)
    if get(io, :compact, false)
        print(io, "Cache into preallocated ", summary(op.buffer))
    else
        print(io, "$(typeof(op).name)(")
        showarg(io, op.buffer)
        print(io, ')')
    end
end
