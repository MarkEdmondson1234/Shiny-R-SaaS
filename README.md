# Creating a paid R SaaS with Firebase, Stripe and Shiny

Create a template for R users to create paid subscription services for Shiny Apps

## Many thanks to...

This project is derived from:

* https://www.tychobra.com/posts/2019-01-03-firebasse-auth-wtih-shiny/
* [getfirefly.org](http://getfirefly.org)
* Firebase [AuthUI](https://firebaseopensource.com/projects/firebase/firebaseui-web/)

## Payment strategy

![](sequence_diagram.png)

## Steps to Run the Shiny App

1. Download or clone this repository
2. Create a [Firebase](https://firebase.google.com/) account, and in your new account create a project 
3. In your new Firebase project enable the login providers you want.
4. Click the "Web Setup" button (top right in above screenshot) and copy your project's "apiKey", "authDomain", and "projectId" into the object defined in line 1 of the file "www/sof-auth.js"
5. Run the Shiny app

## Running the payment app

TBD - demo https://sunholo-bootstrap-dev.web.app/
