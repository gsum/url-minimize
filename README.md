# url-minimize

This app shotens the passed long url. There is 2 parts in this app the API part and application part. [ Ruby community is famous for self-documenting code](http://www.stackednotion.com/blog/2016/11/02/on-documenting-code/) there is no comments the source code of this app. 

#### Information of app:

* Ruby 2.5.3
* Rails 5.2.3
* PostgreSQL 10.5

**Supporting Gems**
* active-record-serialize
* sidekiq
* rest-client
* redis-rails
* awesome-print
* better-errors
* figaro

#### Runing the app on local

* Clone the app
`git clone https://github.com/gsum/url-minimize.git`

* bundle install
`bundle`

* Setup db
`rails db:setup`
 
* Start the server
`rails s`

* Start redis server
`redis-server`

* Run sidekiq for background job
`bundle exec sidekiq`
