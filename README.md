# MoneyProfit - Fintech Application

**MoneyProfit** is a comprehensive fintech application designed to help users manage their financial health. With features like CIBIL score checking, loan applications, and interest rate comparisons, the app provides a one-stop solution for all financial needs. Built using the **MVVM** architecture and **Provider** for state management, the app is optimized for seamless user experiences.

## Table of Contents
- [Features](#features)
- [Technology Stack](#technology-stack)
- [Architecture](#architecture)
- [State Management](#state-management)
- [Pages and Functionality](#pages-and-functionality)
- [Setup](#setup)
- [Contributors](#contributors)
- [License](#license)

---

## Features
- **User Authentication**: Secure login using a mobile number and OTP.
- **CIBIL Score Check**: Users can register and check their CIBIL score.
- **Loan Application**: Apply for various types of loans (home, personal, car, business, vehicle, education, etc.).
- **Interest Rate Comparison**: Compare loan interest rates from various Indian banks.
- **Dashboard**: Displays the user's CIBIL score, loan details, and credit card information.
- **MVVM Architecture**: Clean architecture that separates UI from business logic.
- **Provider for State Management**: Efficient and reactive state management.

---

## Technology Stack
- **Framework**: Flutter
- **Language**: Dart
- **Architecture**: Model-View-ViewModel (MVVM)
- **State Management**: Provider
- **Backend**: Firebase/REST API
- **Database**: Firebase Firestore or any NoSQL database

---

## Architecture
The app follows the **MVVM (Model-View-ViewModel)** architecture, ensuring better code separation, maintainability, and scalability.

### Key Components:
- **Model**: Handles the data logic, such as fetching user info, CIBIL score, and loan details from the backend.
- **View**: UI components that render the app’s different pages (Login, Dashboard, Loan Apply, etc.).
- **ViewModel**: Acts as a middle layer between the View and Model, transforming data and handling user interactions.

---

## State Management
The **Provider** package is used for managing the state of the application. It allows the app to handle state changes efficiently, ensuring the UI reflects the latest data in real time.

---

## Pages and Functionality

1. **Login Page**
   - Allows users to log in using their mobile number and OTP for secure access.
   - Simple and secure authentication process.

2. **Registration Page**
   - Users can fill in their details to check their CIBIL score.
   - Basic validation ensures correct input data.

3. **Dashboard**
   - Displays key financial details including CIBIL score, loans taken, and credit card information.
   - The user can access loan applications or check their loan history.

4. **Loan Apply**
   - Users can apply for various loans such as home loan, personal loan, car loan, business loan, vehicle loan, and education loan.
   - Simple loan application form with the required fields for each loan type.

5. **Compare Loan Interest Rates**
   - Compare interest rates from various Indian banks for different loan categories.
   - Helps users choose the best loan option based on interest rates.

---

## Setup
To run the app locally, follow these steps:

1. Clone the repository:
   ```bash
   git clone https://github.com/nagendrainvweb/moneyprofit.git
   ```

2. Navigate to the project directory:
   ```bash
   cd moneyprofit
   ```

3. Install dependencies:
   ```bash
   flutter pub get
   ```

4. Run the app:
   ```bash
   flutter run
   ```

Make sure to set up the Firebase or REST API backend for data handling and user authentication.

---

## Contributors
- **Nagendra Prajapati** - Lead Developer

---

## License
This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.
