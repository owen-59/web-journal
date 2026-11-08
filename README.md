# Journal Website
A journaling website like some certain more premium paid options, but without any AI features, or payment. It works on the web by storing your markdown files on your server, and storing them with front-matter (mostly) compatible with Obsidian and then hosting a website at which they are accessibly from. The website currently has no authentication, so do not expose it publicly. 

## Features
 - Images
 - Tags
 - Location data
 - Markdown editor

## Install
Clone the repository, install docker, and use the sample docker compose file. Note that it is very beta, and you cannot create a blank entry. To test editing, create an empty file at `backend/data/2026/11/08/1200.md`.

## Transitioning from Day One
This tool is very rough and does not support all Day One features. To run this tool, ensure you have node with typescript, and put your Journal Export in the folder root as Export-Journal/Export-Journal.json.
 - Download your Day One data as JSON.
 - Use the tool at [owen-59/dayone2journal](https://github.com/owen-59/dayone2journal).
