library(shiny)
library(firebase)
library(googleAuthR)

gar_auth_configure(path = Sys.getenv("GAR_CLIENT_JSON"))

token <- gar_auth(scopes = "https://www.googleapis.com/auth/cloud-platform",
                  email = "m@sunholo.com")

#' Gets a Firebase data entry.  Will return NULL if it can not
fb_document_get <- function(document_path,
                            database_id = "(default)",
                            project_id = "sunholo-bootstrap-dev"){

  the_url <- sprintf("https://firestore.googleapis.com/v1/projects/%s/databases/%s/documents/%s",
                     project_id, database_id, document_path)

  f <- gar_api_generator(the_url,
                         "GET",
                         data_parse_function = function(x) x)

  o <- tryCatch(f(),
           error = function(err){
             message("Couldn't find entry - ", err$message)
             NULL
             })
  str(o)
  o
}

#' Get a Stripe customer object from the Stripe customerId
#' https://stripe.com/docs/api/customers/retrieve
strp_user_get <- function(customerId){

  the_url <- sprintf("https://api.stripe.com/v1/customers/%s",
                     customerId)
  res <- httr::GET(the_url,
            httr::authenticate(Sys.getenv("STRIPE_KEY"),""))

  httr::content(res)
}

#' Get all the subscriptions for a user
strp_subscription_get <- function(customerId){
  o <- strp_user_get(customerId)

  o$subscriptions
}

#' Return TRUE is customer has a live subscription, FALSE if not
strp_subscription_check <- function(customerId){
  o <- strp_subscription_get(customerId)

  message("Checking if ", customerId,
          " is a Stripe subscriber: ", o$total_count > 0)

  o$total_count > 0
}
