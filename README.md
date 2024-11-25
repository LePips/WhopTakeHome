# Whop Take Home

Built with Xcode 16.1 with no additional packages for iOS 17. View basic websites based on a "Bookmarks" functionality.

Features:

- **Static and expanding rows**
	- Allow static and expanding rows to view more content.
- **Paging API Client**
	- Allows paging an API client based on index. API systems may allow paging by index and also allow clients to know when there is no more content to retrieve. Will page more content based on the scrolling offset and size of the view and has infinite scrolling.
- **Stateful View Models**
	- With basic stateful systems, views can focus on presentation over state handling. All conform to `Observable` to use SwiftUI's integration with that macro.
- **Loading States**
	- On the main list view, rows to represent loading use provided mechanisms for views, like `redacted`.
- **App Settings**
	- For demo purposes, change some settings to show alternate states and behavior.
- **Unit Testing**
	- Unit tests for the `ContentViewModel` and `APIClient` paging functionality.