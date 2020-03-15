function(input, output, session) {

  ##### Switch Views ------------------

  # switch between auth sign in/registration and app for signed in user
  observeEvent(session$userData$current_user(), {
    current_user <- session$userData$current_user()
    str(current_user)

    if(is.null(current_user)) {
      shinyjs::show("sign_in_panel")
      shinyjs::hide("main")
      shinyjs::hide("verify_email_view")
    } else {
      shinyjs::hide("sign_in_panel")
      shinyjs::hide("register_panel")

      if(!is.null(current_user$uid)){
        shinyjs::show("main")
      } else {
        shinyjs::show("verify_email_view")
      }

    }



  }, ignoreNULL = FALSE)

  # Signed in user --------------------
  # the `session$userData$current_user()` reactiveVal will hold information about the user
  # that has signed in through Firebase.  A value of NULL will be used if the user is not
  # signed in
  session$userData$current_user <- reactiveVal(NULL)

  # input$sof_auth_user comes from front end js in "www/sof-auth.js"
  observeEvent(input$sof_auth_user, {

    message("setting sof_auth_user")
    # set the signed in user
    session$userData$current_user(input$sof_auth_user)


  }, ignoreNULL = FALSE)



  ##### App for signed in user
  signed_in_user_df <- reactive({
    req(session$userData$current_user())

    out <- session$userData$current_user()
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
    req(session$userData$current_user())

    user <- unlist(session$userData$current_user())

    fb_document_get(paste0("users/", user[["uid"]]))
    # set if activate subscription

  })

  subscriber_check <- reactive({
    req(user())
    strp_subscription_check(user()$fields$stripeCustomerId$stringValue)
  })

  output$subscriber <- renderUI({

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

  output$is_user <- renderUI({

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
      req(signed_in_user_df())
      str(signed_in_user_df())
      signed_in_user_df()
  })

}
