twitter redux
=======

Time Spent: 20 hours

Hamburger menu
-------
* [x] Dragging anywhere in the view should reveal the menu.
* [x] The menu should include links to your profile, the home timeline, and the mentions view.

Profile page
---------
* [x] Contains the user header view
* [x] Contains a section with the users basic stats: # tweets, # following, # followers
* [x] Optional: Implement the paging view for the user description.
* [ ] Optional: As the paging view moves, increase the opacity of the background screen. 
* [x] Optional: Pulling down the profile page should ~blur~ and resize the header image.

Home Timeline
---------
* [x] Tapping on a user image should bring up that user's profile page

Optional: Account switching
--------
* [ ] Long press on tab bar to bring up Account view with animation
* [ ] Tap account to switch to
* [ ] Include a plus button to Add an Account
* [ ] Swipe to delete an account

Walkthrough
--------
![gif](https://raw.github.com/devanessa/twitter/week2/walkthrough.gif)

Known Issues
-------
- The new container view controller broke some features from last week (dismissing view on twitter post, and potentially others since I did not test)
- Paging view for user description does not scroll after scolling the table view. Bringing the scrollview to front does not bring back gesture recognition.

Sources:
------
- [Twitter API](https://dev.twitter.com/)
- Buttons courtesy of [iconmonstr](http://iconmonstr.com/)
- Login [Twitter Icon](https://www.iconfinder.com/icons/107170/circle_color_twitter_icon)

