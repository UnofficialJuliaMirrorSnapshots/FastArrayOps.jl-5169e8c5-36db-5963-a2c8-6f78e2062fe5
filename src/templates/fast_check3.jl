(0 != incx && 0 != incy && 0 != incz) || throw(ArgumentError("zero increment"))
(0 < ix && 0 < iy && 0 < iz) || throw(BoundsError())
ix+(n-1)*abs(incx) <= length(x) || throw(BoundsError())
iy+(n-1)*abs(incy) <= length(y) || throw(BoundsError())
iz+(n-1)*abs(incz) <= length(z) || throw(BoundsError())
