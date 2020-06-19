library(firebase)
fluidPage(

  useFirebase(),

  h1("R SaaS - Bootstrapping paid Shiny applications with Firebase & Stripe"),
  useFirebaseUI(),

  reqSignin(actionButton("signout", "Sign out")),

  # will only display upon login
  tableOutput("user_out"),
  uiOutput("is_user"),
  uiOutput("subscriber"),

  uiOutput("msg"),
  plotOutput("plot")

)
