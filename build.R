library(googleAuthR)

API_KEY <- Sys.getenv("FIREBASE_API_KEY")

gar_auth_configure(path = Sys.getenv("GAR_CLIENT_JSON"))

token <- gar_auth(scopes = "https://www.googleapis.com/auth/cloud-platform",
                  email = "m@sunholo.com")

fb_document_get <- function(document_path,
                            database_id = "(default)",
                            project_id = "sunholo-bootstrap-dev"){

  the_url <- sprintf("https://firestore.googleapis.com/v1/projects/%s/databases/%s/documents/%s",
                     project_id, database_id, document_path)

  f <- gar_api_generator(the_url,
                         "GET",
                         data_parse_function = function(x) x)

  f()
}

# to use
#fb_document_get("subscriptions")
#fb_document_get("subscriptions/XXXX")
