# setup firebase R package

#remotes::install_github("JohnCoene/firebase")
library(firebase)
firebase_config(api_key = Sys.getenv("FIREBASE_API_KEY"),
                project_id = Sys.getenv("FIREBASE_PROJECT"))
file.copy("firebase.rds", "shiny/firebase.rds")

# setup a firestore auth key
library(googleAuthR)

if(Sys.getenv("GAR_CLIENT_JSON") == ""){
  stop("Need to set a GAR_CLIENT_JSON env arg to a clientID JSON file")
}
# creates firebase-reader-auth-key.json file
gar_service_provision("firebase-reader", "roles/datastore.viewer")
