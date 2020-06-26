library(shiny)
library(firebase)
library(googleAuthR)

gar_auth_service("firebase-reader-auth-key.json",
                 scope = "https://www.googleapis.com/auth/datastore")

#' Gets a Firebase data entry.  Will return NULL if it can not
fb_document_get <- function(document_path,
                            database_id = "(default)",
                            project_id = Sys.getenv("FIREBASE_PROJECT")){

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


usePaddle <- function(vendor_id = Sys.getenv("PADDLE_VENDOR")){
  singleton(
    tags$head(
      tags$script(src="https://cdn.paddle.com/paddle/paddle.js"),
      tags$script(sprintf("Paddle.Setup({ vendor: %s });", vendor_id))
    )
  )
}

#' Create paddle Subscribe button
pdle_subscribe <- function(product_id,
                           user_id,
                           email = NULL,
                           success = "/"){

  if(!is.null(email)){
    email_line = sprintf('email: "%s"', email)
  } else {
    email_line = "email: null"
  }

  tagList(
    shiny::tags$button(href="#",id="buy", "Subscribe!", icon = icon("shopping-bag"), class = "btn-success"),
    tags$script(sprintf(
      'function openCheckout() {
        Paddle.Checkout.open({ product: %s,
                               %s,
                               passthrough: "{\\"uid\\":\\"%s\\"}",
                               success: "%s"
                               });
      }
      document.getElementById("buy").addEventListener("click", openCheckout, false);',
      product_id, email_line, user_id, success
    ))
  )

}
