library(firebase)

PADDLE_PRODUCT_ID <- 597736

function(input, output, session) {

  # https://firebase.john-coene.com/articles/ui.html
  f <- FirebaseUI$new()$set_providers(
    email = TRUE,
    google = TRUE,
    twitter = TRUE,
    github = TRUE
  )$launch()


  firebase_user <- reactive({
    f$req_sign_in()
    f$get_signed_in()$response
  })


  observeEvent(input$signout, {
    f$sign_out()
  })

  ##### App for signed in user
  signed_in_user_df <- reactive({
    req(firebase_user())

    out <- firebase_user()
    output <- c("uid","provider","displayName","photoURL","email","emailVerified",
                "isAnonymous","apiKey","appName","authDomain",
                "lastLoginAt","createdAt")
    if(is.null(out$email)){
      out$email <- "<none>"
    }
    out$provider <- out$providerData[[1]]$providerId
    data.frame(key = output,
               value = unlist(out[output]),
               row.names = NULL, stringsAsFactors = FALSE)

  })


  output$user_out <- renderTable({
    req(signed_in_user_df())
    signed_in_user_df()
  })

  # NULL if no subscription
  subscriber <- reactive({
    req(firebase_user())

    o <- fb_document_get(paste0("subscriptions/", firebase_user()$uid))

    if(!is.null(o) && o$fields$status$stringValue == "deleted"){
      # has subscription entry but it is cancelled
      return(NULL)
    }

    o

  })

  subscriber_details <- reactive({
    req(subscriber())
    ss <- subscriber()

    tagList(
      h3("Your subscription details"),
      tags$ul(
        tags$li("Status:", ss$fields$status$stringValue),
        tags$li("Email:", ss$fields$email$stringValue),
        tags$li("Last update: ", ss$fields$event_time$stringValue),
        tags$li("Next bill date:", ss$fields$next_bill_date$stringValue)
      ),
      a(href=ss$fields$update_url$stringValue,
        tags$button("Update your subscription",
                           icon = icon("credit-card"),
                           class = "btn-info")),
      " ",
      a(href=ss$fields$cancel_url$stringValue,
        tags$button("Cancel your subscription",
                    icon = icon("window-close"),
                    class = "btn-danger"))
      )

  })

  output$subscriber <- renderUI({
    req(firebase_user())

    subscriber <- subscriber()
    if(is.null(subscriber)){
      return(tagList(
        p("...but you are not yet a subscriber to paid content
          - would you like to be? ",
          pdle_subscribe(PADDLE_PRODUCT_ID,
                         user_id = firebase_user()$uid,
                         email = firebase_user()$email),
          helpText("If you have subscribed already, make sure you have logged in with a method using the same email as your subscription")

          ))
        )
    }

    tagList(
      h3("You are a subscriber!"),
      subscriber_details()
    )

  })

  output$paid_content <- renderPlot({
    req(subscriber())

    plot(iris)

  })




}
