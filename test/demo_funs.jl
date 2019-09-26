function summer(A)
   s = zero(eltype(A))
   for a in A
       s += a
   end
   return s
end

#----------------------------------------------------------------

function autumn(A)
   s = zero(eltype(A))
   for a in A
       s += autumn_s1(a)
   end
   autum_s2(s)
   return autum_s2(s)
end

autum_s2(s) = s+one(s)

function autumn_s1(a)
   s = zero(a)
   i = zero(a)
   while(i<a)
      i += one(a)
      s += autumn_s1s1(a)
   end

   return autum_s1s2(s)
end

autum_s1s2(s) = s*one(s)

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
eg1()
