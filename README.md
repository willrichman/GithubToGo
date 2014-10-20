A [GitHub](http://www.github.com) client created for [Code Fellows'](http://codefellows.org) iOS Development Accelerator Week 3.

Monday:

- Implement a split view controller in your app to control your interface
- Create a network controller and implement a method that fetches repositories based on a search term. Instead of pointing the request at the Actual Github API server, use the node script provided in the class repository and point the request at your own machine. Since our apps aren't authenticated with Github yet we will hit the rate limit after 5 unauthenticated calls from our IP. The node script is called server.js. Just run it with your node command in terminal.
- Create a RepositoryViewController and parse through the JSON returned fromm the server into model objects and display the results in a table view.
- Devise a way to show the master view controller when the app is first launched on iPhone, not the detail view controller.