using Documenter, MixedModeDebugger

makedocs(;
    modules=[MixedModeDebugger],
    format=Documenter.HTML(),
    pages=[
        "Home" => "index.md",
    ],
    repo="https://github.com/oxinabox/MixedModeDebugger.jl/blob/{commit}{path}#L{line}",
    sitename="MixedModeDebugger.jl",
    authors="Lyndon White",
    assets=String[],
)

deploydocs(;
    repo="github.com/oxinabox/MixedModeDebugger.jl",
)
