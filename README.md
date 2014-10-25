A [GitHub](http://www.github.com) client created for [Code Fellows'](http://codefellows.org) iOS Development Accelerator Week 3.

##Monday:

- Implement a split view controller in your app to control your interface
- Create a network controller and implement a method that fetches repositories based on a search term. Instead of pointing the request at the Actual Github API server, use the node script provided in the class repository and point the request at your own machine. Since our apps aren't authenticated with Github yet we will hit the rate limit after 5 unauthenticated calls from our IP. The node script is called server.js. Just run it with your node command in terminal.
- Create a RepositoryViewController and parse through the JSON returned fromm the server into model objects and display the results in a table view.
- Devise a way to show the master view controller when the app is first launched on iPhone, not the detail view controller.

##Tuesday:

- Implement an OAuth workflow in your app that successfully lets the user authenticate with your app.
- Recreate a NSURLSession with a NSURLSessionConfiguration with the Authorization Header Field matched up with our oath token.
- Implement a UISearchBar on your repo search view controller and modify your repo search fetch method on your network controller to use the search bar’s text. Be sure to only be making authenticated network calls using your oath token!
- Display the repo’s they searched for a in the table view
- Implement user defaults to store the authorization token, so it only does the OAuth process once.

##Wednesday:

- Create a UserSearchViewController that searches for users, similar to how we are already searching for repositories. Instead of a table view, use a collection view to display the users avatar image and their name.
- Upon clicking on a cell, implement a custom transition, and transition the image clicked on to a UserDetailViewController page that has their picture, name, and whatever other info you want pulled from their API.

##Thursday:

- Implement Regex in your app. Use it to validate the characters the user types into the search bar. Extend String with this functionality.
- Implement WKWebView in your app. When a user clicks on a repo, show their repo's web page with WKWebView.


##Friendship Friday:
Done in conjunction with [Reid Weber](https://github.com/Reidweb1)

Challenges:

Implement the 'My Profile' view controller in your app. This should display info about the currently logged in user (their bio, if they are hirable, their count of public and private repos, etc).
Implement a way for the logged in user to create a repo from the app. Good luck and god bless.
Implement a way for the user to update their bio.