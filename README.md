# SorbetProgress

Measure your progress as you adopt [sorbet](https://sorbet.org/). I find that 
measuring progress keeps me motivated, which is crucial to finishing a project.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'sorbet-progress'
```

Then:

    bundle

Or install it yourself:

    gem install sorbet-progress

## Usage

```bash
srb tc --metrics-file /tmp/sorbet_metrics.json
sorbet_progress /tmp/sorbet_metrics.json
```

## Contributing

This project does not accept bug reports. Pull requests are welcome. 

This project is intended to be a safe, welcoming space for collaboration, and
contributors are expected to adhere to the [code of conduct](/CODE_OF_CONDUCT.md)
