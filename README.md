# CloudFlare Manager

This is a small collection of Ruby classes that I use to manage my many domains hosted on CloudFlare.

The awesome CloudFlare API allows me to inspect and change DNS entries.
So when it comes time to move servers, I make that change with these scripts.

## Configuration

Uses Ruby 2.2, and will work with rvm or rbenv to set the correct version of Ruby.

`dotenv` is used, so you just need to create a `.env` file and add the environment variables:

* `CLOUDFLARE_EMAIL`
* `CLOUDFLARE_API_KEY`

## Functionality

### AllDnsRecords

Goes through every zone and returns every DNS record, optionally filtered by name, type, etc.

### ReplaceOldServer

Goes through every zone and finds every record that points to a specific hostname (matching on the record content).
Updates each record to point to a different hostname.
