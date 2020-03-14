function(input, output, session) {

  ##### Switch Views ------------------

  # switch between auth sign in/registration and app for signed in user
  observeEvent(session$userData$current_user(), {
    current_user <- session$userData$current_user()
    message("blah")
    str(current_user)

    if (is.null(current_user)) {
      shinyjs::show("sign_in_panel")
      shinyjs::hide("main")
      shinyjs::hide("verify_email_view")
    } else {
      shinyjs::hide("sign_in_panel")
      shinyjs::hide("register_panel")

      if (current_user$emailVerified == TRUE) {
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

    message("sof_auth_user: ", input$sof_auth_user)
    # set the signed in user
    session$userData$current_user(input$sof_auth_user)

  }, ignoreNULL = FALSE)



  ##### App for signed in user
  signed_in_user_df <- reactive({
    req(session$userData$current_user())

    out <- session$userData$current_user()
    out <- unlist(out)

    data.frame(
      name = names(out),
      value = unname(out)
    )

  })

  subscriber <- reactive({
    req(session$userData$current_user())

    user <- unlist(session$userData$current_user())
    datastore <- fb_document_get(paste0("users/", user[["uid"]]))

    datastore$fields$stripeCustomerId$stringValue

  })

  output$subscriber <- renderUI({

    if(!is.null(subscriber())){
      return(paste("You are a subscriber - stripeCustomerId:", subscriber()))
    }

    tagList(
      div("You are not a subscriber :( - would you like to?",
          a(href = "https://sunholo-bootstrap-dev.web.app/account",
            "Buy Now!"))
    )


  })


  output$user_out <- renderDataTable({
    datatable(
      signed_in_user_df(),
      rownames = FALSE,
      options = list(
        dom = "tp",
        scrollX = TRUE
      )
    )
  })

}
