typealias clockid_t Int32
@enum(CLOCK_ID,
  CLOCK_REALTIME = 0,
  CLOCK_MONOTONIC = 1
)

@enum(TIMER_FLAG,
  TIMER_RELTIME = 0,
  TIMER_ABSTIME = 1
)

type timespec
  sec::Clonglong
  nsec::Clong
end

function gettime(clockid::CLOCK_ID)
  res = timespec(0,0)
  s = ccall((:clock_gettime,librt),Int32,(clockid_t,Ref{timespec}),
    clockid,Ref(res))
  s!=0 && error("Error in gettime()")
  return res
end

function nanosleep(clockid::CLOCK_ID, t::timespec, flag::TIMER_FLAG = TIMER_ABSTIME)
  flag==TIMER_RELTIME && error("Relative time nanosleep not supported yet!")
  rem = timespec(0,0)
  s = ccall((:clock_nanosleep,librt),Int32,(clockid_t,Int32,Ref{timespec},Ref{timespec}),
    clockid,flag,Ref(t),Ref(rem))
  s!=0 && error("Error in nanosleep()")
  return nothing
end