This is a handy ruby script that calculates the accumulated overtime in hours and minutes by reading my tracking text file.

# How to use?

Provide a `timesheet.txt` with the format shown in the [timesheet_example.txt](./timesheet_example.txt).

Then run:

```bash
ruby overtime.rb
```

It will print:

```bash
OVERTIME ACCUMULATED UNTIL NOW: XXh YYm
```

If there are invalid entries it will tell you the dates that are invalid. You check and correct them manually.

