fluidPage(
  shiny::singleton(
    shiny::tags$head(
      tags$link(type="text/css",
                rel="stylesheet",
                href="https://cdn.firebase.com/libs/firebaseui/3.5.2/firebaseui.css"),
      tags$script(src="https://www.gstatic.com/firebasejs/7.11.0/firebase-app.js"),
      tags$script(src="https://www.gstatic.com/firebasejs/7.11.0/firebase-analytics.js"),
      tags$script(src="https://www.gstatic.com/firebasejs/7.11.0/firebase-auth.js"),
      tags$script(src="https://cdn.firebase.com/libs/firebaseui/3.5.2/firebaseui.js"),
      shiny::tags$script(src="sof-auth.js")
    )
  ),

  # load shinyjs on
  shinyjs::useShinyjs(),

  h1("R SaaS - Bootstrapping paid for Shiny applications with Firebase & Stripe"),
  div(id = "firebaseui-auth-container"),
  div(id="loader", "Loading..."),

  hidden(fluidRow(
    id = "main",
    column(
      12,
      a(tags$button(
        id = "submit_sign_out",
        type = "button",
        "Sign Out",
        class = "btn-danger pull-right",
        style = "color: white;"
      ), href="#", onclick="firebase.auth().signOut();location.reload();")
    ),
    column(
      12,
      div(
        style = "padding: 50px",
        h1("You are now signed in via Firebase"),
        br(),
        br(),
        h3("Some information that comes with the signed in user on Firebase"),

        tableOutput("user_out"),
        uiOutput("is_user"),
        uiOutput("subscriber")
      )
    )
  ))
)
