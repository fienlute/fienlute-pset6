Fien Lute
10752862
App Studio 
pset6 - final assignment

The "My Travel Weather Guide" app helps the user to remember all the places in the world they want to visit. The user can search for cities all over the world. If a city is clicked, it will be stored in firebase (online database). The cities that are saved in Firebase will be printed (in alphabetic) order in the table view on the second View Controller. If a user swipes left, the city can be removed from the table view. It then will be removed from firebase as well. A city can easily be removed from the tableview by swiping it to the left and click delete. 

When a city is saved, it can be clicked. When clicked, the Yahoo Weather api will be loaded. The user will go to a page where the country, the current temperature, the forecast, time/date and the time of the sunset/sunrise is displayed.

If the user clicks a city from which yahoo weather api doesn't have the information, the user will get an alert and will be redirectioned to the previous view. I wanted the user to be able to put places in the tableview that are not in the api. The user might want to remember to visit this place eventhough yahoo doesn't have the weather info. 

It is not possible to enter digits or symbols to the list of cities. When the user tries this, he/she will get an alert where this is explained. When the user tries to search without putting anything in the searchbar, he/she will get this alert as well. 

The user can easily go back to any view of the app, due the back button on the top. 

Through the use of state restoration I made it possible that when the app is killed and started up again, the user will return to the excact state and view as where he/she left of. 

In the second viewcontroller the next warning is given: "Expression of type 'UIViewController?'. This ViewController is used, so I couldn't get rid of is. That's why this warning is still there. 

To use Firebase correctly I used a tutorial from the website https://www.raywenderlich.com/139322/firebase-tutorial-getting-started-2

