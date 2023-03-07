# README

## Prerequisites

- Ruby 3.1.2
- Rails 7.0

### Rails dependencies

```shell
bundle install
```

### Slack dependencies
In order to send a message to a slack workplace it is necessary to have a slack web api app connected to it. You can create one [here](https://api.slack.com/apps). 
Once created, generate a slack bot token with a write scope. See below how to configure the web service.

## Development
### Start local server

```shell
rails s
```

### Environment variables
Create a `.env` file.
Add the following environment variables:
```shell
SLACK_API_TOKEN # the token of your slack app, ex: xoxb-... 
SLACK_CHANNEL # the name of the channel the message will be sent to, ex: #general
APP_API_TOKEN # an api token to authenticate with the web service. It will be required as a bearer token to post requests the web service.
```

### How to run the test suite
```shell
bundle exec rspec
```

## Deployment instructions
Set the following environment variables
```shell
SLACK_API_TOKEN # the bot token of your slack app, ex: xoxb-... 
SLACK_CHANNEL # the name of the channel to send the message to, ex: #general
APP_API_TOKEN # an api token to authenticate with the web service. It will be required as a bearer token to post requests the web service.
RAILS_MASTER_KEY # required if not automatically generated upon deployment
```

## How to send requests
Example:
```shell
curl --location --request POST '<base_url>/api/v1/bounce_reports' \
--header 'Authorization: Bearer <app_api_token>' \
--header 'Content-Type: application/json' \
--data-raw '{
"RecordType": "Bounce",
"Type": "SpamNotification",
"TypeCode": 512,
"Name": "Spam notification",
"Tag": "",
"MessageStream": "outbound",
"Description": "The message was delivered, but was either blocked by the user, or classified as spam, bulk mail, or had rejected content.",
"Email": "zaphod@example.com",
"From": "notifications@honeybadger.io",
"BouncedAt": "2023-02-27T21:41:30Z"
}'
```