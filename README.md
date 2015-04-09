# Overview
Genea is a simple genealogy library. It is implemented in Ruby and uses JSON to store data.

# Format

Here is a simple example of a .genea file (just plain text):

    {
        "people": [
            {"id": "michel-dupont", "first_name": "Michel", "last_name": "Dupont", "sex": "M", "birthday": "1963-02-18", "deathday": "2001-03-01"},
            {"id": "madeleine-durand", "first_name": "Madeleine", "middle_name": "Helene", "last_name": "Durand", "sex": "F", "birthday": "1961-06-02", "alive": "false", "comments": "Death day unknown"},

            {"id": "stephane-dupont", "first_name": "Stephane", "middle_name": "Jean Emile", "last_name": "Dupont", "sex": "M", "birthday": "1997-11-24"}
        ],

        "families": [
            {"type": "wedding", "parent1": "michel-dupont", "parent2": "madeleine-durand", "issues": ["stephane-dupont"], "comments": "'pacs' is a valid type of family too"}
        ]
    }

# Tests

In the tests/ directory, you will find an example .genea file and a few Ruby testing files.

# Author

Created by [Louis Brunner](https://github.com/Hyrrmadr).
