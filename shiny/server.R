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


  output$user_out <- renderUI({
    req(firebase_user())

    user <- firebase_user()
    tagList(
      div(class="card",
          img(src = user$photoURL, style="width:100%"),
          h2(paste("Welcome", user$displayName)),

          p(class="email", user$email),
          p(paste("Last login:",
                       as.POSIXct(as.numeric(user$lastLoginAt)/1000,
                                  origin = "1970-01-01"))),
          p(paste("Created: ",
                       as.POSIXct(as.numeric(user$createdAt)/1000,
                                  origin = "1970-01-01"))),
          p(actionButton("signout", "Sign out", class = "btn-danger")),
          p()
      ))

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
      div(class="card",
        h3("Subscription details"),
        p("Status:", ss$fields$status$stringValue),
        p(class="email", ss$fields$email$stringValue),
        p("Last update: ", ss$fields$event_time$stringValue),
        p("Next bill date:", ss$fields$next_bill_date$stringValue),
        p(a(href=ss$fields$update_url$stringValue,
          "Update your subscription",
                             icon = icon("credit-card"),
                             class = "btn-info")),
        " ",
        p(a(href=ss$fields$cancel_url$stringValue,
          "Cancel your subscription",
                      icon = icon("window-close"),
                      class = "btn-danger"))
        )
      )

  })

  output$subscriber <- renderUI({
    req(firebase_user())

    subscriber <- subscriber()
    if(is.null(subscriber)){
      return(tagList(
        div(class="card",
        p("To see paid content please subscribe:",
          pdle_subscribe(PADDLE_PRODUCT_ID,
                         user_id = firebase_user()$uid,
                         email = firebase_user()$email),
          helpText("If you have subscribed already, make sure you have logged in with a method using the same email as your subscription"),
          helpText("Use coupon code 'test123' to get 100% discount")

          )))
        )
    }

    subscriber_details()

  })

  output$paid_content <- renderPlot({
    req(subscriber())

    plot(iris)

  })




}
