# url-minimize

This app shotens the passed long url. There is 2 parts in this app the API part and application part. [ Ruby community is famous for self-documenting code](http://www.stackednotion.com/blog/2016/11/02/on-documenting-code/) there is no comments the source code of this app. Following is the information about end points and usage of API. 

* [ Here is API Documentation ](https://github.com/gsum/url-minimize/wiki/API)
* [ Here is Running App ](https://url-minimize.herokuapp.com/)

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

#### Design of app
The app part has one `pages_controller`, which is responsible for showing the page on browser. This is added there for possible future extension of UI. There are `index` and `show` page for that controller.

The api controller in in `api` directory of controller indication that controller contains apis. Since versioning is also good convention for developing so the `api` directoory contains `v1` directory. Inside v1 directory there is `urls_controller` since we are dealing with urls. The `urls_controller` has three public methods `top`, `url` and `show`.

##### top method
This method simply query the database for top 100 result and order them descendingly and returns a JSON object with 302 header. The object is serialized just to show `short_url`, `original_url`, `hit_count` and `title`. This is a simple GET action and requires no headers or any other params.

##### url method
This is the core method of this API. This method simply takes `url` params, then first check if the url is valid or not. `github.com` and `http://github.com` both are valid but only `github` is invalid. If validation is failed, this method reponses with 400 Bad request message. If the url is valid, then the url goes through second check, where sanitized url is checked it exist in database or not.  In sanitization, `http://` is added to the url which does not have scheme. 
If the url is already in database, the methods returns serialized JSON object with HTTP status of 302.
If the url does not exist, url method create a shorted url for passed url and return serialised JSON object with HTTP status 201.

##### show method
All the redirection and hit counts happens in this method. All the shorted URL routed to this method and if the url exists in the system, this method permanently reditect to the original address. If the url does not exist, it gives 404 header. If the request is from the browser and this method does not find the passed url in the system, then this method render 404 error page.

##### sanitize_url and validate_url method
Those two methods are for validation and sanitization of URLs. When a string URL is passed, `sanitize_url` method change that url to URI object and then does the scheme check. If there is scheme, the method call `validate_url`, which check presence of scheme and presence of host and present of `.` in host. If all the tests are passed then it returns a redirectable URL.
For example, sanitize_url and validate_url gives following tests

|Passe URL| Valid? | Returned string | Explaination|
|---------|--------|-----------------|-------------|
|`github.com`|yes| `http://github.com`|just add `http` on passed url|
|`http://github.com`|yes|`http://github.com`| |
|`github`|no|-|there is no .domain|
|`http://github`|no|-|there is no .domain|

##### The database model
So when the database mode for a url is created there is 2 callbacks I have used. First one is `before_create` and `after_create`. The `before_create` generates a unique url_safe SecureRandom string to shorten the given url and this callback also gives the default `hit_count` value 0 for newly created object.

`after_create` callback call sideworker method to scrap the original website and find the title for that object.

##### worker method
The sideworker method happens asynchronously after the obeject is created. The worker method sends a get request to the `original_url` using RestClient and if the URL is available then it extract `<title>` using regex and update the object's title.

