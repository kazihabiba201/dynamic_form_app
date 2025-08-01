# Dynamic Form Surveyor App

A Flutter application for surveyors that renders dynamic forms based on configurable JSON files. Supports various input types, validations, image uploads, and submission exports (TXT and PDF).

---

## App Apk Link
You can download the APK file [here](https://drive.google.com/file/d/1PW1-Hu__hBbd_IOioV9lpvpJusnAHp6_/view?usp=sharing).

##  Features

-  Dynamic form rendering from local JSON files
-  Field validation (min/max length, required fields, etc.)
-  Image uploads (single and multi-image support)
-  Submission preview screen
-  Export filled form data as `.txt` or `.pdf`
-  Local state management using `Provider`
-  Clean architecture for better maintainability
-  Navigation handled via `go_router`

---

##  App Screens

1. **Form List Page** – Lists available dynamic forms
2. **Form Page** – Dynamically renders fields for selected form
3. **Submission View Page** – Shows responses with export options

---

## Dependencies
This project uses the following packages:

- cupertino_icons: ^1.0.8
- provider: ^6.1.5
- go_router: ^16.0.0
- image_picker: ^1.1.2
- pdf: ^3.11.3
- printing: ^5.14.2
- path_provider: ^2.1.5
- open_filex: ^4.7.0

##  Project Structure

![projectimage](https://github.com/kazihabiba201/dynamic_form_app/blob/master/assets/image/project_structure.PNG)


---

###  Setup

Make sure you have Flutter installed. Then:

```bash
flutter pub get
flutter run
```

This project uses the following json:
assets/forms/
├── form_1.json
├── form_2.json
└── form_3.json
Then add them to your pubspec.yaml:

```bash
flutter:
  uses-material-design: true
  assets:
    - assets/forms/form_1.json
    - assets/forms/form_2.json
    - assets/forms/form_3.json
```
## App Icon(Android)
![appicon](https://github.com/kazihabiba201/dynamic_form_app/blob/master/assets/image/app_icon.jpg)

## App Screen
### Dynamic Form List
![dynamic](https://github.com/kazihabiba201/dynamic_form_app/blob/master/assets/image/dynamic_form_list.jpg)

### Custom Feedback Form
![custom](https://github.com/kazihabiba201/dynamic_form_app/blob/master/assets/image/customer_feedback_form1.jpg)
![feedback](https://github.com/kazihabiba201/dynamic_form_app/blob/master/assets/image/custom_feedback_form2.jpg)

### Health Survey Form
![health](https://github.com/kazihabiba201/dynamic_form_app/blob/master/assets/image/health_survey_form.jpg)
![survey](https://github.com/kazihabiba201/dynamic_form_app/blob/master/assets/image/health_survey_form2.jpg)

### Property Inspection
![property](https://github.com/kazihabiba201/dynamic_form_app/blob/master/assets/image/property_inpection_form.jpg)
![inspection](https://github.com/kazihabiba201/dynamic_form_app/blob/master/assets/image/property_inspection2.jpg)

### Submission Preview
![preview](https://github.com/kazihabiba201/dynamic_form_app/blob/master/assets/image/submitted_preview.jpg)

### Save as TXT or PDF
![txt](https://github.com/kazihabiba201/dynamic_form_app/blob/master/assets/image/dynamic_form_json_formt.jpg)
![pdf](https://github.com/kazihabiba201/dynamic_form_app/blob/master/assets/image/dynamic_form_pdf_format.jpg)


