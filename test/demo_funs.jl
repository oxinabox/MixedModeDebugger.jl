function summer(A)
   s = zero(eltype(A))
   for a in A
       s += a
   end
   return s
end

#----------------------------
function winter(A)
   s = zero(eltype(A))
   return winter_s1(s,A)
end
function winter_s1(s, A)
   for a in A
       s += exp(a)
   end
   return winter_s1s1(s)
end
function winter_s1s1(s)
   return s + s
end
#----------------------------------------------------------------

function autumn(A)
   s = zero(eltype(A))
   for a in A
       s += autumn_s1(a)
   end
   return autumn_s2(s)
end

function autumn_s2(s)
    for ii in 15
        s+one(s+one(s))
    end
    return autumn_s2s1(s)
end
autumn_s2s1(s) = s-one(s)

function autumn_s1(a)
   s = zero(a)
   i = zero(a)
   while(i<a)
      i += one(a)
      s += autumn_s1s1(a)
   end
   autumn_s1s2(s)
   return s
end

autumn_s1s2(s) = s*one(s)

autumn_s1s1(a) = exp(a-1)

#----------------------------


function eg1()
    println("1a")
    eg2()
    println("1b")
end
function eg2()
    println("  2a")
    eg3()
    println("  2b")
end
function eg3()
    x=1+1+1
    print("    ")
    println(x)
end
