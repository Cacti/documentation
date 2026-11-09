"""Keep Markdown navigation anchors compatible without ambiguous regex tails."""
from pathlib import Path
import sys
import unittest

sys.path.insert(0, str(Path(__file__).resolve().parents[1]))
from check_navigation import anchors


class HeadingAnchors(unittest.TestCase):
    def test_closing_hashes_tabs_duplicates_and_fenced_examples(self):
        text = '''# A title ##
# A title
##	Tab heading
### Keep#hash
####### Not a heading
```markdown
# Hidden example
```
<a id="old-bookmark"></a>
'''
        self.assertEqual(anchors(text), {'a-title', 'a-title-1', 'tab-heading',
                                         'keephash', 'old-bookmark'})

    def test_long_heading_and_empty_lines(self):
        title = 'heading' + ' ' * 10000 + 'tail'
        result = anchors('\n#\n## ###\n# ' + title + '\n')
        self.assertEqual(result, {title.replace(' ', '-')})


if __name__ == '__main__':
    unittest.main()
