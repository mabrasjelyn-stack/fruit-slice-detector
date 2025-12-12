# 🍊 Fruit Slice Detector
### 🤖 AI-Powered Fruit Classification Mobile App

<div align="center">

![Flutter](https://img.shields.io/badge/Flutter-02569B?style=for-the-badge&logo=flutter&logoColor=white)
![Firebase](https://img.shields.io/badge/Firebase-FFCA28?style=for-the-badge&logo=firebase&logoColor=black)
![TensorFlow](https://img.shields.io/badge/TensorFlow_Lite-FF6F00?style=for-the-badge&logo=tensorflow&logoColor=white)
![Dart](https://img.shields.io/badge/Dart-0175C2?style=for-the-badge&logo=dart&logoColor=white)

**Instantly identify fruit slices using Machine Learning**  
*A Computer Science Final Project*

</div>

---

## 📱 About This Project

**Fruit Slice Detector** is a Flutter mobile app that classifies fruit slices in real-time using **TensorFlow Lite**. Users can scan fruits via camera or gallery, and the app identifies **10 different fruit types** with high accuracy. This project demonstrates practical use of **AI, computer vision, and mobile development** with a modern UI/UX design.

---

## ✨ Key Features

- 🎯 Real-Time Classification using camera or gallery
- 🧠 AI-Powered on-device TensorFlow Lite model
- 📊 Confidence Scoring for predictions
- 📈 Analytics Dashboard with pie and line charts
- 🗂️ Scan History with thumbnails and timestamps
- ☁️ Firebase Firestore integration for cloud storage
- 🎨 Modern gradient UI with smooth animations
- 📱 Cross-Platform (Android & iOS)
- 🚀 Optimized for fast performance
- 🔒 Privacy-Focused: All ML processing on-device

---

## 🍎 Detectable Fruit Classes

### 1. 🍊 Orange Slice
<div align="center">
<img src="assets/orange-slice.PNG" width="350" alt="Orange Slice">
</div>
**Description:** The orange is a classic citrus fruit, known worldwide for its vibrant color and refreshing taste. When sliced, oranges reveal a beautiful internal structure.  

---

### 2. 🍋 Lemon Slice
<div align="center">
<img src="assets/lemon-slice.PNG" width="350" alt="Lemon Slice">
</div>
**Description:** Lemons are tart citrus fruits with a pale yellow color. Lemon slices are lighter, more translucent, and smaller than oranges.  

---

### 3. 🍈 Grapefruit Slice
<div align="center">
<img src="assets/Grapefruit.png" width="350" alt="Grapefruit Slice">
</div>
**Description:** Grapefruit is a large citrus fruit with pink to red flesh, known for its bitter-sweet taste and beautiful coloring.  

---

### 4. 🍎 Apple Slice
<div align="center">
<img src="assets/apple-slice.jpg" width="350" alt="Apple Slice">
</div>
**Description:** Apples reveal a distinctive star-shaped seed pattern when sliced horizontally, making them instantly recognizable.  

---

### 5. 🍉 Watermelon Slice
<div align="center">
<img src="assets/watermelon-slice.jpg" width="350" alt="Watermelon Slice">
</div>
**Description:** Watermelon has bright red flesh, black seeds, and a green rind, making it visually distinctive.  

---

### 6. 🍓 Strawberry Slice
<div align="center">
<img src="assets/sliced-strawberry.jpg" width="350" alt="Strawberry Slice">
</div>
**Description:** Strawberries are small, sweet berries with tiny seeds on the exterior. When sliced, they show a lighter interior flesh.  

---

### 7. 🥝 Kiwi Slice
<div align="center">
<img src="assets/kiwi-slice.jpg" width="350" alt="Kiwi Slice">
</div>
**Description:** Kiwi has bright green flesh, a white center, and tiny black seeds in a radial pattern, making it visually striking.  

---

### 8. 🍍 Pineapple Slice
<div align="center">
<img src="assets/pineapple-slice.PNG" width="350" alt="Pineapple Slice">
</div>
**Description:** Pineapple has golden flesh and a fibrous texture with a distinct circular core, making slices easy to identify.  

---

### 9. 🍌 Banana Slice
<div align="center">
<img src="assets/banana-slice.png" width="350" alt="Banana Slice">
</div>
**Description:** Bananas create perfect circular "coins" with a creamy texture when sliced. They have no seeds or complex internal structure.  

---

### 10. 🥭 Mango Slice
<div align="center">
<img src="assets/mango-slice.png" width="350" alt="Mango Slice">
</div>
**Description:** Mango is known as the "king of fruits" with golden-orange flesh and smooth, fibrous texture.  

---

## 📸 App Screenshots

### Splash Screen & Home Interface
<div align="center">
<table>
<tr>
<td align="center" width="33%">
<img src="screenshots/splash.png" width="250" alt="Splash Screen"><br>
<b>🎨 Splash Screen</b><br>
Animated welcome screen with gradient background
</td>
<td align="center" width="33%">
<img src="screenshots/home.png" width="250" alt="Home Page"><br>
<b>🏠 Home Page</b><br>
Main dashboard with quick action buttons
</td>
<td align="center" width="33%">
<img src="screenshots/drawer.png" width="250" alt="Navigation Drawer"><br>
<b>📋 Navigation Drawer</b><br>
Side menu for accessing all app features
</td>
</tr>
</table>
</div>

---

### Scanner & Detection Interface
<div align="center">
<table>
<tr>
<td align="center" width="33%">
<img src="screenshots/scanner-empty.png" width="250" alt="Scanner Empty"><br>
<b>📷 Scanner Ready</b><br>
Interface ready to capture or select fruit image
</td>
<td align="center" width="33%">
<img src="screenshots/scanner-carousel.png" width="250" alt="Class Carousel"><br>
<b>🎠 Class Carousel</b><br>
Browse all detectable fruit classes
</td>
<td align="center" width="33%">
<img src="screenshots/tools-list.png" width="250" alt="Tools List"><br>
<b>📝 Available Classes</b><br>
List of all detectable fruit slices
</td>
</tr>
</table>
</div>

---

### Detection Results & Prediction Distribution
<div align="center">
<table>
<tr>
<td align="center" width="33%">
<img src="screenshots/detection-orange.png" width="250" alt="Orange Detection"><br>
<b>🍊 Orange Detected</b><br>
Successful classification with confidence
</td>
<td align="center" width="33%">
<img src="screenshots/detection-kiwi.png" width="250" alt="Kiwi Detection"><br>
<b>🥝 Kiwi Detected</b><br>
Another detection example
</td>
<td align="center" width="33%">
<img src="screenshots/prediction-distribution.png" width="250" alt="Prediction Distribution"><br>
<b>📊 Prediction Distribution</b><br>
Expandable section showing probability breakdown for all 10 classes
</td>
</tr>
</table>
</div>

---

### History & Analytics
<div align="center">
<table>
<tr>
<td align="center" width="50%">
<img src="screenshots/history-empty.png" width="250" alt="History Empty"><br>
<b>📜 Empty History</b><br>
No scan history yet
</td>
<td align="center" width="50%">
<img src="screenshots/history-filled.png" width="250" alt="History Filled"><br>
<b>📜 Scan History</b><br>
Log with thumbnails and labels
</td>
</tr>
<tr>
<td align="center" width="50%">
<img src="screenshots/stats-pie.png" width="250" alt="Pie Chart"><br>
<b>📊 Pie Chart</b><br>
Visual distribution of scanned fruit types
</td>
<td align="center" width="50%">
<img src="screenshots/stats-line.png" width="250" alt="Line Chart"><br>
<b>📈 Line Chart Analytics</b><br>
Average detections per fruit class
</td>
</tr>
</table>
</div>

---
