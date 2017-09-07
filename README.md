# Dradis Addon Template
This template is used to generate the standard directory and files for a Dradis add-on.

## Usage
To generate your Dradis add-on with this template, simply run:
```
rails plugin new <add-on name> -m template.rb
```

## Directory Structure
```
addon
    ├── lib
    │   ├── dradis
    │   │   └── plugins
    │   │       ├── addon
    │   │       │   ├── engine.rb
    │   │       │   ├── field_processor.rb
    │   │       │   ├── gem_version.rb
    │   │       │   ├── importer.rb
    │   │       │   └── version.rb
    │   │       └── addon.rb
    │   ├── dradis-addon.rb
    │   └── addon
    ├── templates
    ├── Gemfile
    ├── LICENSE
    ├── README.md
    ├── CONTRIBUTING.md
    ├── Rakefile
    └── addon.gemspec
```
