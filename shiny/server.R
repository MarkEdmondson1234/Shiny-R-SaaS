library(firebase)

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
    data.frame(key = output, value = unlist(out[output]), row.names = NULL)

  })

  user <- reactive({
    req(firebase_user())

    fb_document_get(paste0("users/", firebase_user()$uid))
    # set if activate subscription

  })

  subscriber_check <- reactive({
    req(user())
    strp_subscription_check(user()$fields$stripeCustomerId$stringValue)
  })

  output$subscriber <- renderUI({
    req(firebase_user())

    subscriber_check <- subscriber_check()
    if(!is.null(subscriber_check) && !subscriber_check()){
      return(tagList(
        p("...but you are not yet a subscriber to paid content
          - would you like to be? ",
          a(href = "https://sunholo-bootstrap-dev.web.app/account", "Buy Now!")
          ))
        )
    }

    tagList(
      h3("You are a subscriber!"),
      br(),
      p("Here is your paid for content:"),
      plotOutput("paid_content")
    )

  })

  output$paid_content <- renderPlot({

    plot(iris)

  })

  output$is_customer <- renderUI({

    if(!is.null(user())){
      return(paste("You are a stripe customer - stripeCustomerId:",
                   user()$fields$stripeCustomerId$stringValue))
    }

    tagList(
      div("You are not a customer :( - would you like to be? ",
          a(href = "https://sunholo-bootstrap-dev.web.app/account",
            "Buy Now!"))
    )
  })


  output$user_out <- renderTable({
    f$req_sign_in() # require sign in
    str(signed_in_user_df())
    signed_in_user_df()
  })

  observeEvent(input$signout, {
    f$sign_out()
  })

}
