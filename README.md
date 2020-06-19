# Creating a paid R SaaS with Firebase, Stripe and Shiny

Create a template for R users to create paid subscription services for Shiny Apps.

## Many thanks to...

This project is derived from:

* https://www.tychobra.com/posts/2019-01-03-firebasse-auth-wtih-shiny/
* [getfirefly.org](http://getfirefly.org)
* Firebase [AuthUI](https://firebaseopensource.com/projects/firebase/firebaseui-web/)
* An early iteration inspired some of this package https://github.com/JohnCoene/firebase which it now uses fore firebase auth

## Payment strategy

![](sequence_diagram.png)

## Steps to Run the Shiny App

1. Download or clone this repository
2. Create a [Firebase](https://firebase.google.com/) account, and in your new account create a project 
3. In your new Firebase project enable the login providers you want (currently supporting Google, GitHub and Twitter)

![](firebase-login.png)

4. Click the "Web Setup" button (top right in above screenshot) and copy your project's "apiKey", "authDomain", and "projectId" into the object defined in line 1 of the file "www/sof-auth.js"
5. Run the Shiny app

The functions in `global.R` take care of communicating with the Firebase database and Stripe, but do not handle payments which is passed off to the payment app.

## Running the payment app

The Shiny App will offer to link to the payment app via links in its free content after login.  The payment app is a React Firebase hosted app that takes care of payment details.  The user needs to log in to the apps with the same email/method and enter credit card details which are stored in Stripe and Firebase, accessed via the Shiny app to allow entry to paid content.

### How to deploy the payment app

WIP - working demo here https://sunholo-bootstrap-dev.web.app/
