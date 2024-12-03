# Tequila
The better way to see how well your games run on Apple Silicon

![CleanShot 2024-12-03 at 1  04 38@2x](https://github.com/user-attachments/assets/c0842ea3-87f6-41b6-aa8c-3f4ebba37125)

## About Tequila
Gaming on Mac's has become amazing now thanks to Rosetta 2, CrossOver and lots of other translation layers but I've always found it such a struggle to find a list that tells me what games can run on what translation layer and how well. I stumbled across AppleGamingWiki's master list which gave me this info but the website was such a pain to use so I decided to scrape the data and create my own app! In future, I plan to add a way to add your own Steam library which will then automatically show you how well your different games will run on your system! Tequila is made completely with Swift and uses a native looking Apple UI which will blend in nicely with your Mac apps!

## Features
Tequila is very barebones at the moment. You can save your favourite games to your Library which will allow you to access them at ease and there is a master list available with search.  
![CleanShot 2024-12-03 at 1  04 45@2x](https://github.com/user-attachments/assets/8a268e2c-ff8e-4e3e-8ce1-b1d46ded3375)
![CleanShot 2024-12-03 at 1  05 01@2x](https://github.com/user-attachments/assets/069dae76-cc2a-459b-9cdc-508c36bf129a)

## To-do
- [x] Add aliases to master list
- [ ] Add community updates for master list
- [ ] Ability to filter the master list
- [ ] Add caching for images and GiantBomb data
- [ ] Categories to find best games to play with set translation layers
- [ ] Steam Library

## How to build
Tequila is built like any other Mac OS xcode project. However, you need to add your GiantBomb API key in your `Config.xcconfig` file as follows:  
```
GIANT_BOMB_API_KEY = YOUR_GIANT_BOMB_KEY
```
You then also have to add the following to your `Info.plist` file:  
```
<key>GIANT_BOMB_API_KEY</key>
<string>${GIANT_BOMB_API_KEY}</string>
```
Once you've done this, you will be able to use all the GiantBomb features!
