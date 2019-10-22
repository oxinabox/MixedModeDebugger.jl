functiontypeof(m::Method) = parameter_typeof(m.sig)[1]
parameter_typeof(sig::UnionAll) = parameter_typeof(sig.body)
parameter_typeof(sig::DataType) = sig.parameters
