#####Circle CI Build Status
[![Circle CI](https://circleci.com/gh/adambedford/goggle_reader.svg?style=svg)](https://circleci.com/gh/adambedford/goggle_reader)

---

# [Goggle Reader](https://goggle-reader.herokuapp.com)

Goggle Reader is an RSS and Atom feed reader designed to replace Google Reader.

Users can sign in with their existing Google account and immediately begin adding feeds.

Articles can be filtered by feed, and can also be bookmarked for later reading.

# Developing Goggle Reader

The main components of this application are:

* `User`
* `Feed`
* `Article`

Users and Feeds are associated through Feed Subscriptions, and Users can associate themselves with Articles through Bookmarked Articles.

When a User enters a URL, a Feed will either be created or an existing feed will be located with the URL. In both circumstances, a `FeedSubscription` is created. This approach is preferred to creating new `Feed` records for each user as it is quite probable that multiple users will subscribe to the same feed.

Periodically (every 5 minutes), a web request takes place for each Feed to update it's Articles. These requests happen asynchronously and are queued and performed using Sidekiq.

Articles are fetched and parsed using [FeedJira](http://feedjira.com/). This library is preferred to Ruby's `RSS::Parser` as it provides flexibility to handle both RSS and Atom feeds.


### Technology Used
* Ruby on Rails
* Coffeescript
* SASS
* Rspec
* Omniauth
* Feedjira (open source feed parser)
* Haml templating
* Sidekiq (background job processing)
* Simple Form (form builder)
* Puma (web server)


# Roadmap
* Pagination on the Articles index page
* Implement a Feed search using the Feedly API to create feed by name rather than URL
* Add "Refresh All" button to Articles index to refresh all feeds
* Introduce concept of previously read articles and add option to filter by read status
* Social sharing
* Introduce concept of Folders to categorize feeds/articles
