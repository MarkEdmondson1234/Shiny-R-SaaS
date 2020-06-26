library(firebase)
library(shiny)

fluidPage(
  usePaddle(),
  useFirebase(),

  h1("R SaaS - Bootstrapping paid Shiny applications with Firebase & Paddle"),
  useFirebaseUI(),

  reqSignin(actionButton("signout", "Sign out")),

  # will only display upon login
  tableOutput("user_out"),
  uiOutput("subscriber"),

  # will only display if paddle subscription active
  plotOutput("paid_content")

)
