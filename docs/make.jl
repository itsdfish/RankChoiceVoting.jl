using Documenter
using RankChoiceVoting

makedocs(
    sitename = "RankChoiceVoting",
    format = Documenter.HTML(
        assets=[
            asset(
                "https://fonts.googleapis.com/css?family=Montserrat|Source+Code+Pro&display=swap",
                class=:css,
            ),
        ],
        collapselevel=1,
    ),
    modules = [RankChoiceVoting],
    pages = [
        "Home" => "index.md",
        "Rank Choice Votes" => "voting_data.md",
        "Systems" => ["Borda" => "systems/borda.md"],
        "Criteria" => ["Majority" => "criteria/majority.md"
                        "Reversal Symmetry" => "criteria/reversalsymmetry.md"],
        "API" => "api.md",
    ]
)

deploydocs(
    repo="github.com/itsdfish/RankChoiceVoting.jl.git",
)