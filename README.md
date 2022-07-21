# flutter_googlesheet

Read data from Google Sheet to Flutter App 

## Getting Started

This project is a detailed demonstration on how to read google sheets form in your Flutter App.

## Packages needed:
3 packages are needed to implement the dark theme: 
-	[HTTP](https://pub.dev/packages/http)
    - Add this line to 	your terminal: **```flutter pub add http ```**
-	[Intl](https://pub.dev/packages/intl) Optional if needed to deal with internationalization issues.
    - Add this line to your terminal: **```flutter pub add intl```**

Finally run an  the command “flutter pub get” in your terminal and then check your package's in pubspec.yaml file under dependencies

## Structure:
1.	In your lib folder create 3 additional folders respectively and copy the classes from the repository.
    -	**Models** : includes a class file named ***info.dart*** that sets the Object and constructer.
    -	**Controller**: includes a class file named ***info_controller.dart*** that includes the http.post and http.get functions used to read or write from and to the Google sheet. This is done using the App Script Generated Web App link.
    -	**Constants**: includes a class file for dark theme where you can customize all your ThemeData. I personally created another class called ***colors.dart*** in which all my used colors are added. 
2.  The ***info_list.dart*** file outputs the list of info received from the google form.
3.	The ***main.dart*** file includes a form to be filled and pushed into the google form.

##  App Script Code
1.  Open your google sheet, and click on Extensions > App Script.
    If Extensions tab is not showing read [this](https://support.google.com/docs/answer/2942256?hl=en&co=GENIE.Platform%3DDesktop) to enable it.
2.  App script will open and now you can write your functions.
    -**doPost()**

    ```
    function doPost(request){
        // Open Google Sheet using ID, enter your own ID
        var sheet = SpreadsheetApp.openById("1efNeqFsGX4uf2iywONP0_m9LsjpbUUcMmQhc0uL0690");
        var result = {"status": "SUCCESS"};
        try{
            // Get all Parameters 
            var first_name = request.parameter.firstName;
            var last_name = request.parameter.lastName;
            var email = request.parameter.email;

            // Append data on Google Sheet
            var rowData = sheet.appendRow([first_name, last_name, email]);

        }catch(exc){
            // If error occurs, throw exception
            result = {"status": "FAILED", "message": exc};
        }

        // Return result
        return ContentService
        .createTextOutput(JSON.stringify(result))
        .setMimeType(ContentService.MimeType.JSON);
    }
    ```
    -**doGet()**
    ```
    function doGet(request){
        // Open Google Sheet using ID, enter your own Sheet ID here
        var sheet_id = "1efNeqFsGX4uf2iywONP0_m9LsjpbUUcMmQhc0uL0690";
        //If the file has multpile sheets you can specify which sheet do you want to read from
        var sheet_name = "Sheet1";
        var sheet = SpreadsheetApp.openById(sheet_id).getSheetByName(sheet_name);

        // Get all values in active sheet
        var values = sheet.getDataRange().getValues();
        var data = [];

        // Iterate values in descending order 
        // here we will be reading our sheet row by row, var i =3 because we started from the third row depending on my sheet. So set it according to your sheet, and from which row you would like to start
        for (var i = 3; i <= values.length-1; i++) {

            // Get each row
            var row = values[i];
            //if you want to get data with specific criteria use request.parameter."the used parameter"
            // in this case, we passed in the url code in info_controller.dart ?name=userName
            // so we are taking the value of the passed parameter name
            //if you want to get the whole list then remove the below line, the if statemement and keep what's inside it outside it
            //row[1] means for the current row where the value of the column 1 is equal to the entered param
            if (row[1] == request.parameter.name){
            // Create object
            var info = {};
            info['Subscription ID'] = row[0]
            info['First Name'] = row[1];
            info['Last Name'] = row[2];
            info['Email'] = row[3];

            // Push each row object in data
            data.push(info);
            }
        
        }
        // Return result
        return ContentService
        .createTextOutput(JSON.stringify(data))
        .setMimeType(ContentService.MimeType.JSON);
    }
    
    ```
3. Deploy your code from delpoy button. You can test before deployment, manage deployments and create new deployments.
4. Copy the web app link created on deployment and enter it in the info_controller.dart file as the URL value. 

##  Notes:
1. Always create new deployments for each time you modify your App Script code.
2. Customize this project files to fit your own needs depending on the values and fields needed.
3. Remember the value taken from app script is set as json, this is why we need to refactor it using fromJson function in info.dart class. 

For any further help, feel free to contact me on my email ``` assiljanbeih@gmail.com ```