library(DiagrammeR)

mermaid("
  sequenceDiagram
  User->>Shiny App: Load app
  Shiny App->>Firebase: Firebase Auth Login
  Firebase->>Shiny App: Firebase UserId
  Shiny App->>Firebase subscriptions: check subscription database
  Firebase subscriptions->>Shiny App: subscription status
  alt No Subscription
     Shiny App->>Paddle Button: JS library makes button
     Paddle Button->>Paddle: User puts in credit card
     Paddle->>Cloud Function: Webhook update
     Cloud Function->>Firebase subscriptions: update with Firebase UserId
     Shiny App->>User: Reload
   else Active Subscription
     Firebase subscriptions->>Shiny App: Sends subscription status
     User->>Paid Content: User can use paid content
     Shiny App->>Paddle Button: JS library makes cancel and update buttons
   end
   alt Monthly subscription payment fails
     Paddle->>Cloud Function: Webhook update
     Cloud Function->>Firebase subscriptions: update with Firebase UserId
     Firebase subscriptions->>User: User loses access to paid content
   else User Cancel
     Shiny App->>Paddle Button: User cancels subscription
     Paddle Button->>Paddle: Cancel
     Paddle->>Cloud Function: Webhook update
     Cloud Function->>Firebase subscriptions: update with Firebase UserId
     Firebase subscriptions->>User: User loses access to paid content
   end
  ")
