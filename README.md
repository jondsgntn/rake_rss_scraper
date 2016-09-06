# [RAKE] RSS Scraper

This is a collection of rake tasks to be used with a Ruby on Rails project

`rake rss:get_articles`

This task takes records from the `feeds` table and uses an RSS Feed URL to pull recent posts and add them to the `articles` table

`rake rss:test_feed["http://www.test.com/feed.rss"]`

This task takes the supplied URL and outputs some data to test if it is a valid RSS Feed or not

`rake rss:clear_articles`

This task is meant to be run as a cron job that runs every night and archives any articles that are more than a week old

The schemas for the `feeds` and `articles` tables are:

```
create_table "articles", force: :cascade do |t|
  t.string   "name"
  t.string   "url"
  t.datetime "created_at",                  null: false
  t.datetime "updated_at",                  null: false
  t.datetime "published"
  t.string   "source"
  t.string   "tags",        default: " "
  t.boolean  "archived",    default: false
  t.boolean  "queued",      default: false
  t.string   "customtitle"
  t.datetime "deploy"
end

create_table "feeds", force: :cascade do |t|
  t.string   "name"
  t.string   "url"
  t.datetime "created_at", null: false
  t.datetime "updated_at", null: false
  t.string   "identifier"
  t.string   "twitt"
end
```
