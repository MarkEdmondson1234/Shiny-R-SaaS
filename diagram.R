library(DiagrammeR)

mermaid("
  sequenceDiagram
  User->>Shiny App: Load app
  Shiny App->>Firebase: Firebase Auth Login
  Firebase->>Shiny App: Firebase UserId
  alt Firebase UserId=New User
    Shiny App->>Free content: Not a customer
  end
  alt User signs up as New Customer
    Free content->>Payment App: payment link
  else Payment signup
    Payment App->>Firebase: Firebase Auth Login
    Firebase->>Payment App: Firebase UserId
    Payment App->>Stripe: Credit card details
    Stripe->>Payment App: stripeCustomerId
    Stripe->>Payment App: stripeSubscriptionId
    Payment App->>Firebase: Firebase UserId
    Payment App->>Firebase: stripeSubscriptionId
    Payment App->>Firebase: stripeUserId
  else signed up
    Payment App->>Shiny App: Redirect back
  end
  alt Firebase UserId=existingCustomer
    Shiny App->>Firebase: Firebase UserId
    Firebase->>Shiny App: Existing stripeCustomerId
    Firebase->>Shiny App: Existing stripeSubscriptionId
    Shiny App->>Customer Content: Deliver paid content
  end
")
