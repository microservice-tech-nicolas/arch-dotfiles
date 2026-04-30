# H1 Header: Main Document Title

This is the largest header level, typically used for document titles. It should appear in a distinctive color that stands out prominently.

## H2 Header: Major Section

Second-level headers are used for major sections of a document. They should be visually distinct from H1 but still prominent.

### H3 Header: Subsection

Third-level headers are perfect for subsections within major sections. They maintain hierarchy while being clearly readable.

#### H4 Header: Minor Section

Fourth-level headers work well for smaller subdivisions and detailed organization.

##### H5 Header: Sub-minor Section

Fifth-level headers provide fine-grained organization for complex documents.

###### H6 Header: Smallest Section

The smallest header level, useful for the most detailed subdivisions.

---

## Code Examples

### Inline Code

Here's some `inline code` that should be highlighted differently from regular text. You can use `variables`, `functions()`, and `file.paths` inline.

### Fenced Code Blocks

```javascript
// JavaScript example
function greetUser(name) {
    console.log(`Hello, ${name}!`);
    return true;
}

const user = "Neovim User";
greetUser(user);
```

```python
# Python example
def calculate_fibonacci(n):
    """Calculate the nth Fibonacci number."""
    if n <= 1:
        return n
    return calculate_fibonacci(n-1) + calculate_fibonacci(n-2)

# Test the function
result = calculate_fibonacci(10)
print(f"The 10th Fibonacci number is: {result}")
```

```bash
# Bash commands
echo "Testing markdown rendering"
ls -la ~/.config/nvim/
nvim test-markdown.md
```

---

## Lists and Organization

### Unordered Lists

- First item with regular text
- Second item with **bold text**
- Third item with *italic text*
- Fourth item with `inline code`
  - Nested item level 1
  - Another nested item
    - Deeply nested item
    - Another deep item

### Ordered Lists

1. First numbered item
2. Second numbered item with [a link](https://neovim.io)
3. Third numbered item with ***bold italic***
4. Fourth numbered item
   1. Nested numbered item
   2. Another nested numbered item
      1. Deeply nested numbered item

### Task Lists and Checkboxes

- [x] Completed task with checkmark
- [x] Another completed task
- [ ] Incomplete task (empty checkbox)
- [ ] Another incomplete task
- [x] ~~Completed and struck through~~
- [ ] Task with **bold text**
- [ ] Task with `code snippet`

---

## Blockquotes and Emphasis

### Blockquotes
>
> This is a simple blockquote that should be visually distinct from regular text.
> It can span multiple lines and should maintain consistent formatting.

> **Important Note:** Blockquotes can contain other markdown elements like **bold text**, *italic text*, and `inline code`.

> ### Blockquote with Header
>
> Even headers can be placed inside blockquotes for special emphasis.

### Nested Blockquotes
>
> This is the first level of quotation.
>
> > This is a nested blockquote within the first.
> >
> > > And this is a third level of nesting.

### Text Emphasis

- **Bold text** should be clearly distinguishable
- *Italic text* should be visually different
- ***Bold and italic combined*** for maximum emphasis
- ~~Strikethrough text~~ for deletions or corrections
- Regular text for comparison

---

## Tables

### Simple Table

| Header 1 | Header 2 | Header 3 |
|----------|----------|----------|
| Cell 1   | Cell 2   | Cell 3   |
| Data A   | Data B   | Data C   |
| Info X   | Info Y   | Info Z   |

### Table with Alignment

| Left Aligned | Center Aligned | Right Aligned |
|:-------------|:--------------:|--------------:|
| Left         |    Center      |         Right |
| Text         |    Data        |        Number |
| Example      |    Content     |           123 |

### Complex Table

| Feature | Status | Description | Priority |
|---------|--------|-------------|----------|
| Headers | ✅ Working | All 6 levels implemented | High |
| Code Blocks | ✅ Working | Syntax highlighting active | High |
| Lists | ✅ Working | Ordered and unordered | Medium |
| Tables | 🔄 Testing | Currently being validated | Medium |
| Links | ✅ Working | Internal and external | Low |

---

## Links and References

### External Links

- [Neovim Official Site](https://neovim.io)
- [render-markdown.nvim Plugin](https://github.com/MeanderingProgrammer/render-markdown.nvim)
- [Markdown Guide](https://www.markdownguide.org)

### Internal Links

- [Jump to Headers Section](#code-examples)
- [Go to Tables](#tables)
- [Back to Top](#h1-header-main-document-title)

### Reference Style Links

This is [an example][1] reference-style link.
This is [another example][example] with a named reference.

[1]: https://neovim.io "Neovim"
[example]: https://github.com/MeanderingProgrammer/render-markdown.nvim "render-markdown plugin"

---

## Advanced Markdown Features

### Horizontal Rules

Above this line should be a horizontal rule.

---

Below this line should be another horizontal rule.

### Escape Characters

You can escape special characters: \*not italic\*, \`not code\`, \# not a header

### HTML in Markdown (if supported)

<details>
<summary>Click to expand</summary>

This content should be collapsible if HTML is supported in your markdown renderer.

</details>

---

## Testing Checklist

When viewing this file in Neovim with render-markdown enabled, verify:

- [ ] All 6 header levels display in different colors/styles
- [ ] Code blocks have syntax highlighting
- [ ] Inline code is visually distinct
- [ ] Lists are properly formatted with bullets/numbers
- [ ] Checkboxes render as actual checkbox symbols
- [ ] Blockquotes are indented and styled
- [ ] Tables are formatted with borders/grid
- [ ] Links are highlighted and clickable
- [ ] Bold, italic, and strikethrough text render correctly
- [ ] Horizontal rules display as lines

---

*This test file was created to validate markdown rendering configuration in Neovim.*
**Last updated:** Testing Phase

