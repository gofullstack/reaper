# Reaper

Reaper generates IIF files from invoice data stored in Harvest

## Configuration

Reaper is configured with environment variables.
The following environment variables are required:

- `HARVEST_OAUTH_ID` - the OAuth ID of your Harvest application
- `HARVEST_OAUTH_SECRET` - the OAuth Secret of your Harvest application
- `SECRET_TOKEN` - the secret token used by Rails for verifying signed cookies

Optional variables:

- `AIRBRAKE_KEY` - An Airbrake API key
- `GOOGLE_ANALYTICS_ID` - A Google Analytics tracking ID
- `TYPEKIT_URL` - Your Typekit URL, for the optimal typography experience
- `USERVOICE_TOKEN` - The last part of your Uservoice URL
- `NEW_RELIC_LICENSE_KEY` - A NewRelic license key
- `NEW_RELIC_APP_NAME` - The name you'd like to use in NewRelic
- `WEB_CONCURRENCY` - The number of Unicorn workers to spawn

## Development

Be sure you have SQLite3 installed, Postgres installed, a JS runtime, and can [install Nokogiri](http://www.nokogiri.org/tutorials/installing_nokogiri.html).
Then, prepare your environment by running `bundle install`.

Run `guard` to run specs.

### Configuring

To configure Harvest for local development without using environment variables, run:

```
cp config/settings.yml config/settings/development.local.yml
cp config/settings.yml config/settings/test.local.yml
```

Then, obtain a Client ID and Client Secret by creating an OAuth2 Client in your Harvest account's settings, at https://yourharvestorganization.harvestapp.com/oauth2_clients.
Use `http://localhost:PORT` for the Website URL and `http://localhost:PORT/auth/harvest/callback` for the Redirect URI values.

Copy the Client ID and Client secret into the aforementioned YAML files, and you'll be able to hack on Reaper.

### Regenerating the VCR cassettes

If, for whatever reason, you need to regenerate the VCR cassettes, you'll need to have a `harvest.access_token` setting, ideally in `config/settings/test.local.yml`.
To get such a token, first follow the above steps to configure your local app as an OAuth2 Client.
Then, sign up for your local app, and once you've been redirected back to Reaper, run `rails runner 'puts User.order(:updated_at).last.access_token'`.
You should see a long string of text: this is your access token.

### Vagrant Workflow

If you'd like to use the Vagrant box in the repo, be sure to install the [vagrant-berkshelf](https://github.com/berkshelf/vagrant-berkshelf) and [vagrant-omnibus](https://github.com/opscode/vagrant-omnibus) Vagrant plugins.
Once you've got those installed, a `vagrant up` ought to do the trick.

## How Reaper Works

When a user authenticates via Harvest, we retrieve the first page of their outstanding invoices (at most 50 invoices).
For the first 40 of those, we retrieve detailed invoice information, which allows us to access the invoice's line items.

A user then selects invoices to export, and clicks the Export button.
We generate an IIF file from these invoices and their associated line items.

### The IIF File

An IIF File has a header row, followed by a list of invoices.
Each invoice may have a subsequent list of line items.
A line with an invoice begins with _TRNS_, and a line with a line item begins with _SPL_.
An invoice and its line items are followed by a line containing only _ENDTRNS_.

## License

Reaper is licensed under the GPLv3. See [LICENSE](LICENSE) for details.
