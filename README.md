# Music Dataset Virtualization App

A Flutter-based music library application capable of handling large datasets (50,000+ tracks) using lazy loading and pagination techniques.

---

## 📌 Project Overview

This application demonstrates large dataset virtualization, infinite scrolling, track details, and lyrics fetching using free public APIs.

The goal was to render and interact with 50,000+ tracks smoothly while maintaining stable memory usage.

---

## 🚀 Features Implemented

- Infinite Scrolling (Lazy Loading)
- Pagination using limit + index strategy
- Track Listing (Name, Artist, Track ID)
- Track Details Screen
- Lyrics Fetching (LRCLIB API)
- Audio Preview (Play / Pause)
- Progress Bar with Seek Support
- Resume playback from paused position
- Offline Handling ("NO INTERNET CONNECTION")
- Stable memory usage using ListView.builder
- DevTools memory testing performed

---

## 🧠 Architecture

This project currently uses **GetX (Controller-based architecture)** for state management.

⚠ Note:  
The original requirement mentioned BLoC pattern.  
Due to time constraints and limited preparation time, BLoC architecture was not fully implemented.  
However, the application follows separation of concerns with:

- API Service Layer
- Controller Layer
- UI Layer

Most functionality is working as expected.

---

## 🌐 APIs Used

### API-A: Track List
Deezer Search API (Paged Fetch)
