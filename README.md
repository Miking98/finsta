# Project 3 - *Finsta*

**Finsta** is a photo sharing app using Parse as its backend.

Time spent: **21** hours spent in total

## User Stories

The following **required** functionality is completed:

- [ X ] User can sign up to create a new account using Parse authentication
- [ X ] User can log in and log out of his or her account
- [ X ] The current signed in user is persisted across app restarts
- [ X ] User can take a photo, add a caption, and post it to "Instagram"
- [ X ] User can view the last 20 posts submitted to "Instagram"
- [ X ] User can pull to refresh the last 20 posts submitted to "Instagram"
- [ X ] User can load more posts once he or she reaches the bottom of the feed using infinite Scrolling
- [ X ] User can tap a post to view post details, including timestamp and creation
- [ X ] User can use a tab bar to switch between all "Instagram" posts and posts published only by the user.

The following **optional** features are implemented:

- [ X ] Show the username and creation time for each post
- [ X ] After the user submits a new post, show a progress HUD while the post is being uploaded to Parse.
- [ ] User Profiles:
  - [ X ] Allow the logged in user to add a profile photo
  - [ X ] Display the profile photo with each post
  - [ ] Tapping on a post's username or profile photo goes to that user's profile page
- [ X ] User can comment on a post and see all comments for each post in the post details screen.
- [ X ] User can like a post and see number of likes for each post in the post details screen.
- [ X ] Run your app on your phone and use the camera to take the photo


The following **additional** features are implemented:

- [ X ] Clicking the "heart" button under a post updates the like counter on the client side immediately while the request is being sent to the server, just like Instagram
- [ X ] Full-fledged comment view for each post like Instagram has
- [ X ] Top comment under post will default to the caption the user provides when uploading an image, but will automatically fall back on the oldest comment if no caption is specified, just like Instagram
- [ X ] "Explore" view" using Collection View like Instagram has
- [ X ] Ability to edit profile with all features of Instagram, e.g. bio, website, phone number, gender, etc.

Please list two areas of the assignment you'd like to **discuss further with your peers** during the next class (examples include better ways to implement something, how to extend your app in certain ways, etc):

1. Toggle the heart button based on whether the user has already liked a post
2. Have done a lot of RDBMS but no NoSQL before, so would like to learn more about how to optimize queries and aggregate data in place of JOINs
3. More autolayout usage - right now the features are there, but don't look nearly as nice as Instagram due to poor layout

## Video Walkthrough

Here's a walkthrough of implemented user stories:

<img src='' title='Video Walkthrough' width='' alt='Video Walkthrough' />

GIF created with [LiceCap](http://www.cockos.com/licecap/).

## Credits

List an 3rd party libraries, icons, graphics, or other assets you used in your app.

- [AFNetworking](https://github.com/AFNetworking/AFNetworking) - networking task library


## Notes

Creating a full-functional commenting feature and the ability to like posts, then fetch this information quickly and display it to the user (e.g. counting number of comments and likes in home feed view under each post)

## License

Copyright 2017 Michael Wornow

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
