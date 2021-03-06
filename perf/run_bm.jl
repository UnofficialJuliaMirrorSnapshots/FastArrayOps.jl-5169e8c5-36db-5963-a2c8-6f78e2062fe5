
const PLOTBM = true     # save plot to img?
const PROCLEN = 8
const STDNRUNS = 5000000
const STDCP = 2:PROCLEN-1
const STDCFGS = [2,4,8,12,26,50,200,1000,4000,20000,120000,400000,1000000,6000000]

include("bm_setup.jl")
if PLOTBM
    include("bm_plot.jl")
end

# scale, scalar
type Scale_incx1 <: FuncType end
type Scale_incxnu <: FuncType end
type Scale_2d_incx1 <: FuncType end
type Scale_oop_incx1 <: FuncType end
type Scale_oop_incxnu <: FuncType end
# scale, array
type Scalearr_incx1 <: FuncType end
type Scalearr_incxnu <: FuncType end
type Scalearr_oop_incx1 <: FuncType end
type Scalearr_oop_incxnu <: FuncType end
# add, scalar

# add, array
type Addarr_incx1 <: FuncType end
type Addarr_oop_incx1 <: FuncType end
# addscal
type Addscal_incx1 <: FuncType end
type Addscal_oop_incx1 <: FuncType end
# copy
type Copy_incx1 <: FuncType end
type Copy_incxnu <: FuncType end
# fill
type Fill_incx1 <: FuncType end
type Fill_incxnu <: FuncType end

const METHODLIST = (
    (Scale_incx1,       "x = a*x (i=1, inc=1)",     STDNRUNS, STDCP, STDCFGS),
    (Scale_incxnu,      "x = a*x (i=2, inc=40)",    STDNRUNS<<3, STDCP, STDCFGS[6:end]),
    (Scale_2d_incx1,    "x = a*x 2-d (columns)",    STDNRUNS>>5, STDCP, STDCFGS),
    (Scale_oop_incx1,   "x = a*y (i=1, inc=1)",     STDNRUNS, STDCP, STDCFGS),
    (Scale_oop_incxnu,  "x = a*y (i=2, inc=40)",    STDNRUNS<<1, STDCP, STDCFGS[6:end]),
    (Scalearr_incx1,    "x = x.*y (i=1, inc=1)",    STDNRUNS>>3, [2,4,6,7], STDCFGS),
    (Scalearr_incxnu,   "x = x.*y (i=2, inc=40)",   STDNRUNS, [4,6,7], STDCFGS[6:end]),
    (Scalearr_oop_incx1, "x = y.*z (i=1, inc=1)",   STDNRUNS>>3, [2,4,6,7], STDCFGS),
    (Scalearr_oop_incxnu, "x = y.*z (i=2, inc=40)", STDNRUNS, [4,6,7], STDCFGS[6:end]),
    (Addarr_incx1,      "x = x + y (i=1, inc=1)",   STDNRUNS>>3, [4,5,6,7], STDCFGS),
    (Addarr_oop_incx1,  "x = y + z (i=1, inc=1)",   STDNRUNS>>3, [4,5,6,7], STDCFGS),
    (Addscal_incx1,     "x = x + a*y (i=1, inc=1)", STDNRUNS>>3, [4,5,6,7], STDCFGS),
    (Addscal_oop_incx1, "x = y + a*z (i=1, inc=1)", STDNRUNS>>3, [4,5,6,7], STDCFGS),
    (Copy_incx1,        "x = y (i=1, inc=1)",       STDNRUNS, STDCP, STDCFGS),
    (Copy_incxnu,       "x = y (i=2, inc=40)",      STDNRUNS<<3, [2,4,5,6,7], STDCFGS),
    (Fill_incx1,        "x = a (a=0, i=1, inc=1)",  STDNRUNS<<3, [2,4,6,7], STDCFGS),
    (Fill_incxnu,       "x = a (a=0, i=2, inc=40)", STDNRUNS<<3, [2,4,6,7], STDCFGS),
          )
const NM = length(METHODLIST)

global bm_method, bm_title, chooseproc, cfgs, FUNT, Nruns
for mi = NM-1:NM   #NM
    FUNT, bm_title, Nruns, chooseproc, cfgs = METHODLIST[mi]
    bm_method = string(FUNT())
    println(bm_title)
    include(string(bm_method,".jl"))
    t_a = time()
    include("bm_perform.jl")
    t_b = time()
    println("time: ", string(round(t_b-t_a, 1)), "s\n")
    if PLOTBM
        savetableimg(rtable, bm_title, string("./master/", string(FUNT())), FAOproc, chooseproc)
    end
end



