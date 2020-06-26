library(firebase)
library(shiny)

fluidPage(
  theme="profile.css",
  usePaddle(),
  useFirebase(),
  titlePanel("R SaaS - Bootstrapping paid Shiny applications with Firebase & Paddle"),

  sidebarLayout(
    sidebarPanel(
      useFirebaseUI(),
      # will only display upon login
      uiOutput("user_out"),
      uiOutput("subscriber"),
    ),
    mainPanel(

      # will only display if paddle subscription active
      plotOutput("paid_content")
    )
  )
)
