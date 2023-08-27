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
    "Systems" => ["system" => "systems/systems.md"],
    "Criteria" => ["criteria" => "criteria/criteria.md"],
    "Functions" => ["functions" => "functions/functions.md"],
    "API" => "api.md",
]
)

# Documenter can also automatically deploy documentation to gh-pages.
# See "Hosting Documentation" and deploydocs() in the Documenter manual
# for more information.
#=deploydocs(
    repo = "<repository url>"
)=#
