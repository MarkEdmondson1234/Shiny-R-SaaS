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
      p("See the app code ", a(href="https://github.com/MarkEdmondson1234/Shiny-R-SaaS", "on GitHub"))
    ),
    mainPanel(

      # will only display if paddle subscription active
      plotOutput("paid_content")
    )
  )
)
