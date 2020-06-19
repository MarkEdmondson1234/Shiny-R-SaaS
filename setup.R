# setup firebase R package

#remotes::install_github("JohnCoene/firebase")
library(firebase)
firebase_config(api_key = Sys.getenv("FIREBASE_API_KEY"),
                project_id = Sys.getenv("FIREBASE_PROJECT"))
file.copy("firebase.rds", "shiny/firebase.rds")
