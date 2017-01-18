# Cafe-Near-Me
Cafe Near Me is an iOS app that allows people to search cafes for any location in the world. The app shows a table list of cafes for a search location with their addresses. A user can select the cafe from this table list to view more about that cafe, the app shows photos, reviews and location on the map for this cafe. If the user wishes to bookmark the cafe for future the app will save the cafe photo, reviews and location. 
CONTENTS OF THIS FILE
---------------------

* INTRODUCTION
* REQUIREMENTS
* INSTALLATION
* CONFIGURATION


INTRODUCTION
------------

The Cafe Near Me app searches and displays cafes to a maximum of 50 within a 3km
distance from a given search location. The user can search cafes for any valid
location in the world. The app has a table view that displays the search
results. Each cell shows the name and address of the cafe as title and subtitle.
Selecting a cafe will fetch more details about that cafe which includes cafe
rating, opening hours, photos, reviews and location on map. Rating and opening
hours are displayed only if they are available. The app has four tab views cafe,
photos, reviews and map. Cafe tab shows one cafe photo, cafe name, cafe address,
rating and open hours. The photos tab shows up to 33 cafe photos in a collection
view. Selecting a photo in the collection view shows it on UIImage view just
above the photos collection view. The reviews tab shows all reviews for the cafe
in a table view. Each review has a reviewer name, review and an optional
reviewer photo. Selecting a review will show it in detail in the space above the
table view. The last tab view is the map tab which shows the cafe location on
map. The map has a pin for the cafe and taping the pin will show cafe name as
pin annotation title. On the top of the map view there is a label displaying the
distance of the cafe from search location.

The app also has a bookmarking feature which allows a user to bookmark a cafe
and view it later even offline. The option for bookmark is available in the
navigation bar for cafe tab as a 'Make Bookmark' button. Tapping the 'Make
Bookmark' button will add the cafe to bookmarks and toggles button name to
'Remove Bookmark'. Similarly a cafe can be removed from the bookmarks by tapping
the 'Remove Bookmark' button. This buttons are not available when viewing a cafe
in the bookmarked list. A bookmarks button is shown in the navigation bar for
the search location scene which is the first screen for the app. Tapping the
bookmarks button will show a table view for all bookmarked cafes. Selecting a
cafe from this table view will show cafe, photos, reviews and map tab.  The
navigation bar for this table view also contains a trash button for removing a
cafe from bookmark list. Tapping the trash button will show an alert to the user
and change the bookmark list to edit mode, selecting a cafe now will remove it
from the bookmark list when the user has done tap the done button to save and
exit from edit mode.

All network failures while fetching details, photos, reviews are informed to the
user as a alert. Similarly if no cafes are available for a search location a 'No
Cafes Available' label is shown, if no photos are available 'No photos
available' label is shown, if no reviews available 'No reviews available' label
is shown. All network requests are indicated with activity indicator.


REQUIREMENTS
------------

The app requires network connectivity while searching cafes for a location for
the following :

* Displaying cafe details
* Displaying cafe photos 
* Displaying cafe reviews
* Displaying cafe location on map


INSTALLATION
------------

Install as you would normally install an iOS app.


CONFIGURATION
-------------

The app has no modifiable settings to configure.
