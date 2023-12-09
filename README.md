# GoogleSpreadsheetFetcher

Provides access to Google spreadsheets

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'google_spreadsheet_fetcher'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install google_spreadsheet_fetcher

## Usage

```ruby
sheet_key = 'example_sheet_id'

GoogleSpreadsheetFetcher.configure do |config|
  ...
end

user_id = 'sample'

fetcher = GoogleSpreadsheetFetcher::Fetcher.new(sheet_key, user_id)

fetcher.fetch_all_rows_by!(index: 0)
fetcher.fetch_all_rows_by!(title: 'sheet_title')
fetcher.fetch_all_rows_by!(sheet_id: 1234567890)


# or, you can do a bulk fetching. In this case, you only need to access the API once,
# but it will take a little longer on first fetch.
fetcher = GoogleSpreadsheetFetcher::BulkFetcher.new(sheet_key, user_id)
fetcher.fetch

fetcher.all_rows_by!(index: 0)
fetcher.all_rows_by!(title: 'sheet_title')
fetcher.all_rows_by!(sheet_id: 1234567890)
```

### Use Service Account

https://github.com/taka0125/google_spreadsheet_fetcher/wiki/Use-Service-Account

### Use OAuth2

https://github.com/taka0125/google_spreadsheet_fetcher/wiki/Use-OAuth2

## Development

```bash
$ make setup
$ make ruby/rspec
```

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/taka0125/google_spreadsheet_fetcher.

