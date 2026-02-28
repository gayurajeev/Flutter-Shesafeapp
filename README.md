<<<<<<< HEAD
# shesafe

A new Flutter project.

## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Learn Flutter](https://docs.flutter.dev/get-started/learn-flutter)
- [Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Flutter learning resources](https://docs.flutter.dev/reference/learning-resources)

For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev/), which offers tutorials,
samples, guidance on mobile development, and a full API reference.
=======
<p align="center">
  <img src="./img.png" alt="Project Banner" width="100%">
</p>

# SheSafe 🎯

## Basic Details

### Team Name: Electra

### Team Members
- Member 1: Gayathry Rajeev - CET
- Member 2: Parvathy Nair - CET

### Hosted Project Link
https://github.com/gayurajeev/Flutter-Shesafeapp
### Project Description
SheSafe is a women-focused mobile application that helps users locate nearby washrooms within one kilometer and instantly alert emergency contacts during unsafe situations, promoting dignity, mobility, and safety in public spaces.
### The Problem statement
Women lack a reliable, women-centric digital solution that simultaneously provides nearby washroom access and immediate safety support in unfamiliar or emergency situations.

### The Solution
We developed SheSafe to effectively address the challenges of accessibility and personal safety faced by women in public spaces. The application enables users to locate nearby washrooms within a one-kilometer radius based on their current location, ensuring quick access during urgent situations.

To support informed decision-making, SheSafe provides reviews, ratings, and detailed features of each washroom, such as cleanliness, availability, and safety conditions. This transparency helps users choose facilities with confidence.

In addition to accessibility, SheSafe prioritizes user safety through an Emergency SOS feature. With a single tap, the app sends an instant alert message along with the user’s location to pre-saved emergency contacts, enabling timely assistance during threatening or uncomfortable situations.

By combining essential public infrastructure access with real-time safety support, SheSafe serves as a reliable digital companion, empowering women to move freely and confidently in any environment.

### Technical Details
Technologies / Components Used

For Software:

Languages used: Dart

Frameworks used: Flutter

Libraries / Packages used:

geolocator – for GPS location access

google_maps_flutter / flutter_map – for map visualization

url_launcher / sms – for emergency SOS alerts

shared_preferences – for storing emergency contacts

Tools used:

Android Studio / VS Code

Git & GitHub

Flutter SD



## Features
Nearby Washroom Finder:
Finds washrooms within a 1 km radius based on the user’s current location.

Ratings & Reviews:
Displays user reviews, ratings, and available facilities to help users choose safe and clean washrooms.

Emergency SOS:
Sends an instant alert message with live location to saved emergency contacts.

User-Friendly Interface:
Simple, fast, and intuitive UI designed for quick access during emerge


## Implementation
For Software
Installation
git clone https://github.com/gayurajeev/Flutter-Shesafeapp.git
cd Flutter-Shesafeapp
flutter pub get
Run
flutter run

### For Software:

#### Screenshots (Add at least 3)

<img width="1440" height="900" alt="Screenshot 2026-02-28 at 5 48 12 PM" src="https://github.com/user-attachments/assets/f23653f2-ad80-4755-9d96-6d1752960a34" />



#### Diagrams

**System Architecture:**

![Architecture Diagram](docs/architecture.png)
*Explain your system architecture - components, data flow, tech stack interaction*

**Application Workflow:**

![Workflow](docs/workflow.png)
*Add caption explaining your workflow*

---



## Additional Documentation

### For Web Projects with Backend:

#### API Documentation

**Base URL:** `https://api.yourproject.com`

##### Endpoints

**GET /api/endpoint**
- **Description:** [What it does]
- **Parameters:**
  - `param1` (string): [Description]
  - `param2` (integer): [Description]
- **Response:**
```json
{
  "status": "success",
  "data": {}
}
```

**POST /api/endpoint**
- **Description:** [What it does]
- **Request Body:**
```json
{
  "field1": "value1",
  "field2": "value2"
}
```
- **Response:**
```json
{
  "status": "success",
  "message": "Operation completed"
}
```

[Add more endpoints as needed...]

---

### For Mobile Apps:

#### App Flow Diagram

![App Flow](docs/app-flow.png)
*Explain the user flow through your application*

#### Installation Guide

**For Android (APK):**
1. Download the APK from [Release Link]
2. Enable "Install from Unknown Sources" in your device settings:
   - Go to Settings > Security
   - Enable "Unknown Sources"
3. Open the downloaded APK file
4. Follow the installation prompts
5. Open the app and enjoy!


**Building from Source:**
```bash
# For Android
flutter build apk
# or
./gradlew assembleDebug

# For iOS
flutter build ios
# or
xcodebuild -workspace App.xcworkspace -scheme App -configuration Debug
```

---


**Final Assembly:**
![Final Build](images/final-build.jpg)
*Caption: Completed project ready for testing*

---



#### Demo Output

**Example 1: Basic Processing**

**Input:**
```
This is a sample input file
with multiple lines of text
for demonstration purposes
```

**Command:**
```bash
python script.py sample.txt
```

**Output:**
```
Processing: sample.txt
Lines processed: 3
Characters counted: 86
Status: Success
Output saved to: output.txt
```

**Example 2: Advanced Usage**

**Input:**
```json
{
  "name": "test",
  "value": 123
}
```

**Command:**
```bash
python script.py -v --format json data.json
```

**Output:**
```
[VERBOSE] Loading configuration...
[VERBOSE] Parsing JSON input...
[VERBOSE] Processing data...
{
  "status": "success",
  "processed": true,
  "result": {
    "name": "test",
    "value": 123,
    "timestamp": "2024-02-07T10:30:00"
  }
}
[VERBOSE] Operation completed in 0.23s
```

---



## AI Tools Used (Optional - For Transparency Bonus)

If you used AI tools during development, document them here for transparency:

**Tool Used:** [e.g., GitHub Copilot, v0.dev, Cursor, ChatGPT, Claude]

**Purpose:** [What you used it for]
- Example: "Generated boilerplate React components"
- Example: "Debugging assistance for async functions"
- Example: "Code review and optimization suggestions"

**Key Prompts Used:**
- "Create a REST API endpoint for user authentication"
- "Debug this async function that's causing race conditions"
- "Optimize this database query for better performance"

**Percentage of AI-generated code:** [Approximately X%]

**Human Contributions:**
- Architecture design and planning
- Custom business logic implementation
- Integration and testing
- UI/UX design decisions

*Note: Proper documentation of AI usage demonstrates transparency and earns bonus points in evaluation!*

---

## Team Contributions

- [Name 1]: [Specific contributions - e.g., Frontend development, API integration, etc.]
- [Name 2]: [Specific contributions - e.g., Backend development, Database design, etc.]
- [Name 3]: [Specific contributions - e.g., UI/UX design, Testing, Documentation, etc.]

---

## License

This project is licensed under the [LICENSE_NAME] License - see the [LICENSE](LICENSE) file for details.

**Common License Options:**
- MIT License (Permissive, widely used)
- Apache 2.0 (Permissive with patent grant)
- GPL v3 (Copyleft, requires derivative works to be open source)

---

Made with ❤️ at TinkerHub
>>>>>>> 4ebaf364f73660b07cb2a00c7aedb3043b55fa77
