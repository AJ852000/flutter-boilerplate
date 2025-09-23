# AI-Assisted Markdown Documentation Example

> This is a filled-out example of the AI-assisted Markdown documentation template for a Flutter widget.

---

## 1. Overview

**Name:** `MyCustomWidget`  
**Type:** `Flutter Widget`  
**Purpose:** A reusable card widget that displays a title, subtitle, and icon, suitable for quick UI prototyping.

**AI-Generated Description:**  
`MyCustomWidget` provides a clean and customizable card layout with tappable functionality. It can be used in dashboards, profile cards, or any content that requires a title, subtitle, and icon.

---

## 2. Screenshots

Include screenshots to visually explain the component.

**Option 1: Local file**

```markdown
![Alt Text](assets/images/my_custom_widget.png)
```

**Option 2: Using an image hosting service (e.g., [Postimages](https://postimages.org/))**

1. Upload your screenshot to https://postimages.org/
2. Copy the direct image link.
3. Use the link in Markdown:

```markdown
![MyCustomWidget Screenshot](https://i.postimg.cc/your_image_id.png)
```

**Example:**
![Screenshot Example](https://i.postimg.cc/your_image_id.png)

> Tip: Store screenshots locally or use an image hosting service if sharing documentation online.

---

## 3. Properties / Parameters Table

| Property   | Type       | Default      | Description                               |
| ---------- | ---------- | ------------ | ----------------------------------------- |
| `title`    | `String`   | `''`         | The main text displayed on the card       |
| `subtitle` | `String`   | `''`         | Secondary text below the title            |
| `icon`     | `IconData` | `Icons.star` | Icon displayed on the card                |
| `onTap`    | `Function` | `null`       | Callback function when the card is tapped |

---

## 4. Methods / Functions Table (Optional)

| Method           | Parameters           | Return Type | Description                        |
| ---------------- | -------------------- | ----------- | ---------------------------------- |
| `updateTitle`    | `String newTitle`    | `void`      | Updates the title text of the card |
| `updateSubtitle` | `String newSubtitle` | `void`      | Updates the subtitle text          |

---

## 5. Example Usage

```dart
MyCustomWidget(
  title: 'Welcome',
  subtitle: 'Flutter Widget Example',
  icon: Icons.flutter_dash,
  onTap: () {
    print('Card tapped!');
  },
)
```

---

## 6. Linking to Other Documentation

- Relative link to another Markdown file:

```markdown
[See Advanced Widget Docs](../advanced_widgets/advanced_widget.md)
```

- External links:

```markdown
[Flutter Official Docs](https://flutter.dev/docs)
[GitHub Repository](https://github.com/your-repo)
```

---

## 7. Tips & Best Practices

- Keep **descriptions concise and clear**.
- Update **screenshots** after UI changes.
- Use **tables** for properties, methods, and parameters.
- AI can generate **FAQs, tips, and best practices** automatically.
- Use **collapsible sections** for long code examples:

<details>
<summary>Click to expand example</summary>

```dart
Text('Hidden code snippet')
```

</details>

---

## 8. Recommended Folder Structure

```
docs/
  ├─ widgets/
  │    ├─ my_custom_widget.md
  │    └─ advanced_widget.md
  └─ images/
       ├─ my_custom_widget.png
```

---

## 9. AI Tools for Markdown Documentation

| Tool                | Purpose                               |
| ------------------- | ------------------------------------- |
| ChatGPT / GPT       | Generate descriptions, examples, FAQs |
| GitHub Copilot      | Generate code snippets and tables     |
| Other AI Assistants | Automate formatting and editing       |

---

> ✅ **Instructions:**
>
> 1. Replace all placeholders with actual project info.
> 2. Use AI tools to fill descriptions, tables, and code snippets.
> 3. Add screenshots to the `assets/images/` folder or upload to [Postimages](https://postimages.org/) and use the link.
> 4. Maintain consistency across all documentation files.
