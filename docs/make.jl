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
        "Systems" => ["Borda" => "systems/borda.md",
                     "Bucklin" => "systems/bucklin.md",
                     "Instant Runoff" => "systems/instant_runoff.md"],
        "Criteria" => ["Condorcet Loser" => "criteria/condorcet_loser.md",
                        "Condorcet Winner" => "criteria/condorcet_winner.md",
                        "Consistency" => "criteria/consistency.md",
                        "Majority" => "criteria/majority.md",
                        "Monotonicity" => "criteria/monotonicity.md",
                        "Mutual Majority" => "criteria/mutual_majority.md",
                        "Reversal Symmetry" => "criteria/reversalsymmetry.md",
                        "IIA" => "criteria/IIA.md"],
        "API" => "api.md",
    ]
)

deploydocs(
    repo="github.com/itsdfish/RankChoiceVoting.jl.git",
)